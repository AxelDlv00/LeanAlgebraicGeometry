---
author: sync
content_type: theorem
created: '2026-07-27T01:04:30'
decl: MvPolynomial.substAlgHom_X
file: AlgebraicJacobian/Curve/P1Aut.lean
generated: lean
lean_status: lean_ok
title: MvPolynomial.substAlgHom_X
type: lean
updated: '2026-07-31T20:15:19'
---
theorem substAlgHom_X (M : Matrix σ σ R) (i : σ) :
    substAlgHom M (X i) = matrixLinearForm M i :=
  aeval_X _ _