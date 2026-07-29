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

/-! ## The evaluation `H⁰(𝒪(Θᵃ)) → W(d)^{Θᵃ}` -/

/-- **The germ of a widened equation spans the stalk ideal of the family.**  The widened
counterpart of `DivisorAdaptation.germ_eqn_span_eq_stalkIdeal`
(`Picard/DivisorFamilyTheta.lean:322`); its proof is the same one, and it ports because
`eqn_rel` is stated pointwise on both carriers. -/
theorem germ_eqn_span_eq_stalkIdeal (j : D.index) {z : relCurve C R}
    (hz : z ∈ D.pieces j) :
    Ideal.span {((relCurve C R).presheaf.germ (D.pieces j) z hz).hom (A.eqn j)}
      = d.stalkIdeal z := by
  obtain ⟨u, hu⟩ := A.eqn_rel j z
  have hzW : z ∈ D.pieces j ⊓ d.cover.opens z := ⟨hz, d.cover.mem_opens z⟩
  have hgerm : ((relCurve C R).presheaf.germ (D.pieces j) z hz).hom (A.eqn j)
      = ((relCurve C R).presheaf.germ (D.pieces j ⊓ d.cover.opens z) z hzW).hom
          (u : Γ(relCurve C R, D.pieces j ⊓ d.cover.opens z))
        * ((relCurve C R).presheaf.germ (d.cover.opens z) z
            (d.cover.mem_opens z)).hom (d.eqn z) := by
    have h := congrArg ((relCurve C R).presheaf.germ
      (D.pieces j ⊓ d.cover.opens z) z hzW).hom hu
    rw [map_mul, TopCat.Presheaf.germ_res_apply, TopCat.Presheaf.germ_res_apply] at h
    exact h
  rw [hgerm, Ideal.span_singleton_mul_left_unit (u.isUnit.map
    ((relCurve C R).presheaf.germ (D.pieces j ⊓ d.cover.opens z) z hzW).hom)]
  exact d.germ_eqn_span_eq z z (d.cover.mem_opens z)

/-- The per-piece evaluation of a global theta section: take the side component assigned to
the piece, restrict it, and reduce mod `(f_j)`.  Where the chart-typed version splits on the
`Sum` index (`DivisorAdaptation.thetaPieceEval`), this is one application of
`relThetaResSide` at `τ.side j`. -/
noncomputable def thetaPieceEval (j : D.index) :
    relThetaSections C R π a →ₗ[R] A.colength j :=
  (Ideal.Quotient.mkₐ R (Ideal.span {A.eqn j})).toLinearMap ∘ₗ
    relThetaResSide a (τ.side j) (piece_le_relPinnedChart τ j)

/-- **The section evaluation into the widened chart product.** -/
noncomputable def thetaEval : relThetaSections C R π a →ₗ[R] A.chartProd :=
  LinearMap.pi (thetaPieceEval A τ a)

@[simp]
lemma thetaEval_apply (x : relThetaSections C R π a) (j : D.index) :
    thetaEval A τ a x j
      = Ideal.Quotient.mk (Ideal.span {A.eqn j})
          (relThetaResSide a (τ.side j) (piece_le_relPinnedChart τ j) x) := rfl

/-- The left overlap arrow on a residue class: restrict into the overlap, then reduce.

Stated here because both widened forms exist only as `private` lemmas of
`Picard/DivisorFamilyAffCert.lean` (`toOvlLeft_mk'`/`toOvlRight_mk'`) — and both are `rfl`,
so this is a name, not a proof (inbox `I-0712`: `private` hides the name, not the argument).
The `resHom` spelling is the one the matching law below rewrites along. -/
lemma toOvlLeft_mk (i j : D.index) (s : Γ(relCurve C R, D.pieces i)) :
    A.toOvlLeft i j (Ideal.Quotient.mk (Ideal.span {A.eqn i}) s)
      = Ideal.Quotient.mk (A.ovlIdeal i j)
          ((relCurve C R).resHom inf_le_left s) :=
  rfl

