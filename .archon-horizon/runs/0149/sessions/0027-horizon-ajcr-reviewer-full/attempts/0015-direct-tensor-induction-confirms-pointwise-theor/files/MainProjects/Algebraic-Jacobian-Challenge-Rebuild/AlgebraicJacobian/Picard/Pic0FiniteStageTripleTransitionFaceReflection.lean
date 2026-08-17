/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.FinitePresentationAlgebraMapFiniteStage
import AlgebraicJacobian.Picard.Pic0FiniteStageTransportedTripleTransitionFace

/-!
# Reflection of the finite-stage triple-transition face equation

A descended triple transition and pair transition which agree with their transported
ambient maps satisfy the same compatibility with the two triple-model faces.
-/

set_option autoImplicit false

universe u

open CategoryTheory TensorProduct
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] [IsSepClosed k]

section

set_option linter.style.setOption false
set_option synthInstance.maxHeartbeats 400000
set_option maxHeartbeats 6400000

variable {F : Type u} [Field F] [Algebra F k]
variable (L : DatG0.FinSubext F k)
variable (n m : Pic0FiniteStageRingIndex C -> Nat)
variable (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
variable (e : forall j,
  k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j) ≃ₐ[k]
    Pic0FiniteStageRing C j)
variable (M : DatG0.FinSubext L.1 k)
variable (mapM : forall q : Pic0FiniteStageMapIndex C,
  Pic0FiniteStageModelRing C L n m relation M
      (Pic0FiniteStageMapSource C q) →ₐ[M.1]
    Pic0FiniteStageModelRing C L n m relation M
      (Pic0FiniteStageMapTarget C q))
variable (hmapM : forall q,
  (Algebra.TensorProduct.map M.1.val
      (AlgHom.id L.1
        (DatG0.FiniteRelationAlgebra L.1
          (n (Pic0FiniteStageMapTarget C q))
          (m (Pic0FiniteStageMapTarget C q))
          (relation (Pic0FiniteStageMapTarget C q))))).comp
      ((mapM q).restrictScalars L.1) =
    ((pic0FiniteStageTransportedMap C L n m relation e q).restrictScalars
      L.1).comp
      (Algebra.TensorProduct.map M.1.val
        (AlgHom.id L.1
          (DatG0.FiniteRelationAlgebra L.1
            (n (Pic0FiniteStageMapSource C q))
            (m (Pic0FiniteStageMapSource C q))
            (relation (Pic0FiniteStageMapSource C q))))))

set_option maxHeartbeats 3200000 in
-- Inference preserves the dependent ring instances already fixed by `mapM`.
/-- Scalar extension of the descended pair transition from `M` to `N`. -/
noncomputable def pic0FiniteStagePairTransitionBaseChange
    (N : DatG0.FinSubext M.1 k)
    (U V : Pic0FiniteStageChartIndex C) :=
  AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := N.1) (mapM (Sum.inr (U, V)))

include hmapM

set_option maxHeartbeats 6400000 in
-- Both component equivalences carry dependent quotient-algebra instances.
/-- Scalar extension of the descended pair transition to `k` is the transition
conjugated through the component model comparisons. -/
theorem pic0FiniteStagePairTransition_scalarExtension_eq_comparison
    (U V : Pic0FiniteStageChartIndex C) :
    AlgebraicJacobian.scalarExtensionMapOfAlgHom
        (R := M.1) (K := k) (mapM (Sum.inr (U, V))) =
      pic0FiniteStagePairModelComparisonTransition
        C L n m relation e M U V := by
  let EUV := pic0FiniteStageModelBaseChangeEquiv
    C L n m relation e M (Sum.inr (U, V))
  let EVU := pic0FiniteStageModelBaseChangeEquiv
    C L n m relation e M (Sum.inr (V, U))
  have hnat := pic0FiniteStageModelBaseChangeEquiv_naturality
    C L n m relation e M mapM hmapM (Sum.inr (U, V))
  apply DFunLike.ext _ _
  intro x
  apply EUV.injective
  change
    EUV
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M.1) (K := k) (mapM (Sum.inr (U, V))) x) =
      EUV (EUV.symm (pic0FiniteStageTransition C (U, V) (EVU x)))
  rw [EUV.apply_symm_apply]
  exact DFunLike.congr_fun hnat x

