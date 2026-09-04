/-
Copyright (c) 2026 The StacksPart01Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart01Lib Contributors
-/

import StacksPart01Lib.CommutativeAlgebra
import Mathlib.RingTheory.Support

/-!
# Support and powers of ideals

This file proves the Noetherian support criterion from Stacks Project Tag
`00L6`.
-/

set_option autoImplicit false

namespace StacksPart01

/-- **Stacks Project, Tag 00L6**: for a finite module over a Noetherian ring,
some power of an ideal annihilates the module exactly when the module's
support lies in the ideal's zero locus. -/
@[stacks 00L6]
theorem exists_pow_smul_top_eq_bot_iff_support_subset_zeroLocus
    {R M : Type*} [CommRing R] [IsNoetherianRing R]
    [AddCommGroup M] [Module R M] [Module.Finite R M] (I : Ideal R) :
    (∃ n : ℕ, I ^ n • (⊤ : Submodule R M) = ⊥) ↔
      Module.support R M ⊆ PrimeSpectrum.zeroLocus I := by
  rw [Module.support_eq_zeroLocus,
    PrimeSpectrum.zeroLocus_subset_zeroLocus_iff]
  constructor
  · rintro ⟨n, hn⟩ x hx
    rw [← Submodule.le_annihilator_iff, Submodule.annihilator_top] at hn
    rw [Ideal.mem_radical_iff]
    exact ⟨n, hn (Ideal.pow_mem_pow hx n)⟩
  · intro h
    obtain ⟨n, hn⟩ := noetherian_ideal_power_subset h
    refine ⟨n, ?_⟩
    rw [← Submodule.le_annihilator_iff, Submodule.annihilator_top]
    exact hn

end StacksPart01
