/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageTripleModelComparison
import AlgebraicJacobian.Picard.Pic0FiniteStageTripleModelScalarExtension
import AlgebraicJacobian.Picard.Pic0FiniteStageTripleTransitionEquations

/-!
# Face equations for descended finite-stage triple transitions

A comparison from each scalar-extended triple model to the exact triple-intersection
ring transports the exact cyclic transition to the ambient field.  If the comparisons
carry both tensor-pushout faces to the exact restriction faces, the transported
transition carries the rotated right face to the original left face after the pair
transition.  The same equation then reflects to every finite stage carrying compatible
models of the transported transitions.
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
variable (Q : forall q : Pic0FiniteStageTripleTransitionIndex C,
  k ⊗[M.1] Pic0FiniteStageTripleTransitionModelTarget
      C L n m relation M mapM q ≃ₐ[k]
    Pic0FiniteStageTripleRing C q.1 q.2.1 q.2.2)
variable (hQLeft : forall U V W,
  let fUV := pic0FiniteStageRestrictionLeftModel
    C L n m relation M mapM U V
  let fUW := pic0FiniteStageRestrictionLeftModel
    C L n m relation M mapM U W
  (Q (U, (V, W))).toAlgHom.comp
      (AlgebraicJacobian.scalarExtensionMapOfAlgHom
        (R := M.1) (K := k) (finiteStageTensorPushoutFaceLeft fUV fUW)) =
    (pic0FiniteStageOverlapToTripleLeft C U V W).comp
      (pic0FiniteStageModelBaseChangeEquiv
        C L n m relation e M (Sum.inr (U, V))).toAlgHom)
variable (hQRight : forall U V W,
  let fUV := pic0FiniteStageRestrictionLeftModel
    C L n m relation M mapM U V
  let fUW := pic0FiniteStageRestrictionLeftModel
    C L n m relation M mapM U W
  (Q (U, (V, W))).toAlgHom.comp
      (AlgebraicJacobian.scalarExtensionMapOfAlgHom
        (R := M.1) (K := k) (finiteStageTensorPushoutFaceRight fUV fUW)) =
    (pic0FiniteStageOverlapToTripleRight C U V W).comp
      (pic0FiniteStageModelBaseChangeEquiv
        C L n m relation e M (Sum.inr (U, W))).toAlgHom)

include e hmapM hQLeft hQRight

