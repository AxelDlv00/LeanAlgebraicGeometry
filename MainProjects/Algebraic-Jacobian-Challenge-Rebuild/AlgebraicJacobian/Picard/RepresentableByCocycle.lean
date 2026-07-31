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

universe v u u'

open CategoryTheory

namespace CategoryTheory.Functor.RepresentableBy

/-- Transport a representation through the right adjoint of an adjunction.

This is the categorical pullback step used for overlap bases: if `L ⊣ R`, then a
representation of `F` by `Y` induces one of `L.op ⋙ F` by `R.obj Y`.  The statement
requires only the adjunction; for schemes, `Over.mapPullbackAdj` supplies it whenever
the relevant pullbacks exist, including tensor-product (non-field) bases. -/
noncomputable def ofLeftAdjoint
    {C : Type u} {D : Type u'} [Category.{v, u} C] [Category.{v, u'} D]
    {L : C ⥤ D} {R : D ⥤ C} (adj : L ⊣ R)
    {F : Dᵒᵖ ⥤ Type v} {Y : D} (e : F.RepresentableBy Y) :
    (L.op ⋙ F).RepresentableBy (R.obj Y) :=
  (adj.representableBy Y).ofIso (Functor.isoWhiskerLeft L.op e.toIso)

/-- The universal element of `ofLeftAdjoint` is obtained by applying the adjunction inverse. -/
theorem ofLeftAdjoint_homEquiv
    {C : Type u} {D : Type u'} [Category.{v, u} C] [Category.{v, u'} D]
    {L : C ⥤ D} {R : D ⥤ C} (adj : L ⊣ R)
    {F : Dᵒᵖ ⥤ Type v} {Y : D} (e : F.RepresentableBy Y)
    {X : C} (g : X ⟶ R.obj Y) :
    (ofLeftAdjoint adj e).homEquiv g = e.homEquiv ((adj.homEquiv X Y).symm g) := by
  rfl

/-- Compare representations of two isomorphic presheaves.

The source representation is first transported along `η`; the comparison is then the ordinary
Yoneda comparison.  This is the canonical overlap isomorphism once the two pullback Picard
presheaves have been identified. -/
noncomputable def uniqueUpToIsoOfIso
    {C : Type u} [Category.{v, u} C]
    {F F' : Cᵒᵖ ⥤ Type v} {Y Y' : C}
    (e : F.RepresentableBy Y) (e' : F'.RepresentableBy Y') (η : F ≅ F') : Y ≅ Y' :=
  (e.ofIso η).uniqueUpToIso e'

/-- The comparison in `uniqueUpToIsoOfIso` intertwines the two universal elements. -/
theorem homEquiv_uniqueUpToIsoOfIso_hom
    {C : Type u} [Category.{v, u} C]
    {F F' : Cᵒᵖ ⥤ Type v} {Y Y' : C}
    (e : F.RepresentableBy Y) (e' : F'.RepresentableBy Y') (η : F ≅ F')
    {X : C} (f : X ⟶ Y) :
    e'.homEquiv (f ≫ (uniqueUpToIsoOfIso e e' η).hom) =
      η.hom.app (Opposite.op X) (e.homEquiv f) := by
  change e'.homEquiv (f ≫ ((e.ofIso η).uniqueUpToIso e').hom) =
    (e.ofIso η).homEquiv f
  have h : ((e.ofIso η).uniqueUpToIso e').hom =
      e'.homEquiv.symm ((e.ofIso η).homEquiv (𝟙 Y)) := rfl
  rw [h, comp_homEquiv_symm, Equiv.apply_symm_apply]
  rw [← (e.ofIso η).homEquiv_comp f (𝟙 Y), Category.comp_id]

/-- Three canonical comparisons satisfy the cocycle law when the presheaf isomorphisms do. -/
theorem uniqueUpToIsoOfIso_trans
    {C : Type u} [Category.{v, u} C]
    {F₁ F₂ F₃ : Cᵒᵖ ⥤ Type v} {Y₁ Y₂ Y₃ : C}
    (e₁ : F₁.RepresentableBy Y₁) (e₂ : F₂.RepresentableBy Y₂)
    (e₃ : F₃.RepresentableBy Y₃)
    (η₁₂ : F₁ ≅ F₂) (η₂₃ : F₂ ≅ F₃) (η₁₃ : F₁ ≅ F₃)
    (hη : η₁₃ = η₁₂ ≪≫ η₂₃) :
    uniqueUpToIsoOfIso e₁ e₃ η₁₃ =
      uniqueUpToIsoOfIso e₁ e₂ η₁₂ ≪≫ uniqueUpToIsoOfIso e₂ e₃ η₂₃ := by
  apply Iso.ext
  apply e₃.homEquiv.injective
  calc
    e₃.homEquiv (uniqueUpToIsoOfIso e₁ e₃ η₁₃).hom =
        η₁₃.hom.app (Opposite.op Y₁) (e₁.homEquiv (𝟙 Y₁)) := by
      simpa using homEquiv_uniqueUpToIsoOfIso_hom e₁ e₃ η₁₃ (𝟙 Y₁)
    _ = η₂₃.hom.app (Opposite.op Y₁)
        (η₁₂.hom.app (Opposite.op Y₁) (e₁.homEquiv (𝟙 Y₁))) := by
      rw [hη]
      rfl
    _ = e₃.homEquiv ((uniqueUpToIsoOfIso e₁ e₂ η₁₂).hom ≫
        (uniqueUpToIsoOfIso e₂ e₃ η₂₃).hom) := by
      rw [homEquiv_uniqueUpToIsoOfIso_hom e₂ e₃ η₂₃]
      rw [← Category.id_comp (uniqueUpToIsoOfIso e₁ e₂ η₁₂).hom,
        homEquiv_uniqueUpToIsoOfIso_hom e₁ e₂ η₁₂]

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
