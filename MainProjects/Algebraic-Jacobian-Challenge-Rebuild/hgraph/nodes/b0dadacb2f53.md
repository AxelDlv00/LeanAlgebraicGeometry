---
author: sync
content_type: lemma
created: '2026-07-28T13:42:17'
decl: AlgebraicGeometry.AffAdaptation.subsingleton_colength_of_disjoint_supportLocus
docstring: '**A piece that misses the support has vanishing colength**: its equation
  has unit germs

  throughout, hence is a unit, hence spans the unit ideal.  Clauses (c1) are free
  there.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffPerPiece.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.AffAdaptation.subsingleton_colength_of_disjoint_supportLocus
type: lean
updated: '2026-07-30T15:28:02'
---
lemma subsingleton_colength_of_disjoint_supportLocus (j : D.index)
    (hdisj : ∀ z : relCurve C R, z ∈ D.pieces j → z ∉ d.supportLocus) :
    Subsingleton (A.colength j) := by
  have hunit : IsUnit (A.eqn j) := by
    apply (relCurve C R).toRingedSpace.isUnit_of_isUnit_germ
    intro z hz
    have hU : z ∈ d.unitLocus := not_not.mp (hdisj z hz)
    exact (A.isUnit_germ_eqn_iff j hz).mpr
      ((d.mem_unitLocus_iff_isUnit_germ (d.cover.mem_opens z)).mp hU)
  exact Ideal.Quotient.subsingleton_iff.mpr
    (Ideal.eq_top_of_isUnit_mem _ (Ideal.subset_span rfl) hunit)