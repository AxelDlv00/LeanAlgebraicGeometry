/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageModelChartMaps
import AlgebraicJacobian.Picard.Pic0GlueData
import Lean.LibrarySuggestions.Basic

/-!
# Compatible classes on the finite-stage glued carrier

The tensor model charts of a finite-stage glue package carry classes over the
model field.  The explicit restriction equations are exactly the hypotheses
needed by the cover sheaf lemma, yielding a unique class on the finite-stage
carrier regarded over the model field.
-/

set_option autoImplicit false

-- Lean 4.31's symbol-frequency analysis of these dependent tensor signatures
-- stalls module export. Exclude only automatic premise suggestions; the public
-- declarations and their kernel checks are unchanged.
run_cmd do
  Lean.modifyEnv fun env =>
    ["modelChartι_left", "modelChartι_isOpenImmersion", "modelChartι_jointly_surjective",
      "modelChartι_isPullback", "existsUnique_gluedModelClass",
      "exists_gluedModelClass_with_comparison"].foldl
      (fun env name => Lean.LibrarySuggestions.nameDenyListExt.addEntry env name) env

universe u v

open CategoryTheory CategoryTheory.Limits
open scoped MonoidalCategory

namespace AlgebraicGeometry.Pic0FiniteStageGluePackage

noncomputable section

variable {F K : Type u} [Field F] [Field K] [Algebra F K]
  [Algebra.IsAlgebraic F K] [IsSepClosed K]
  (Ck : Over (Spec (.of K))) [SmoothOfRelativeDimension 1 Ck.hom]
  [IsProper Ck.hom] [GeometricallyIrreducible Ck.hom]
  (P : Pic0FiniteStageGluePackage Ck F)

private theorem existsUnique_of_indexed_cover
    {k : Type u} [Field k] (CM : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 CM.hom] [IsProper CM.hom]
    [GeometricallyIrreducible CM.hom]
    (A : Pic0FiniteStageRingIndex Ck → Over (Spec (.of k)))
    (r : ∀ j : Pic0FiniteStageRestrictionIndex Ck,
      A (Pic0FiniteStageRestrictionTarget Ck j) ⟶
        A (Pic0FiniteStageRestrictionSource Ck j))
    {X : Over (Spec (.of k))}
    (incl : ∀ U, A (Sum.inl U) ⟶ X)
    [∀ U, IsOpenImmersion (incl U).left]
    (hcover : ∀ p : X.left, ∃ U, p ∈ (incl U).left.opensRange)
    (hp : ∀ U V, IsPullback (r (Sum.inl (U, V))).left
      (r (Sum.inr (U, V))).left (incl U).left (incl V).left)
    (x : ∀ j, pic0Subgroup CM (A j))
    (hx : ∀ j, pic0Map CM (r j) (x (Pic0FiniteStageRestrictionSource Ck j)) =
      x (Pic0FiniteStageRestrictionTarget Ck j)) :
    ∃! s : pic0Subgroup CM X, ∀ U, pic0Map CM (incl U) s = x (Sum.inl U) := by
  apply pic0Subgroup_existsUnique_of_pullback_cover CM incl hcover
    (fun U V => r (Sum.inl (U, V))) (fun U V => r (Sum.inr (U, V))) hp
    (fun U => x (Sum.inl U))
  intro U V
  exact (hx (Sum.inl (U, V))).trans (hx (Sum.inr (U, V))).symm

/-- The model-field chart inclusion has the underlying canonical gluing map. -/
theorem modelChartι_left (U : Pic0FiniteStageChartIndex Ck) :
    (P.modelChartι Ck U).left = P.glueData.ι U := by
  rfl

/-- The canonical tensor-model chart maps are open immersions. -/
theorem modelChartι_isOpenImmersion (U : Pic0FiniteStageChartIndex Ck) :
    IsOpenImmersion (P.modelChartι Ck U).left := by
  exact P.glueData.ι_isOpenImmersion U

/-- The canonical tensor-model charts cover the glued carrier. -/
theorem modelChartι_jointly_surjective (p : P.gluedOver.left) :
    ∃ U : Pic0FiniteStageChartIndex Ck, p ∈ Set.range (P.modelChartι Ck U).left.base := by
  exact P.glueData.ι_jointly_surjective p

set_option maxHeartbeats 800000 in
-- Comparing the literal tensor legs with the assembled overlap exceeds 200k.
/-- The two tensor-model restrictions form the pullback of the model chart inclusions. -/
theorem modelChartι_isPullback (U V : Pic0FiniteStageChartIndex Ck) :
    IsPullback
      (Over.overSpecMap ((CommAlgCat.of P.context.models.M.1 P.context.triple.N.1 ◁
        pic0FiniteStageModelRestriction Ck P.context.models (Sum.inl (U, V))).hom)).left
      (Over.overSpecMap ((CommAlgCat.of P.context.models.M.1 P.context.triple.N.1 ◁
        pic0FiniteStageModelRestriction Ck P.context.models (Sum.inr (U, V))).hom)).left
      (P.modelChartι Ck U).left (P.modelChartι Ck V).left := by
  apply (congrArg₂ (fun f g =>
      IsPullback f g (P.modelChartι Ck U).left (P.modelChartι Ck V).left)
    (P.glueData_f_eq_tensorModelRestriction Ck U V).symm
    (P.glueData_tf_eq_tensorModelRestriction Ck U V).symm).mpr
  apply (congrArg₂ (IsPullback (P.glueData.f U V)
    (P.glueData.t U V ≫ P.glueData.f V U))
    (P.modelChartι_left Ck U) (P.modelChartι_left Ck V)).mpr
  exact pic0FiniteStageAffineRingGluePresentation_isPullback
    Ck P.context U V