set_option maxHeartbeats 6400000 in
-- The pointwise form lets the inferred pair-map instances determine the source carrier.
/-- The finite-stage pair transition commutes with the canonical maps to `k`. -/
theorem pic0FiniteStagePairTransitionBaseChange_ambient
    (N : DatG0.FinSubext M.1 k)
    (U V : Pic0FiniteStageChartIndex C) :
    forall x,
      (Algebra.TensorProduct.map N.1.val
        (AlgHom.id M.1
          (Pic0FiniteStageModelRing C L n m relation M
            (Pic0FiniteStageMapTarget C (Sum.inr (U, V))))))
          (pic0FiniteStagePairTransitionBaseChange
            C L n m relation M mapM N U V x) =
        pic0FiniteStagePairModelComparisonTransition
          C L n m relation e M U V
          ((Algebra.TensorProduct.map N.1.val
            (AlgHom.id M.1
              (Pic0FiniteStageModelRing
                C L n m relation M
                  (Pic0FiniteStageMapSource C (Sum.inr (U, V)))))) x) := by
  intro x
  induction x using TensorProduct.induction_on with
  | zero => simp
  | add x y hx hy => simp only [map_add, hx, hy]
  | tmul c a =>
      rw [AlgebraicJacobian.scalarExtensionMapOfAlgHom_tmul,
        Algebra.TensorProduct.map_tmul, Algebra.TensorProduct.map_tmul]
      rw [← pic0FiniteStagePairTransition_scalarExtension_eq_comparison
        C L n m relation e M mapM hmapM U V]
      simp [AlgebraicJacobian.scalarExtensionMapOfAlgHom_tmul]

variable [Algebra.IsAlgebraic M.1 k]

