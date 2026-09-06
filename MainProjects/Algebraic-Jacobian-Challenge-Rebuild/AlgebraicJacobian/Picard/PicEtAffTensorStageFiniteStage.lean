/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Curve.BaseChangeInstances
import AlgebraicJacobian.Picard.PicEtAffBaseFieldShuffle
import AlgebraicJacobian.Picard.PicEtAffTensorStage
import AlgebraicJacobian.Picard.PicEtTensorStageFlatten
import AlgebraicJacobian.Picard.PicEtAffNestedTensorStage

/-!
# Finite tensor stages for etale-plus Picard classes

This module packages the final finite-stage output for an etale-plus Picard class over
`K tensor[F] B`.  Unlike the cover-only finite-stage theorem, the class itself is defined
over the selected finite tensor stage and maps back to the original ambient class.
-/

set_option autoImplicit false

universe u

open CategoryTheory
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

set_option maxSynthPendingDepth 16 in
/-- An etale-plus Picard class together with one finite tensor stage over which the class
is already defined. -/
structure PicEtAffTensorStageData
    {F K B : Type u} [Field F] [Field K] [Algebra F K]
    [CommRing B] [Algebra F B]
    (C : Over (Spec (.of F))) (x : PicEtAff C (K ⊗[F] B)) where
  /-- The finite intermediate field carrying the descended class. -/
  stage : DatG0.FiniteStageData F K
  /-- The etale-plus Picard class over the finite tensor stage. -/
  xStage : PicEtAff C (stage.stage ⊗[F] B)
  /-- Compatibility with the canonical map from the finite stage to the ambient tensor
  product. -/
  map_eq : PicEtAff.mapAlg (k := F) C (stage.tensorMap (A := B)) xStage = x

set_option synthInstance.maxHeartbeats 100000 in
-- Tensor field transports use both the intermediate and original scalar actions.
set_option maxHeartbeats 800000 in
set_option maxSynthPendingDepth 16 in
/-- Every etale-plus Picard class over a tensor product is represented at one finite
intermediate tensor stage.  The descended class is built on the nested stage over the
intermediate field, transported back to the original curve, and then flattened to a stage
over the original field. -/
theorem exists_picEtAff_tensorStage_data
    {F K B : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] [CommRing B] [Algebra F B]
    (C : Over (Spec (.of F)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom]
    (x : PicEtAff C (K ⊗[F] B)) :
    Nonempty (PicEtAffTensorStageData C x) := by
  obtain ⟨M, hM⟩ :=
    exists_finSubext_baseChanged_tensorStage_cover_representation (C := C) x
  dsimp only at hM
  let iota : M.1 ⊗[F] B →ₐ[F] K ⊗[F] B :=
    Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
  letI : Algebra (M.1 ⊗[F] B) (K ⊗[F] B) := iota.toRingHom.toAlgebra
  obtain ⟨E, ξK, hx⟩ := hM
  let CM : Over (Spec (.of M.1)) := (baseChange F M.1).obj C
  let ξM : descentClasses CM (E.baseChange (K ⊗[F] B)) :=
    (crossBaseTransportFamily F M.1 C).descentHom (E.baseChange (K ⊗[F] B)) ξK
  obtain ⟨S, z, hz⟩ := exists_picEtAff_nested_tensorStage (B := B) M CM E ξM
  let TS := S.stage ⊗[M.1] (M.1 ⊗[F] B)
  letI : Algebra F TS := Algebra.TensorProduct.leftAlgebra
  letI : IsScalarTower F M.1 TS := TensorProduct.isScalarTower_left
  let y : PicEtAff C TS := (PicEtAff.baseFieldShuffle F M.1 C TS).symm z
  let Q := DatG0.FiniteStageTensorFlatteningData.ofFiniteStage (B := B) M S
  refine ⟨{
    stage := Q.outer
    xStage := PicEtAff.mapAlg (k := F) C Q.tensorEquiv.toAlgHom y
    map_eq := ?_
  }⟩
  rw [← PicEtAff.mapAlg_comp, Q.compatibility]
  let φ : TS →ₐ[M.1] K ⊗[F] B :=
    DatG0.tensorStageNestedAmbientMapOverIntermediate M S
  calc
    PicEtAff.mapAlg (k := F) C (DatG0.tensorStageNestedAmbientMap M S) y =
        (PicEtAff.baseFieldShuffle F M.1 C (K ⊗[F] B)).symm
          (PicEtAff.mapAlg (k := M.1) CM φ z) := by
      change PicEtAff.mapAlg (k := F) C (φ.restrictScalars F) y = _
      exact (PicEtAff.mapAlg_baseFieldShuffle_symm F M.1 C φ z).symm
    _ = (PicEtAff.baseFieldShuffle F M.1 C (K ⊗[F] B)).symm
        (PicEtAff.mk (k := M.1) CM (E.baseChange (K ⊗[F] B)) ξM) := by
      rw [hz]
    _ = PicEtAff.mk (k := F) C (E.baseChange (K ⊗[F] B)) ξK := by
      rw [← PicEtAff.baseFieldShuffle_mk]
      exact (PicEtAff.baseFieldShuffle F M.1 C (K ⊗[F] B)).symm_apply_apply _
    _ = x := hx

end

end AlgebraicGeometry
