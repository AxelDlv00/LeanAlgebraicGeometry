/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageTensorPushoutUniversal
import AlgebraicJacobian.Picard.Pic0FiniteStageTripleModelComparison
import AlgebraicJacobian.Picard.Pic0FiniteStageTripleModelScalarExtensionFaces

/-!
# Named comparison for finite-stage Picard triple-overlap models

The component comparisons identify scalar extensions of the descended chart and
pair-overlap rings with their exact section rings.  Their naturality transports the
exact triple-intersection pushout to the scalar-extended model rings.  The named tensor
pushout interface then supplies the comparison equivalence without exposing dependent
tensor-product instances at declaration boundaries.

The final two equations identify the forward faces of this comparison.  They combine
the map-level face formulas for scalar extension with the universal-property face
formulas for the transported exact pushout.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits TopologicalSpace TensorProduct
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] [IsSepClosed k]

section Comparison

-- These shared binders contain dependent quotient algebras and their scalar towers.
set_option linter.style.setOption false
set_option synthInstance.maxHeartbeats 400000
set_option maxHeartbeats 3200000

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

include hmapM

set_option synthInstance.maxHeartbeats 400000 in
-- Each corner contains a scalar extension of a dependent finite-presentation model.
set_option maxHeartbeats 3200000 in
/-- The exact triple-overlap pushout transported through the three component
comparisons. -/
theorem pic0FiniteStageTripleComparisonSquare
    (U V W : Pic0FiniteStageChartIndex C) :
    let kfUV := AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := M.1) (K := k)
      (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U V)
    let kfUW := AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := M.1) (K := k)
      (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U W)
    let eUV := pic0FiniteStageModelBaseChangeEquiv
      C L n m relation e M (Sum.inr (U, V))
    let eUW := pic0FiniteStageModelBaseChangeEquiv
      C L n m relation e M (Sum.inr (U, W))
    IsPushout
      (CommRingCat.ofHom kfUV.toRingHom)
      (CommRingCat.ofHom kfUW.toRingHom)
      (CommRingCat.ofHom
        ((pic0FiniteStageOverlapToTripleLeft C U V W).comp
          eUV.toAlgHom).toRingHom)
      (CommRingCat.ofHom
        ((pic0FiniteStageOverlapToTripleRight C U V W).comp
          eUW.toAlgHom).toRingHom) := by
  dsimp only
  let kfUV := AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := k)
    (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U V)
  let kfUW := AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := k)
    (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U W)
  let eU := pic0FiniteStageModelBaseChangeEquiv
    C L n m relation e M (Sum.inl U)
  let eUV := pic0FiniteStageModelBaseChangeEquiv
    C L n m relation e M (Sum.inr (U, V))
  let eUW := pic0FiniteStageModelBaseChangeEquiv
    C L n m relation e M (Sum.inr (U, W))
  apply (isPushout_pic0FiniteStageTripleRing C U V W).of_iso'
    eU.toRingEquiv.toCommRingCatIso
    eUV.toRingEquiv.toCommRingCatIso
    eUW.toRingEquiv.toCommRingCatIso
    (Iso.refl (CommRingCat.of (Pic0FiniteStageTripleRing C U V W)))
  · have hUV := pic0FiniteStageModelBaseChangeEquiv_restrictionLeft
      C L n m relation e M mapM hmapM U V
    change CommRingCat.ofHom
        (((pic0FiniteStageRestrictionLeft C U V).comp eU.toAlgHom).toRingHom) =
      CommRingCat.ofHom ((eUV.toAlgHom.comp kfUV).toRingHom)
    exact congrArg (fun q => CommRingCat.ofHom q.toRingHom) hUV.symm
  · have hUW := pic0FiniteStageModelBaseChangeEquiv_restrictionLeft
      C L n m relation e M mapM hmapM U W
    change CommRingCat.ofHom
        (((pic0FiniteStageRestrictionLeft C U W).comp eU.toAlgHom).toRingHom) =
      CommRingCat.ofHom ((eUW.toAlgHom.comp kfUW).toRingHom)
    exact congrArg (fun q => CommRingCat.ofHom q.toRingHom) hUW.symm
  · rfl
  · rfl

