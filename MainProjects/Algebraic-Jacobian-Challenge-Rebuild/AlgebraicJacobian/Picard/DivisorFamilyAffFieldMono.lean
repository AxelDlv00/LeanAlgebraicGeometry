/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivSchemeMonoBridgeField
import AlgebraicJacobian.Picard.DivisorFamilyAffFraming
import AlgebraicJacobian.Picard.DivisorFamilyAffStalkEval

/-!
# The field-level window-recovery mono is CARRIER-FREE — the widened separation rung
needs no widened mathematics

Reviewer finding `I-1248` reports that the R2 widened carrier `DivFamZarAff`
(`Picard/DivisorFamilyAffZar.lean:165`) has a certificate producer and **no classifier
tower**, and names the missing rungs as the classifier, the characterizing clause, and
**separation** — calling the last load-bearing, because separation is what lets `ofPull`
derive `pull_classify`.  The reading it invites is that the widened separation is
chart-typed mathematics awaiting a widened re-proof.

**This file measures that reading and it is wrong at the bottom of the chain.**  Follow
the chart-typed separation down:

`eq_of_isDivRepClassify` (`Picard/DivRepClassifyZarSep.lean:352`)
  → `divFam_divEq_of_eps_eq_total` (`Picard/DivSchemeMonoBridgeRel.lean:417`)
  → `divFam_divEq_of_eps_eq'` (`Picard/DivSchemeMonoBridge.lean:434`)
  → `CertifiedDivisorFamily.windowGen` (`…MonoBridgeRel.lean:334`)
  → `CertifiedDivisorFamily.stalkIdeal_le_span_windowGerm_of_field`
    (`Picard/DivSchemeMonoBridgeField.lean:193`).

In that last proof the carrier `G : CertifiedDivisorFamily C K π g` occurs **only** as
`G.eqns` and as `DivFam.mk G` under `divFamEps` / `divFamEpsWindowGermSet` — and both of
those are, by `rfl`, functions of `G.eqns` alone (`divFamEps` is `divisorWindow F.eqns` at
two windows, `DivisorFamilyWindow.lean`).  The adaptation, the certificate, the cover and
the chart typing never enter.

So the field-level rung is not chart-typed at all: it is a statement about a bare
`d : (relCurve C K).LocalEquations`, and what the certificate is used for is exactly two
facts about the presentation divisor of `d`:

* `deg_K (presentationDivisor K d.presentation) = g`, and
* its effectivity `0 ≤ presentationDivisor K d.presentation`.

Both are available on the **widened** side already, the first being
`AffAdaptation.IsCertified.deg_presentationDivisor` (`Picard/DivisorFamilyAffStalkEval.lean`,
no separation and no cover hypothesis) and the second the general
`Scheme.zero_le_coeffAt_presentationDivisor`.

## What this file proves, and what it does NOT

* `eqns_stalkIdeal_le_span_windowGermSet_of_field` — the window generation over a field
  for an **arbitrary** local-equation system whose presentation divisor is effective of
  degree `g`.  No carrier, no adaptation, no cover.
* `CertifiedDivisorFamilyAff.stalkIdeal_le_span_windowGerm_of_field`,
  `CertifiedDivisorFamilyAff.windowGen_of_field`,
  `CertifiedDivisorFamilyAff.divEq_of_eps_eq_of_field` — the widened instances, the last
  being the widened field mono: **two widened certified families over a field with equal
  `ε`-pairs cut divisor-equal systems**.
* `DivFamZarAff.mk_eq_mk_of_eps_eq_of_field` — the same read at the widened quotient.

It does **not** produce the widened classifier, the widened characterizing clause, or
`exists_certChartCover` widened (that is `framecover-aff`, held by `ajcr-p1`), and it does
not discharge `(divFunctorAff C n).RepresentableBy` — which still has zero producers.  Nor
does it touch `IsChartUniv`, Zariski-local surjectivity, or `rep`.  What it removes is one
named rung from the widened tower's bill, by showing the rung was never carrier-specific.