/-- The right overlap arrow on a residue class. -/
lemma toOvlRight_mk (i j : D.index) (s : Γ(relCurve C R, D.pieces j)) :
    A.toOvlRight i j (Ideal.Quotient.mk (Ideal.span {A.eqn j}) s)
      = Ideal.Quotient.mk (A.ovlIdeal i j)
          ((relCurve C R).resHom inf_le_right s) :=
  rfl

/-- **The evaluation lands in the widened Θ-twisted glued module**: on each pairwise
overlap, the global matching of the two side components through the theta cocycle *is* the
Θ-twisted matching of the colengths.

Where the chart-typed proof (`DivisorAdaptation.thetaEval_mem`) runs a four-case `Sum`
split and calls `relThetaSections_matching` twice with hand-built containments, this is a
single application of `relThetaResSide_matching` — the side-uniform form of the same
matching law.  That collapse is the concrete payoff of taking the sides from a
`ChartTyping` rather than from the index type. -/
theorem thetaEval_mem (x : relThetaSections C R π a) :
    thetaEval A τ a x ∈ thetaGluedSubmodule A τ a := by
  rw [mem_thetaGluedSubmodule_iff]
  rintro ⟨i, j⟩
  rw [thetaEval_apply, thetaEval_apply, toOvlLeft_mk, toOvlRight_mk, ← map_mul]
  refine congrArg _ ?_
  -- both sides restrict the SAME section into the overlap; the side matching law compares
  -- the two assigned sides there, and `thetaOvlUnit` is by definition its unit
  rw [resHom_relThetaResSide (b := τ.side i), resHom_relThetaResSide (b := τ.side j)]
  exact relThetaResSide_matching a (τ.side i) (τ.side j)
    (pieces_inf_le_relPinnedChart_inf τ i j) x

/-- **The evaluation `H⁰(𝒪(Θᵃ)) → W(d)^{Θᵃ}` over a widened cover.** -/
noncomputable def thetaGluedEval :
    relThetaSections C R π a →ₗ[R] ThetaGlued A τ a :=
  LinearMap.codRestrict (thetaGluedSubmodule A τ a) (thetaEval A τ a) (thetaEval_mem A τ a)

lemma thetaGluedEval_coe (x : relThetaSections C R π a) :
    (thetaGluedEval A τ a x : A.chartProd) = thetaEval A τ a x := rfl

/-- The kernel of the corestricted evaluation is the kernel of the evaluation. -/
lemma ker_thetaGluedEval_eq_ker :
    LinearMap.ker (thetaGluedEval A τ a) = LinearMap.ker (thetaEval A τ a) :=
  LinearMap.ker_codRestrict _ _ _

/-! ## The kernel bridge — left exactness, and the seam with the chart-typed layer -/

