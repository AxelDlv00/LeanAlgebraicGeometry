/-
Copyright (c) 2026 The StacksPart02Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart02Lib Contributors
-/

import Mathlib.AlgebraicGeometry.AffineScheme
import Mathlib.RingTheory.Localization.Away.Basic

/-!
# Standard opens and their localization maps

The standard open `D(f)` on an affine open is represented on sections by the
localization away from `f`.  This file exposes that fact and the induced map
between such localizations under a ring homomorphism.
-/

namespace StacksPart02

open AlgebraicGeometry

universe u

/-- Sections on a standard open of an affine open are the localization away
from the defining section (Stacks, Tag 01HS(1)). -/
theorem affineOpen_standardOpen_isLocalization
    {X : Scheme.{u}} {U : X.Opens} (hU : IsAffineOpen U) (f : Γ(X, U)) :
    IsLocalization.Away f Γ(X, X.basicOpen f) := by
  exact hU.isLocalization_basicOpen f

/-- The corresponding statement for an affine scheme and a global section. -/
theorem affineScheme_standardOpen_isLocalization
    (X : Scheme.{u}) [IsAffine X] (f : Γ(X, ⊤)) :
    IsLocalization.Away f Γ(X, X.basicOpen f) := by
  infer_instance

section RingMap

variable {R S Rf Sf : Type*}
variable [CommSemiring R] [CommSemiring S]
variable [CommSemiring Rf] [CommSemiring Sf]
variable [Algebra R Rf] [Algebra S Sf]

/-- The canonical map between localizations induced by a ring map.

If `Rf` is `R` localized away from `f` and `Sf` is `S` localized away from
`φ(f)`, this is the map supplied by the universal property of localization.
-/
noncomputable def standardOpenLocalizationMap
    (φ : R →+* S) (f : R)
    [IsLocalization.Away f Rf]
    [IsLocalization.Away (φ f) Sf] :
    Rf →+* Sf :=
  IsLocalization.Away.map Rf Sf φ f

@[simp]
theorem standardOpenLocalizationMap_algebraMap
    (φ : R →+* S) (f : R)
    [IsLocalization.Away f Rf]
    [IsLocalization.Away (φ f) Sf] (a : R) :
    standardOpenLocalizationMap φ f (algebraMap R Rf a) =
      algebraMap S Sf (φ a) := by
  have h : Submonoid.powers f ≤ (Submonoid.powers (φ f)).comap φ := by
    rintro x ⟨n, rfl⟩
    exact ⟨n, by simp⟩
  change IsLocalization.map Sf φ h (algebraMap R Rf a) = algebraMap S Sf (φ a)
  exact IsLocalization.map_eq h a

/-- Ring-hom form of `standardOpenLocalizationMap_algebraMap`. -/
theorem standardOpenLocalizationMap_comp_algebraMap
    (φ : R →+* S) (f : R)
    [IsLocalization.Away f Rf]
    [IsLocalization.Away (φ f) Sf] :
    (standardOpenLocalizationMap φ f).comp (algebraMap R Rf) =
      (algebraMap S Sf).comp φ := by
  ext a
  exact standardOpenLocalizationMap_algebraMap φ f a

end RingMap

section Inclusion

variable {R : Type*} [CommSemiring R]

/-- The containment `D(g) ⊆ D(f)` is equivalent to an exponent relation
`g^n = a f` (Stacks, Tag 01HS(1)(b)). -/
theorem standardOpen_subset_iff_exists_pow_eq_mul {f g : R}
    (hsub : PrimeSpectrum.basicOpen g ≤ PrimeSpectrum.basicOpen f) :
    ∃ n : ℕ, ∃ a : R, g ^ n = a * f := by
  have h' := (PrimeSpectrum.basicOpen_le_basicOpen_iff g f).mp hsub
  rw [Ideal.mem_radical_iff] at h'
  obtain ⟨n, hn⟩ := h'
  obtain ⟨a, ha⟩ := Ideal.mem_span_singleton'.mp hn
  exact ⟨n, a, by simpa [mul_comm] using ha.symm⟩

/-- The defining element of a larger standard open is invertible after
localizing at a smaller standard open. -/
theorem standardOpen_isUnit_of_subset {f g : R}
    (hsub : PrimeSpectrum.basicOpen g ≤ PrimeSpectrum.basicOpen f) :
    IsUnit (algebraMap R (Localization.Away g) f) := by
  exact (PrimeSpectrum.basicOpen_le_basicOpen_iff_algebraMap_isUnit
    (S := Localization.Away g) (f := g) (g := f)).mp hsub

/-- The canonical localization map associated to an inclusion of standard
opens `D(g) ⊆ D(f)`. -/
noncomputable def standardOpenLocalizationMapOfSubset {f g : R}
    (hsub : PrimeSpectrum.basicOpen g ≤ PrimeSpectrum.basicOpen f) :
    Localization.Away f →+* Localization.Away g :=
  IsLocalization.Away.lift f
    (g := algebraMap R (Localization.Away g))
    (standardOpen_isUnit_of_subset hsub)

@[simp]
theorem standardOpenLocalizationMapOfSubset_algebraMap {f g : R}
    (hsub : PrimeSpectrum.basicOpen g ≤ PrimeSpectrum.basicOpen f) (a : R) :
    standardOpenLocalizationMapOfSubset hsub (algebraMap R (Localization.Away f) a) =
      algebraMap R (Localization.Away g) a := by
  exact IsLocalization.Away.lift_eq f (standardOpen_isUnit_of_subset hsub) a

end Inclusion

end StacksPart02
