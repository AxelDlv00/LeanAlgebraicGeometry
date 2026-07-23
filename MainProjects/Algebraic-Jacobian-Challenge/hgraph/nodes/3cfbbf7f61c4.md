---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Adelic.C_mul_T_eq_smul
docstring: A monomial equals its constant coefficient scaling the pure power `xⁿ`.
file: AlgebraicJacobian/RiemannRoch/Adelic/P1BaseCase.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.C_mul_T_eq_smul
type: lean
updated: '2026-07-24T03:02:13'
---
lemma C_mul_T_eq_smul (a : R) (n : ℤ) :
    (C a * T n : LaurentPolynomial R) = a • T n := by
  simp [Algebra.smul_def]