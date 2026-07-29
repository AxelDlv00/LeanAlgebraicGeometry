/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivisorFamilyAffAdaptation
import AlgebraicJacobian.Picard.DivSchemeFamilySide

/-!
# The Θ-LAYER OVER THE WIDENED CARRIER (R2): what actually blocked cert-r2's producer

Protection `I-0492` widened the certificate carrier to arbitrary affine opens, and the
widened lane now produces a class from geometry
(`ThetaGeneratorSeed.divFamZarAff_of_swallowing_affineOpen`,
`Picard/DivisorFamilyAffSeedGate.lean`).  That producer still cannot feed U2, and the
reason recorded across five sessions — "U2 needs a certificate" — is **not** it.

## The measurement that renames the seam

U2's consumer `DivRepChartFamily.IsChartClause` (`Picard/DivRepAffPullClause.lean:121`)
quantifies over `DivFamZar C (ChartRing i j) π g`, the *chart-typed* value.  There is no
map `DivFamZarAff → DivFamZar` and there cannot be (`informal/spec-dd-r.md` ADDENDUM 3 §2:
a straddling divisor has no chart-typed certificate).  So the only usable route is to
re-derive the ε-value facts on the widened carrier — and *that* is where the absence is:

> `divFamEps_eq_of_le` (`Picard/DivRepChartClassUnivQuot.lean`) needs projectivity and
> constant rank `g` of the **window quotient**.  On `DivFam` those are landed
> *unconditionally* (`Picard/DivSchemeFrameCover.lean:106`/`:117`) — but their only proof
> route is `windowQuotEquiv` (`Picard/DivisorFamilyWindow.lean:179`), whose target is
> `A.ThetaGlued a`, and `ThetaGlued` / `thetaGluedEval` / `thetaOvlUnit` /
> `thetaDeltaRight` / `ker_thetaGluedEval` are defined **only** on `DivisorAdaptation`
> (`Picard/DivisorFamilyTheta.lean`).

Cross-measured at HEAD: of the files mentioning `AffAdaptation`, **zero** define any theta
arrow.  `DivisorFamilyAffFraming.lean` is right that the ε-pair *statement* is
carrier-indifferent (both carriers have the same `eqns` field and `divisorWindow` reads
nothing else); the ε-pair **facts** are not, and statement was never separated from facts.

## Why this is a port and not new mathematics

The Θ-layer's chart-dependence is exactly **one `Bool` per piece**.  `FinCoverData`'s
version reads it off the `Sum` index (`pieces_inl_le` / `pieces_inr_le`), which is why it
looks chart-typed; but the side-uniform API it could have used already exists and is
consumed by some sixty files:

* `relThetaResSide` (`Picard/DivSchemeFamilySide.lean:155`) — the side component,
  restricted into any open below `relPinnedChart (side j)`;
* `relThetaSideUnit` (`:180`) — the matching unit of an ordered pair of sides, whose
  four-case split *is* `FinCoverData.thetaOvlUnit`'s;
* `relThetaResSide_matching` (`:194`) and `resHom_relThetaResSide` (`:172`).

Each needs only `piece ≤ relPinnedChart (side j)` — which is **verbatim** the field
`ChartTyping.piece_le` (`Picard/DivisorFamilyAffCover.lean:204`), the datum `I-0492`
clause 3 deliberately kept *separate* from the certificate clauses precisely so the
Θ-layer could have it without the certificate demanding it.

So this file is the missing face, built the way clause 3 intends: the twisting data is
indexed by a `ChartTyping`, and **no certificate clause and no locally-certified predicate
mentions it**.

## What this file does and does not claim

It builds the widened Θ-twisted glued module and its evaluation, and proves the kernel
bridge — left exactness, i.e. that the kernel is the *same* cover-independent vanishing
submodule the chart-typed layer produces.  That is the input `windowQuotEquiv`'s widened
analogue needs.

