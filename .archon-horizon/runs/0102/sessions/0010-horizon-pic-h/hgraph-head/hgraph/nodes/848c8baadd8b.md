---
author: sync
content_type: definition
created: '2026-07-31T09:39:43'
decl: LaurentPolynomial.unitsHom
docstring: 'The homomorphism `Rˣ × ℤ →* (R[T;T⁻¹])ˣ` sending `(c, n)` to `C c * T
  n`.  Over any

  commutative ring; the domain hypothesis is only needed for surjectivity.'
file: AlgebraicJacobian/Algebra/LaurentUnits.lean
generated: lean
lean_status: lean_ok
title: LaurentPolynomial.unitsHom
type: lean
updated: '2026-08-01T09:44:09'
---
noncomputable def unitsHom :
    Rˣ × Multiplicative ℤ →* (LaurentPolynomial R)ˣ where
  toFun p := (Units.map (LaurentPolynomial.C : R →+* LaurentPolynomial R).toMonoidHom p.1)
      * tUnit (Multiplicative.toAdd p.2)
  map_one' := Units.ext (by
    change (LaurentPolynomial.C (1 : R)) * T (0 : ℤ) = 1
    rw [map_one, T_zero, one_mul])
  map_mul' a b := Units.ext (by
    change LaurentPolynomial.C ((a.1 * b.1 : Rˣ) : R) * T (Multiplicative.toAdd (a.2 * b.2))
      = (LaurentPolynomial.C (a.1 : R) * T (Multiplicative.toAdd a.2))
        * (LaurentPolynomial.C (b.1 : R) * T (Multiplicative.toAdd b.2))
    push_cast
    have hT : (T (Multiplicative.toAdd (a.2 * b.2)) : LaurentPolynomial R)
        = T (Multiplicative.toAdd a.2) * T (Multiplicative.toAdd b.2) := by
      rw [← T_add]; rfl
    rw [map_mul, hT]
    ring)

omit [IsDomain R] in
@[simp]