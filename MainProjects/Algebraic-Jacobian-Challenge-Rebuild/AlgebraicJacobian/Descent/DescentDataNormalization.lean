/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import Mathlib.CategoryTheory.Sites.Descent.DescentDataPrime

/-!
# Diagonal normalization of invertible descent cocycles

An invertible overlap morphism satisfying the triple cocycle is automatically
the identity after restriction to the diagonal.
-/

set_option autoImplicit false

universe t v' v u' u

namespace CategoryTheory.Pseudofunctor

open Opposite Limits LocallyDiscreteOpToCat

variable {C : Type u} [Category.{v} C]
  (F : Pseudofunctor (LocallyDiscrete Cᵒᵖ) Cat.{v', u'})
  {ι : Type t} {S : C} {X : ι → C} {f : ∀ i, X i ⟶ S}
  (sq : ∀ i j, ChosenPullback (f i) (f j))
  (sq₃ : ∀ i₁ i₂ i₃, ChosenPullback₃ (sq i₁ i₂) (sq i₂ i₃) (sq i₁ i₃))

open DescentData'

/-- An invertible overlap morphism satisfying the triple cocycle restricts to
the identity on every diagonal. -/
lemma pullHom'_hom_self_of_comp
    {obj : ∀ i, F.obj (.mk (op (X i)))}
    (hom : ∀ i j, (F.map (sq i j).p₁.op.toLoc).toFunctor.obj (obj i) ⟶
      (F.map (sq i j).p₂.op.toLoc).toFunctor.obj (obj j))
    (homIso : ∀ i j, IsIso (hom i j))
    (hom_comp : ∀ i₁ i₂ i₃,
      pullHom' hom (sq₃ i₁ i₂ i₃).p (sq₃ i₁ i₂ i₃).p₁ (sq₃ i₁ i₂ i₃).p₂ ≫
      pullHom' hom (sq₃ i₁ i₂ i₃).p (sq₃ i₁ i₂ i₃).p₂ (sq₃ i₁ i₂ i₃).p₃ =
      pullHom' hom (sq₃ i₁ i₂ i₃).p (sq₃ i₁ i₂ i₃).p₁ (sq₃ i₁ i₂ i₃).p₃) :
    ∀ i, pullHom' hom (f i) (𝟙 (X i)) (𝟙 (X i)) = 𝟙 _ := by
  intro i
  let d := pullHom' hom (f i) (𝟙 (X i)) (𝟙 (X i))
  have hd : d ≫ d = d := by
    dsimp only [d]
    exact comp_pullHom'' hom hom_comp (f i)
      (𝟙 (X i)) (𝟙 (X i)) (𝟙 (X i))
      (by simp) (by simp) (by simp)
  let g := (sq i i).isPullback.lift (𝟙 (X i)) (𝟙 (X i)) (by simp)
  let a := (F.mapComp' (sq i i).p₁.op.toLoc g.op.toLoc
      (𝟙 (X i)).op.toLoc
      (by rw [← Quiver.Hom.comp_toLoc, ← op_comp, IsPullback.lift_fst])).hom.toNatTrans.app
        (obj i)
  let b := (F.map g.op.toLoc).toFunctor.map (hom i i)
  let c := (F.mapComp' (sq i i).p₂.op.toLoc g.op.toLoc
      (𝟙 (X i)).op.toLoc
      (by rw [← Quiver.Hom.comp_toLoc, ← op_comp, IsPullback.lift_snd])).inv.toNatTrans.app
        (obj i)
  letI := homIso i i
  have ha : IsIso a := by
    dsimp only [a]
    infer_instance
  have hb : IsIso b := by
    dsimp only [b]
    infer_instance
  have hc : IsIso c := by
    dsimp only [c]
    infer_instance
  have hbc : IsIso (b ≫ c) :=
    @IsIso.comp_isIso _ _ _ _ _ b c hb hc
  have habc : IsIso (a ≫ b ≫ c) :=
    @IsIso.comp_isIso _ _ _ _ _ a (b ≫ c) ha hbc
  have hd_eq : d = a ≫ b ≫ c := by rfl
  haveI : IsIso d := hd_eq ▸ habc
  apply (cancel_mono d).1
  rw [hd]
  simp

end CategoryTheory.Pseudofunctor