set_option synthInstance.maxHeartbeats 400000 in
-- The named pushout prevents reconstruction of its dependent tensor instances.
set_option maxHeartbeats 3200000 in
/-- The comparison from the scalar-extended descended pushout to the exact
triple-intersection ring. -/
noncomputable def pic0FiniteStageTripleMiddleComparison
    (U V W : Pic0FiniteStageChartIndex C) :
    let kfUV := AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := M.1) (K := k)
      (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U V)
    let kfUW := AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := M.1) (K := k)
      (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U W)
    Pic0FiniteStageTensorPushoutRing kfUV kfUW ≃ₐ[k]
      Pic0FiniteStageTripleRing C U V W := by
  dsimp only
  let kfUV := AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := k)
    (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U V)
  let kfUW := AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := k)
    (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U W)
  let eUV := pic0FiniteStageModelBaseChangeEquiv
    C L n m relation e M (Sum.inr (U, V))
  let eUW := pic0FiniteStageModelBaseChangeEquiv
    C L n m relation e M (Sum.inr (U, W))
  let gUV := (pic0FiniteStageOverlapToTripleLeft C U V W).comp eUV.toAlgHom
  let gUW := (pic0FiniteStageOverlapToTripleRight C U V W).comp eUW.toAlgHom
  exact finiteStageTensorPushoutAlgEquivOfIsPushout
    kfUV kfUW gUV gUW
    (pic0FiniteStageTripleComparisonSquare
      C L n m relation e M mapM hmapM U V W)

set_option synthInstance.maxHeartbeats 400000 in
-- The source is a scalar extension of a dependent named tensor pushout.
set_option maxHeartbeats 3200000 in
/-- Scalar extension of a descended triple model is canonically the exact
triple-intersection ring. -/
noncomputable def pic0FiniteStageTripleModelComparison
    (U V W : Pic0FiniteStageChartIndex C) :
    k ⊗[M.1] Pic0FiniteStageTripleModelRing
        C L n m relation M mapM U V W ≃ₐ[k]
      Pic0FiniteStageTripleRing C U V W :=
  (finiteStageTensorPushoutScalarExtension_named (K := k)
    (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U V)
    (pic0FiniteStageRestrictionLeftModel C L n m relation M mapM U W)).trans
      (pic0FiniteStageTripleMiddleComparison
        C L n m relation e M mapM hmapM U V W)

set_option synthInstance.maxHeartbeats 400000 in
-- Both sides retain the same named scalar-extension and pushout instances.
set_option maxHeartbeats 3200000 in
/-- The triple-model comparison carries the scalar extension of its left face to
exact restriction from the first pair-overlap. -/
theorem pic0FiniteStageTripleModelComparison_faceLeft
    (U V W : Pic0FiniteStageChartIndex C) :
    let fUV := pic0FiniteStageRestrictionLeftModel
      C L n m relation M mapM U V
    let fUW := pic0FiniteStageRestrictionLeftModel
      C L n m relation M mapM U W
    (pic0FiniteStageTripleModelComparison
        C L n m relation e M mapM hmapM U V W).toAlgHom.comp
      (AlgebraicJacobian.scalarExtensionMapOfAlgHom
        (R := M.1) (K := k)
        (finiteStageTensorPushoutFaceLeft fUV fUW)) =
      (pic0FiniteStageOverlapToTripleLeft C U V W).comp
        (pic0FiniteStageModelBaseChangeEquiv
          C L n m relation e M (Sum.inr (U, V))).toAlgHom := by
  dsimp only
  let fUV := pic0FiniteStageRestrictionLeftModel
    C L n m relation M mapM U V
  let fUW := pic0FiniteStageRestrictionLeftModel
    C L n m relation M mapM U W
  let kfUV := AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := k) fUV
  let kfUW := AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := k) fUW
  let eUV := pic0FiniteStageModelBaseChangeEquiv
    C L n m relation e M (Sum.inr (U, V))
  let eUW := pic0FiniteStageModelBaseChangeEquiv
    C L n m relation e M (Sum.inr (U, W))
  let gUV := (pic0FiniteStageOverlapToTripleLeft C U V W).comp eUV.toAlgHom
  let gUW := (pic0FiniteStageOverlapToTripleRight C U V W).comp eUW.toAlgHom
  let square := pic0FiniteStageTripleComparisonSquare
    C L n m relation e M mapM hmapM U V W
  let middle := finiteStageTensorPushoutAlgEquivOfIsPushout
    kfUV kfUW gUV gUW square
  let beta := finiteStageTensorPushoutScalarExtension_named
    (K := k) fUV fUW
  let scalarFace := AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := k) (finiteStageTensorPushoutFaceLeft fUV fUW)
  apply DFunLike.ext _ _
  intro x
  change middle (beta (scalarFace x)) = gUV x
  have hbeta := DFunLike.congr_fun
    (finiteStageTensorPushoutScalarExtension_faceLeft_map
      (K := k) fUV fUW) x
  rw [hbeta]
  exact finiteStageTensorPushoutAlgEquivOfIsPushout_faceLeft
    kfUV kfUW gUV gUW square x

