/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageGluedOver
import AlgebraicJacobian.Picard.Pic0FiniteStageUniversalModelClasses
import AlgebraicJacobian.Picard.Pic0FiniteStageModelRightLeg

/-!
# Tensor-model charts of the finite-stage glued carrier

The affine sources are the tensor model algebras on which finite-stage class
descent produces its values. Their canonical inclusions lie over the model
field, and their two restriction maps are the overlap legs of the selected
glued scheme.
-/

set_option autoImplicit false

universe u

open CategoryTheory
open scoped TensorProduct

namespace AlgebraicGeometry.Pic0FiniteStageGluePackage

noncomputable section

private theorem chart_comp_specMap
    {R S A : Type u} [CommRing R] [CommRing S] [CommRing A]
    [Algebra R S] [Algebra S A] [Algebra R A]
    (hcomp : (algebraMap S A).comp (algebraMap R S) = algebraMap R A)
    {X : Scheme.{u}} (f : Spec (.of A) ⟶ X) (p : X ⟶ Spec (.of S))
    (h : f ≫ p = Spec.map (CommRingCat.ofHom (algebraMap S A))) :
    f ≫ (p ≫ Spec.map (CommRingCat.ofHom (algebraMap R S))) =
      Spec.map (CommRingCat.ofHom (algebraMap R A)) := by
  rw [← Category.assoc, h, ← Spec.map_comp, ← CommRingCat.ofHom_comp,
    hcomp]

private theorem specMap_tensor_comp_of_algHom_comp_eq
    {R S A B D : Type u} [CommRing R] [CommRing S]
    [CommRing A] [CommRing B] [CommRing D]
    [Algebra R S] [Algebra R A] [Algebra R B] [Algebra R D]
    {f : A →ₐ[R] B} {g : B →ₐ[R] D} {h : A →ₐ[R] D}
    (heq : g.comp f = h) :
    Spec.map (CommRingCat.ofHom
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom (K := S) g).toRingHom) ≫
        Spec.map (CommRingCat.ofHom
          (AlgebraicJacobian.scalarExtensionMapOfAlgHom (K := S) f).toRingHom) =
      Spec.map (CommRingCat.ofHom
        (Algebra.TensorProduct.map (AlgHom.id R S) h).toRingHom) := by
  rw [← Spec.map_comp, ← CommRingCat.ofHom_comp]
  apply congrArg (fun a : S ⊗[R] A →+* S ⊗[R] D => Spec.map (CommRingCat.ofHom a))
  apply RingHom.ext
  intro x
  induction x using TensorProduct.induction_on with
  | zero => simp
  | add x y hx hy => simp only [map_add, hx, hy]
  | tmul s a =>
      simp only [RingHom.comp_apply, AlgHom.toRingHom_eq_coe, RingHom.coe_coe,
        AlgebraicJacobian.scalarExtensionMapOfAlgHom_tmul,
        Algebra.TensorProduct.map_tmul, AlgHom.id_apply]
      exact congrArg (fun b => s ⊗ₜ[R] b) (DFunLike.congr_fun heq a)

variable {F K : Type u} [Field F] [Field K] [Algebra F K]
  [Algebra.IsAlgebraic F K] [IsSepClosed K]
  (Ck : Over (Spec (.of K))) [SmoothOfRelativeDimension 1 Ck.hom]
  [IsProper Ck.hom] [GeometricallyIrreducible Ck.hom]
  (P : Pic0FiniteStageGluePackage Ck F)

set_option maxHeartbeats 800000 in
-- The canonical tensor chart must be compared with the assembled glue chart.
/-- The canonical tensor chart inclusion, regarded over the model field. -/
def modelChartι (U : Pic0FiniteStageChartIndex Ck) :
    overSpec P.context.models.M.1
        (P.context.triple.N.1 ⊗[P.context.models.M.1]
          (pic0FiniteStageModelAlgebra Ck P.context.models (Sum.inl U))) ⟶
      (Over.map (Spec.map (CommRingCat.ofHom
        (algebraMap P.context.models.M.1 P.context.triple.N.1)))).obj
        P.gluedOver := by
  rcases P with ⟨⟨D, T⟩⟩
  let P : Pic0FiniteStageGluePackage Ck F := ⟨⟨D, T⟩⟩
  let A := T.N.1 ⊗[D.M.1] (pic0FiniteStageModelAlgebra Ck D (Sum.inl U))
  letI : Algebra T.N.1 A :=
    Algebra.TensorProduct.leftAlgebra (R := D.M.1) (S := T.N.1)
      (A := T.N.1) (B := pic0FiniteStageModelAlgebra Ck D (Sum.inl U))
  exact Over.homMk (P.glueData.ι U)
    (@chart_comp_specMap D.M.1 T.N.1 A
      (inferInstance : CommRing D.M.1)
      (inferInstance : CommRing T.N.1)
      (inferInstance : CommRing A)
      (inferInstance : Algebra D.M.1 T.N.1)
      (inferInstance : Algebra T.N.1 A)
      (inferInstance : Algebra D.M.1 A)
      (by ext a; rfl)
      P.glueData.glued (P.glueData.ι U) P.gluedMap
      (P.presentation.chartMap_factor U))

set_option maxHeartbeats 800000 in
-- Identifying the assembled chart with the literal tensor model exceeds 200k.
/-- The glued left overlap leg is the scalar extension of the model restriction. -/
theorem glueData_f_eq_tensorModelRestriction (U V : Pic0FiniteStageChartIndex Ck) :
    P.glueData.f U V = (Over.overSpecMap
      (Algebra.TensorProduct.map
        (AlgHom.id P.context.models.M.1 P.context.triple.N.1)
        (pic0FiniteStageModelRestriction Ck P.context.models (Sum.inl (U, V))).hom)).left :=
  rfl

set_option maxHeartbeats 800000 in
-- The right leg compares the assembled maps with their scalar-extended models.
/-- Transition followed by the reversed left leg is the actual right model restriction. -/
theorem glueData_tf_eq_tensorModelRestriction (U V : Pic0FiniteStageChartIndex Ck) :
    P.glueData.t U V ≫ P.glueData.f V U = (Over.overSpecMap
      (Algebra.TensorProduct.map
        (AlgHom.id P.context.models.M.1 P.context.triple.N.1)
        (pic0FiniteStageModelRestriction Ck P.context.models (Sum.inr (U, V))).hom)).left := by
  rcases P with ⟨⟨D, T⟩⟩
  exact specMap_tensor_comp_of_algHom_comp_eq (S := T.N.1)
    (D.mapM_transition_comp_restrictionLeft_eq_right Ck U V)

end

end AlgebraicGeometry.Pic0FiniteStageGluePackage
