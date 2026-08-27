/-
Copyright (c) 2026 The StacksPart07Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart07Lib Contributors
-/

import StacksPart07Lib.RepresentableMorphisms

/-!
# Products of representable transformations

The product lemma in the first algebraic-stacks chapter (Stacks, Tag `02ZU`)
is formal: a product transformation is a composite of two base changes of the
original transformations.  This file records that argument in the presheaf
model used by the Part 07 representability interface.
-/

namespace StacksPart07Lib

open CategoryTheory
open CategoryTheory.Limits
open CategoryTheory.MorphismProperty

universe v u

/-! The pullback of a map along the second product projection. -/

lemma isPullback_prod_snd_with_id {C : Type u} [Category.{v} C]
    {A B : C} (f : A ⟶ B) (X : C) [HasBinaryProduct X A]
    [HasBinaryProduct X B] :
    IsPullback (prod.snd : X ⨯ A ⟶ A) (prod.map (𝟙 X) f) f
      (prod.snd : X ⨯ B ⟶ B) := by
  let c : PullbackCone f (prod.snd : X ⨯ B ⟶ B) :=
    PullbackCone.mk (prod.snd : X ⨯ A ⟶ A) (prod.map (𝟙 X) f)
      (by rw [prod.map_snd])
  apply IsPullback.of_isLimit (c := c)
  exact PullbackCone.IsLimit.mk (by
      rw [prod.map_snd])
    (fun s => prod.lift (s.snd ≫ prod.fst) s.fst)
    (fun s => by
      rw [prod.lift_snd])
    (fun s => by
      apply prod.hom_ext
      · rw [Category.assoc, prod.map_fst, prod.lift_fst_assoc, Category.comp_id]
      · rw [Category.assoc, prod.map_snd, prod.lift_snd_assoc]
        exact s.condition)
    (fun s m h₁ h₂ => by
      apply prod.hom_ext
      · rw [← h₂, Category.assoc, prod.map_fst, prod.lift_fst, Category.comp_id]
      · rw [← h₁, prod.lift_snd])

/-!
### Product representability

The products here are the categorical products in the presheaf category. -/

theorem representableTransformation_prod {C : Type u} [Category.{v} C]
    {F₁ G₁ F₂ G₂ : Presheaf C}
    (f₁ : F₁ ⟶ G₁) (f₂ : F₂ ⟶ G₂)
    (h₁ : RepresentableTransformation C f₁)
    (h₂ : RepresentableTransformation C f₂) :
    RepresentableTransformation C (prod.map f₁ f₂) := by
  have hleft : RepresentableTransformation C (prod.map f₁ (𝟙 F₂)) :=
    representableTransformation_baseChange
      (IsPullback.of_prod_fst_with_id f₁ F₂) h₁
  have hright : RepresentableTransformation C (prod.map (𝟙 G₁) f₂) :=
    representableTransformation_baseChange
      (isPullback_prod_snd_with_id f₂ G₁) h₂
  have hcomp : RepresentableTransformation C
      (prod.map f₁ (𝟙 F₂) ≫ prod.map (𝟙 G₁) f₂) :=
    representableTransformation_comp _ _ hleft hright
  rw [prod.map_map] at hcomp
  simpa using hcomp

end StacksPart07Lib
