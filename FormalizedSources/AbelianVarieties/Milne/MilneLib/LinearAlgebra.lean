/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import Mathlib.RingTheory.PicardGroup

/-!
# Rank-one module maps

The first algebraic lemma in Milne's chapter on line bundles is the fact that
a surjection between free modules of rank one is automatically an
isomorphism.  We package a chosen rank-one basis as a linear equivalence with
the base ring; this keeps the statement independent of a particular basis
implementation while exposing the exact algebra used in the proof.
-/

namespace MilneLib

theorem LinearMap.bijective_of_surjective_rank_one
    {R M N : Type*} [CommRing R]
    [AddCommGroup M] [AddCommGroup N]
    [Module R M] [Module R N]
    (eM : M ≃ₗ[R] R) (eN : N ≃ₗ[R] R)
    (f : M →ₗ[R] N) (hf : Function.Surjective f) :
    Function.Bijective f := by
  let g : R →ₗ[R] R := eN.toLinearMap.comp (f.comp eM.symm.toLinearMap)
  have hg : Function.Surjective g := by
    intro y
    obtain ⟨n, hn⟩ := eN.surjective y
    obtain ⟨m, hm⟩ := hf n
    refine ⟨eM m, ?_⟩
    simpa [g, hm] using hn
  have hginj : Function.Injective g :=
    (Module.Invertible.bijective_of_surjective hg).injective
  exact ⟨by
    intro x y hxy
    apply eM.injective
    apply hginj
    simpa [g] using congrArg eN hxy, hf⟩

end MilneLib
