---
author: sync
content_type: lemma
created: '2026-07-28T19:44:56'
decl: AlgebraicGeometry.AffAdaptation.rankAtStalk_colength_eq_zero_of_disjoint
docstring: '**A piece that misses the support contributes rank zero.**  Its colength
  module is

  subsingleton, so its `Module.support` is empty and `rankAtStalk` vanishes at every
  prime.


  The flatness and finiteness instances `rankAtStalk_eq_zero_iff_notMem_support` wants
  are free

  for a subsingleton module: it is free (on the empty basis), hence flat, and finite.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffRank.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.rankAtStalk_colength_eq_zero_of_disjoint
type: lean
updated: '2026-07-29T15:31:44'
---
lemma rankAtStalk_colength_eq_zero_of_disjoint (j : D.index)
    (hdisj : Disjoint d.supportLocus (D.pieces j : Set (relCurve C R)))
    (p : PrimeSpectrum R) :
    Module.rankAtStalk (R := R) (A.colength j) p = 0 := by
  haveI := A.subsingleton_colength_of_disjoint_supportLocus j
    (fun _ hz hsupp => (Set.disjoint_left.mp hdisj) hsupp hz)
  haveI : Module.Free R (A.colength j) := Module.Free.of_subsingleton R (A.colength j)
  haveI : Module.Flat R (A.colength j) := Module.Flat.of_free
  haveI : Module.Finite R (A.colength j) := Module.Finite.of_finite
  rw [Module.rankAtStalk_eq_zero_iff_notMem_support,
    Module.support_eq_empty (R := R) (M := A.colength j)]
  exact Set.notMem_empty p