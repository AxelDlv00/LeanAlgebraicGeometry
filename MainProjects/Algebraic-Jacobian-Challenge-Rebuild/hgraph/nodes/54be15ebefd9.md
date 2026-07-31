---
author: sync
content_type: theorem
created: '2026-07-19T10:31:16'
decl: LinearMap.rTensor_subtype_injective_of_forall_ker_rTensor_residueField_le
docstring: '**Base change of the kernel, injectivity half**: `L ⊗ κ(p) → M ⊗ κ(p)`
  is injective

  (`L ↪ M` is split by `exists_comp_subtype_eq_id`, and split injections are universally

  injective).'
file: AlgebraicJacobian/Picard/SlicingFlatKernel.lean
generated: lean
lean_status: lean_ok
stale: true
title: LinearMap.rTensor_subtype_injective_of_forall_ker_rTensor_residueField_le
type: lean
updated: '2026-07-31T20:14:44'
---
theorem LinearMap.rTensor_subtype_injective_of_forall_ker_rTensor_residueField_le
    [Module.Flat R M] (hle : L ≤ LinearMap.ker f)
    (hspan : ∀ p : PrimeSpectrum R,
      LinearMap.ker (f.rTensor p.asIdeal.ResidueField) ≤
        LinearMap.range ((L.subtype).rTensor p.asIdeal.ResidueField))
    (p : PrimeSpectrum R) :
    Function.Injective ((L.subtype).rTensor p.asIdeal.ResidueField) := by
  obtain ⟨r, hr⟩ := exists_comp_subtype_eq_id f L hle hspan
  have hcomp : (r.rTensor p.asIdeal.ResidueField) ∘ₗ
      ((L.subtype).rTensor p.asIdeal.ResidueField) = LinearMap.id := by
    rw [← LinearMap.rTensor_comp, hr, LinearMap.rTensor_id]
  exact Function.HasLeftInverse.injective ⟨_, LinearMap.congr_fun hcomp⟩

omit [IsNoetherianRing R] [Module.Finite R M] [Module.Finite R N] [Module.Flat R N] in