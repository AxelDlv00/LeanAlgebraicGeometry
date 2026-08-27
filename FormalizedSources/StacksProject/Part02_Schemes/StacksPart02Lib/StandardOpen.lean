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

end StacksPart02
