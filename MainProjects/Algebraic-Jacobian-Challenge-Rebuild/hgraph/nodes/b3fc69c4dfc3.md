---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: IsLocalization.Away.leftMap
docstring: The `A`-algebra map `B₁ ⊗[A] B₂ →ₐ[A] Si ⊗[A] B₂` localizing only the left
  factor.
file: AlgebraicJacobian/Algebra/TensorAway.lean
generated: lean
lean_status: lean_ok
title: IsLocalization.Away.leftMap
type: lean
updated: '2026-07-16T21:33:27'
---
noncomputable def leftMap : B₁ ⊗[A] B₂ →ₐ[A] Si ⊗[A] B₂ :=
  Algebra.TensorProduct.map (IsScalarTower.toAlgHom A B₁ Si) (AlgHom.id A B₂)