set_option synthInstance.maxHeartbeats 400000 in
-- All three comparison objects and the pair-transition naturality square are dependent.
set_option maxHeartbeats 6400000 in
/-- The transported cyclic transition carries the scalar extension of the rotated right
face to the scalar extension of the original left face after the pair transition. -/
theorem pic0FiniteStageTransportedTripleTransition_fac
    (U V W : Pic0FiniteStageChartIndex C) :
    let fVW := pic0FiniteStageRestrictionLeftModel
      C L n m relation M mapM V W
    let fVU := pic0FiniteStageRestrictionLeftModel
      C L n m relation M mapM V U
    let fUV := pic0FiniteStageRestrictionLeftModel
      C L n m relation M mapM U V
    let fUW := pic0FiniteStageRestrictionLeftModel
      C L n m relation M mapM U W
    (pic0FiniteStageTransportedTripleTransition
        C L n m relation M mapM Q (U, (V, W))).comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M.1) (K := k) (finiteStageTensorPushoutFaceRight fVW fVU)) =
      (AlgebraicJacobian.scalarExtensionMapOfAlgHom
        (R := M.1) (K := k)
        (finiteStageTensorPushoutFaceLeft fUV fUW)).comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M.1) (K := k) (mapM (Sum.inr (U, V)))) := by
  dsimp only
  have hright := hQRight V W U
  have hleft := hQLeft U V W
  dsimp only at hright hleft
  have hnat := pic0FiniteStageModelBaseChangeEquiv_naturality
    C L n m relation e M mapM hmapM (Sum.inr (U, V))
  change
    (pic0FiniteStageModelBaseChangeEquiv
        C L n m relation e M (Sum.inr (U, V))).toAlgHom.comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M.1) (K := k) (mapM (Sum.inr (U, V)))) =
      (pic0FiniteStageTransition C (U, V)).comp
        (pic0FiniteStageModelBaseChangeEquiv
          C L n m relation e M (Sum.inr (V, U))).toAlgHom at hnat
  apply DFunLike.ext _ _
  intro x
  apply (Q (U, (V, W))).injective
  change
    (Q (U, (V, W)))
        ((Q (U, (V, W))).symm
          (pic0FiniteStageTripleTransition C U V W
            ((Q (V, (W, U)))
              ((AlgebraicJacobian.scalarExtensionMapOfAlgHom
                (R := M.1) (K := k)
                (finiteStageTensorPushoutFaceRight
                  (pic0FiniteStageRestrictionLeftModel
                    C L n m relation M mapM V W)
                  (pic0FiniteStageRestrictionLeftModel
                    C L n m relation M mapM V U))) x)))) =
      (Q (U, (V, W)))
        ((AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M.1) (K := k)
          (finiteStageTensorPushoutFaceLeft
            (pic0FiniteStageRestrictionLeftModel
              C L n m relation M mapM U V)
            (pic0FiniteStageRestrictionLeftModel
              C L n m relation M mapM U W)))
          ((AlgebraicJacobian.scalarExtensionMapOfAlgHom
            (R := M.1) (K := k) (mapM (Sum.inr (U, V)))) x))
  rw [(Q (U, (V, W))).apply_symm_apply]
  calc
    pic0FiniteStageTripleTransition C U V W
        ((Q (V, (W, U)))
          ((AlgebraicJacobian.scalarExtensionMapOfAlgHom
            (R := M.1) (K := k)
            (finiteStageTensorPushoutFaceRight
              (pic0FiniteStageRestrictionLeftModel
                C L n m relation M mapM V W)
              (pic0FiniteStageRestrictionLeftModel
                C L n m relation M mapM V U))) x)) =
      pic0FiniteStageTripleTransition C U V W
        (pic0FiniteStageOverlapToTripleRight C V W U
          ((pic0FiniteStageModelBaseChangeEquiv
            C L n m relation e M (Sum.inr (V, U))) x)) := by
              exact congrArg (pic0FiniteStageTripleTransition C U V W)
                (DFunLike.congr_fun hright x)
    _ = pic0FiniteStageOverlapToTripleLeft C U V W
        (pic0FiniteStageTransition C (U, V)
          ((pic0FiniteStageModelBaseChangeEquiv
            C L n m relation e M (Sum.inr (V, U))) x)) := by
              exact DFunLike.congr_fun
                (pic0FiniteStageTripleTransition_fac C U V W)
                ((pic0FiniteStageModelBaseChangeEquiv
                  C L n m relation e M (Sum.inr (V, U))) x)
    _ = pic0FiniteStageOverlapToTripleLeft C U V W
        ((pic0FiniteStageModelBaseChangeEquiv
          C L n m relation e M (Sum.inr (U, V)))
          ((AlgebraicJacobian.scalarExtensionMapOfAlgHom
            (R := M.1) (K := k) (mapM (Sum.inr (U, V)))) x)) := by
              exact congrArg (pic0FiniteStageOverlapToTripleLeft C U V W)
                (DFunLike.congr_fun hnat x).symm
    _ = (Q (U, (V, W)))
        ((AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M.1) (K := k)
          (finiteStageTensorPushoutFaceLeft
            (pic0FiniteStageRestrictionLeftModel
              C L n m relation M mapM U V)
            (pic0FiniteStageRestrictionLeftModel
              C L n m relation M mapM U W)))
          ((AlgebraicJacobian.scalarExtensionMapOfAlgHom
            (R := M.1) (K := k) (mapM (Sum.inr (U, V)))) x)) := by
              exact (DFunLike.congr_fun hleft
                ((AlgebraicJacobian.scalarExtensionMapOfAlgHom
                  (R := M.1) (K := k) (mapM (Sum.inr (U, V)))) x)).symm

