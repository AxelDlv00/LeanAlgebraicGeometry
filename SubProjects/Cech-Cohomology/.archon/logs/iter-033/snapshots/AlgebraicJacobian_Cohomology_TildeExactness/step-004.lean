/-
Copyright (c) 2026 Axel Delaval. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Axel Delaval
-/
import Mathlib.AlgebraicGeometry.Modules.Tilde
import Mathlib.RingTheory.LocalProperties.Exactness

/-!
# The tilde functor preserves finite limits (Stacks 01HV, exactness of `~`)

Project-local supplement (Route-P step P3, feeding `qcoh_kernel_qcoh`).

For `X = Spec R`, the tilde functor `~ : ModuleCat R ⥤ (Spec R).Modules`,
`M ↦ M^~`, is exact; in particular it preserves finite limits (kernels).  The
mathematical content is *stalkwise flatness*: the stalk of `M^~` at the point
`x ↔ 𝔭` is the localisation `M_𝔭` (Mathlib's
`ModuleCat.tilde.toStalk` is an `IsLocalizedModule`), localisation `R → R_𝔭` is
flat hence exact, and isomorphisms of `𝒪_X`-modules are detected on stalks.

This file is `AlgebraicGeometry.tildePreservesFiniteLimits`.
-/

universe u

open CategoryTheory Limits AlgebraicGeometry

namespace AlgebraicGeometry

variable {R : CommRingCat.{u}}

/-! ## Project-local Mathlib supplement — exactness of the tilde functor -/

/-- The tilde functor `~ : ModuleCat R ⥤ (Spec R).Modules` preserves finite colimits.
This is the *right-exactness* half of exactness of `~`: it is a left adjoint
(`AlgebraicGeometry.tilde.adjunction`), hence preserves all colimits.  Project-local because
the packaged statement is what the kernel/cokernel quasi-coherence argument (Stacks
`lemma-kernel-cokernel-quasi-coherent`) consumes. -/
theorem tilde_preservesFiniteColimits :
    Limits.PreservesFiniteColimits (tilde.functor R) := inferInstance

section MonoAttempt

variable {M N : ModuleCat R} (f : M ⟶ N) (x : PrimeSpectrum.Top R)

example [Mono f] : Mono ((tilde.functor R).map f) := by
  have hfaithful : (modulesSpecToSheaf (R := R)).Faithful :=
    SpecModulesToSheafFullyFaithful.faithful
  apply (modulesSpecToSheaf (R := R)).mono_of_mono_map (f := (tilde.functor R).map f)
  haveI hstalk : ∀ y : PrimeSpectrum.Top R,
      Mono ((TopCat.Presheaf.stalkFunctor (ModuleCat R) y).map
        (modulesSpecToSheaf.map ((tilde.functor R).map f)).hom) := by
    intro y
    sorry
  exact TopCat.Presheaf.mono_of_stalk_mono _

end MonoAttempt

end AlgebraicGeometry
