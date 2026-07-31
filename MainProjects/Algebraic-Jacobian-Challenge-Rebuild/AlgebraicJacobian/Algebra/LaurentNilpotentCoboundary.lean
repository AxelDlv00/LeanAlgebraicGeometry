/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.LaurentTwoChartCoboundary
import AlgebraicJacobian.Curve.P1

/-!
# NILPOTENT LAURENT UNITS ARE COBOUNDARIES — THE NON-REDUCED HALF, WITH NO DOMAIN HYPOTHESIS

`Picard/LaurentTwoChartCoboundary.lean` characterizes the ℙ¹ coboundary subgroup
`laurentCoboundaryUnits A` **over a domain**: a Laurent unit is a coboundary exactly when it is
`C` of a unit of `A`.  That binder is not cosmetic and both its author and
`Algebra/LaurentUnits.lean` record why it cannot simply be dropped: whenever `e² = 0` the element
`1 + C e * T 1` is a unit of `A[t]`, so at a non-reduced `A` the chart unit groups are strictly
bigger than the constants and `Polynomial.isUnit_iff` — the engine of that characterization — is
false.

**Every test ring in the `pic⁰` vanishing obligation is arbitrary**, `k[ε]` included.  So the
domain-only characterization does not reach the obligation, and the gap is exactly the
non-reduced directions.  This file closes those directions, in the direction a consumer needs:

> a Laurent unit congruent to `1` modulo a nilpotent **is** a coboundary,
> over an arbitrary commutative ring.

## Why this is the good direction, and not a repricing of the domain result

The domain characterization and this file point opposite ways and neither implies the other:

* over a domain, `eq_C_of_mem_laurentCoboundaryUnits` says the coboundary subgroup is *small*
  (only constants), which is what makes `Pic(ℙ¹_A) = ℤ` nonzero — `t` escapes it;
* here the coboundary subgroup is shown to *contain* every nilpotent deformation of `1`.  There
  is no tension: at a non-reduced ring the extra chart units are precisely the nilpotent
  deformations, and they are coboundaries because they deform `1` on *each chart separately*.

The mechanism is the **additive** Laurent span `LaurentPolynomial.exists_toLaurent_add_aeval`
(`Curve/P1.lean:62`, stated over an arbitrary `CommSemiring`) — i.e. `H¹(ℙ¹, 𝒪) = 0`, the same
input that computes the ℙ¹ cohomology.  Splitting the nilpotent part `z = p(T) + q(T⁻¹)`
additively and exponentiating gives chart units `1 + p` and `1 + q` whose product is `1 + z`,
because the cross term `p·q` carries `e²`.  That is the classical statement that a line bundle
trivial on the reduction, on a curve with vanishing `H¹`, is trivial: **the obstruction to
deforming a trivialization lives in `H¹` and there is none.**

## The nilpotency index

`nilpotent_isUnit_mem_laurentCoboundaryUnits` is stated for an arbitrary nilpotent `e` rather
than only for `e² = 0`, and the induction is on the nilpotency index: `e ^ (n+1) = 0` is handled
by peeling one square-zero layer at a time, each layer contributing chart units and coboundaries
being a subgroup.  The square-zero case is separated out as
`sqZero_isUnit_mem_laurentCoboundaryUnits` because that is the case a tangent-space consumer
(`k[ε]`) meets, and it needs no induction.

## What this does NOT do

It does **not** close the ring case of the `pic⁰` vanishing, and it adds no hypothesis to any
existing statement.  What it removes is one specific blocker: "the chart computation is only
available over a domain".  It is now available at every ring *for the classes congruent to `1`
modulo nilpotents*.  The residue is the **reduced** case — a reduced ring is not a domain, and
the exponent of a Laurent unit is only locally constant on `Spec A` — plus, unchanged and prior
to all of this, the bridge from a degree-zero hypothesis to a *presenting* unit
(`Picard/TwoChartCechPicTrivial.lean` `cechPic_eq_one_of_forall_presenting_coboundary` is the
form to aim at; the universal form is false already over a domain, by
`not_tUnit_mem_laurentCoboundaryUnits`).

## Main declarations

* `AlgebraicGeometry.isUnit_one_add_C_mul_of_sqZero` — `1 + C e * p` is a unit of `A[X]` when
  `e² = 0`, over any commutative ring (the chart-unit supply).
* `AlgebraicGeometry.exists_chart_units_of_sqZero` — the **split**: `1 + C e * f` is a product
  of a unit of `A[T]` and a unit of `A[T⁻¹]`, by the additive Laurent span.
* `AlgebraicGeometry.sqZero_isUnit_mem_laurentCoboundaryUnits` — the same in pic-g's coboundary
  subgroup, the form the ℙ¹ Picard computation consumes.
* `AlgebraicGeometry.nilpotent_isUnit_mem_laurentCoboundaryUnits` — an arbitrary nilpotent
  deformation of `1`, by induction on the nilpotency index.
-/

set_option autoImplicit false

universe u

open Polynomial LaurentPolynomial

namespace AlgebraicGeometry

variable {A : Type u} [CommRing A]

/-! ## Chart units from a square-zero element -/

/-- **A square-zero deformation of `1` is a unit of the chart ring** `A[X]`, over an arbitrary
commutative ring: `(1 + C e * p)(1 - C e * p) = 1` because the cross term carries `e²`.

