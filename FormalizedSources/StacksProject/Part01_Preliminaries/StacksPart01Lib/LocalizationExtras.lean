/-
Copyright (c) 2026 The StacksPart01Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart01Lib Contributors
-/

import Mathlib.RingTheory.Localization.Basic
import Mathlib.RingTheory.Etale.Basic

/-!
# The zero localization criterion

The localization of a ring is the zero ring exactly when zero belongs to the
chosen multiplicative system (Stacks, Tag 00CQ).
-/

namespace StacksPart01

/-- A localization is subsingleton exactly when its denominator submonoid
contains zero (Stacks, Tag 00CQ). -/
theorem localization_subsingleton_iff
    {R S : Type*} [CommSemiring R] [CommSemiring S]
    (M : Submonoid R) [Algebra R S] [IsLocalization M S] :
    Subsingleton S ↔ 0 ∈ M := by
  exact IsLocalization.subsingleton_iff

/-- The canonical map into a localization is formally etale (Stacks, Tag 04EG). -/
theorem localization_formallyEtale
    {R : Type*} [CommRing R] (M : Submonoid R) :
    Algebra.FormallyEtale R (Localization M) := by
  exact Algebra.FormallyEtale.of_isLocalization M

/-! ### Localization models and fraction criteria

The equivalence below packages the universal-property comparison of two
localization models (Stacks, Tags 00CP and 02C6).
-/

/-- Two rings satisfying the same localization predicate are canonically
isomorphic as algebras over the base ring. -/
noncomputable def localizationAlgEquiv
    {R S T : Type*} [CommSemiring R] [CommSemiring S] [CommSemiring T]
    (M : Submonoid R) [Algebra R S] [Algebra R T]
    [IsLocalization M S] [IsLocalization M T] :
    S ≃ₐ[R] T :=
  IsLocalization.algEquiv M S T

/-- The localization equivalence sends a fraction to the fraction with the
same numerator and denominator in the target model. -/
@[simp]
theorem localizationAlgEquiv_mk'
    {R S T : Type*} [CommSemiring R] [CommSemiring S] [CommSemiring T]
    (M : Submonoid R) [Algebra R S] [Algebra R T]
    [IsLocalization M S] [IsLocalization M T]
    (x : R) (y : M) :
    localizationAlgEquiv M (IsLocalization.mk' S x y) =
      IsLocalization.mk' T x y := by
  exact IsLocalization.algEquiv_mk' x y

/-- An element maps to zero in the canonical localization exactly when some
denominator kills it (Stacks, Tag 00CQ). -/
theorem localization_map_eq_zero_iff
    {R : Type*} [CommSemiring R] (M : Submonoid R) (r : R) :
    algebraMap R (Localization M) r = 0 ↔
      ∃ m : M, (m : R) * r = 0 := by
  exact IsLocalization.map_eq_zero_iff M (Localization M) r

/-- A canonical localization fraction is zero exactly when some denominator
kills its numerator (Stacks, Tag 00CQ). -/
theorem localization_mk'_eq_zero_iff
    {R : Type*} [CommSemiring R] (M : Submonoid R) (x : R) (s : M) :
    IsLocalization.mk' (Localization M) x s = 0 ↔
      ∃ m : M, (m : R) * x = 0 := by
  exact IsLocalization.mk'_eq_zero_iff x s

end StacksPart01
