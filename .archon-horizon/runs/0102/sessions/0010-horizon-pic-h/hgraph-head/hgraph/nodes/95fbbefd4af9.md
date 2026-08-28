---
author: sync
content_type: theorem
created: '2026-07-31T09:40:08'
decl: LaurentPolynomial.C_mul_T_apply
docstring: The coefficient of a Laurent monomial at an arbitrary index.
file: AlgebraicJacobian/Algebra/LaurentUnits.lean
generated: lean
lean_status: lean_ok
title: LaurentPolynomial.C_mul_T_apply
type: lean
updated: '2026-08-01T09:44:09'
---
theorem C_mul_T_apply (c : R) (n m : ℤ) :
    (LaurentPolynomial.C c * T n : LaurentPolynomial R) m = if n = m then c else 0 := by
  rw [← LaurentPolynomial.single_eq_C_mul_T,
    show (AddMonoidAlgebra.single n c : LaurentPolynomial R) = Finsupp.single n c from rfl,
    Finsupp.single_apply]