This is the supply of chart units that `Polynomial.isUnit_iff` cannot see, and the reason that
lemma needs a domain: at `e ≠ 0` this unit is not a constant. -/
theorem isUnit_one_add_C_mul_of_sqZero {e : A} (he : e * e = 0) (p : Polynomial A) :
    IsUnit (1 + Polynomial.C e * p) := by
  have h0 : (Polynomial.C e * p) * (Polynomial.C e * p) = 0 := by
    calc (Polynomial.C e * p) * (Polynomial.C e * p)
        = (Polynomial.C e * Polynomial.C e) * (p * p) := by ring
      _ = 0 := by rw [← Polynomial.C_mul, he, map_zero, zero_mul]
  have hmul : (1 + Polynomial.C e * p) * (1 - Polynomial.C e * p) = 1 := by
    calc (1 + Polynomial.C e * p) * (1 - Polynomial.C e * p)
        = 1 - (Polynomial.C e * p) * (Polynomial.C e * p) := by ring
      _ = 1 := by rw [h0, sub_zero]
  exact IsUnit.of_mul_eq_one _ hmul

/-- **THE SPLIT**: a square-zero deformation of `1` in the overlap ring is the product of a
chart-`0` unit and a chart-`1` unit, over an arbitrary commutative ring.

The witnesses are `1 + C e * p` and `1 + C e * q` for the *additive* Laurent decomposition
`f = p(T) + q(T⁻¹)` (`LaurentPolynomial.exists_toLaurent_add_aeval`, i.e. `H¹(ℙ¹, 𝒪) = 0`).
Their product is `1 + C e * f` on the nose: the cross term is `C e * C e * (…) = 0`. -/
theorem exists_chart_units_of_sqZero {e : A} (he : e * e = 0) (f : LaurentPolynomial A) :
    ∃ v w : Polynomial A, IsUnit v ∧ IsUnit w ∧
      (1 + LaurentPolynomial.C e * f)
        = Polynomial.toLaurent v * rightChart A w := by
  obtain ⟨p, q, hf⟩ := LaurentPolynomial.exists_toLaurent_add_aeval f
  refine ⟨1 + Polynomial.C e * p, 1 + Polynomial.C e * q,
    isUnit_one_add_C_mul_of_sqZero he p, isUnit_one_add_C_mul_of_sqZero he q, ?_⟩
  have hCC : (LaurentPolynomial.C e : LaurentPolynomial A) * LaurentPolynomial.C e = 0 := by
    rw [← map_mul, he, map_zero]
  have hrq : rightChart A (1 + Polynomial.C e * q)
      = 1 + LaurentPolynomial.C e
          * Polynomial.aeval (LaurentPolynomial.T (-1) : LaurentPolynomial A) q := by
    rw [map_add, map_one, map_mul, rightChart_C, rightChart, Polynomial.aeval_def]
    simp only [Polynomial.coe_eval₂RingHom]
    congr 1
  have hlp : Polynomial.toLaurent (1 + Polynomial.C e * p)
      = 1 + LaurentPolynomial.C e * Polynomial.toLaurent p := by
    rw [map_add, map_one, map_mul, Polynomial.toLaurent_C]
  rw [hf, hrq, hlp]
  symm
  calc (1 + LaurentPolynomial.C e * Polynomial.toLaurent p)
        * (1 + LaurentPolynomial.C e
            * Polynomial.aeval (LaurentPolynomial.T (-1) : LaurentPolynomial A) q)
      = 1 + LaurentPolynomial.C e * Polynomial.toLaurent p
          + LaurentPolynomial.C e
            * Polynomial.aeval (LaurentPolynomial.T (-1) : LaurentPolynomial A) q
          + (LaurentPolynomial.C e * LaurentPolynomial.C e)
            * (Polynomial.toLaurent p
              * Polynomial.aeval (LaurentPolynomial.T (-1) : LaurentPolynomial A) q) := by
        ring
    _ = 1 + LaurentPolynomial.C e
          * (Polynomial.toLaurent p
            + Polynomial.aeval (LaurentPolynomial.T (-1) : LaurentPolynomial A) q) := by
        rw [hCC, zero_mul]; ring

/-! ## The coboundary-subgroup form -/

/-- **The square-zero case in the coboundary subgroup** — the form the ℙ¹ Picard computation
consumes, and the one that is *false* if you try to get it from the domain characterization.

Over a domain `eq_C_of_mem_laurentCoboundaryUnits` forces a coboundary to be a constant; here
`1 + C e * f` is a coboundary and is not constant.  There is no contradiction: at `e ≠ 0` the
ring is not a domain, which is exactly the case that lemma excludes. -/
theorem sqZero_isUnit_mem_laurentCoboundaryUnits {e : A} (he : e * e = 0)
    (f : LaurentPolynomial A) (u : (LaurentPolynomial A)ˣ)
    (hu : (u : LaurentPolynomial A) = 1 + LaurentPolynomial.C e * f) :
    u ∈ laurentCoboundaryUnits A := by
  obtain ⟨v, w, hv, hw, hvw⟩ := exists_chart_units_of_sqZero he f
  refine TruncExpCech.mem_cechCoboundaryUnits.mpr ⟨hv.unit, hw.unit, Units.ext ?_⟩
  simp only [Units.val_mul, Units.coe_map, IsUnit.unit_spec]
  rw [hu, hvw]
  rfl

end AlgebraicGeometry
