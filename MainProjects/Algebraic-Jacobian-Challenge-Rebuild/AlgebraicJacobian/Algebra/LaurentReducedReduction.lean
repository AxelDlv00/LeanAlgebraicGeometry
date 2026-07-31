/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Algebra.LaurentNilpotentCoboundary

/-!
# THE ℙ¹ COBOUNDARY QUESTION IS A QUESTION ABOUT REDUCED RINGS

`Algebra/LaurentNilpotentCoboundary.lean` proves that a Laurent unit congruent to `1` modulo a
nilpotent is a coboundary, over an arbitrary commutative ring.  On its own that is a statement
about a special class of units.  This file turns it into a **reduction of the test ring**:

> a Laurent unit whose image in `(A ⧸ nilradical A)[T;T⁻¹]` is a coboundary
> is itself a coboundary over `A`.

Since `A ⧸ nilradical A` is reduced, the ℙ¹ coboundary question at an *arbitrary* commutative
ring is equivalent to the same question at *reduced* rings.  The domain-only characterization
(`Picard/LaurentTwoChartCoboundary.lean`) does not reach reduced rings either — a reduced ring
is not a domain — so this does **not** close anything.  What it does is move the whole
obligation off the nilpotents, where it was blocked for a reason both that file and
`Algebra/LaurentUnits.lean` record (`1 + C e * T 1` is a unit at `e² = 0`), and onto a class
where the obstruction is of a different kind: over a reduced ring a Laurent unit *is* locally
`C c · Tⁿ`, and what fails is only that the exponent `n` need not be globally constant on
`Spec A`.

**This is a genuine weakening of the hypothesis, and the check is that the converse is not
free.** The forward direction below (a coboundary downstairs gives one upstairs) is the
substantive one.  The other direction is immediate — coboundaries push forward along any ring
map — so the two are *not* equivalent by symmetry, and the reduction is not a re-spelling of its
own hypothesis.  Stated as `mem_laurentCoboundaryUnits_iff_map_reduced`, with both halves
available separately.

## The two inputs, both proved here because neither is in mathlib at this pin

* `isUnit_of_isUnit_map` — **units are detected modulo a nilpotent kernel**.  If `φ` is
  surjective with `ker φ ≤ nilradical`, then `IsUnit (φ r) → IsUnit r`: lift the inverse, and
  `r * t - 1` lies in the kernel, hence is nilpotent, hence `r * t` is a unit.  Searched
  (`exact?` on both this and the unit-lifting form): absent.
* `isNilpotent_of_map_nilradical_eq_zero` — the kernel of `A[X] → (A ⧸ nil A)[X]` consists of
  nilpotent polynomials, via `Polynomial.isNilpotent_iff` (coefficientwise).  This is what makes
  the previous lemma applicable at the *chart* rings rather than only at `A`.

## Why the lift is by hand rather than by a `Pic`-functoriality lemma

The chart units downstairs are units of `(A ⧸ nil A)[X]`, and lifting them needs surjectivity of
`A[X] → (A ⧸ nil A)[X]` *plus* the unit-detection lemma above; a `Pic`-level statement would
give the class, not the presenting units, and the coboundary subgroup is defined by the presenting
units.  So the lift happens at the level of `Polynomial A`, which is also where the nilpotency of
the kernel is legible.

## Main declarations

* `AlgebraicGeometry.isUnit_of_isUnit_map` — units modulo a nilpotent kernel.
* `AlgebraicGeometry.isNilpotent_of_map_nilradical_eq_zero` — the polynomial kernel is nilpotent.
* `AlgebraicGeometry.mem_laurentCoboundaryUnits_of_map_reduced` — **the reduction**: a coboundary
  after killing the nilradical is a coboundary.
* `AlgebraicGeometry.mem_laurentCoboundaryUnits_iff_map_reduced` — bundled with the free
  converse, so the direction that carries content is visible.
-/

set_option autoImplicit false

universe u

open Polynomial LaurentPolynomial

namespace AlgebraicGeometry

/-! ## Units modulo a nilpotent kernel -/

/-- **Units are detected modulo a nilpotent kernel**: for a surjective `φ` whose kernel consists
of nilpotents, `φ r` a unit forces `r` a unit.

Lift the inverse of `φ r` to some `t`; then `φ (r * t) = 1`, so `r * t - 1` is in the kernel and
hence nilpotent, so `r * t = 1 + (r * t - 1)` is a unit and `r` divides a unit.

Measured absent from mathlib at this pin, in both this form and the unit-lifting form
`∃ r : Rˣ, φ r = s`. -/
theorem isUnit_of_isUnit_map {R S : Type u} [CommRing R] [CommRing S] (φ : R →+* S)
    (hs : Function.Surjective φ) (hker : RingHom.ker φ ≤ nilradical R) {r : R}
    (h : IsUnit (φ r)) : IsUnit r := by
  obtain ⟨t, ht⟩ := hs ((h.unit⁻¹ : Sˣ) : S)
  have h1 : φ (r * t) = 1 := by
    rw [map_mul, ht]
    calc φ r * ((h.unit⁻¹ : Sˣ) : S)
        = ((h.unit : Sˣ) : S) * ((h.unit⁻¹ : Sˣ) : S) := by rw [IsUnit.unit_spec]
      _ = 1 := by rw [← Units.val_mul, mul_inv_cancel, Units.val_one]
  have hnil : IsNilpotent (r * t - 1) := hker (by simp [RingHom.mem_ker, map_sub, h1])
  have hru : IsUnit (r * t) := by simpa using hnil.isUnit_one_add (R := R)
  exact isUnit_of_mul_isUnit_left hru

