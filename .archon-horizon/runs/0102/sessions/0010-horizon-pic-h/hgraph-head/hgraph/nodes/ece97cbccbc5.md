---
author: sync
content_type: theorem
created: '2026-07-31T17:09:33'
decl: AlgebraicGeometry.rightChart_monomial
docstring: '`rightChart` on a monomial: `X ↦ T (-1)`, so `monomial n c ↦ C c · T (-n)`.'
file: AlgebraicJacobian/Algebra/LaurentGeneralNilpotentCoboundary.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.rightChart_monomial
type: lean
updated: '2026-08-01T09:44:08'
---
theorem rightChart_monomial (c : A) (n : ℕ) :
    rightChart A (Polynomial.monomial n c)
      = LaurentPolynomial.C c * LaurentPolynomial.T (-(n : ℤ)) := by
  rw [← Polynomial.C_mul_X_pow_eq_monomial, map_mul, rightChart_C, map_pow, rightChart_X,
    LaurentPolynomial.T_pow]
  congr 2
  ring