set_option maxHeartbeats 12800000 in
-- The reflected equation elaborates through three dependent tensor-product models.
/-- The ambient face equation reflects to a finite stage once the descended triple and
pair transitions commute with the canonical maps to the ambient field. -/
theorem pic0FiniteStageTripleTransitionModel_fac
    (N : DatG0.FinSubext M.1 k)
    (U V W : Pic0FiniteStageChartIndex C)
    (thetaN : forall p : Pic0FiniteStageTripleTransitionIndex C,
      N.1 ⊗[M.1] Pic0FiniteStageTripleTransitionModelSource
          C L n m relation M mapM p →ₐ[N.1]
        N.1 ⊗[M.1] Pic0FiniteStageTripleTransitionModelTarget
          C L n m relation M mapM p)
    (hthetaN : forall p : Pic0FiniteStageTripleTransitionIndex C,
      (Algebra.TensorProduct.map N.1.val
          (AlgHom.id M.1
            (Pic0FiniteStageTripleTransitionModelTarget
              C L n m relation M mapM p))).comp
          ((thetaN p).restrictScalars M.1) =
        ((pic0FiniteStageTransportedTripleTransitionOfModels
          C L n m relation e M mapM hmapM p.1 p.2.1 p.2.2).restrictScalars
            M.1).comp
          (Algebra.TensorProduct.map N.1.val
            (AlgHom.id M.1
              (Pic0FiniteStageTripleTransitionModelSource
                C L n m relation M mapM p)))) :
    (thetaN (U, (V, W))).comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M.1) (K := N.1)
          (pic0FiniteStageTripleModelFaceRight
            C L n m relation M mapM V W U)) =
      (AlgebraicJacobian.scalarExtensionMapOfAlgHom
        (R := M.1) (K := N.1)
        (pic0FiniteStageTripleModelFaceLeft
          C L n m relation M mapM U V W)).comp
        (pic0FiniteStagePairTransitionBaseChange
          C L n m relation M mapM N U V) := by
  apply DatG0.tensorProduct_algHom_comp_eq_of_baseChange N
    (AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := M.1) (K := N.1)
      (pic0FiniteStageTripleModelFaceRight
        C L n m relation M mapM V W U))
    (thetaN (U, (V, W)))
    ((AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := M.1) (K := N.1)
      (pic0FiniteStageTripleModelFaceLeft
        C L n m relation M mapM U V W)).comp
      (pic0FiniteStagePairTransitionBaseChange
        C L n m relation M mapM N U V))
    (AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := M.1) (K := k)
      (pic0FiniteStageTripleModelFaceRight
        C L n m relation M mapM V W U))
    (pic0FiniteStageTransportedTripleTransitionOfModels
      C L n m relation e M mapM hmapM U V W)
    ((AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := M.1) (K := k)
      (pic0FiniteStageTripleModelFaceLeft
        C L n m relation M mapM U V W)).comp
      (pic0FiniteStagePairModelComparisonTransition
        C L n m relation e M U V))
  · have hval : N.1.val = IsScalarTower.toAlgHom M.1 N.1 k := by
      ext x
      rfl
    rw [hval]
    exact AlgebraicJacobian.scalarExtensionMapOfAlgHom_tower
      (pic0FiniteStageTripleModelFaceRight
        C L n m relation M mapM V W U)
  · exact hthetaN (U, (V, W))
  · apply DFunLike.ext _ _
    intro x
    have hval : N.1.val = IsScalarTower.toAlgHom M.1 N.1 k := by
      ext y
      rfl
    have hface := AlgebraicJacobian.scalarExtensionMapOfAlgHom_tower
      (F := M.1) (L := N.1) (K := k)
      (pic0FiniteStageTripleModelFaceLeft
        C L n m relation M mapM U V W)
    rw [← hval] at hface
    calc
      (Algebra.TensorProduct.map N.1.val
          (AlgHom.id M.1
            (Pic0FiniteStageTripleTransitionModelTarget
              C L n m relation M mapM (U, (V, W)))))
          (((AlgebraicJacobian.scalarExtensionMapOfAlgHom
            (R := M.1) (K := N.1)
            (pic0FiniteStageTripleModelFaceLeft
              C L n m relation M mapM U V W)).comp
            (pic0FiniteStagePairTransitionBaseChange
              C L n m relation M mapM N U V)) x) =
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M.1) (K := k)
          (pic0FiniteStageTripleModelFaceLeft
            C L n m relation M mapM U V W))
          ((Algebra.TensorProduct.map N.1.val
            (AlgHom.id M.1
              (Pic0FiniteStageModelRing
                C L n m relation M
                  (Pic0FiniteStageMapTarget C (Sum.inr (U, V))))))
            (pic0FiniteStagePairTransitionBaseChange
              C L n m relation M mapM N U V x)) :=
          DFunLike.congr_fun hface
            (pic0FiniteStagePairTransitionBaseChange
              C L n m relation M mapM N U V x)
      _ = (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M.1) (K := k)
          (pic0FiniteStageTripleModelFaceLeft
            C L n m relation M mapM U V W))
          ((pic0FiniteStagePairModelComparisonTransition
            C L n m relation e M U V)
            ((Algebra.TensorProduct.map N.1.val
              (AlgHom.id M.1
                (Pic0FiniteStageModelRing
                  C L n m relation M
                    (Pic0FiniteStageMapSource C (Sum.inr (U, V)))))) x)) := by
            exact congrArg
              (AlgebraicJacobian.scalarExtensionMapOfAlgHom
                (R := M.1) (K := k)
                (pic0FiniteStageTripleModelFaceLeft
                  C L n m relation M mapM U V W))
              (pic0FiniteStagePairTransitionBaseChange_ambient
                C L n m relation e M mapM hmapM N U V x)
      _ = (((AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M.1) (K := k)
          (pic0FiniteStageTripleModelFaceLeft
            C L n m relation M mapM U V W)).comp
        (pic0FiniteStagePairModelComparisonTransition
          C L n m relation e M U V)).restrictScalars M.1).comp
          (Algebra.TensorProduct.map N.1.val
            (AlgHom.id M.1
              (Pic0FiniteStageModelRing
                C L n m relation M
                  (Pic0FiniteStageMapSource C (Sum.inr (U, V)))))) x := rfl
  · exact pic0FiniteStageTransportedTripleTransition_fac
      C L n m relation e M mapM hmapM U V W

end

end


end AlgebraicGeometry
