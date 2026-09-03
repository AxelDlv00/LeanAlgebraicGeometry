/-
Copyright (c) 2026 The StacksPart01Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart01Lib Contributors
-/

import StacksPart01Lib.Localization
import Mathlib.RingTheory.Ideal.Maps
import Mathlib.RingTheory.Spectrum.Prime.Basic

/-!
# Support elements

The localization criterion for a single module element gives the pointwise
form of the Stacks Project's support-element lemma (Tag `07Z5`).
-/

set_option autoImplicit false

namespace StacksPart01

variable {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]

/-- **Stacks Project, Tag 07Z5**: a prime contains the annihilator of an
element exactly when that element remains nonzero after localization at the
prime. -/
@[stacks 07Z5]
theorem support_element (p : PrimeSpectrum R) (m : M) :
    p ∈ PrimeSpectrum.zeroLocus
      (LinearMap.ker (LinearMap.toSpanSingleton R M m) : Set R) ↔
      (LocalizedModule.mkLinearMap p.asIdeal.primeCompl M) m ≠ 0 := by
  rw [PrimeSpectrum.mem_zeroLocus]
  constructor
  · intro hI hzero
    obtain ⟨r, hr, hrm⟩ :=
      (localizedModule_mem_ker_iff p.asIdeal.primeCompl (m := m)).mp (by
        rw [LinearMap.mem_ker]
        exact hzero)
    apply hr
    exact hI ((LinearMap.mem_ker).mpr hrm)
  · intro hne r hrI
    by_contra hrp
    apply hne
    apply (localizedModule_mem_ker_iff p.asIdeal.primeCompl (m := m)).mpr
    refine ⟨r, hrp, ?_⟩
    exact (LinearMap.mem_ker).mp hrI

end StacksPart01