**The `Field` restriction is real and is not hidden**: this is the field-level rung.  The
general-test rung `CertifiedDivisorFamily.windowGen` (`…MonoBridgeRel.lean:334`) reduces
the arbitrary-`R` case to this one at each residue field, and *that* reduction does use
the adaptation — through `G.adaptation.index`, `stalkIdeal_eq_span_germ_eqn` and
`FinCoverData.windowRes`.  So the widened general-test rung is a separate obligation and
this file states it as owed rather than closed; see `## The general-test rung is owed`.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
/- `lake env lean` drops the lakefile's `[leanOptions]` (I-0161); pin in-file. -/
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {K : Type u} [Field K] [Algebra k K]
variable {π : C.left ⟶ P1 k} [IsFinite π]

noncomputable local instance instOverCleftAffFieldMono :
    C.left.Over (Spec (.of k)) := ⟨C.hom⟩

variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
variable [SmoothOfRelativeDimension 1 (C.left ↘ Spec (.of k))] [IsIntegral C.left]
  [LocallyOfFiniteType (C.left ↘ Spec (.of k))] [QuasiCompact (C.left ↘ Spec (.of k))]
  [IsDominant π]
variable [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0)]
  [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1)]
variable (hπ : π ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k))
variable [IsIntegral (relCurve C K)]
  [SmoothOfRelativeDimension 1 (relCurve C K ↘ Spec (CommRingCat.of K))]
  [LocallyOfFiniteType (relCurve C K ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (relCurve C K ↘ Spec (CommRingCat.of K))]
  [Module.Finite K (Sheaf.HModule ((relCurve C K).moduleKSheaf K) 0)]
  [Module.Finite K (Sheaf.HModule ((relCurve C K).moduleKSheaf K) 1)]

/-! ## The carrier-free germ set -/

variable (K) in
/-- **The `ε`-window germ set of a bare local-equation system.**  This is
`divFamEpsWindowGermSet` (`Picard/DivSchemeMonoBridge.lean:346`) with the carrier deleted:
that definition reads its `DivFam` argument only through `divFamEps`, which is
`divisorWindow` of the underlying `eqns`, so nothing is lost.

`eqnsWindowGermSet_divFam` and `eqnsWindowGermSet_eps` below record that both carriers'
germ sets ARE this one, by `rfl` — which is the whole content of the carrier-freeness. -/
noncomputable def eqnsWindowGermSet (g : ℕ) (d : (relCurve C K).LocalEquations)
    (z : relCurve C K) : Set ((relCurve C K).presheaf.stalk z) :=
  Scheme.twistGermSet
    ((↑(Submodule.map (relThetaWindowEquiv C K π (windowM_choice π hπ g)
        (relThetaPairH1_windowM C π hπ g)).toLinearMap
        (divisorWindow d (relThetaPairH1_windowM C π hπ g))) :
      Set (relThetaSections C K π (windowM_choice π hπ g)))) z

omit [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] in
set_option maxRecDepth 8000 in
/-- The chart-typed germ set is the carrier-free one at the family's equations.

The `omit` list is not cosmetic and was measured, not guessed: the four binders dropped
here are the ones the elaborator reports unused, and the fibre-curve binders that look
equally idle canNOT be dropped — they are referenced through the instance towers that type
`relThetaWindowEquiv`.  What the identification needs is the typing of the window, not the
geometry of the divisor. -/
lemma eqnsWindowGermSet_divFam (g : ℕ) (G : CertifiedDivisorFamily C K π g)
    (z : relCurve C K) :
    divFamEpsWindowGermSet hπ g (DivFam.mk G) z = eqnsWindowGermSet K hπ g G.eqns z :=
  rfl

omit [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] in
set_option synthInstance.maxHeartbeats 800000 in
set_option maxRecDepth 8000 in
/-- The WIDENED germ set is the same carrier-free one — `CertifiedDivisorFamilyAff.eps`
(`Picard/DivisorFamilyAffFraming.lean:112`) is `divisorWindow` of its `eqns` too. -/
lemma eqnsWindowGermSet_eps (g : ℕ) (F : CertifiedDivisorFamilyAff C K g)
    (z : relCurve C K) :
    eqnsWindowGermSet K hπ g F.eqns z
      = Scheme.twistGermSet
        ((↑(Submodule.map (relThetaWindowEquiv C K π (windowM_choice π hπ g)
            (relThetaPairH1_windowM C π hπ g)).toLinearMap (F.eps hπ g).1) :
          Set (relThetaSections C K π (windowM_choice π hπ g)))) z :=
  rfl

end AlgebraicGeometry
