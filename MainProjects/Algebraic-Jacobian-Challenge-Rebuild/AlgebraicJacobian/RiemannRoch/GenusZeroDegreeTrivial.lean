/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.RiemannRoch.SectionBound
import AlgebraicJacobian.RiemannRoch.ChiLedger
import AlgebraicJacobian.RiemannRoch.SectionSpaces
import AlgebraicJacobian.Picard.DivisorClassMeromorphic

/-!
# AT GENUS `0`, A DEGREE-ZERO PICARD CLASS IS TRIVIAL

The degree homomorphism `classDeg` (`RiemannRoch/Degree.lean`) has a large landed API in one
direction — `classDeg_one`, `classDeg_mul`, `classDeg_inv`, `classDeg_picClass`,
`classDeg_eq_zero_of_mem_picFromBase` — every one of which computes a degree *from* a class.
**The converse is absent**: nothing in the tree concludes that a class is trivial from its
degree, at any genus.  A name census cannot see that gap, because the missing statement has
no name; what shows it is that the degree-zero *subgroup* has 93 consumers and no producer.

This file supplies the converse at `χ(𝒪) = 1`, i.e. at genus `0`.

## The argument

Three landed steps, no new mathematics:

1. every Čech class is the class of a Weil divisor
   (`Scheme.CurveDivisor.exists_picClass_eq`), and the degrees agree (`classDeg_picClass`);
2. the χ-ledger `χ(𝒪(D)) = χ(𝒪) + deg D` (`chi_divisorSheaf`) at `deg D = 0` and `χ(𝒪) = 1`
   gives `χ(𝒪(D)) = 1`, hence `h⁰ > 0` since `χ = h⁰ - h¹` and `h¹ ≥ 0`.  **This is where
   genus `0` enters, and it is the only place**;
3. `exists_effective_of_h0_pos` turns the section into an *effective* representative of the
   same class, whose degree is therefore still `0`; and an effective divisor of degree `≤ 0`
   is `0` (`Scheme.CurveDivisor.eq_zero_of_deg_le_zero`, coefficients nonnegative weighted by
   positive residue degrees).  So the class is the class of `0`, which is `1`.

**No `H¹`-vanishing hypothesis is needed.**  χ alone forces the section: `h⁰ = χ + h¹ ≥ χ`.
That is worth stating explicitly because every other section-producing consumer in the tree
carries a `Subsingleton (Sheaf.HModule … 1)` binder for the divisor sheaf, and here it would
be dead weight — the binder is about `𝒪(D)`, whose `h¹` the argument never needs to know.

## What this is for

It is the field-level layer of the degree-zero Picard vanishing that
`Picard/Pic0VanishingAffineReduction.lean` reduces to test rings, and the debt
`Albanese/Genus0Terminal.lean` isolates.  It does **not** discharge that debt: the vanishing
quantifies over test *rings*, and this statement is over a *field*.  The remaining step is the
ring-level one, and it is not supplied here.

## Main declarations

* `AlgebraicGeometry.eq_one_of_classDeg_eq_zero_of_chi_one` — **the converse of the degree
  API**: at `χ(𝒪) = 1`, a Čech Picard class of degree `0` is trivial.
* `AlgebraicGeometry.classDeg_eq_zero_iff_eq_one_of_chi_one` — bundled as an iff with the
  landed `classDeg_one`, so both directions sit under one name.
-/

set_option autoImplicit false

universe u

open CategoryTheory

namespace AlgebraicGeometry

variable (K : Type u) [Field K] {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of K))]
  [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X]
  [QuasiCompact (X ↘ Spec (CommRingCat.of K))]
  [LocallyOfFiniteType (X ↘ Spec (CommRingCat.of K))]
  [Module.Finite K (Sheaf.HModule (X.moduleKSheaf K) 0)]
  [Module.Finite K (Sheaf.HModule (X.moduleKSheaf K) 1)]

/-- **At genus `0`, a degree-zero Picard class is trivial.**

The direction the tree's degree API was missing.  Genus `0` enters exactly once: through the
χ-ledger, which at `deg D = 0` and `χ(𝒪) = 1` gives `χ(𝒪(D)) = 1` and hence a global section.
The section is converted to an effective representative of the same class, which then has
degree `0` and is therefore the zero divisor.

Needs no `H¹`-vanishing hypothesis on `𝒪(D)`: `h⁰ = χ + h¹ ≥ χ`. -/
theorem eq_one_of_classDeg_eq_zero_of_chi_one
    (hchi : Sheaf.chi (X.moduleKSheaf K) = 1)
    (L : X.CechPic) (hL : classDeg K L = 0) : L = 1 := by
  obtain ⟨D, hD⟩ := Scheme.CurveDivisor.exists_picClass_eq K L
  have hdegD : Scheme.CurveDivisor.deg K D = 0 := by
    rw [← classDeg_picClass K D, hD, hL]
  have hchiD : Sheaf.chi (X.divisorSheaf K D) = 1 := by
    rw [chi_divisorSheaf, hchi, hdegD, add_zero]
  -- `χ = h⁰ - h¹` with `h¹ ≥ 0`, so `χ = 1` forces a section
  have hh0 : 0 < Sheaf.h0 (X.divisorSheaf K D) := by
    have h := hchiD
    rw [Sheaf.chi] at h
    omega
  obtain ⟨E, hEeff, hEcl⟩ := exists_effective_of_h0_pos K D hh0
  have hdegE : Scheme.CurveDivisor.deg K E = 0 := by
    rw [deg_eq_deg_of_picClass_eq K hEcl, hdegD]
  have hE0 : E = 0 :=
    Scheme.CurveDivisor.eq_zero_of_deg_le_zero K hEeff (le_of_eq hdegE)
  rw [← hD, ← hEcl, hE0]
  exact Scheme.CurveDivisor.picClass_zero K

/-- The two directions under one name: at `χ(𝒪) = 1` the degree of a Čech Picard class
vanishes exactly when the class is trivial.  The forward direction is the landed
`classDeg_one`. -/
theorem classDeg_eq_zero_iff_eq_one_of_chi_one
    (hchi : Sheaf.chi (X.moduleKSheaf K) = 1) (L : X.CechPic) :
    classDeg K L = 0 ↔ L = 1 :=
  ⟨eq_one_of_classDeg_eq_zero_of_chi_one K hchi L, fun h => by rw [h]; exact classDeg_one K⟩

end AlgebraicGeometry
