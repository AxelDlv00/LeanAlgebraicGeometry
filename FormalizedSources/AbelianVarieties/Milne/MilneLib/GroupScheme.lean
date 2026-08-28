/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import Mathlib.AlgebraicGeometry.Group.Abelian

/-!
# Group varieties

The group-object interface for schemes supplies canonical translations between
sections.  Proper geometrically integral group schemes over a field are
commutative, giving the categorical core of Milne's abelian-variety language.
-/

set_option autoImplicit false

universe v u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj

namespace MilneLib

namespace GroupVariety

section Categorical

variable {C : Type u} [Category.{v} C] [CartesianMonoidalCategory C]
  {G : C} [GrpObj G] {X : C}

/- The cartesian identity used when reducing the geometric rigidity lemma to
   its projection/slice equation. -/
theorem rigidity_snd_lift
    {X Y : C} (x₀ : 𝟙_ C ⟶ X) :
    snd X Y ≫ lift (toUnit Y ≫ x₀) (𝟙 Y) =
      lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y) := by
  ext1 <;> simp

/- Invariance under replacing the first coordinate by `x₀` is equivalent to
   factoring through the second projection. -/
theorem factors_through_snd_iff
    {X Y Z : C} (x₀ : 𝟙_ C ⟶ X) (f : X ⊗ Y ⟶ Z) :
    (∃ g : Y ⟶ Z, f = snd X Y ≫ g) ↔
      lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y) ≫ f = f := by
  constructor
  · rintro ⟨g, rfl⟩
    rw [← rigidity_snd_lift x₀]
    simp
  · intro h
    refine ⟨lift (toUnit Y ≫ x₀) (𝟙 Y) ≫ f, ?_⟩
    calc
      f = lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y) ≫ f := h.symm
      _ = (snd X Y ≫ lift (toUnit Y ≫ x₀) (𝟙 Y)) ≫ f := by
        rw [rigidity_snd_lift x₀]
      _ = snd X Y ≫ (lift (toUnit Y ≫ x₀) (𝟙 Y) ≫ f) :=
        Category.assoc _ _ _

/-- The group-valued functor of points of a group object. -/
abbrev pointsFunctor (G : C) [GrpObj G] : Cᵒᵖ ⥤ GrpCat :=
  CategoryTheory.yonedaGrpObj G

/-- The functor of points is represented by the underlying group object. -/
def pointsFunctor_representable (G : C) [GrpObj G] :
    (pointsFunctor G ⋙ CategoryTheory.forget GrpCat).RepresentableBy G :=
  CategoryTheory.yonedaGrpObjRepresentableBy G

theorem comp_mulRight_hom (f : X ⟶ G) (g : 𝟙_ C ⟶ G) :
    f ≫ (GrpObj.mulRight g).hom = f * (toUnit X ≫ g) := by
  rw [GrpObj.mulRight_hom, comp_lift_assoc, Category.comp_id,
    comp_toUnit_assoc, CategoryTheory.Hom.mul_def]

theorem comp_mulRight_inv (f : X ⟶ G) (g : 𝟙_ C ⟶ G) :
    f ≫ (GrpObj.mulRight g).inv = f * (toUnit X ≫ g)⁻¹ := by
  rw [GrpObj.mulRight_inv, comp_lift_assoc, Category.comp_id,
    ← Category.assoc, comp_toUnit, CategoryTheory.Hom.mul_def,
    CategoryTheory.Hom.inv_def, Category.assoc]

/-- The translation carrying the section `x` to the section `y`. -/
def pointTranslation (G : C) [GrpObj G] (x y : 𝟙_ C ⟶ G) : G ≅ G :=
  (GrpObj.mulRight x).symm ≪≫ GrpObj.mulRight y

@[simp]
theorem pointTranslation_self (x : 𝟙_ C ⟶ G) :
    pointTranslation G x x = Iso.refl G := by
  simp [pointTranslation]

@[simp]
theorem pointTranslation_symm (x y : 𝟙_ C ⟶ G) :
    (pointTranslation G x y).symm = pointTranslation G y x := by
  simp [pointTranslation]

