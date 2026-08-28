---
author: sync
content_type: definition
created: '2026-07-19T15:31:13'
decl: AlgebraicGeometry.tensorPointEval
docstring: '**Evaluation of a base-changed function at a `k`-point**: the `k`-algebra
  map

  `A ⊗[k] L →ₐ[k] L` induced by `φ : A →ₐ[k] k` on the first factor,

  `a ⊗ c ↦ φ(a) • c`.  The algebraic shadow of evaluating a section of the base-changed

  chart at the base change of a rational point.'
file: AlgebraicJacobian/Curve/SepPointsDenseKit.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.tensorPointEval
type: lean
updated: '2026-08-01T09:44:10'
---
noncomputable def tensorPointEval (φ : A →ₐ[k] k) : A ⊗[k] L →ₐ[k] L :=
  (Algebra.TensorProduct.lid k L).toAlgHom.comp
    (Algebra.TensorProduct.map φ (AlgHom.id k L))

@[simp]