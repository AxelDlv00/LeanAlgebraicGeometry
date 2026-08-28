/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import Mathlib.AlgebraicGeometry.Group.Abelian

/-!
# Isogenies

For a homomorphism of group schemes over a field, the kernel is the fibre over
the identity section.  The predicate below records the source-faithful
surjective-and-finite-kernel condition using Mathlib's scheme morphism
properties.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj
open AlgebraicGeometry

namespace MilneLib

variable {K : Type u} [Field K]
variable {A B : Over (Spec (.of K))} [GrpObj A] [GrpObj B]

/-- The kernel scheme of a group-scheme homomorphism, as the fibre over the identity. -/
noncomputable def isogenyKernel (f : A ⟶ B) : Scheme :=
  pullback f.left (η[B].left)

/-- The structure morphism of the kernel scheme over the base field. -/
noncomputable def isogenyKernelToBase (f : A ⟶ B) :
    isogenyKernel f ⟶ Spec (.of K) :=
  pullback.snd f.left (η[B].left)

/-- A surjective group-scheme homomorphism with finite kernel. -/
def Isogeny (f : A ⟶ B) [IsMonHom f] : Prop :=
  Surjective f.left ∧ IsFinite (isogenyKernelToBase f)

/-- The identity homomorphism is an isogeny. -/
@[simp]
theorem Isogeny.id (A : Over (Spec (.of K))) [GrpObj A] :
    Isogeny (𝟙 A) := by
  constructor
  · infer_instance
  · dsimp [isogenyKernelToBase, isogenyKernel]
    infer_instance

/- An isomorphism of group schemes has trivial (hence finite) kernel.  The
   explicit forgetful transport is needed because the slice-category `IsIso`
   instance is not reducible through `Over.Hom.left` during synthesis. -/
theorem Isogeny.of_isIso (f : A ⟶ B) [IsMonHom f] [IsIso f] :
    Isogeny f := by
  letI : IsIso f.left := (Over.forget (Spec (CommRingCat.of K))).map_isIso f
  constructor
  · infer_instance
  · dsimp [isogenyKernelToBase, isogenyKernel]
    infer_instance

/- When the underlying homomorphisms are finite, the usual closure of finite
   and surjective morphisms under composition gives the corresponding
   isogeny.  The finite-map hypotheses are explicit until the full
   finite-kernel-to-finite-map theorem is available in Mathlib. -/
theorem Isogeny.comp_of_finite
    {C : Over (Spec (.of K))} [GrpObj C]
    (f : A ⟶ B) (g : B ⟶ C) [IsMonHom f] [IsMonHom g]
    [IsFinite f.left] [IsFinite g.left]
    (hf : Isogeny f) (hg : Isogeny g) :
    Isogeny (f ≫ g) := by
  letI : Surjective f.left := hf.1
  letI : Surjective g.left := hg.1
  constructor
  · rw [Over.comp_left]
    infer_instance
  · dsimp [isogenyKernelToBase, isogenyKernel]
    haveI : IsFinite ((f ≫ g).left) := by
      rw [Over.comp_left]
      infer_instance
    infer_instance

theorem Isogeny.surjective (f : A ⟶ B) [IsMonHom f] (h : Isogeny f) :
    Surjective f.left :=
  h.1

theorem Isogeny.finite_kernel (f : A ⟶ B) [IsMonHom f] (h : Isogeny f) :
    IsFinite (isogenyKernelToBase f) :=
  h.2

end MilneLib
