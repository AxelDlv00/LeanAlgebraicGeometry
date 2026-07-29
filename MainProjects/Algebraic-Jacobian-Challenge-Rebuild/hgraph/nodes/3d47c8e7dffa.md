---
author: sync
content_type: theorem
created: '2026-07-17T08:41:25'
decl: Module.Flat.mem_smul_top_of_tmul_residueField_one_eq_zero
docstring: '**The prime-fibre kernel computation** (the flat half): for flat `M` and
  a prime

  `p`, `x ⊗ 1 = 0` in `M ⊗[R] κ(p)` forces `x ∈ p • ⊤`. The map

  `M ⧸ p•⊤ ≃ M ⊗ (R⧸p) → M ⊗ κ(p)` is injective because `R⧸p ↪ κ(p)` is and `M` is

  flat.'
file: AlgebraicJacobian/Picard/FibrewiseRegular.lean
generated: lean
lean_status: lean_ok
stale: true
title: Module.Flat.mem_smul_top_of_tmul_residueField_one_eq_zero
type: lean
updated: '2026-07-29T15:26:17'
---
theorem Module.Flat.mem_smul_top_of_tmul_residueField_one_eq_zero [Module.Flat R M]
    (p : Ideal R) [p.IsPrime] {x : M}
    (hx : (x ⊗ₜ[R] (1 : p.ResidueField) : M ⊗[R] p.ResidueField) = 0) :
    x ∈ p • (⊤ : Submodule R M) := by
  set f : (R ⧸ p) →ₗ[R] p.ResidueField :=
    (Algebra.linearMap (R ⧸ p) p.ResidueField).restrictScalars R with hf
  have hfinj : Function.Injective f := by
    intro u v huv
    exact Ideal.injective_algebraMap_quotient_residueField p huv
  have h1 : (TensorProduct.tensorQuotEquivQuotSMul M p).symm
      (Submodule.Quotient.mk x) = x ⊗ₜ[R] (1 : R ⧸ p) :=
    TensorProduct.tensorQuotEquivQuotSMul_symm_mk p x
  have h2 : (LinearMap.lTensor M f) (x ⊗ₜ[R] (1 : R ⧸ p))
      = x ⊗ₜ[R] (1 : p.ResidueField) := by
    rw [LinearMap.lTensor_tmul]
    congr 1
    rw [hf]
    simp
  have h5 : (x ⊗ₜ[R] (1 : R ⧸ p) : M ⊗[R] (R ⧸ p)) = 0 :=
    Module.Flat.lTensor_preserves_injective_linearMap f hfinj
      (by rw [h2, hx, map_zero])
  have hmk : (Submodule.Quotient.mk x : M ⧸ (p • (⊤ : Submodule R M))) = 0 :=
    (TensorProduct.tensorQuotEquivQuotSMul M p).symm.injective
      (by rw [h1, h5, map_zero])
  rwa [Submodule.Quotient.mk_eq_zero] at hmk

end ResidueFibre

section Core

variable {R : Type u} [CommRing R] {M : Type v} [AddCommGroup M] [Module R M]