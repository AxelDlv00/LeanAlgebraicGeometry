---
author: sync
content_type: lemma
created: '2026-07-30T03:30:39'
decl: AlgebraicGeometry.AffAdaptation.isUnit_germ_eqn_of_coeffAt_eq_zero
docstring: Where the divisor coefficient vanishes, the piece equation is a stalk unit,
  widened.
file: AlgebraicJacobian/Picard/DivisorFamilyAffStalkEval.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.isUnit_germ_eqn_of_coeffAt_eq_zero
type: lean
updated: '2026-07-31T20:15:24'
---
lemma isUnit_germ_eqn_of_coeffAt_eq_zero (j : D.index) {z : relCurve C K}
    (hz : z ∈ D.pieces j) (hzg : z ≠ genericPoint (relCurve C K))
    (h0 : coeffAt hzg (Scheme.presentationDivisor K d.presentation) = 0) :
    IsUnit (((relCurve C K).presheaf.germ (D.pieces j) z hz).hom (A.eqn j)) := by
  have hη : genericPoint (relCurve C K) ∈ D.pieces j :=
    Scheme.genericPoint_mem_of_nonempty ⟨z, hz⟩
  have hne : ((relCurve C K).presheaf.germ (D.pieces j) (genericPoint (relCurve C K))
      hη).hom (A.eqn j) ≠ 0 :=
    mem_nonZeroDivisors_iff_ne_zero.mp (A.eqn_regular j (genericPoint (relCurve C K)) hη)
  set g : (relCurve C K).functionFieldˣ := Units.mk0 _ hne with hgdef
  have hg : (g : (relCurve C K).functionField)
      = ((relCurve C K).presheaf.germ (D.pieces j) (genericPoint (relCurve C K)) hη).hom
          (A.eqn j) := rfl
  have h1 := A.coeffAt_eq_toAdd_ordZ_eqn j hz hzg g hg
  rw [h0] at h1
  have hord : Scheme.ordZ (relCurve C K ↘ Spec (CommRingCat.of K)) hzg g = 1 :=
    Multiplicative.toAdd.injective (by rw [h1]; exact toAdd_one.symm)
  exact (Scheme.isUnit_germ_iff_ordZ_eq_one K hη (A.eqn j) g hg hz hzg).mpr hord

/-! ## The stalk evaluations of the widened colength modules

Ported from `DivisorAdaptation.stalkColEval` and friends
(`Picard/DivisorFamilyStalkEval.lean:150-269`).  The stalk `K`-algebra structure is the house
local instance `Scheme.stalkOverAlgebra`, activated here rather than at the top of the file so
the three already-landed section-only lemmas above are elaborated in the environment they were
written in. -/

attribute [local instance] Scheme.stalkOverAlgebra