/-- The germ of a side component through a piece is the germ taken in the pinned chart:
`relThetaResSide` is a restriction, so `germ_res_apply` moves the germ up. -/
lemma germ_relThetaResSide_eq (x : relThetaSections C R π a) (b : Bool)
    {W W' : (relCurve C R).Opens} (hW : W ≤ relPinnedChart C R π b) (hW' : W' ≤ W)
    {z : relCurve C R} (hz : z ∈ W') :
    ((relCurve C R).presheaf.germ W' z hz).hom (relThetaResSide a b (hW'.trans hW) x)
      = ((relCurve C R).presheaf.germ W z (hW' hz)).hom (relThetaResSide a b hW x) := by
  rw [← resHom_relThetaResSide a b hW hW' x]
  exact TopCat.Presheaf.germ_res_apply _ _ _ _ _

/-- **The two clauses of `vanishingSubmodule`, read side-uniformly.**  Its statement is a
conjunction over the two pinned charts; this packages it as one statement over an arbitrary
`Bool`, which is what a proof indexed by `τ.side j` needs.

Factored out because `cases` on `τ.side j` at the use site fails with *"result is not type
correct"*: the `Bool` occurs inside the germ's own open, so the motive is dependent and
`subst` does not rescue it either (memory `cases-on-a-bool-a-type-mentions`).  Splitting
over a *variable* `Bool` in a separate lemma is the fix. -/
lemma germ_val_mem_stalkIdeal_of_forall_side (x : relThetaSections C R π a)
    (h : (∀ (z : relCurve C R) (hz : z ∈ (⊤ : (relCurve C R).Opens) ⊓
          (relCover C R (fiberTwoCover π)).V₀),
        ((relCurve C R).presheaf.germ ((⊤ : (relCurve C R).Opens) ⊓
          (relCover C R (fiberTwoCover π)).V₀) z hz).hom x.val.1 ∈ d.stalkIdeal z) ∧
      ∀ (z : relCurve C R) (hz : z ∈ (⊤ : (relCurve C R).Opens) ⊓
          (relCover C R (fiberTwoCover π)).V₁),
        ((relCurve C R).presheaf.germ ((⊤ : (relCurve C R).Opens) ⊓
          (relCover C R (fiberTwoCover π)).V₁) z hz).hom x.val.2 ∈ d.stalkIdeal z)
    (b : Bool) {z : relCurve C R}
    (hz : z ∈ (⊤ : (relCurve C R).Opens) ⊓ relPinnedChart C R π b) :
    ((relCurve C R).presheaf.germ ((⊤ : (relCurve C R).Opens) ⊓ relPinnedChart C R π b)
        z hz).hom (relThetaResSide a b inf_le_right x) ∈ d.stalkIdeal z := by
  -- `simpa` discharges the identity restriction `relThetaResSide b inf_le_right x = x.val.b`
  -- (`relThetaResSide_false`/`_true` plus `presheaf.map_id`), which is the only gap.
  cases b with
  | false => simpa using h.1 z hz
  | true => simpa using h.2 z hz

/-- **The germ of a side component of a killed section lies in `d`'s stalk ideal**, at a
point of the piece `j`, read on the overlap of that piece with the pinned chart `b`.

The proof follows `ThetaGeneratorSeed.le_vanishingSubmodule` (`Picard/DivSchemeFamily.lean:397`)
step for step — that is the template, and it is what makes this a port: it already works on
`D.piece z ⊓ relPinnedChart b` with the side taken from a `Bool`, so the only change is that
the piece comes from the joint cover and its side from `τ` rather than from the seed. -/
lemma germ_val_mem_stalkIdeal_of_thetaEval_eq_zero {x : relThetaSections C R π a}
    (hker : ∀ j, thetaEval A τ a x j = 0) (b : Bool) (j : D.index)
    {z : relCurve C R} (hzj : z ∈ D.pieces j)
    (hz : z ∈ (⊤ : (relCurve C R).Opens) ⊓ relPinnedChart C R π b) :
    ((relCurve C R).presheaf.germ ((⊤ : (relCurve C R).Opens) ⊓ relPinnedChart C R π b)
        z hz).hom (Bool.rec x.val.1 x.val.2 b) ∈ d.stalkIdeal z := by
  have hzW : z ∈ D.pieces j ⊓ relPinnedChart C R π b := ⟨hzj, hz.2⟩
  -- the matching law comparing the pinned side `b` with the piece's assigned side
  have hmatch := relThetaResSide_matching a b (τ.side j) (le_inf
    (inf_le_right : D.pieces j ⊓ relPinnedChart C R π b ≤ _)
    (inf_le_left.trans (piece_le_relPinnedChart τ j))) x
  -- the assigned-side germ lies in the stalk ideal: the evaluation vanishes on the piece
  have hgermside : ((relCurve C R).presheaf.germ
      (D.pieces j ⊓ relPinnedChart C R π b) z hzW).hom
        (relThetaResSide a (τ.side j)
          ((le_inf (inf_le_right : D.pieces j ⊓ relPinnedChart C R π b ≤ _)
            (inf_le_left.trans (piece_le_relPinnedChart τ j))).trans inf_le_right) x)
      ∈ d.stalkIdeal z := by
    rw [show relThetaResSide a (τ.side j)
        ((le_inf (inf_le_right : D.pieces j ⊓ relPinnedChart C R π b ≤ _)
          (inf_le_left.trans (piece_le_relPinnedChart τ j))).trans inf_le_right) x
        = (relCurve C R).resHom (inf_le_left : D.pieces j ⊓ relPinnedChart C R π b
            ≤ D.pieces j)
          (relThetaResSide a (τ.side j) (piece_le_relPinnedChart τ j) x) from
      (resHom_relThetaResSide a (τ.side j) (piece_le_relPinnedChart τ j) inf_le_left x).symm]
    rw [show ((relCurve C R).presheaf.germ
        (D.pieces j ⊓ relPinnedChart C R π b) z hzW).hom
          ((relCurve C R).resHom (inf_le_left : D.pieces j ⊓ relPinnedChart C R π b
            ≤ D.pieces j)
            (relThetaResSide a (τ.side j) (piece_le_relPinnedChart τ j) x))
        = ((relCurve C R).presheaf.germ (D.pieces j) z hzj).hom
          (relThetaResSide a (τ.side j) (piece_le_relPinnedChart τ j) x) from
      TopCat.Presheaf.germ_res_apply _ _ _ _ _]
    -- vanishing of the evaluation at `j`: the side component is a multiple of `A.eqn j`
    have hmem : relThetaResSide a (τ.side j) (piece_le_relPinnedChart τ j) x
        ∈ Ideal.span {A.eqn j} := by
      have h := hker j
      rw [thetaEval_apply, Ideal.Quotient.eq_zero_iff_mem] at h
      exact h
    obtain ⟨c, hc⟩ := Ideal.mem_span_singleton.mp hmem
    have hgerm := congrArg ((relCurve C R).presheaf.germ (D.pieces j) z hzj).hom hc
    rw [map_mul] at hgerm
    rw [← germ_eqn_span_eq_stalkIdeal A j hzj, hgerm]
    exact Ideal.mul_mem_right _ _ (Ideal.subset_span rfl)
  -- transport across the side unit
  have hkey := congrArg ((relCurve C R).presheaf.germ
    (D.pieces j ⊓ relPinnedChart C R π b) z hzW).hom hmatch
  rw [map_mul] at hkey
  have hgermb : ((relCurve C R).presheaf.germ
      (D.pieces j ⊓ relPinnedChart C R π b) z hzW).hom
        (relThetaResSide a b ((le_inf
          (inf_le_right : D.pieces j ⊓ relPinnedChart C R π b ≤ _)
          (inf_le_left.trans (piece_le_relPinnedChart τ j))).trans inf_le_left) x)
      = ((relCurve C R).presheaf.germ
          ((⊤ : (relCurve C R).Opens) ⊓ relPinnedChart C R π b) z hz).hom
        (Bool.rec x.val.1 x.val.2 b) := by
    cases b with
    | false =>
        rw [relThetaResSide_false]
        exact TopCat.Presheaf.germ_res_apply _ _ _ _ _
    | true =>
        rw [relThetaResSide_true]
        exact TopCat.Presheaf.germ_res_apply _ _ _ _ _
  rw [hgermb] at hkey
  rw [hkey]
  exact Ideal.mul_mem_left _ _ hgermside

/-- **THE KERNEL BRIDGE OVER THE WIDENED CARRIER** (left exactness of the Θ-twisted
section sequence): the kernel of the widened Θ-twisted colength evaluation is exactly the
**cover-independent** vanishing submodule of the family — the DD-4 spelling of
`H⁰(𝒪(Θᵃ − d)) = ker (H⁰(𝒪(Θᵃ)) → W(d)^{Θᵃ})`.

This is the statement that makes the widening *usable* rather than merely well-formed. Its
right-hand side is **literally the same term** as in the chart-typed
`DivisorAdaptation.ker_thetaGluedEval` (`Picard/DivisorFamilyTheta.lean:350`) — the
vanishing submodule mentions `d` and the two pinned charts and no cover at all. Hence
`divisorWindow` (`Picard/DivisorFamilyWindow.lean:103`), which is the comap of that
submodule, is the *same submodule on both carriers*, and a widened
`windowQuotEquiv`-analogue has the left-exactness half it needs.

Two places where the widened proof differs from the chart-typed one, both in R2's
direction:

* the forward direction picks a piece containing the point out of the **joint** cover
  (`AffCoverData.exists_mem_pieces`, `I-0492` clause 4(ii)) rather than out of one of the
  two per-chart covers `cover₀`/`cover₁` — which is precisely the datum the widening
  replaced the partitions of unity by;
* the case analysis on which pinned chart a point lies in is driven by `τ.side j` for the
  chosen piece, so the two directions never need the point's chart membership *a priori*.
  The chart-typed proof gets that membership from the `Sum` index for free and pays for it
  by being confined to a fixed pair. -/
theorem ker_thetaGluedEval :
    LinearMap.ker (thetaGluedEval A τ a)
      = d.vanishingSubmodule R (relCover C R (fiberTwoCover π)).V₀
          (relCover C R (fiberTwoCover π)).V₁ (relThetaCocycle C R π a) := by
  rw [ker_thetaGluedEval_eq_ker]
  ext x
  rw [LinearMap.mem_ker, Scheme.LocalEquations.mem_vanishingSubmodule_iff, funext_iff]
  constructor
  · intro hker
    -- pick a piece containing the point out of the JOINT cover, then compare sides
    exact ⟨fun z hz =>
        (D.exists_mem_pieces z).elim fun j hj =>
          germ_val_mem_stalkIdeal_of_thetaEval_eq_zero A τ a hker false j hj hz,
      fun z hz =>
        (D.exists_mem_pieces z).elim fun j hj =>
          germ_val_mem_stalkIdeal_of_thetaEval_eq_zero A τ a hker true j hj hz⟩
  · intro h j
    rw [thetaEval_apply, Pi.zero_apply, Ideal.Quotient.eq_zero_iff_mem]
    refine Scheme.mem_span_singleton_of_forall_germ
      (fun z hz => A.eqn_regular j z hz) (fun z hz => ?_)
    -- the germ through the piece is the germ in the assigned chart, where `h` applies
    rw [germ_eqn_span_eq_stalkIdeal A j hz]
    have key : ((relCurve C R).presheaf.germ (D.pieces j) z hz).hom
        (relThetaResSide a (τ.side j) (piece_le_relPinnedChart τ j) x)
        = ((relCurve C R).presheaf.germ
            ((⊤ : (relCurve C R).Opens) ⊓ relPinnedChart C R π (τ.side j)) z
            ⟨trivial, piece_le_relPinnedChart τ j hz⟩).hom
          (relThetaResSide a (τ.side j) inf_le_right x) :=
      germ_relThetaResSide_eq a x (τ.side j) inf_le_right
        (le_inf le_top (piece_le_relPinnedChart τ j)) hz
    rw [key]
    -- `cases` on `τ.side j` fails here with "result is not type correct": the Bool occurs
    -- in the germ's OPEN, so the motive is dependent (memory `cases-on-a-bool-a-type-mentions`).
    -- The split is therefore factored out over an arbitrary Bool.
    exact germ_val_mem_stalkIdeal_of_forall_side a x h (τ.side j)
      ⟨trivial, piece_le_relPinnedChart τ j hz⟩

end AffAdaptation

end AlgebraicGeometry
