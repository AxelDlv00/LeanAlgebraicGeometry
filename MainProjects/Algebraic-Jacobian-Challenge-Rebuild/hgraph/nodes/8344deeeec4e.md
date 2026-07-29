---
author: sync
content_type: theorem
created: '2026-07-16T21:33:27'
decl: Module.trivialization_hom_ext
docstring: 'Two `C`-linear maps out of `C ⊗[A] N` valued in `C` that agree on the
  tensors

  `1 ⊗ₜ n` are equal: these tensors `C`-span the base change.'
file: AlgebraicJacobian/Algebra/BaseChangeTrivialization.lean
generated: lean
lean_status: lean_ok
stale: true
title: Module.trivialization_hom_ext
type: lean
updated: '2026-07-29T15:26:26'
---
theorem trivialization_hom_ext {t₁ t₂ : C ⊗[A] N →ₗ[C] C}
    (h : ∀ n : N, t₁ (1 ⊗ₜ n) = t₂ (1 ⊗ₜ n)) : t₁ = t₂ := by
  apply LinearMap.restrictScalars_injective A
  apply TensorProduct.ext'
  intro c n
  have hc : (c ⊗ₜ[A] n : C ⊗[A] N) = c • (1 ⊗ₜ[A] n : C ⊗[A] N) := by
    rw [TensorProduct.smul_tmul', smul_eq_mul, mul_one]
  simp only [LinearMap.coe_restrictScalars, hc, map_smul, h]