set_option synthInstance.maxHeartbeats 400000 in
-- Reflection elaborates the face, transition, and triple-transition tower squares together.
set_option maxHeartbeats 6400000 in
/-- A compatible finite-stage triple transition satisfies the same face equation. -/
theorem pic0FiniteStageTripleTransitionModel_fac
    [Algebra.IsAlgebraic M.1 k]
    (N : DatG0.FinSubext M.1 k)
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
        ((pic0FiniteStageTransportedTripleTransition
          C L n m relation M mapM Q p).restrictScalars M.1).comp
          (Algebra.TensorProduct.map N.1.val
            (AlgHom.id M.1
              (Pic0FiniteStageTripleTransitionModelSource
                C L n m relation M mapM p))))
    (U V W : Pic0FiniteStageChartIndex C) :
    let fVW := pic0FiniteStageRestrictionLeftModel
      C L n m relation M mapM V W
    let fVU := pic0FiniteStageRestrictionLeftModel
      C L n m relation M mapM V U
    let fUV := pic0FiniteStageRestrictionLeftModel
      C L n m relation M mapM U V
    let fUW := pic0FiniteStageRestrictionLeftModel
      C L n m relation M mapM U W
    (thetaN (U, (V, W))).comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M.1) (K := N.1) (finiteStageTensorPushoutFaceRight fVW fVU)) =
      (AlgebraicJacobian.scalarExtensionMapOfAlgHom
        (R := M.1) (K := N.1)
        (finiteStageTensorPushoutFaceLeft fUV fUW)).comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M.1) (K := N.1) (mapM (Sum.inr (U, V)))) := by
  dsimp only
  have hval : N.1.val = IsScalarTower.toAlgHom M.1 N.1 k := by
    ext x
    rfl
  have hreflect := DatG0.tensorProduct_algHom_comp_eq_of_baseChange N
    (AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := M.1) (K := N.1)
      (finiteStageTensorPushoutFaceRight
        (pic0FiniteStageRestrictionLeftModel
          C L n m relation M mapM V W)
        (pic0FiniteStageRestrictionLeftModel
          C L n m relation M mapM V U)))
    (thetaN (U, (V, W)))
    (AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := M.1) (K := N.1)
      ((finiteStageTensorPushoutFaceLeft
        (pic0FiniteStageRestrictionLeftModel
          C L n m relation M mapM U V)
        (pic0FiniteStageRestrictionLeftModel
          C L n m relation M mapM U W)).comp
        (mapM (Sum.inr (U, V)))))
    (AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := M.1) (K := k)
      (finiteStageTensorPushoutFaceRight
        (pic0FiniteStageRestrictionLeftModel
          C L n m relation M mapM V W)
        (pic0FiniteStageRestrictionLeftModel
          C L n m relation M mapM V U)))
    (pic0FiniteStageTransportedTripleTransition
      C L n m relation M mapM Q (U, (V, W)))
    (AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := M.1) (K := k)
      ((finiteStageTensorPushoutFaceLeft
        (pic0FiniteStageRestrictionLeftModel
          C L n m relation M mapM U V)
        (pic0FiniteStageRestrictionLeftModel
          C L n m relation M mapM U W)).comp
        (mapM (Sum.inr (U, V)))))
    (by
      rw [hval]
      exact AlgebraicJacobian.scalarExtensionMapOfAlgHom_tower
        (finiteStageTensorPushoutFaceRight
          (pic0FiniteStageRestrictionLeftModel
            C L n m relation M mapM V W)
          (pic0FiniteStageRestrictionLeftModel
            C L n m relation M mapM V U)))
    (hthetaN (U, (V, W)))
    (by
      rw [hval]
      exact AlgebraicJacobian.scalarExtensionMapOfAlgHom_tower
        ((finiteStageTensorPushoutFaceLeft
          (pic0FiniteStageRestrictionLeftModel
            C L n m relation M mapM U V)
          (pic0FiniteStageRestrictionLeftModel
            C L n m relation M mapM U W)).comp
          (mapM (Sum.inr (U, V)))))
    (by
      simpa only [AlgebraicJacobian.scalarExtensionMapOfAlgHom_comp] using
        (pic0FiniteStageTransportedTripleTransition_fac
          C L n m relation e M mapM hmapM Q hQLeft hQRight U V W))
  simpa only [AlgebraicJacobian.scalarExtensionMapOfAlgHom_comp] using hreflect

end

end

end AlgebraicGeometry
