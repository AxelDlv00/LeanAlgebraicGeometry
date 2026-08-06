---
author: sync
content_type: theorem
created: '2026-08-02T04:08:38'
decl: AlgebraicGeometry.divEq_trivEqns_of_isLocallyCertifiedAff_zero
docstring: A widened locally certified degree-zero system is divisor-equal to the
  trivial system.
file: AlgebraicJacobian/Picard/DivisorFamilyAffDegreeZeroRep.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divEq_trivEqns_of_isLocallyCertifiedAff_zero
type: lean
updated: '2026-08-07T05:01:51'
---
theorem divEq_trivEqns_of_isLocallyCertifiedAff_zero
    {d : (relCurve C R).LocalEquations} (hd : IsLocallyCertifiedAff 0 d) :
    Scheme.LocalEquations.DivEq d (DivFamZar.trivEqns C R) := by
  classical
  obtain ⟨m, f, hspan, hG⟩ := hd
  set f' : ULift.{u} (Fin m) → R := fun i => f i.down with hf'
  have hspan' : Ideal.span (Set.range f') = ⊤ := by
    rw [← hspan]
    congr 1
    exact Set.ext fun x =>
      ⟨fun ⟨i, hi⟩ => ⟨i.down, hi⟩, fun ⟨i, hi⟩ => ⟨ULift.up i, hi⟩⟩
  haveI : ∀ i : ULift.{u} (Fin m),
      IsOpenImmersion (relCurveMap C R (Localization.Away (f' i))) :=
    fun i => isOpenImmersion_relCurveMap_away C R (Localization.Away (f' i)) (f' i)
  refine Scheme.LocalEquations.divEq_of_divEq_pullback
    (fun i : ULift.{u} (Fin m) => relCurveMap C R (Localization.Away (f' i)))
    (fun y => exists_relCurveMap_base_eq C R f'
      (fun i => Localization.Away (f' i)) hspan' y)
    (fun i => Scheme.LocalEquations.germ_pullbackEqn_mem_nonZeroDivisors_of_isOpenImmersion
      (relCurveMap C R (Localization.Away (f' i))) d)
    (fun i => Scheme.LocalEquations.germ_pullbackEqn_mem_nonZeroDivisors_of_isOpenImmersion
      (relCurveMap C R (Localization.Away (f' i))) (DivFamZar.trivEqns C R))
    (fun i => ?_)
  obtain ⟨G, hGdiv⟩ := hG i.down
  exact (hGdiv.symm.trans
      (G.adaptation.divEq_trivEqns_of_isCertified_zero G.certified)).trans
    (divEq_pullback_trivEqns _ _).symm