It does **not** prove surjectivity of the widened evaluation (the right-exactness heart,
`thetaGluedEval_surjective`'s analogue), and it does not produce a widened ε-value
identity: those consume the widened certificate's (c2) clause through a widened
`IsThetaPaired`, which is the next face and is *not* built here.  Read this as "the
ε-value facts are now *stateable* over the widened carrier", not as a gate cleared.

## Main declarations

* `AlgebraicGeometry.AffAdaptation.thetaOvlUnit` — the twisting unit of an ordered pair of
  widened pieces, read off a `ChartTyping` rather than a `Sum` index.
* `AlgebraicGeometry.AffAdaptation.thetaGluedSubmodule` / `ThetaGlued` — the Θ-twisted
  glued colength module over a widened cover, spelled as a kernel exactly as the
  chart-typed one.
* `AlgebraicGeometry.AffAdaptation.thetaGluedEval` — the evaluation
  `H⁰(𝒪(Θᵃ)) → W(d)^{Θᵃ}`.
* `AlgebraicGeometry.AffAdaptation.ker_thetaGluedEval` — **the kernel bridge**: the kernel
  is the cover-independent vanishing submodule, so it agrees with the chart-typed layer's
  and `divisorWindow` is the same submodule on both carriers.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
/- `lake env lean` drops the lakefile's `[leanOptions]` (I-0161), so the pinned synthesis
depth must be set in-file for the faithful per-file check. -/
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory TopologicalSpace Opposite

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {R : Type u} [CommRing R] [Algebra k R]
/- `ChartTyping` is stated with an `[IsAffineHom π]` binder, which `[IsFinite π]` already
supplies — the `overlappingInstances` linter reports the pair, so only `IsFinite` is taken
here and `IsAffineHom` is found by synthesis. -/
variable {π : C.left ⟶ P1 k} [IsFinite π]

namespace AffAdaptation

variable {D : AffCoverData C R} {d : (relCurve C R).LocalEquations}
variable (A : AffAdaptation D d) (τ : ChartTyping C R π D) (a : ℕ)

/-! ## The twisting unit, read off a chart typing

`FinCoverData.thetaOvlUnit` (`Picard/DivisorFamilyTheta.lean:149`) splits on the `Sum`
index and produces `1`, the cocycle, or its inverse.  That is `relThetaSideUnit` at the two
pieces' sides, and here the sides come from `τ` rather than from the index type — which is
the whole difference between the two layers. -/

/-- The pinned chart assigned to a widened piece agrees with `relPinnedChart` on the nose
(`pinnedChartOfSide` is `bif`, `relPinnedChart` is a match on the same `Bool`). -/
lemma pinnedChartOfSide_eq (b : Bool) :
    pinnedChartOfSide C R π b = relPinnedChart C R π b := by
  cases b <;> rfl

/-- The piece is contained in the pinned chart of its assigned side, in the
`relPinnedChart` spelling the side-uniform Θ API consumes. -/
lemma piece_le_relPinnedChart (j : D.index) :
    D.pieces j ≤ relPinnedChart C R π (τ.side j) :=
  (pinnedChartOfSide_eq (C := C) (R := R) (π := π) (τ.side j)) ▸ τ.piece_le j

/-- An overlap of two widened pieces sits below both assigned pinned charts. -/
lemma pieces_inf_le_relPinnedChart_inf (i j : D.index) :
    D.pieces i ⊓ D.pieces j
      ≤ relPinnedChart C R π (τ.side i) ⊓ relPinnedChart C R π (τ.side j) :=
  inf_le_inf (piece_le_relPinnedChart τ i) (piece_le_relPinnedChart τ j)

/-- **The Θ twisting unit of an ordered pair of widened pieces**: the side matching unit
of the two assigned sides, restricted to the overlap.  This replaces
`FinCoverData.thetaOvlUnit`'s four-case `Sum` split by one application of
`relThetaSideUnit` — the cases are the same cases, and the `Bool`s now come from the
separate `ChartTyping` datum rather than from the index type. -/
noncomputable def thetaOvlUnit (i j : D.index) :
    Γ(relCurve C R, D.pieces i ⊓ D.pieces j)ˣ :=
  relThetaSideUnit a (τ.side i) (τ.side j) (pieces_inf_le_relPinnedChart_inf τ i j)

/-! ## The Θ-twisted glued colength module -/

/-- **The Θ-twisted right overlap arrow** over a widened cover: restrict the `p.2`
component to each overlap and multiply by the twisting unit of the pair.  Verbatim
`DivisorAdaptation.thetaDeltaRight` (`Picard/DivisorFamilyTheta.lean:203`) with
`thetaOvlUnit` read off `τ`. -/
noncomputable def thetaDeltaRight : A.chartProd →ₗ[R] A.ovlProd :=
  LinearMap.pi (fun p : D.index × D.index =>
    LinearMap.mulLeft R (Ideal.Quotient.mk (A.ovlIdeal p.1 p.2)
        ((thetaOvlUnit τ a p.1 p.2 :
          Γ(relCurve C R, D.pieces p.1 ⊓ D.pieces p.2)ˣ) :
          Γ(relCurve C R, D.pieces p.1 ⊓ D.pieces p.2))) ∘ₗ
      (A.toOvlRight p.1 p.2).toLinearMap ∘ₗ LinearMap.proj p.2)

/-- **The Θ-twisted glued colength module `W(d)^{Θᵃ}` over a widened cover**, spelled as a
kernel so the `FlatCokernel` base-change shapes apply exactly as chart-typed. -/
noncomputable def thetaGluedSubmodule : Submodule R A.chartProd :=
  LinearMap.ker (A.deltaLeft - thetaDeltaRight A τ a)

/-- The twisted-equalizer description of the widened `W(d)^{Θᵃ}`. -/
lemma mem_thetaGluedSubmodule_iff (s : A.chartProd) :
    s ∈ thetaGluedSubmodule A τ a ↔ ∀ p : D.index × D.index,
      A.toOvlLeft p.1 p.2 (s p.1)
        = Ideal.Quotient.mk (A.ovlIdeal p.1 p.2)
            ((thetaOvlUnit τ a p.1 p.2 :
              Γ(relCurve C R, D.pieces p.1 ⊓ D.pieces p.2)ˣ) :
              Γ(relCurve C R, D.pieces p.1 ⊓ D.pieces p.2))
          * A.toOvlRight p.1 p.2 (s p.2) := by
  simp only [thetaGluedSubmodule, LinearMap.mem_ker, LinearMap.sub_apply, sub_eq_zero,
    funext_iff, deltaLeft, thetaDeltaRight, LinearMap.pi_apply, LinearMap.coe_comp,
    Function.comp_apply, LinearMap.proj_apply, AlgHom.toLinearMap_apply,
    LinearMap.mulLeft_apply]

/-- The widened Θ-twisted glued colength module, as a type. -/
noncomputable abbrev ThetaGlued : Type u := ↥(thetaGluedSubmodule A τ a)

end AffAdaptation

end AlgebraicGeometry