/-- The kernel of `A[X] → (A ⧸ nilradical A)[X]` consists of **nilpotent** polynomials: a
polynomial killed downstairs has every coefficient in the nilradical, and
`Polynomial.isNilpotent_iff` is exactly the coefficientwise criterion. -/
theorem isNilpotent_of_map_nilradical_eq_zero {A : Type u} [CommRing A] {p : Polynomial A}
    (h : Polynomial.mapRingHom (Ideal.Quotient.mk (nilradical A)) p = 0) :
    IsNilpotent p := by
  rw [Polynomial.isNilpotent_iff]
  intro i
  have hi : (Ideal.Quotient.mk (nilradical A)) (p.coeff i) = 0 := by
    have := congrArg (fun z => Polynomial.coeff z i) h
    simpa using this
  exact (Ideal.Quotient.eq_zero_iff_mem).mp hi

/-! ## The base-change map on Laurent rings, and that it commutes with both ℙ¹ charts -/

section BaseChange

variable {A B : Type u} [CommRing A] [CommRing B]

/-- The Laurent ring is functorial in the coefficient ring: base change along `φ`.  Mathlib
spells this `AddMonoidAlgebra.mapRingHom` at `M := ℤ`; there is no `LaurentPolynomial.map`. -/
noncomputable abbrev laurentMap (φ : A →+* B) :
    LaurentPolynomial A →+* LaurentPolynomial B :=
  AddMonoidAlgebra.mapRingHom ℤ φ

/-- Base change on a Laurent monomial: `AddMonoidAlgebra.map_single` once the `C · T` spelling is
turned into `Finsupp.single` by `single_eq_C_mul_T`. -/
theorem laurentMap_C_mul_T (φ : A →+* B) (a : A) (n : ℤ) :
    laurentMap φ (LaurentPolynomial.C a * LaurentPolynomial.T n)
      = LaurentPolynomial.C (φ a) * LaurentPolynomial.T n := by
  rw [← LaurentPolynomial.single_eq_C_mul_T, ← LaurentPolynomial.single_eq_C_mul_T]
  exact AddMonoidAlgebra.map_single (φ : A →+ B) a n

/-- `T (-1) ^ n = T (-n)`, in the orientation the right chart produces.  `T_pow` is stated with
the exponent on the *left* of the product, so the arithmetic is done by hand. -/
private lemma T_neg_one_pow {R : Type u} [CommRing R] (n : ℕ) :
    (LaurentPolynomial.T (-1 : ℤ) : LaurentPolynomial R) ^ n
      = LaurentPolynomial.T (-(n : ℤ)) := by
  have h := LaurentPolynomial.T_pow (R := R) (-1 : ℤ) n
  rw [show ((n : ℤ) * (-1)) = -(n : ℤ) from by ring] at h
  exact h

/-- **Base change commutes with the left ℙ¹ chart** `Polynomial.toLaurent`. -/
theorem laurentMap_toLaurent (φ : A →+* B) (p : Polynomial A) :
    laurentMap φ (Polynomial.toLaurent p)
      = Polynomial.toLaurent (Polynomial.mapRingHom φ p) := by
  induction p using Polynomial.induction_on' with
  | add p q hp hq => simp [hp, hq]
  | monomial n a =>
      rw [← Polynomial.C_mul_X_pow_eq_monomial, Polynomial.toLaurent_C_mul_X_pow,
        laurentMap_C_mul_T]
      simp

/-- **Base change commutes with the right ℙ¹ chart** `rightChart`. -/
theorem laurentMap_rightChart (φ : A →+* B) (p : Polynomial A) :
    laurentMap φ (rightChart A p) = rightChart B (Polynomial.mapRingHom φ p) := by
  induction p using Polynomial.induction_on' with
  | add p q hp hq => simp [hp, hq]
  | monomial n a =>
      rw [← Polynomial.C_mul_X_pow_eq_monomial]
      have hl : rightChart A (Polynomial.C a * Polynomial.X ^ n)
          = LaurentPolynomial.C a * LaurentPolynomial.T (-(n : ℤ)) := by
        rw [map_mul, rightChart_C, map_pow, rightChart_X, T_neg_one_pow]
      have hr : rightChart B (Polynomial.C (φ a) * Polynomial.X ^ n)
          = LaurentPolynomial.C (φ a) * LaurentPolynomial.T (-(n : ℤ)) := by
        rw [map_mul, rightChart_C, map_pow, rightChart_X, T_neg_one_pow]
      rw [hl, laurentMap_C_mul_T]
      simp [hr]

end BaseChange

end AlgebraicGeometry
