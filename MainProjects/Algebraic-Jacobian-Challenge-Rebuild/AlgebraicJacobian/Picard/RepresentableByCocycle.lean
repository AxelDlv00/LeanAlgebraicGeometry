/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.JacobianData

/-!
# Canonical cocycles of representability isomorphisms

`Functor.RepresentableBy.uniqueUpToIso` is defined by Yoneda uniqueness, but mathlib does
not expose the two equations that descent data consume: its universal-element intertwining
formula and transitivity for three independently chosen representing objects.  These generic
lemmas make those equations explicit.  In particular, the transitivity theorem proves a
three-face cocycle without defining the `1,3` face as a composite.
-/

set_option autoImplicit false

universe v u

open CategoryTheory

namespace CategoryTheory.Functor.RepresentableBy

/-- Composition with the canonical representing-object isomorphism transports the universal
element unchanged. -/
theorem homEquiv_uniqueUpToIso_hom {C : Type u} [Category.{v, u} C]
    {F : Cᵒᵖ ⥤ Type v} {Y Y' : C} (e : F.RepresentableBy Y)
    (e' : F.RepresentableBy Y') {X : C} (f : X ⟶ Y) :
    e'.homEquiv (f ≫ (e.uniqueUpToIso e').hom) = e.homEquiv f := by
  have h : (e.uniqueUpToIso e').hom =
      e'.homEquiv.symm (e.homEquiv (𝟙 Y)) := rfl
  rw [h, comp_homEquiv_symm, Equiv.apply_symm_apply]
  rw [← e.homEquiv_comp f (𝟙 Y), Category.comp_id]

/-- The canonical isomorphisms between three representations satisfy the cocycle law.  The
`1,3` comparison is the independently defined `uniqueUpToIso e₁ e₃`, not a composite alias. -/
theorem uniqueUpToIso_trans {C : Type u} [Category.{v, u} C]
    {F : Cᵒᵖ ⥤ Type v} {Y₁ Y₂ Y₃ : C}
    (e₁ : F.RepresentableBy Y₁) (e₂ : F.RepresentableBy Y₂)
    (e₃ : F.RepresentableBy Y₃) :
    e₁.uniqueUpToIso e₃ = e₁.uniqueUpToIso e₂ ≪≫ e₂.uniqueUpToIso e₃ := by
  apply Iso.ext
  apply e₃.homEquiv.injective
  calc
    e₃.homEquiv (e₁.uniqueUpToIso e₃).hom = e₁.homEquiv (𝟙 Y₁) := by
      simpa using homEquiv_uniqueUpToIso_hom e₁ e₃ (𝟙 Y₁)
    _ = e₂.homEquiv (e₁.uniqueUpToIso e₂).hom := by
      symm
      simpa using homEquiv_uniqueUpToIso_hom e₁ e₂ (𝟙 Y₁)
    _ = e₃.homEquiv
        ((e₁.uniqueUpToIso e₂).hom ≫ (e₂.uniqueUpToIso e₃).hom) := by
      symm
      exact homEquiv_uniqueUpToIso_hom e₂ e₃ (e₁.uniqueUpToIso e₂).hom

end CategoryTheory.Functor.RepresentableBy
