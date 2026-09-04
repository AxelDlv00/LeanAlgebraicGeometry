/-
Copyright (c) 2026 The StacksPart01Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart01Lib Contributors
-/

import Mathlib.Algebra.Module.LocalizedModule.Exact
import Mathlib.RingTheory.LocalProperties.Exactness

/-!
# Local criteria for modules and linear maps

This file packages the six local-global criteria from Stacks Project Tag
`00HN`.  Each statement records both the prime-local and maximal-local
characterizations.
-/

set_option autoImplicit false

namespace StacksPart01

/-- **Stacks Project, Tag 00HN (1)**: an element of a module is zero exactly
when it vanishes after localization at every prime, or equivalently at every
maximal ideal. -/
@[stacks 00HN "(1)"]
theorem eq_zero_iff_localized_at_prime_and_maximal
    {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M] (x : M) :
    (x = 0 ↔ ∀ p : PrimeSpectrum R,
      LocalizedModule.mkLinearMap p.asIdeal.primeCompl M x = 0) ∧
    (x = 0 ↔ ∀ (J : Ideal R) [J.IsMaximal],
      LocalizedModule.mkLinearMap J.primeCompl M x = 0) := by
  constructor
  · constructor
    · intro hx p
      simp [hx]
    · intro h
      apply Module.eq_zero_of_localization_maximal (R := R) (M := M)
        (fun J _ => LocalizedModule J.primeCompl M)
        (fun J _ => LocalizedModule.mkLinearMap J.primeCompl M)
      intro J hJ
      exact h ⟨J, inferInstance⟩
  · constructor
    · intro hx J hJ
      simp [hx]
    · intro h
      exact Module.eq_zero_of_localization_maximal (R := R) (M := M)
        (fun J _ => LocalizedModule J.primeCompl M)
        (fun J _ => LocalizedModule.mkLinearMap J.primeCompl M) x h

/-- **Stacks Project, Tag 00HN (2)**: a module is zero exactly when all its
localizations at prime ideals, or just at maximal ideals, are zero. -/
@[stacks 00HN "(2)"]
theorem subsingleton_iff_localized_at_prime_and_maximal
    {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M] :
    (Subsingleton M ↔ ∀ p : PrimeSpectrum R,
      Subsingleton (LocalizedModule p.asIdeal.primeCompl M)) ∧
    (Subsingleton M ↔ ∀ (J : Ideal R) [J.IsMaximal],
      Subsingleton (LocalizedModule J.primeCompl M)) := by
  constructor
  · constructor
    · intro hM p
      letI := hM
      infer_instance
    · intro h
      apply Module.subsingleton_of_localization_maximal (R := R) (M := M)
        (fun J _ => LocalizedModule J.primeCompl M)
        (fun J _ => LocalizedModule.mkLinearMap J.primeCompl M)
      intro J hJ
      exact h ⟨J, inferInstance⟩
  · constructor
    · intro hM J hJ
      letI := hM
      infer_instance
    · intro h
      exact Module.subsingleton_of_localization_maximal (R := R) (M := M)
        (fun J _ => LocalizedModule J.primeCompl M)
        (fun J _ => LocalizedModule.mkLinearMap J.primeCompl M) h

/-- **Stacks Project, Tag 00HN (3)**: exactness of a complex of modules can be
checked after localization at all prime ideals, or just at all maximal ideals. -/
@[stacks 00HN "(3)"]
theorem exact_iff_localized_at_prime_and_maximal
    {R M N L : Type*} [CommRing R]
    [AddCommGroup M] [Module R M]
    [AddCommGroup N] [Module R N]
    [AddCommGroup L] [Module R L]
    (f : M →ₗ[R] N) (g : N →ₗ[R] L) :
    (Function.Exact f g ↔ ∀ p : PrimeSpectrum R,
      Function.Exact (LocalizedModule.map p.asIdeal.primeCompl f)
        (LocalizedModule.map p.asIdeal.primeCompl g)) ∧
    (Function.Exact f g ↔ ∀ (J : Ideal R) [J.IsMaximal],
      Function.Exact (LocalizedModule.map J.primeCompl f)
        (LocalizedModule.map J.primeCompl g)) := by
  constructor
  · constructor
    · intro h p
      exact LocalizedModule.map_exact p.asIdeal.primeCompl f g h
    · intro h
      apply exact_of_localized_maximal f g
      intro J hJ
      exact h ⟨J, inferInstance⟩
  · constructor
    · intro h J hJ
      exact LocalizedModule.map_exact J.primeCompl f g h
    · exact exact_of_localized_maximal f g

