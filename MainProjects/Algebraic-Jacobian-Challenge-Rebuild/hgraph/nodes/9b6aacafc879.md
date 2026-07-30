---
author: sync
content_type: definition
created: '2026-07-24T17:02:48'
decl: AlgebraicGeometry.descentMul₁₂
docstring: 'The `A`-linear degeneracy multiplying the first two tensor positions,

  `x ⊗ (y ⊗ z) ↦ xy ⊗ z`.'
file: AlgebraicJacobian/Picard/SpecDegeneracy.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.descentMul₁₂
type: lean
updated: '2026-07-30T15:28:02'
---
noncomputable def descentMul₁₂ : B ⊗[A] (B ⊗[A] B) →ₐ[A] B ⊗[A] B :=
  Algebra.TensorProduct.lift (Module.descentIncl₁ A B) (AlgHom.id A (B ⊗[A] B))
    fun _ _ => Commute.all _ _

@[simp]