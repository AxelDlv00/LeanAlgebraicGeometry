/-
Copyright (c) 2026 The StacksPart01Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart01Lib Contributors
-/

import StacksPart01Lib.Nilradical
import StacksPart01Lib.LocalizationExtras
import Mathlib.RingTheory.KrullDimension.Zero
import Mathlib.RingTheory.LocalProperties.Reduced

/-!
# Reduced rings and minimal-prime localizations

The local rings at minimal primes of a reduced ring are fields, and the
canonical map into their product is injective (Stacks, Tags 00EU and 00EW).
-/

namespace StacksPart01

/-- Every element of the maximal ideal in the localization at a minimal prime
is nilpotent (Stacks, Tag 00EU). -/
theorem isNilpotent_of_mem_maximalIdeal_localizationAt_minimalPrime
    {R : Type*} [CommRing R]
    (p : PrimeSpectrum R) (hp : IsMin p)
    {x : Localization.AtPrime p.asIdeal}
    (hx : x ∈ IsLocalRing.maximalIdeal (Localization.AtPrime p.asIdeal)) :
    IsNilpotent x := by
  letI : Ring.KrullDimLE 0 (Localization.AtPrime p.asIdeal) :=
    Ring.KrullDimLE.of_isLocalization p.asIdeal
      (PrimeSpectrum.isMin_iff.mp hp) _
  exact Ring.KrullDimLE.isNilpotent_iff_mem_maximalIdeal.mpr hx

/-- The localization of a reduced ring at a minimal prime is a field
(Stacks, Tag 00EU). -/
theorem localizationAt_minimalPrime_isField
    {R : Type*} [CommRing R] [IsReduced R]
    (p : PrimeSpectrum R) (hp : IsMin p) :
    IsField (Localization.AtPrime p.asIdeal) := by
  letI : Ring.KrullDimLE 0 (Localization.AtPrime p.asIdeal) :=
    Ring.KrullDimLE.of_isLocalization p.asIdeal
      (PrimeSpectrum.isMin_iff.mp hp) _
  exact Ring.KrullDimLE.isField_of_isReduced

/-- The kernel of the canonical map at a minimal prime is that prime ideal
(Stacks, Tag 00EU). -/
theorem ker_algebraMap_localizationAt_minimalPrime
    {R : Type*} [CommRing R] [IsReduced R]
    (p : PrimeSpectrum R) (hp : IsMin p) :
    RingHom.ker (algebraMap R (Localization.AtPrime p.asIdeal)) = p.asIdeal := by
  letI : Field (Localization.AtPrime p.asIdeal) :=
    (localizationAt_minimalPrime_isField p hp).toField
  rw [RingHom.ker_eq_comap_bot, ← IsLocalRing.maximalIdeal_eq_bot]
  exact IsLocalization.AtPrime.under_maximalIdeal _ _

/-- A reduced ring embeds in the product of its localizations at minimal
primes (Stacks, Tag 00EW). -/
theorem reduced_algebraMap_pi_localizationAt_minimalPrime_injective
    (R : Type*) [CommRing R] [IsReduced R] :
    Function.Injective
      (RingHom.pi fun p : {p : PrimeSpectrum R // IsMin p} =>
        algebraMap R (Localization.AtPrime p.1.asIdeal)) := by
  rw [RingHom.injective_iff_ker_eq_bot, Pi.ker_ringHom]
  apply le_antisymm ?_ bot_le
  intro x hx
  have hxnil : x ∈ nilradical R := by
    change x ∈ (⊥ : Ideal R).radical
    rw [← sInf_minimalPrimes_eq_radical, Ideal.mem_sInf]
    intro q hq
    letI : q.IsPrime := hq.isPrime
    let q' : PrimeSpectrum R := ⟨q, inferInstance⟩
    let p : {p : PrimeSpectrum R // IsMin p} :=
      ⟨q', PrimeSpectrum.isMin_iff.mpr hq⟩
    have hxker : x ∈ RingHom.ker
        (algebraMap R (Localization.AtPrime q)) := by
      simpa [p, q'] using (Ideal.mem_iInf.mp hx p)
    have hxq' : x ∈ q'.asIdeal := by
      rw [← ker_algebraMap_localizationAt_minimalPrime q' p.2]
      exact hxker
    simpa [q'] using hxq'
  simpa [nilradical_eq_zero R] using hxnil

/-- In a reduced ring, the union of the minimal primes is exactly the set of
zero divisors (Stacks, Tag 00EW). -/
theorem iUnion_minimalPrimes_eq_compl_nonZeroDivisors
    {R : Type*} [CommRing R] [IsReduced R] :
    ⋃ p ∈ minimalPrimes R, (p : Set R) =
      (nonZeroDivisors R : Set R)ᶜ := by
  rw [Ideal.iUnion_minimalPrimes]
  rw [show (⊥ : Ideal R).radical = nilradical R from rfl,
    nilradical_eq_zero R]
  ext x
  simp only [Set.mem_setOf_eq, Set.mem_compl_iff, SetLike.mem_coe,
    mem_nonZeroDivisors_iff_right, Ideal.zero_eq_bot, Ideal.mem_bot,
    not_forall, mul_comm]
  constructor <;> rintro ⟨y, h₁, h₂⟩ <;> exact ⟨y, h₂, h₁⟩

end StacksPart01
