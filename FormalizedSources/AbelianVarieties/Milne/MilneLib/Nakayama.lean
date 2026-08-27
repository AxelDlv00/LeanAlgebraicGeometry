/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import Mathlib.RingTheory.Nakayama
import Mathlib.RingTheory.LocalRing.MaximalIdeal.Basic

/-!
# The local Nakayama step

The residue-fibre surjectivity criterion in Milne's exactness discussion has a
direct local module form: a surjection after reduction modulo the maximal ideal
of a local ring lifts to a surjection when the target is finite.
-/

namespace MilneLib

theorem LinearMap.surjective_of_surjective_residue
    {R M N : Type*} [CommRing R] [IsLocalRing R]
    [AddCommGroup M] [AddCommGroup N]
    [Module R M] [Module R N] [Module.Finite R N]
    (f : M →ₗ[R] N)
    (hf : Function.Surjective
      (((IsLocalRing.maximalIdeal R) • (⊤ : Submodule R N)).mkQ ∘ₗ f)) :
    Function.Surjective f := by
  exact LinearMap.surjective_of_surjective_comp_mkQ f _
    (IsLocalRing.maximalIdeal_le_jacobson _) hf

end MilneLib
