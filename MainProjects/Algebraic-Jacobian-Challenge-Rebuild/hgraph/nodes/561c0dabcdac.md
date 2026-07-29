---
author: sync
content_type: theorem
created: '2026-07-27T01:04:30'
decl: MvPolynomial.substAlgHom_X
file: AlgebraicJacobian/Curve/P1Aut.lean
generated: lean
lean_status: lean_ok
stale: true
title: MvPolynomial.substAlgHom_X
type: lean
updated: '2026-07-29T15:26:21'
---
theorem substAlgHom_X (M : Matrix σ σ R) (i : σ) :
    substAlgHom M (X i) = matrixLinearForm M i :=
  aeval_X _ _