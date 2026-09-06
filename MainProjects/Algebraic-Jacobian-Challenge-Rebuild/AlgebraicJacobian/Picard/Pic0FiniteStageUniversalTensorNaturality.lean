/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageUniversalTensorClasses

/-!
# Naturality of the transported finite-stage universal classes

The universal chart and overlap values remain compatible after transport through a
curve isomorphism, the cross-base equivalence, and the chosen tensor-ring models.
The restriction theorem covers both canonical arrows of every pairwise overlap.
-/

set_option autoImplicit false

universe u

open CategoryTheory
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

variable {F K : Type u} [Field F] [Field K] [Algebra F K]
  (C : Over (Spec (.of F))) [SmoothOfRelativeDimension 1 C.hom]
  [IsProper C.hom] [GeometricallyIrreducible C.hom]
  (Ck : Over (Spec (.of K))) [SmoothOfRelativeDimension 1 Ck.hom]
  [IsProper Ck.hom] [GeometricallyIrreducible Ck.hom]

/-- Transport from a base-changed curve commutes with restriction along an algebra map. -/
theorem pic0Map_crossBase_pullback_naturality (i : (baseChange F K).obj C ≅ Ck)
    {A B : Type u} [CommRing A] [CommRing B]
    [Algebra F A] [Algebra K A] [IsScalarTower F K A]
    [Algebra F B] [Algebra K B] [IsScalarTower F K B]
    (f : A →ₐ[K] B) (y : pic0Subgroup Ck (overSpec K A)) :
    pic0Map C (Over.overSpecMap (f.restrictScalars F))
      (pic0Map C (mapOverSpecIso F K A).inv
        (pic0CrossBaseEquiv F K C (overSpec K A)
          (pic0Pullback i.hom (overSpec K A) y))) =
    pic0Map C (mapOverSpecIso F K B).inv
      (pic0CrossBaseEquiv F K C (overSpec K B)
        (pic0Pullback i.hom (overSpec K B)
          (pic0Map Ck (Over.overSpecMap f) y))) := by
  have hsq :
      Over.overSpecMap (f.restrictScalars F) ≫ (mapOverSpecIso F K A).inv =
        (mapOverSpecIso F K B).inv ≫
          (Over.map (Spec.map (CommRingCat.ofHom (algebraMap F K)))).map
            (Over.overSpecMap f) := by
    refine Over.OverMorphism.ext ?_
    exact (Category.comp_id _).trans (Category.id_comp _).symm
  apply Subtype.ext
  simp only [pic0Map_coe, pic0CrossBaseEquiv_apply_coe, pic0Pullback_coe]
  rw [← picEtMap_comp, hsq, picEtMap_comp, picEtMap_picEtCrossBaseInv,
    picEtMap_picEtPullback]

variable [IsSepClosed K]

/-- The indexed pinned class respects both canonical chart-to-overlap restrictions. -/
theorem pic0FiniteStageUniversalRingClass_restriction
    (j : Pic0FiniteStageRestrictionIndex Ck) :
    pic0Map Ck (Over.overSpecMap (pic0FiniteStageRestriction Ck j))
        (pic0FiniteStageUniversalRingClass Ck (Pic0FiniteStageRestrictionSource Ck j)) =
      pic0FiniteStageUniversalRingClass Ck (Pic0FiniteStageRestrictionTarget Ck j) := by
  rcases j with ⟨U, V⟩ | ⟨U, V⟩
  · exact pic0FiniteStageUniversalChartClass_restrict_left Ck U V
  · exact pic0FiniteStageUniversalChartClass_restrict_right Ck U V

/-- The actual pinned universal values, transported to the original curve through the
chosen tensor models, respect the conjugated atlas restriction maps. -/
theorem pic0FiniteStageUniversalRingClass_tensor_restriction
    (i : (baseChange F K).obj C ≅ Ck)
    (A : Pic0FiniteStageRingIndex Ck → Type u)
    [∀ j, CommRing (A j)] [∀ j, Algebra F (A j)]
    (e : ∀ j, K ⊗[F] A j ≃ₐ[K] Pic0FiniteStageRing Ck j)
    (j : Pic0FiniteStageRestrictionIndex Ck) :
    let s := Pic0FiniteStageRestrictionSource Ck j
    let t := Pic0FiniteStageRestrictionTarget Ck j
    let f := (e t).symm.toAlgHom.comp ((pic0FiniteStageRestriction Ck j).comp (e s).toAlgHom)
    let x := fun l => pic0Map C (mapOverSpecIso F K (K ⊗[F] A l)).inv
      (pic0CrossBaseEquiv F K C (overSpec K (K ⊗[F] A l))
        (pic0Pullback i.hom (overSpec K (K ⊗[F] A l))
          (pic0Map Ck (Over.overSpecMap (e l).symm.toAlgHom)
            (pic0FiniteStageUniversalRingClass Ck l))))
    pic0Map C (Over.overSpecMap (f.restrictScalars F)) (x s) = x t := by
  intro s t f x
  have hcomp :
      f.comp (e s).symm.toAlgHom =
        (e t).symm.toAlgHom.comp (pic0FiniteStageRestriction Ck j) := by
    ext z
    simp [f]
  have hclasses :
      pic0Map Ck (Over.overSpecMap f)
          (pic0Map Ck (Over.overSpecMap (e s).symm.toAlgHom)
            (pic0FiniteStageUniversalRingClass Ck s)) =
        pic0Map Ck (Over.overSpecMap (e t).symm.toAlgHom)
          (pic0FiniteStageUniversalRingClass Ck t) := by
    apply Subtype.ext
    simp only [pic0Map_coe]
    rw [← picEtMap_comp, ← Over.overSpecMap_comp, hcomp,
      Over.overSpecMap_comp, picEtMap_comp]
    exact congrArg
      (fun z => picEtMap Ck (Over.overSpecMap (e t).symm.toAlgHom) z.1)
      (pic0FiniteStageUniversalRingClass_restriction Ck j)
  dsimp only [x]
  rw [pic0Map_crossBase_pullback_naturality C Ck i, hclasses]

end

end AlgebraicGeometry
