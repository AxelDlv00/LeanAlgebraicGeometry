/-
Copyright (c) 2026 The StacksPart01Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart01Lib Contributors
-/

import Mathlib.RingTheory.Support

/-!
# Support and quotients

The support statements in this file package the four assertions of the
Stacks Project's Tag `00L3`.  Their proofs are delegated to the corresponding
kernel-checked Mathlib results.
-/

namespace StacksPart01

variable {R M N P : Type*} [CommRing R]

/-! The four clauses of Stacks Project Tag `00L3`. -/

/-- The support of a quotient by `I` is the intersection with `V(I)` when the
ambient module is finite. -/
@[stacks 00L3 "(1)"]
theorem support_quotient [AddCommGroup M] [Module R M] [Module.Finite R M]
    (I : Ideal R) :
    Module.support R (M ⧸ (I • (⊤ : Submodule R M))) =
      Module.support R M ∩ PrimeSpectrum.zeroLocus I := by
  exact Module.support_quotient I

/-- An injective linear map can only enlarge module support. -/
@[stacks 00L3 "(2)"]
theorem support_subset_of_injective [AddCommGroup M] [Module R M]
    [AddCommGroup N] [Module R N] (f : M →ₗ[R] N)
    (hf : Function.Injective f) :
    Module.support R M ⊆ Module.support R N := by
  exact Module.support_subset_of_injective f hf

/-- A surjective linear map can only shrink module support. -/
@[stacks 00L3 "(3)"]
theorem support_subset_of_surjective [AddCommGroup M] [Module R M]
    [AddCommGroup N] [Module R N] (f : M →ₗ[R] N)
    (hf : Function.Surjective f) :
    Module.support R N ⊆ Module.support R M := by
  exact Module.support_subset_of_surjective f hf

/-- Support is the union of the supports in a short exact sequence. -/
@[stacks 00L3 "(4)"]
theorem support_of_exact [AddCommGroup M] [Module R M]
    [AddCommGroup N] [Module R N] [AddCommGroup P] [Module R P]
    {f : M →ₗ[R] N} {g : N →ₗ[R] P} (h : Function.Exact f g)
    (hf : Function.Injective f) (hg : Function.Surjective g) :
    Module.support R N = Module.support R M ∪ Module.support R P := by
  exact Module.support_of_exact h hf hg

end StacksPart01
