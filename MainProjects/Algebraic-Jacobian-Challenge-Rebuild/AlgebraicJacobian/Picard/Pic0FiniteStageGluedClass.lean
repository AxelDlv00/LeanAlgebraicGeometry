/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageModelChartMaps
import AlgebraicJacobian.Picard.PicEtCoverBridge

/-!
# Compatible classes on the finite-stage glued carrier

The tensor model charts of a finite-stage glue package carry classes over the
model field.  The explicit restriction equations are exactly the hypotheses
needed by the cover sheaf lemma, yielding a unique class on the finite-stage
carrier regarded over the model field.
-/

set_option autoImplicit false

universe u v

open CategoryTheory CategoryTheory.Limits
open scoped TensorProduct

namespace AlgebraicGeometry.Pic0FiniteStageGluePackage

noncomputable section

variable {F K : Type u} [Field F] [Field K] [Algebra F K]
  [Algebra.IsAlgebraic F K] [IsSepClosed K]
  (Ck : Over (Spec (.of K))) [SmoothOfRelativeDimension 1 Ck.hom]
  [IsProper Ck.hom] [GeometricallyIrreducible Ck.hom]
  (P : Pic0FiniteStageGluePackage Ck F)

private theorem restriction_eq_of_compatible
    (A : Pic0FiniteStageRingIndex Ck → Type v)
    (r : ∀ j : Pic0FiniteStageRestrictionIndex Ck,
      A (Pic0FiniteStageRestrictionSource Ck j) →
        A (Pic0FiniteStageRestrictionTarget Ck j))
    (x : ∀ j, A j)
    (hx : ∀ j, r j (x (Pic0FiniteStageRestrictionSource Ck j)) =
      x (Pic0FiniteStageRestrictionTarget Ck j))
    (U V : Pic0FiniteStageChartIndex Ck) :
    r (Sum.inl (U, V)) (x (Sum.inl U)) =
      r (Sum.inr (U, V)) (x (Sum.inl V)) :=
  (hx (Sum.inl (U, V))).trans (hx (Sum.inr (U, V))).symm

/-- The model-field chart inclusion has the underlying canonical gluing map. -/
theorem modelChartι_left (U : Pic0FiniteStageChartIndex Ck) :
    (P.modelChartι Ck U).left = P.glueData.ι U := by
  rcases P with ⟨⟨D, T⟩⟩
  rfl

/-- The canonical tensor-model chart maps are open immersions. -/
theorem modelChartι_isOpenImmersion (U : Pic0FiniteStageChartIndex Ck) :
    IsOpenImmersion (P.modelChartι Ck U).left := by
  rcases P with ⟨⟨D, T⟩⟩
  exact (show Pic0FiniteStageGluePackage Ck F from ⟨⟨D, T⟩⟩).glueData.ι_isOpenImmersion U