/-- **Stacks Project, Tag 00HN (4)**: injectivity of a linear map can be
checked after localization at all prime ideals, or just at all maximal ideals. -/
@[stacks 00HN "(4)"]
theorem injective_iff_localized_at_prime_and_maximal
    {R M N : Type*} [CommRing R]
    [AddCommGroup M] [Module R M]
    [AddCommGroup N] [Module R N]
    (f : M →ₗ[R] N) :
    (Function.Injective f ↔ ∀ p : PrimeSpectrum R,
      Function.Injective (LocalizedModule.map p.asIdeal.primeCompl f)) ∧
    (Function.Injective f ↔ ∀ (J : Ideal R) [J.IsMaximal],
      Function.Injective (LocalizedModule.map J.primeCompl f)) := by
  constructor
  · constructor
    · intro h p
      exact LocalizedModule.map_injective p.asIdeal.primeCompl f h
    · intro h
      apply injective_of_localized_maximal f
      intro J hJ
      exact h ⟨J, inferInstance⟩
  · constructor
    · intro h J hJ
      exact LocalizedModule.map_injective J.primeCompl f h
    · exact injective_of_localized_maximal f

/-- **Stacks Project, Tag 00HN (5)**: surjectivity of a linear map can be
checked after localization at all prime ideals, or just at all maximal ideals. -/
@[stacks 00HN "(5)"]
theorem surjective_iff_localized_at_prime_and_maximal
    {R M N : Type*} [CommRing R]
    [AddCommGroup M] [Module R M]
    [AddCommGroup N] [Module R N]
    (f : M →ₗ[R] N) :
    (Function.Surjective f ↔ ∀ p : PrimeSpectrum R,
      Function.Surjective (LocalizedModule.map p.asIdeal.primeCompl f)) ∧
    (Function.Surjective f ↔ ∀ (J : Ideal R) [J.IsMaximal],
      Function.Surjective (LocalizedModule.map J.primeCompl f)) := by
  constructor
  · constructor
    · intro h p
      exact LocalizedModule.map_surjective p.asIdeal.primeCompl f h
    · intro h
      apply surjective_of_localized_maximal f
      intro J hJ
      exact h ⟨J, inferInstance⟩
  · constructor
    · intro h J hJ
      exact LocalizedModule.map_surjective J.primeCompl f h
    · exact surjective_of_localized_maximal f

/-- **Stacks Project, Tag 00HN (6)**: bijectivity of a linear map can be
checked after localization at all prime ideals, or just at all maximal ideals. -/
@[stacks 00HN "(6)"]
theorem bijective_iff_localized_at_prime_and_maximal
    {R M N : Type*} [CommRing R]
    [AddCommGroup M] [Module R M]
    [AddCommGroup N] [Module R N]
    (f : M →ₗ[R] N) :
    (Function.Bijective f ↔ ∀ p : PrimeSpectrum R,
      Function.Bijective (LocalizedModule.map p.asIdeal.primeCompl f)) ∧
    (Function.Bijective f ↔ ∀ (J : Ideal R) [J.IsMaximal],
      Function.Bijective (LocalizedModule.map J.primeCompl f)) := by
  constructor
  · constructor
    · intro h p
      exact ⟨LocalizedModule.map_injective p.asIdeal.primeCompl f h.1,
        LocalizedModule.map_surjective p.asIdeal.primeCompl f h.2⟩
    · intro h
      apply bijective_of_localized_maximal f
      intro J hJ
      exact h ⟨J, inferInstance⟩
  · constructor
    · intro h J hJ
      exact ⟨LocalizedModule.map_injective J.primeCompl f h.1,
        LocalizedModule.map_surjective J.primeCompl f h.2⟩
    · exact bijective_of_localized_maximal f

end StacksPart01
