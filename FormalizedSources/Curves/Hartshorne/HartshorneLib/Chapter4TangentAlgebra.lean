/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import Mathlib.Algebra.MvPolynomial.CommRing
import Mathlib.RingTheory.DiscreteValuationRing.Basic
import Mathlib.RingTheory.LocalRing.MaximalIdeal.Square
import Mathlib.RingTheory.LocalRing.ResidueField.Basic

/-!
# Local polynomial coordinates and tangent separation

If every element of a local algebra is a fraction of polynomial expressions in
chosen coordinates, their differences from their residue values generate the
maximal ideal. In a discrete valuation ring, some such difference is therefore
a uniformizer. This is the local algebra in the converse tangent-separation
criterion for a projective linear system.
-/

set_option autoImplicit false

namespace Hartshorne

open MvPolynomial IsLocalRing

/-- Polynomial evaluation preserves congruence of the coordinates modulo an ideal. -/
theorem aeval_sub_eval_mem_of_sub_mem
    {k R J : Type*} [CommRing k] [CommRing R] [Algebra k R]
    (I : Ideal R) (c : J → R) (a : J → k)
    (hc : ∀ j, c j - algebraMap k R (a j) ∈ I) (p : MvPolynomial J k) :
    aeval c p - algebraMap k R (eval a p) ∈ I := by
  induction p using MvPolynomial.induction_on with
  | C b => simp
  | add p q hp hq =>
      simpa only [map_add, add_sub_add_comm] using I.add_mem hp hq
  | mul_X p j hp =>
      simpa only [map_mul, aeval_X, eval_X, mul_sub, sub_mul,
        sub_add_sub_cancel] using
        I.add_mem (I.mul_mem_left (aeval c p) (hc j))
          (I.mul_mem_right (algebraMap k R (a j)) hp)

/-- Polynomial fractions generate the maximal ideal by their centered coordinates.
The fraction hypothesis is supplied by surjectivity of a map from a localization
of the polynomial ring. -/
theorem maximalIdeal_le_of_polynomial_fractions
    {k R J : Type*} [Field k] [CommRing R] [IsLocalRing R] [Algebra k R]
    (c : J → R) (a : J → k) (I : Ideal R) (hI : I ≤ maximalIdeal R)
    (hc : ∀ j, c j - algebraMap k R (a j) ∈ I)
    (hfrac : ∀ r : R, ∃ p q : MvPolynomial J k,
      IsUnit (aeval c q) ∧ r * aeval c q = aeval c p) :
    maximalIdeal R ≤ I := by
  intro r hr
  obtain ⟨p, q, hq, hpq⟩ := hfrac r
  have hp : aeval c p ∈ maximalIdeal R :=
    hpq ▸ (maximalIdeal R).mul_mem_right (aeval c q) hr
  have hdiff := aeval_sub_eval_mem_of_sub_mem I c a hc p
  have hconst : algebraMap k R (eval a p) ∈ maximalIdeal R := by
    simpa only [sub_sub_cancel] using (maximalIdeal R).sub_mem hp (hI hdiff)
  have hzero : eval a p = 0 := by
    by_contra hne
    exact hconst ((isUnit_iff_ne_zero.mpr hne).map (algebraMap k R))
  have hpI : aeval c p ∈ I := by simpa only [hzero, map_zero, sub_zero] using hdiff
  exact (I.mul_unit_mem_iff_mem hq).mp (hpq ▸ hpI)

/-- If polynomial fractions in the coordinates generate a DVR with residue field
equal to the coefficient field, some coordinate minus a scalar is a uniformizer. -/
theorem exists_irreducible_sub_algebraMap_of_polynomial_fractions
    {k R J : Type*} [Field k] [CommRing R] [IsDomain R]
    [IsDiscreteValuationRing R] [Algebra k R]
    (c : J → R)
    (hres : Function.Surjective ((residue R).comp (algebraMap k R)))
    (hfrac : ∀ r : R, ∃ p q : MvPolynomial J k,
      IsUnit (aeval c q) ∧ r * aeval c q = aeval c p) :
    ∃ j a, Irreducible (c j - algebraMap k R a) := by
  classical
  choose a ha using fun j => hres (residue R (c j))
  have hcenter (j : J) : c j - algebraMap k R (a j) ∈ maximalIdeal R := by
    rw [← residue_eq_zero_iff, map_sub, sub_eq_zero]
    exact (ha j).symm
  have hnot : ¬ ∀ j, c j - algebraMap k R (a j) ∈ maximalIdeal R ^ 2 := by
    intro h
    have hle := maximalIdeal_le_of_polynomial_fractions c a (maximalIdeal R ^ 2)
      (Ideal.pow_le_self (by decide)) h hfrac
    exact (not_le_of_gt ((maximalIdeal_sq_lt_maximalIdeal R).mpr
      (IsDiscreteValuationRing.not_isField R))) hle
  push Not at hnot
  obtain ⟨j, hj⟩ := hnot
  refine ⟨j, a j, hcenter j, ?_⟩
  intro b d hbd
  by_contra! hunit
  apply hj
  rw [hbd, pow_two]
  exact Ideal.mul_mem_mul hunit.1 hunit.2

end Hartshorne
