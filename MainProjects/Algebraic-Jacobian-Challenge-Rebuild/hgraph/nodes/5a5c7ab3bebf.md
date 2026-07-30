---
author: sync
content_type: theorem
created: '2026-07-20T16:31:23'
decl: AlgebraicJacobian.RigidEngine.submodule_eq_top_of_forall_rTensor_residueField_surjective
docstring: 'A finite submodule whose inclusion is fibrewise surjective is the whole

  ambient module.'
file: AlgebraicJacobian/Cohomology/FibreSurjective.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicJacobian.RigidEngine.submodule_eq_top_of_forall_rTensor_residueField_surjective
type: lean
updated: '2026-07-30T15:27:59'
---
theorem submodule_eq_top_of_forall_rTensor_residueField_surjective
    {X : Type u} [AddCommGroup X] [Module R X] [Module.Finite R X]
    (P : Submodule R X) [Module.Finite R ↥P]
    (hfib : ∀ p : PrimeSpectrum R,
      Function.Surjective (P.subtype.rTensor p.asIdeal.ResidueField)) :
    P = ⊤ := by
  rw [← P.range_subtype]
  exact range_eq_top_of_forall_rTensor_residueField_surjective P.subtype hfib