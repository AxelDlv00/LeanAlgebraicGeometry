---
author: sync
content_type: definition
created: '2026-07-24T17:02:46'
decl: Algebra.TensorProduct.faceA₁₃
docstring: Index-wise face hitting tensor positions `1, 3`.
file: AlgebraicJacobian/Algebra/TensorAwayPi.lean
generated: lean
lean_status: lean_ok
title: Algebra.TensorProduct.faceA₁₃
type: lean
updated: '2026-07-31T20:15:17'
---
noncomputable def faceA₁₃ (i j k : ι) : (S i ⊗[A] S k) →ₐ[A] S i ⊗[A] (S j ⊗[A] S k) :=
  Algebra.TensorProduct.map (AlgHom.id A (S i)) Algebra.TensorProduct.includeRight