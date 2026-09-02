/-
Copyright (c) 2026 The StacksPart01Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart01Lib Contributors
-/

import StacksPart01Lib.Integral
import Mathlib.RingTheory.Ideal.GoingUp

/-!
# Integral extensions and going up

This file records the field and prime-ideal consequences of integral ring maps
used in the finite-extension part of the Stacks Project.
-/

namespace StacksPart01

/-! ### Integral algebras over fields -/

/-- An integral domain which is integral over a field is a field
(Stacks, Tag `00GS`). -/
theorem integral_domain_over_field_isField
    {k S : Type*} [Field k] [CommRing S] [Algebra k S]
    [Algebra.IsIntegral k S] [IsDomain S] :
    IsField S := by
  exact isField_of_isIntegral_of_isField' (Field.toIsField k)

/-- If a field embeds integrally into a ring, the source is a field and the
extension is algebraic (Stacks, Tag `00GR`). -/
theorem integral_subring_of_field_isField_and_algebraic
    {R K : Type*} [CommRing R] [Field K] [Algebra R K]
    [Algebra.IsIntegral R K] (hinj : Function.Injective (algebraMap R K)) :
    IsField R ∧ Algebra.IsAlgebraic R K := by
  have hR : IsField R := isField_of_isIntegral_of_isField hinj (Field.toIsField K)
  letI : IsField R := hR
  letI : Nontrivial R := hR.nontrivial
  exact ⟨hR, Algebra.IsIntegral.isAlgebraic⟩

/-! ### Maximal ideals and going up -/

/-- A prime ideal over a maximal contracted ideal is maximal in an integral
extension. -/
theorem integral_prime_over_maximal_isMaximal
    {R S : Type*} [CommRing R] [CommRing S] [Algebra R S]
    [Algebra.IsIntegral R S] (I : Ideal S) [I.IsPrime]
    (hI : (I.comap (algebraMap R S)).IsMaximal) :
    I.IsMaximal :=
  Ideal.isMaximal_of_isIntegral_of_isMaximal_comap I hI

/-- The contraction of a maximal ideal along an integral algebra map is
maximal. -/
theorem integral_maximal_comap_isMaximal
    {R S : Type*} [CommRing R] [CommRing S] [Algebra R S]
    [Algebra.IsIntegral R S] (I : Ideal S) [I.IsMaximal] :
    (I.comap (algebraMap R S)).IsMaximal :=
  Ideal.isMaximal_comap_of_isIntegral_of_isMaximal I

/-- Going up for an integral algebra map (Stacks, Tag `00GU`). -/
theorem integral_going_up
    {R S : Type*} [CommRing R] [CommRing S] [Algebra R S]
    [Algebra.IsIntegral R S]
    (p p' : Ideal R) [p.IsPrime] [p'.IsPrime]
    (hpp' : p ≤ p') (q : Ideal S) [q.IsPrime]
    (hqmap : q.comap (algebraMap R S) = p) :
    ∃ q' : Ideal S, q ≤ q' ∧ q'.IsPrime ∧
      q'.comap (algebraMap R S) = p' := by
  exact Ideal.exists_ideal_over_prime_of_isIntegral p' q
    (by simpa [hqmap] using hpp')

/-- Distinct primes in an integral extension lying over the same prime are
incomparable (Stacks, Tag `00GT`). -/
theorem integral_prime_incomparable
    {R S : Type*} [CommRing R] [CommRing S] [Algebra R S]
    [Algebra.IsIntegral R S]
    (q q' : Ideal S) [q.IsPrime] [q'.IsPrime]
    (hne : q ≠ q')
    (hcomap : q.comap (algebraMap R S) = q'.comap (algebraMap R S)) :
    ¬ q ≤ q' ∧ ¬ q' ≤ q := by
  constructor
  · intro hle
    have hlt : q < q' := lt_of_le_of_ne hle hne
    have hc := Ideal.IsIntegral.comap_lt_comap (R := R) (A := S) hlt
    exact lt_irrefl _ (hcomap ▸ hc)
  · intro hle
    have hlt : q' < q := lt_of_le_of_ne hle hne.symm
    have hc := Ideal.IsIntegral.comap_lt_comap (R := R) (A := S) hlt
    exact lt_irrefl _ (hcomap.symm ▸ hc)

end StacksPart01
