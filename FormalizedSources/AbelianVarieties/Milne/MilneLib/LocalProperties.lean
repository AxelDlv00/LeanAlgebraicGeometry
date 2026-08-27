/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE
Authors: The Milne Contributors
-/

import Mathlib.RingTheory.LocalProperties.Exactness

/-!
# Local exactness

Exactness of a sequence of modules can be checked after localizing at every
maximal ideal.  This is the local-global principle used in Milne's discussion
of coherent modules and exact sequences.
-/

open IsLocalizedModule

namespace MilneLib

variable {R M N L : Type*} [CommSemiring R]
  [AddCommMonoid M] [Module R M]
  [AddCommMonoid N] [Module R N]
  [AddCommMonoid L] [Module R L]

/-
The canonical `LocalizedModule` maps keep the statement independent of a
chosen model for the localization at a maximal ideal.
-/
theorem LinearMap.exact_of_localized_at_maximal
    (f : M →ₗ[R] N) (g : N →ₗ[R] L)
    (h : ∀ (J : Ideal R) [J.IsMaximal],
      Function.Exact
        (IsLocalizedModule.map J.primeCompl
          (LocalizedModule.mkLinearMap J.primeCompl M)
          (LocalizedModule.mkLinearMap J.primeCompl N) f)
        (IsLocalizedModule.map J.primeCompl
          (LocalizedModule.mkLinearMap J.primeCompl N)
          (LocalizedModule.mkLinearMap J.primeCompl L) g)) :
    Function.Exact f g := by
  exact exact_of_localized_maximal f g h

/-- A map of modules is surjective when its canonical localizations at all
maximal ideals are surjective. -/
theorem LinearMap.surjective_of_localized_at_maximal
    (f : M →ₗ[R] N)
    (h : ∀ (J : Ideal R) [J.IsMaximal],
      Function.Surjective
        (IsLocalizedModule.map J.primeCompl
          (LocalizedModule.mkLinearMap J.primeCompl M)
          (LocalizedModule.mkLinearMap J.primeCompl N) f)) :
    Function.Surjective f := by
  exact surjective_of_localized_maximal f h

end MilneLib
