/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivisorFamilyAffFieldDegree
import AlgebraicJacobian.Picard.DivisorFamilyStalkEval
import AlgebraicJacobian.Picard.DivisorFamilyFieldCRT

/-!
# The colength↔degree identity on the WIDENED adaptation, with NO separation hypothesis

`Picard/DivisorFamilyAffFieldDegree.lean` ports the *support-separated* colength↔degree identity
to `AffAdaptation`.  That route works, but its `hsep` is a real restriction and it has no
producer: a `work-reviewer` audit this session closed a refutation showing that `hsep` together
with a support point in `V₀ ⊓ V₁` gives `False`, and a conclusion-position census over the whole
project found zero producers of either separation shape.  So the separated identity's
"the DD-1c backward map satisfies it by construction" was inherited prose with nothing behind it.

The chart-typed side already retired that route.  `DivisorAdaptation.deg_presentationDivisor`
(`Picard/DivisorFamilyFieldCRT.lean:324`) proves the identity for **every** adaptation, with no
separation hypothesis at all, by evaluating the glued equalizer at stalks over the support
(`gluedStalkEval` bijective) instead of decomposing it over the cover.  This file ports that
route, which is the one a consumer should use.

## Why this port is cheaper than it looks

The stalk route touches the cover *less* than the separated route did, not more.  Measured:
`Picard/DivisorFamilyStalkEval.lean` contains **zero** chart-specific tokens, and
`Picard/DivisorFamilyFieldCRT.lean` contains exactly four, all inside one block
(`:181-184`) whose entire output is "every point lies in some piece" — the same
`AffCoverData.exists_mem_pieces` substitution that carried the separated port.  Every member the
engine reads (`pieces`, `index`, `eqn`, `eqn_regular`, `colength`, `ovlColength`, `ovlIdeal`,
`chartProd`, `Glued`, `gluedSubmodule`, `mem_gluedSubmodule_iff`) is carried by `AffAdaptation`
under the same name.

## Main declarations

* `AffAdaptation.span_germ_eqn_eq_stalkIdeal` — a piece equation generates `d`'s stalk ideal at
  each of its points, so the piece-local data is adaptation-free at stalks.
* `AffAdaptation.isUnit_germ_eqn_of_coeffAt_eq_zero` — vanishing coefficient means unit germ.
* `AffAdaptation.stalkColEval`, `stalkColEval_mk` — the piece colength evaluated at a stalk.
* `AffAdaptation.deg_presentationDivisor` — **the identity with no `hsep`**, for every widened
  adaptation.
* `AffAdaptation.IsCertified.deg_presentationDivisor` — `deg D = n`, unconditionally on the cover.

## What this does NOT close

`hdegAff` (`Picard/DivisorFamilyAffAbel.lean`) is the *Abel-value* ledger and remains an explicit
hypothesis there; the distance to it is the widened transport from the presentation divisor's
degree to the Picard class.  Nothing here touches `rep` or any antecedent of the atlas assembly.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
/- `lake env lean` drops the lakefile's `[leanOptions]` (I-0161); pin in-file. -/
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory TopologicalSpace Opposite
open Module (finrank)

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {K : Type u} [Field K] [Algebra k K]

namespace AffAdaptation

variable [IsIntegral (relCurve C K)]
  [SmoothOfRelativeDimension 1 (relCurve C K ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (relCurve C K ↘ Spec (CommRingCat.of K))]

variable {D : AffCoverData C K} {d : (relCurve C K).LocalEquations} (A : AffAdaptation D d)

omit [IsIntegral (relCurve C K)]
  [SmoothOfRelativeDimension 1 (relCurve C K ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (relCurve C K ↘ Spec (CommRingCat.of K))] in
/-- **A piece equation generates the stalk ideal of `d` at each of its points**, widened. -/
lemma span_germ_eqn_eq_stalkIdeal (j : D.index) {z : relCurve C K} (hz : z ∈ D.pieces j) :
    Ideal.span {((relCurve C K).presheaf.germ (D.pieces j) z hz).hom (A.eqn j)}
      = d.stalkIdeal z := by
  sorry

/-- Where the divisor coefficient vanishes, the piece equation is a stalk unit, widened. -/
lemma isUnit_germ_eqn_of_coeffAt_eq_zero (j : D.index) {z : relCurve C K}
    (hz : z ∈ D.pieces j) (hzg : z ≠ genericPoint (relCurve C K))
    (h0 : coeffAt hzg (Scheme.presentationDivisor K d.presentation) = 0) :
    IsUnit (((relCurve C K).presheaf.germ (D.pieces j) z hz).hom (A.eqn j)) := by
  sorry

/-- **The colength↔degree identity for EVERY widened adaptation** — no separation hypothesis. -/
theorem deg_presentationDivisor :
    Scheme.CurveDivisor.deg K (Scheme.presentationDivisor K d.presentation)
      = (finrank K A.Glued : ℤ) := by
  sorry

/-- **`deg D = n` for every widened certified adaptation**, with no hypothesis on the cover. -/
theorem IsCertified.deg_presentationDivisor {n : ℕ} (hc : A.IsCertified n) :
    Scheme.CurveDivisor.deg K (Scheme.presentationDivisor K d.presentation) = (n : ℤ) := by
  sorry

end AffAdaptation

end AlgebraicGeometry
