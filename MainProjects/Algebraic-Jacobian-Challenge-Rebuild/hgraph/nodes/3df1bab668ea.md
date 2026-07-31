---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: Module.dual_ext
docstring: Two `B`-functionals on `B ⊗[A] X` that agree on the tensors `1 ⊗ₜ x` are
  equal.
file: AlgebraicJacobian/Descent/InvertibleModule.lean
generated: lean
lean_status: lean_ok
private: true
title: Module.dual_ext
type: lean
updated: '2026-07-31T20:15:19'
---
private theorem dual_ext {X : Type u} [AddCommGroup X] [Module A X]
    {F G : Dual B (B ⊗[A] X)} (h : ∀ x : X, F (1 ⊗ₜ x) = G (1 ⊗ₜ x)) : F = G := by
  apply LinearMap.restrictScalars_injective A
  apply TensorProduct.ext'
  intro b x
  have hb : b ⊗ₜ[A] x = b • (1 ⊗ₜ[A] x : B ⊗[A] X) := by
    rw [TensorProduct.smul_tmul', smul_eq_mul, mul_one]
  simp only [LinearMap.restrictScalars_apply, hb, map_smul, h]

variable (P : Type u) [AddCommGroup P] [Module A P]