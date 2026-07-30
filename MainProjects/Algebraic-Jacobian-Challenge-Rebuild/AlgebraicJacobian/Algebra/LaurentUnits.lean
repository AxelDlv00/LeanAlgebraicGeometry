/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import Mathlib.Algebra.Polynomial.Laurent
import Mathlib.RingTheory.Polynomial.Basic
import Mathlib.Algebra.Polynomial.Degree.Units
import Mathlib.Algebra.Polynomial.RingDivision

/-!
# The units of a Laurent polynomial ring over a domain (mathlib supplement)

`R[T;T⁻¹]ˣ = Rˣ × ℤ` when `R` is a domain: every unit is `C c * T n` with `c` a unit of `R`,
and the exponent `n` is determined.  **Mathlib does not have this.**  The whole `IsUnit` API
of `Mathlib/Algebra/Polynomial/Laurent.lean` is the single lemma
`LaurentPolynomial.isUnit_T` (measured: `loogle` for `LaurentPolynomial, IsUnit` returns only
that, `(LaurentPolynomial ?R)ˣ` returns nothing, and `grep` of the mathlib file confirms one
`IsUnit` declaration).  The polynomial analogue `Polynomial.isUnit_iff` *is* in mathlib; the
Laurent case is missing because `T (-1)` is a unit, so there is no degree-zero argument.

## Why this is here

It is the multiplicative half of the `ℙ¹` chart data.  `Curve/P1Charts.lean` identifies the
overlap ring of the two standard charts with `LaurentPolynomial k` and provides the *additive*
Laurent span (`exists_res_add_res`), which is what computes `H¹(ℙ¹, 𝒪)`.  Computing
`Pic(ℙ¹)` instead needs the *unit group* of that same overlap ring modulo the images of the two
chart unit groups, and `Rˣ × ℤ` modulo `Rˣ` on each side is where the `ℤ` comes from.

## The proof, and the one place a hypothesis is used

Clear denominators (`LaurentPolynomial.exists_T_pow`): `f * T^a` and `f⁻¹ * T^b` are honest
polynomials whose product is `X ^ (a+b)`.  So the numerator divides a power of `X`, and
`X` is prime in `R[X]` **because `R` is a domain** — this is the only use of `IsDomain`, and it
is not removable: over `R = k[ε]/ε²` the element `1 + εT` is a unit of `R[T;T⁻¹]` and is not of
the form `C c * T n`.

## Main declarations

* `LaurentPolynomial.isUnit_iff_C_mul_T` — **the classification**, as an iff.
* `LaurentPolynomial.exists_eq_C_mul_T_of_isUnit` — its forward half, in the form consumers use.
* `LaurentPolynomial.isUnit_C_mul_T` — the converse half, over any commutative ring.
* `LaurentPolynomial.exp_unique` — the exponent is determined by the element (needs only that
  the coefficient is nonzero, no domain hypothesis).
-/

set_option autoImplicit false

universe u

open Polynomial

namespace LaurentPolynomial

variable {R : Type u} [CommRing R]

/-! ## The easy direction, over an arbitrary commutative ring -/

/-- A Laurent monomial with unit coefficient is a unit.  No domain hypothesis. -/
theorem isUnit_C_mul_T {c : R} (hc : IsUnit c) (n : ℤ) :
    IsUnit (LaurentPolynomial.C c * T n) :=
  (hc.map LaurentPolynomial.C).mul (isUnit_T n)

/-! ## The exponent is determined

Stated separately from the classification because it needs no domain hypothesis, and because
it is what makes `Pic(ℙ¹) ≅ ℤ` rather than merely a quotient of `ℤ`: without it the exponent
would be only a choice. -/

/-- **The exponent of a Laurent monomial is determined by the element**, as soon as its
coefficient is nonzero.  Evaluated at the index `n`, the two `Finsupp.single`s give `c` and
`0`. -/
theorem exp_unique {c d : R} (hc : c ≠ 0) {n m : ℤ}
    (h : (LaurentPolynomial.C c * T n : LaurentPolynomial R) = LaurentPolynomial.C d * T m) :
    n = m := by
  by_contra hne
  have h1 := congrArg (fun f : LaurentPolynomial R => f n) h
  simp only [← LaurentPolynomial.single_eq_C_mul_T] at h1
  rw [show (AddMonoidAlgebra.single n c : LaurentPolynomial R) = Finsupp.single n c from rfl,
      show (AddMonoidAlgebra.single m d : LaurentPolynomial R) = Finsupp.single m d from rfl,
      Finsupp.single_eq_same] at h1
  rw [Finsupp.single_apply, if_neg (fun hh : m = n => absurd hh.symm hne)] at h1
  exact hc h1

/-! ## The classification -/

variable [IsDomain R]

/-- **Every unit of `R[T;T⁻¹]` over a domain is `C c * T n` with `c` a unit.**

Clear denominators to get polynomials `p, q` with `p * q = X ^ (a + b)`; then `p ∣ X ^ (a+b)`
and `X` is prime, so `p` is a unit times `X ^ i`, and the polynomial unit is a constant by
`Polynomial.isUnit_iff`. -/
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

/-- **The unit classification of `R[T;T⁻¹]` over a domain**, as an iff. -/
theorem isUnit_iff_C_mul_T {f : LaurentPolynomial R} :
    IsUnit f ↔ ∃ (c : R) (n : ℤ), IsUnit c ∧ f = LaurentPolynomial.C c * T n := by
  refine ⟨exists_eq_C_mul_T_of_isUnit, ?_⟩
  rintro ⟨c, n, hc, rfl⟩
  exact isUnit_C_mul_T hc n

end LaurentPolynomial
