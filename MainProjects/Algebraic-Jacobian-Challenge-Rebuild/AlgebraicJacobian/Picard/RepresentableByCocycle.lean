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

/-- Transporting a representation across conjugate adjunctions produces the conjugate
right-adjoint isomorphism on the representing object. -/
theorem uniqueUpToIsoOfIso_ofLeftAdjoint_conjugate
    {C : Type u} {D : Type u'} [Category.{v, u} C] [Category.{v, u'} D]
    {L₁ L₂ : C ⥤ D} {R₁ R₂ : D ⥤ C}
    (adj₁ : L₁ ⊣ R₁) (adj₂ : L₂ ⊣ R₂) (α : L₂ ≅ L₁)
    {F : Dᵒᵖ ⥤ Type v} {Y : D} (e : F.RepresentableBy Y) :
    uniqueUpToIsoOfIso
      (ofLeftAdjoint adj₁ e)
      (ofLeftAdjoint adj₂ e)
      (Functor.isoWhiskerRight (NatIso.op α) F) =
      (conjugateIsoEquiv adj₁ adj₂ α).app Y := by
  let e₁ := ofLeftAdjoint adj₁ e
  let e₂ := ofLeftAdjoint adj₂ e
  apply Iso.ext
  apply e₂.homEquiv.injective
  have h : (adj₂.homEquiv (R₁.obj Y) Y).symm
      ((conjugateIsoEquiv adj₁ adj₂ α).app Y).hom =
      α.hom.app (R₁.obj Y) ≫ adj₁.counit.app Y := by
    apply (adj₂.homEquiv (R₁.obj Y) Y).injective
    rw [Equiv.apply_symm_apply]
    have hc := conjugateEquiv_counit adj₁ adj₂ α.hom Y
    have hn := adj₂.homEquiv_naturality_left
      (X' := R₁.obj Y) (X := R₂.obj Y) (Y := Y)
      ((conjugateEquiv adj₁ adj₂ α.hom).app Y) (adj₂.counit.app Y)
    have hunit : (adj₂.homEquiv (R₂.obj Y) Y) (adj₂.counit.app Y) =
        𝟙 (R₂.obj Y) := by
      have hh := adj₂.homEquiv_counit (R₂.obj Y) Y (𝟙 (R₂.obj Y))
      have hh' := congrArg (adj₂.homEquiv (R₂.obj Y) Y) hh
      simpa using hh'.symm
    change (conjugateEquiv adj₁ adj₂ α.hom).app Y = _
    calc
      (conjugateEquiv adj₁ adj₂ α.hom).app Y =
          (conjugateEquiv adj₁ adj₂ α.hom).app Y ≫ 𝟙 _ := by simp
      _ = (conjugateEquiv adj₁ adj₂ α.hom).app Y ≫
          (adj₂.homEquiv (R₂.obj Y) Y) (adj₂.counit.app Y) := by
        rw [hunit, Category.comp_id]
      _ = (adj₂.homEquiv (R₁.obj Y) Y)
          (L₂.map ((conjugateEquiv adj₁ adj₂ α.hom).app Y) ≫ adj₂.counit.app Y) :=
        hn.symm
      _ = (adj₂.homEquiv (R₁.obj Y) Y)
          (α.hom.app (R₁.obj Y) ≫ adj₁.counit.app Y) := by
        exact congrArg (adj₂.homEquiv (R₁.obj Y) Y) hc
  calc
    e₂.homEquiv
        (uniqueUpToIsoOfIso e₁ e₂
          (Functor.isoWhiskerRight (NatIso.op α) F)).hom =
      (Functor.isoWhiskerRight (NatIso.op α) F).hom.app
          (Opposite.op (R₁.obj Y)) (e₁.homEquiv (𝟙 _)) := by
      simpa using homEquiv_uniqueUpToIsoOfIso_hom
        e₁ e₂ (Functor.isoWhiskerRight (NatIso.op α) F) (𝟙 _)
    _ = e.homEquiv (α.hom.app (R₁.obj Y) ≫ adj₁.counit.app Y) := by
      simp only [Functor.isoWhiskerRight_hom, Functor.whiskerRight_app]
      dsimp [e₁]
      rw [ofLeftAdjoint_homEquiv]
      have hunit : (adj₁.homEquiv (R₁.obj Y) Y).symm (𝟙 (R₁.obj Y)) =
          adj₁.counit.app Y := by
        have hh := adj₁.homEquiv_counit (R₁.obj Y) Y (𝟙 (R₁.obj Y))
        simpa using hh
      rw [hunit]
      change (ConcreteCategory.hom (F.map (α.hom.app (R₁.obj Y)).op))
          (e.homEquiv (adj₁.counit.app Y)) =
        e.homEquiv (α.hom.app (R₁.obj Y) ≫ adj₁.counit.app Y)
      exact (e.homEquiv_comp
        (α.hom.app (R₁.obj Y)) (adj₁.counit.app Y)).symm
    _ = e₂.homEquiv ((conjugateIsoEquiv adj₁ adj₂ α).app Y).hom := by
      rw [ofLeftAdjoint_homEquiv, h]
      rfl

/-- Transport through a composite adjunction is the same representation as transport
through the two adjunctions successively. -/
theorem ofLeftAdjoint_comp
    {C : Type u} {D E : Type u'} [Category.{v, u} C]
    [Category.{v, u'} D] [Category.{v, u'} E]
    {L₁ : C ⥤ D} {R₁ : D ⥤ C} {L₂ : D ⥤ E} {R₂ : E ⥤ D}
    (adj₁ : L₁ ⊣ R₁) (adj₂ : L₂ ⊣ R₂)
    {F : Eᵒᵖ ⥤ Type v} {Y : E} (e : F.RepresentableBy Y) :
    ofLeftAdjoint (adj₁.comp adj₂) e =
      ofLeftAdjoint adj₁ (ofLeftAdjoint adj₂ e) := by
  apply RepresentableBy.ext
  change e.homEquiv
      (((adj₁.comp adj₂).homEquiv ((R₂ ⋙ R₁).obj Y) Y).symm (𝟙 _)) =
    e.homEquiv ((adj₂.homEquiv (L₁.obj ((R₂ ⋙ R₁).obj Y)) Y).symm
      ((adj₁.homEquiv ((R₂ ⋙ R₁).obj Y) (R₂.obj Y)).symm (𝟙 _)))
  rw [Adjunction.comp_homEquiv]
  rfl

open Limits
/-- For over-categories, the canonical comparison between direct and iterated
adjunction transport is mathlib's `Over.pullbackComp`. -/
theorem uniqueUpToIsoOfIso_pullbackComp
    {D : Type u} [Category.{v, u} D] [HasPullbacks D]
    {X Y Z : D} (f : X ⟶ Y) (g : Y ⟶ Z)
    {F : (Over Z)ᵒᵖ ⥤ Type v} {J : Over Z} (e : F.RepresentableBy J) :
    uniqueUpToIsoOfIso
      (ofLeftAdjoint (Over.mapPullbackAdj (f ≫ g)) e)
      (ofLeftAdjoint (Over.mapPullbackAdj f)
        (ofLeftAdjoint (Over.mapPullbackAdj g) e))
      (Functor.isoWhiskerRight
        (NatIso.op (Over.mapComp f g).symm) F) =
      (Over.pullbackComp f g).app J := by
  rw [← ofLeftAdjoint_comp]
  exact uniqueUpToIsoOfIso_ofLeftAdjoint_conjugate
    (Over.mapPullbackAdj (f ≫ g))
    ((Over.mapPullbackAdj f).comp (Over.mapPullbackAdj g))
    (Over.mapComp f g).symm e

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
