---
author: sync
content_type: theorem
created: '2026-07-31T07:19:37'
decl: LaurentPolynomial.exists_eq_C_mul_T_of_isUnit
docstring: '**Every unit of `R[T;T⁻¹]` over a domain is `C c * T n` with `c` a unit.**


  Clear denominators to get polynomials `p, q` with `p * q = X ^ (a + b)`; then `p
  ∣ X ^ (a+b)`

  and `X` is prime, so `p` is a unit times `X ^ i`, and the polynomial unit is a constant
  by

  `Polynomial.isUnit_iff`.'
file: AlgebraicJacobian/Algebra/LaurentUnits.lean
generated: lean
lean_status: lean_ok
title: LaurentPolynomial.exists_eq_C_mul_T_of_isUnit
type: lean
updated: '2026-07-31T07:19:37'
---
theorem exists_eq_C_mul_T_of_isUnit {f : LaurentPolynomial R} (hf : IsUnit f) :
    ∃ (c : R) (n : ℤ), IsUnit c ∧ f = LaurentPolynomial.C c * T n := by
  obtain ⟨g, hg⟩ := hf.exists_right_inv
  obtain ⟨a, p, hp⟩ := exists_T_pow f
  obtain ⟨b, q, hq⟩ := exists_T_pow g
  have key : Polynomial.toLaurent (p * q) = Polynomial.toLaurent (Polynomial.X ^ (a + b)) := by
    rw [map_mul, hp, hq]
    rw [show (f * T (a : ℤ)) * (g * T (b : ℤ)) = (f * g) * T ((a : ℤ) + b) by
      rw [T_add]; ring]
    rw [hg, one_mul]
    simp
  have hpq : p * q = Polynomial.X ^ (a + b) := toLaurent_injective key
  obtain ⟨i, _, u, hu⟩ := (dvd_prime_pow Polynomial.prime_X (a + b)).mp ⟨q, hpq.symm⟩
  obtain ⟨c, hc, hcu⟩ := Polynomial.isUnit_iff.mp (Units.isUnit u⁻¹)
  have hpX : p = Polynomial.C c * Polynomial.X ^ i := by
    have hpu : p = Polynomial.X ^ i * (↑u⁻¹ : Polynomial R) := by rw [← hu, mul_assoc]; simp
    rw [hpu, hcu, mul_comm]
  refine ⟨c, (i : ℤ) - a, hc, ?_⟩
  have hf' : f = Polynomial.toLaurent p * T (-(a : ℤ)) := by
    rw [hp, mul_assoc, ← T_add]; simp
  rw [hf', hpX, map_mul, toLaurent_C, map_pow, toLaurent_X, mul_assoc, T_pow, ← T_add,
    show ((i : ℤ) * 1 + -(a : ℤ)) = (i : ℤ) - a by ring]