/-- The canonical tensor-model charts cover the glued carrier. -/
theorem modelChartι_jointly_surjective (p : P.gluedOver.left) :
    ∃ U : Pic0FiniteStageChartIndex Ck, p ∈ Set.range (P.modelChartι Ck U).left.base := by
  rcases P with ⟨⟨D, T⟩⟩
  exact (show Pic0FiniteStageGluePackage Ck F from ⟨⟨D, T⟩⟩).glueData.ι_jointly_surjective p

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
        (P.context.triple.N.1 ⊗[P.context.models.M.1]
          (pic0FiniteStageModelAlgebra Ck P.context.models j))))
    (hx : ∀ j : Pic0FiniteStageRestrictionIndex Ck,
      pic0Map CM (Over.overSpecMap
        (Algebra.TensorProduct.map
          (AlgHom.id P.context.models.M.1 P.context.triple.N.1)
          (pic0FiniteStageModelRestriction Ck P.context.models j).hom))
        (x (Pic0FiniteStageRestrictionSource Ck j)) =
          x (Pic0FiniteStageRestrictionTarget Ck j)) :
    ∃! s : pic0Subgroup CM
        ((Over.map (Spec.map (CommRingCat.ofHom
          (algebraMap P.context.models.M.1 P.context.triple.N.1)))).obj P.gluedOver),
      ∀ U, pic0Map CM (P.modelChartι Ck U) s = x (Sum.inl U) := by
  letI (j : Pic0FiniteStageRingIndex Ck) :
      Algebra P.context.models.M.1
        (P.context.triple.N.1 ⊗[P.context.models.M.1]
          (pic0FiniteStageModelAlgebra Ck P.context.models j)) :=
    Algebra.TensorProduct.instAlgebra
  let rL := fun U V => Algebra.TensorProduct.map
    (AlgHom.id P.context.models.M.1 P.context.triple.N.1)
    (pic0FiniteStageModelRestriction Ck P.context.models (Sum.inl (U, V))).hom
  let rR := fun U V => Algebra.TensorProduct.map
    (AlgHom.id P.context.models.M.1 P.context.triple.N.1)
    (pic0FiniteStageModelRestriction Ck P.context.models (Sum.inr (U, V))).hom
  let incl := P.modelChartι Ck
  have hι : ∀ U : Pic0FiniteStageChartIndex Ck, (incl U).left = P.glueData.ι U := by
    intro U
    exact P.modelChartι_left Ck U
  let fL := fun U V => Over.overSpecMap (rL U V)
  let fR := fun U V => Over.overSpecMap (rR U V)
  have hL : ∀ U V : Pic0FiniteStageChartIndex Ck, (fL U V).left = P.glueData.f U V :=
    fun U V => (P.glueData_f_eq_tensorModelRestriction Ck U V).symm
  have hR : ∀ U V : Pic0FiniteStageChartIndex Ck,
      (fR U V).left = P.glueData.t U V ≫ P.glueData.f V U :=
    fun U V => (P.glueData_tf_eq_tensorModelRestriction Ck U V).symm
  have hcompat : ∀ U V : Pic0FiniteStageChartIndex Ck,
      pic0Map CM (fL U V) (x (Sum.inl U)) =
      pic0Map CM (fR U V) (x (Sum.inl V)) := by
    intro U V
    exact restriction_eq_of_compatible Ck
      (fun j => pic0Subgroup CM (overSpec P.context.models.M.1
        (P.context.triple.N.1 ⊗[P.context.models.M.1]
          (pic0FiniteStageModelAlgebra Ck P.context.models j))))
      (fun j => pic0Map CM (Over.overSpecMap
        (Algebra.TensorProduct.map
          (AlgHom.id P.context.models.M.1 P.context.triple.N.1)
          (pic0FiniteStageModelRestriction Ck P.context.models j).hom))) x hx U V
  letI (U : Pic0FiniteStageChartIndex Ck) : IsOpenImmersion (incl U).left :=
    P.modelChartι_isOpenImmersion Ck U
  refine pic0Subgroup_existsUnique_of_cover incl (P.modelChartι_jointly_surjective Ck)
    (fun U => x (Sum.inl U)) ?_
  intro U V Z gi gj h
  have hleft : gi.left ≫ P.glueData.ι U = gj.left ≫ P.glueData.ι V := by
    have heq : gi.left ≫ (incl U).left = gj.left ≫ (incl V).left :=
      congrArg Over.Hom.left h
    exact (congrArg (fun a => gi.left ≫ a) (hι U)).symm.trans
      (heq.trans (congrArg (fun a => gj.left ≫ a) (hι V)))
  let cone := PullbackCone.mk gi.left gj.left hleft
  let q := (P.glueData.vPullbackConeIsLimit U V).lift cone
  have hqi : q ≫ (fL U V).left = gi.left := by
    exact (congrArg (fun a => q ≫ a) (hL U V)).trans
      ((P.glueData.vPullbackConeIsLimit U V).fac cone WalkingCospan.left)
  have hqj : q ≫ (fR U V).left = gj.left := by
    exact (congrArg (fun a => q ≫ a) (hR U V)).trans
      ((P.glueData.vPullbackConeIsLimit U V).fac cone WalkingCospan.right)
  let qOver : Z ⟶ overSpec P.context.models.M.1
      (P.context.triple.N.1 ⊗[P.context.models.M.1]
        (pic0FiniteStageModelAlgebra Ck P.context.models (Sum.inr (U, V)))) :=
    Over.homMk q (by
      exact (congrArg (fun a => q ≫ a) (fL U V).w.symm).trans
        ((Category.assoc _ _ _).symm.trans
          ((congrArg (fun a => a ≫ _) hqi).trans gi.w)))
  have hqiOver : qOver ≫ fL U V = gi := by
    ext
    exact hqi
  have hqjOver : qOver ≫ fR U V = gj := by
    ext
    exact hqj
  apply Subtype.ext
  have hclasses := congrArg (fun z => (pic0Map CM qOver z).val) (hcompat U V)
  change picEtMap CM qOver (picEtMap CM (fL U V) (x (Sum.inl U)).val) =
    picEtMap CM qOver (picEtMap CM (fR U V) (x (Sum.inl V)).val) at hclasses
  exact (congrArg (fun f => picEtMap CM f (x (Sum.inl U)).val) hqiOver).symm.trans
    ((picEtMap_comp CM (fL U V) qOver (x (Sum.inl U)).val).trans
      (hclasses.trans
        ((picEtMap_comp CM (fR U V) qOver (x (Sum.inl V)).val).symm.trans
          (congrArg (fun f => picEtMap CM f (x (Sum.inl V)).val) hqjOver))))

end

end AlgebraicGeometry.Pic0FiniteStageGluePackage