@[simp]
theorem pointTranslation_trans (x y z : 𝟙_ C ⟶ G) :
    pointTranslation G x y ≪≫ pointTranslation G y z = pointTranslation G x z := by
  simp [pointTranslation, Iso.trans_assoc]

@[reassoc (attr := simp)]
theorem comp_pointTranslation_hom (x y : 𝟙_ C ⟶ G) :
    x ≫ (pointTranslation G x y).hom = y := by
  rw [pointTranslation, Iso.trans_hom, Iso.symm_hom, ← Category.assoc,
    comp_mulRight_inv, comp_mulRight_hom, toUnit_unit,
    Category.id_comp, Category.id_comp, mul_inv_cancel, _root_.one_mul]

/- The inverse translation carries `y` back to `x`; keeping this as a named
   simp lemma avoids repeating the symmetry rewrite at geometric use sites. -/
@[reassoc (attr := simp)]
theorem comp_pointTranslation_inv (x y : 𝟙_ C ⟶ G) :
    y ≫ (pointTranslation G x y).inv = x := by
  exact comp_pointTranslation_hom (G := G) y x

end Categorical

section Scheme

open AlgebraicGeometry

variable {S : Scheme.{u}} (G : Over S) [GrpObj G]

/-- The underlying-scheme isomorphism induced by a translation of sections. -/
noncomputable def pointTranslationIso (x y : 𝟙_ (Over S) ⟶ G) : G.left ≅ G.left :=
  (Over.forget S).mapIso (pointTranslation G x y)

@[simp]
theorem pointTranslationIso_hom (x y : 𝟙_ (Over S) ⟶ G) :
    (pointTranslationIso G x y).hom = (pointTranslation G x y).hom.left :=
  rfl

@[simp]
theorem pointTranslationIso_hom_apply (x y : 𝟙_ (Over S) ⟶ G) (s : S) :
    (pointTranslationIso G x y).hom (x.left s) = y.left s := by
  rw [pointTranslationIso_hom, ← Scheme.Hom.comp_apply, ← Over.comp_left,
    comp_pointTranslation_hom]

@[simp]
theorem pointTranslationIso_inv (x y : 𝟙_ (Over S) ⟶ G) :
    (pointTranslationIso G x y).inv = (pointTranslation G x y).inv.left :=
  rfl

@[simp]
theorem pointTranslationIso_self (x : 𝟙_ (Over S) ⟶ G) :
    pointTranslationIso G x x = Iso.refl G.left := by
  apply Iso.ext
  simp [pointTranslationIso]

@[simp]
theorem pointTranslationIso_symm (x y : 𝟙_ (Over S) ⟶ G) :
    (pointTranslationIso G x y).symm = pointTranslationIso G y x := by
  apply Iso.ext
  simp [pointTranslationIso, pointTranslation]

@[simp]
theorem pointTranslationIso_trans (x y z : 𝟙_ (Over S) ⟶ G) :
    pointTranslationIso G x y ≪≫ pointTranslationIso G y z =
      pointTranslationIso G x z := by
  apply Iso.ext
  simp [pointTranslationIso, pointTranslation, Iso.trans_assoc]

@[reassoc (attr := simp)]
theorem pointTranslationIso_hom_comp (x y : 𝟙_ (Over S) ⟶ G) :
    (pointTranslationIso G x y).hom ≫ G.hom = G.hom :=
  Over.w _

end Scheme

end GroupVariety

open AlgebraicGeometry

variable {K : Type u} [Field K]

/-- The geometric hypotheses used for an abelian group scheme over a field. -/
def IsAbelianVariety (G : Over (Spec (.of K))) [GrpObj G] : Prop :=
  IsProper G.hom ∧ GeometricallyIntegral G.hom

/-- Proper geometrically integral group schemes over a field are commutative. -/
theorem isCommMonObj_of_isAbelianVariety
    (G : Over (Spec (.of K))) [GrpObj G] (hG : IsAbelianVariety G) :
    IsCommMonObj G := by
  letI : IsProper G.hom := hG.1
  letI : GeometricallyIntegral G.hom := hG.2
  exact AlgebraicGeometry.isCommMonObj_of_isProper_of_geometricallyIntegral G

end MilneLib
