---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: Module.trivialization_smul_symm_one
docstring: 'The generator property of a trivialization: every element is the `t`-value
  scalar

  multiple of the generator `t.symm 1`.'
file: AlgebraicJacobian/Algebra/GeneratorUnit.lean
generated: lean
lean_status: lean_ok
title: Module.trivialization_smul_symm_one
type: lean
updated: '2026-08-01T09:44:08'
---
lemma trivialization_smul_symm_one {M₀ : Type u} [AddCommGroup M₀] [Module R M₀]
    (t : M₀ ≃ₗ[R] R) (x : M₀) :
    t x • t.symm 1 = x := by
  apply t.injective
  rw [map_smul, LinearEquiv.apply_symm_apply, smul_eq_mul, mul_one]