variable (CM : Over (Spec (.of P.context.models.M.1)))
  [SmoothOfRelativeDimension 1 CM.hom] [IsProper CM.hom]
  [GeometricallyIrreducible CM.hom]

set_option maxHeartbeats 800000 in
-- Comparing the canonical tensor charts with the assembled gluing maps exceeds 200k.
/-- Compatible classes on the tensor model charts glue uniquely on the selected
finite-stage carrier, regarded over the model field. -/
theorem existsUnique_gluedModelClass
    (x : ∀ j, pic0Subgroup CM
      (overSpec P.context.models.M.1
        (CommAlgCat.of P.context.models.M.1 P.context.triple.N.1 ⊗
          pic0FiniteStageModelAlgebra Ck P.context.models j :
            CommAlgCat P.context.models.M.1)))
    (hx : ∀ j : Pic0FiniteStageRestrictionIndex Ck,
      pic0Map CM (Over.overSpecMap
        ((CommAlgCat.of P.context.models.M.1 P.context.triple.N.1 ◁
          pic0FiniteStageModelRestriction Ck P.context.models j).hom))
        (x (Pic0FiniteStageRestrictionSource Ck j)) =
          x (Pic0FiniteStageRestrictionTarget Ck j)) :
    ∃! s : pic0Subgroup CM
        ((Over.map (Spec.map (CommRingCat.ofHom
          (algebraMap P.context.models.M.1 P.context.triple.N.1)))).obj P.gluedOver),
      ∀ U, pic0Map CM (P.modelChartι Ck U) s = x (Sum.inl U) := by
  let incl := P.modelChartι Ck
  letI (U : Pic0FiniteStageChartIndex Ck) : IsOpenImmersion (incl U).left :=
    P.modelChartι_isOpenImmersion Ck U
  have hcover : ∀ p : P.gluedOver.left,
      ∃ U : Pic0FiniteStageChartIndex Ck, p ∈ (incl U).left.opensRange :=
    P.modelChartι_jointly_surjective Ck
  exact existsUnique_of_indexed_cover Ck CM
    (fun j => overSpec P.context.models.M.1
      (CommAlgCat.of P.context.models.M.1 P.context.triple.N.1 ⊗
        pic0FiniteStageModelAlgebra Ck P.context.models j :
          CommAlgCat P.context.models.M.1))
    (fun j => Over.overSpecMap
      (CommAlgCat.of P.context.models.M.1 P.context.triple.N.1 ◁
        pic0FiniteStageModelRestriction Ck P.context.models j).hom)
    incl hcover (P.modelChartι_isPullback Ck) x hx

/-- Compatible model classes glue with their prescribed pullbacks on additional
test schemes. The comparisons are transported while the chart maps are abstract. -/
theorem exists_gluedModelClass_with_comparison
    (x : ∀ j, pic0Subgroup CM
      (overSpec P.context.models.M.1
        (CommAlgCat.of P.context.models.M.1 P.context.triple.N.1 ⊗
          pic0FiniteStageModelAlgebra Ck P.context.models j :
            CommAlgCat P.context.models.M.1)))
    (hx : ∀ j : Pic0FiniteStageRestrictionIndex Ck,
      pic0Map CM (Over.overSpecMap
        ((CommAlgCat.of P.context.models.M.1 P.context.triple.N.1 ◁
          pic0FiniteStageModelRestriction Ck P.context.models j).hom))
        (x (Pic0FiniteStageRestrictionSource Ck j)) =
          x (Pic0FiniteStageRestrictionTarget Ck j))
    (Y : Pic0FiniteStageChartIndex Ck → Over (Spec (.of P.context.models.M.1)))
    (q : ∀ U, Y U ⟶ overSpec P.context.models.M.1
      (CommAlgCat.of P.context.models.M.1 P.context.triple.N.1 ⊗
        pic0FiniteStageModelAlgebra Ck P.context.models (Sum.inl U) :
          CommAlgCat P.context.models.M.1))
    (y : ∀ U, pic0Subgroup CM (Y U))
    (hbc : ∀ U, pic0Map CM (q U) (x (Sum.inl U)) = y U) :
    ∃ s : pic0Subgroup CM
        ((Over.map (Spec.map (CommRingCat.ofHom
          (algebraMap P.context.models.M.1 P.context.triple.N.1)))).obj P.gluedOver),
      ∀ U, pic0Map CM (q U) (pic0Map CM (P.modelChartι Ck U) s) = y U := by
  have H := @existsUnique_gluedModelClass F K _ _ _ _ _ Ck _ _ _ P CM
    (inferInstance : SmoothOfRelativeDimension 1 CM.hom)
    (inferInstance : IsProper CM.hom) (inferInstance : GeometricallyIrreducible CM.hom) x hx
  obtain ⟨s, hs, _⟩ := H
  refine ⟨s, ?_⟩
  intro U
  exact (congrArg (pic0Map CM (q U)) (hs U)).trans (hbc U)

end

end AlgebraicGeometry.Pic0FiniteStageGluePackage