set_option synthInstance.maxHeartbeats 400000 in
-- Both sides retain the same named scalar-extension and pushout instances.
set_option maxHeartbeats 3200000 in
/-- The triple-model comparison carries the scalar extension of its right face to
exact restriction from the second pair-overlap. -/
theorem pic0FiniteStageTripleModelComparison_faceRight
    (U V W : Pic0FiniteStageChartIndex C) :
    let fUV := pic0FiniteStageRestrictionLeftModel
      C L n m relation M mapM U V
    let fUW := pic0FiniteStageRestrictionLeftModel
      C L n m relation M mapM U W
    (pic0FiniteStageTripleModelComparison
        C L n m relation e M mapM hmapM U V W).toAlgHom.comp
      (AlgebraicJacobian.scalarExtensionMapOfAlgHom
        (R := M.1) (K := k)
        (finiteStageTensorPushoutFaceRight fUV fUW)) =
      (pic0FiniteStageOverlapToTripleRight C U V W).comp
        (pic0FiniteStageModelBaseChangeEquiv
          C L n m relation e M (Sum.inr (U, W))).toAlgHom := by
  dsimp only
  let fUV := pic0FiniteStageRestrictionLeftModel
    C L n m relation M mapM U V
  let fUW := pic0FiniteStageRestrictionLeftModel
    C L n m relation M mapM U W
  let kfUV := AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := k) fUV
  let kfUW := AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := k) fUW
  let eUV := pic0FiniteStageModelBaseChangeEquiv
    C L n m relation e M (Sum.inr (U, V))
  let eUW := pic0FiniteStageModelBaseChangeEquiv
    C L n m relation e M (Sum.inr (U, W))
  let gUV := (pic0FiniteStageOverlapToTripleLeft C U V W).comp eUV.toAlgHom
  let gUW := (pic0FiniteStageOverlapToTripleRight C U V W).comp eUW.toAlgHom
  let square := pic0FiniteStageTripleComparisonSquare
    C L n m relation e M mapM hmapM U V W
  let middle := finiteStageTensorPushoutAlgEquivOfIsPushout
    kfUV kfUW gUV gUW square
  let beta := finiteStageTensorPushoutScalarExtension_named
    (K := k) fUV fUW
  let scalarFace := AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := k) (finiteStageTensorPushoutFaceRight fUV fUW)
  apply DFunLike.ext _ _
  intro x
  change middle (beta (scalarFace x)) = gUW x
  have hbeta := DFunLike.congr_fun
    (finiteStageTensorPushoutScalarExtension_faceRight_map
      (K := k) fUV fUW) x
  rw [hbeta]
  exact finiteStageTensorPushoutAlgEquivOfIsPushout_faceRight
    kfUV kfUW gUV gUW square x

end Comparison

end

end AlgebraicGeometry
