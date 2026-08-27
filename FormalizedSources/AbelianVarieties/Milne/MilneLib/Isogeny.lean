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

theorem Isogeny.surjective (f : A ⟶ B) [IsMonHom f] (h : Isogeny f) :
    Surjective f.left :=
  h.1

theorem Isogeny.finite_kernel (f : A ⟶ B) [IsMonHom f] (h : Isogeny f) :
    IsFinite (isogenyKernelToBase f) :=
  h.2

end MilneLib
