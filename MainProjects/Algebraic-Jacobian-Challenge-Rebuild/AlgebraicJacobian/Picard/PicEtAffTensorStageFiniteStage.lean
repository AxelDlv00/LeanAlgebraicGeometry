/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Curve.MapToP1
import AlgebraicJacobian.Curve.BaseChangeInstances
import AlgebraicJacobian.Picard.PicEtAffBaseFieldShuffle
import AlgebraicJacobian.Picard.PicEtAffTensorStage
import AlgebraicJacobian.Picard.PicEtAffTensorStageMapBack
import AlgebraicJacobian.Picard.PicEtTensorStageFlatten

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
  map_eq : PicEtAff.mapAlg C (stage.tensorMap (A := B)) xStage = x

set_option synthInstance.maxHeartbeats 100000 in
set_option maxHeartbeats 8000000 in
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
  letI : Algebra (M.1 ⊗[F] B) (K ⊗[F] B) :=
    iota.toRingHom.toAlgebra
  obtain ⟨E₀, ξK, hx⟩ := hM
  letI : Algebra M.1 K := IntermediateField.toAlgebra M.1
  letI : Algebra M.1 (M.1 ⊗[F] B) := Algebra.TensorProduct.leftAlgebra
  letI : Algebra M.1 (K ⊗[F] B) := Algebra.TensorProduct.leftAlgebra
  let CM : Over (Spec (.of M.1)) := (baseChange F M.1).obj C
  obtain ⟨pi, hpi, hpi_comp⟩ := exists_isFinite_toP1 (C := CM)
  letI : IsFinite pi := hpi
  let ξM : descentClasses CM (E₀.baseChange (K ⊗[F] B)) :=
    (crossBaseTransportFamily F M.1 C).descentHom (E₀.baseChange (K ⊗[F] B)) ξK
  let cA : (E₀.baseChange (K ⊗[F] B)).Carrier ≃ₐ[K]
      K ⊗[M.1] E₀.Carrier := DatG0.etaleCoverTensorStageCarrierEquiv M E₀
  let qM : relPic CM (overSpec M.1 (K ⊗[M.1] E₀.Carrier)) :=
    relPicAlgMap CM (cA.toAlgHom.restrictScalars M.1)
      (ξM : relPic CM (overSpec M.1 (E₀.baseChange (K ⊗[F] B)).Carrier))
  obtain ⟨D⟩ := exists_relPic_tensorStage_data
    (F := M.1) (K := K) (B := E₀.Carrier) (C := CM) (pi := pi)
    qM
  let R := M.1 ⊗[F] B
  let TS := D.stage.stage ⊗[M.1] R
  letI : CommRing TS := Algebra.TensorProduct.instCommRing
  letI : Algebra M.1 TS := Algebra.TensorProduct.instAlgebra
  letI : Algebra M.1 D.stage.stage := IntermediateField.algebra' D.stage.stage
  letI : Algebra R TS :=
    Algebra.TensorProduct.rightAlgebra (R := M.1) (A := D.stage.stage) (B := R)
  letI : Algebra F TS := Algebra.compHom TS (algebraMap F M.1)
  letI : IsScalarTower F M.1 TS := by
    constructor
    intro f m z
    simp
  let hpush : Algebra.IsPushout M.1 R D.stage.stage TS := TensorProduct.isPushout'
  letI : Algebra.IsPushout M.1 D.stage.stage R TS :=
    (Algebra.IsPushout.comm M.1 D.stage.stage R TS).mpr hpush
  let fM : R →ₐ[M.1] E₀.Carrier :=
    (Algebra.ofId R E₀.Carrier).restrictScalars M.1
  let jA : D.stage.stage ⊗[M.1] E₀.Carrier →ₐ[M.1]
      (E₀.baseChange (K ⊗[F] B)).Carrier :=
    tensorStageDataCarrierMap (B := B) M E₀ D.stage
  let jQ : D.stage.stage ⊗[M.1] Pic0FiniteStageTensorPushoutRing fM fM →ₐ[M.1]
      (E₀.baseChange (K ⊗[F] B)).Carrier ⊗[K ⊗[F] B]
        (E₀.baseChange (K ⊗[F] B)).Carrier :=
    tensorStageDataOverlapMap (B := B) M E₀ D.stage
  have hjQ : Function.Injective (relPicAlgMap CM jQ) :=
    tensorStageData_overlapMap_injective (B := B) M CM E₀ D.stage
  have hmapStage : relPicAlgMap CM jA D.qStage =
      (ξM : relPic CM (overSpec M.1 (E₀.baseChange (K ⊗[F] B)).Carrier)) :=
    tensorStageData_map_eq (B := B) M pi E₀ ξM D
  have hleft :
      let q₁ := finiteStageTensorPushoutFaceLeft fM fM
      let q₁S : D.stage.stage ⊗[M.1] E₀.Carrier →ₐ[M.1]
          D.stage.stage ⊗[M.1] Pic0FiniteStageTensorPushoutRing fM fM :=
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M.1) (K := D.stage.stage) q₁).restrictScalars M.1
      jQ.comp q₁S = (doubleInl (E₀.baseChange (K ⊗[F] B))).comp jA :=
    tensorStageData_faceLeft (B := B) M E₀ D.stage
  have hright :
      let q₂ := finiteStageTensorPushoutFaceRight fM fM
      let q₂S : D.stage.stage ⊗[M.1] E₀.Carrier →ₐ[M.1]
          D.stage.stage ⊗[M.1] Pic0FiniteStageTensorPushoutRing fM fM :=
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M.1) (K := D.stage.stage) q₂).restrictScalars M.1
      jQ.comp q₂S = (doubleInr (E₀.baseChange (K ⊗[F] B))).comp jA :=
    tensorStageData_faceRight (B := B) M E₀ D.stage
  let ξS : descentClasses CM (E₀.baseChange TS) :=
    descentClassOfExplicitComparisons (k := M.1) (S := D.stage.stage)
      (R := R) (TS := TS) (TK := K ⊗[F] B) CM E₀ D.qStage ξM jA jQ hjQ
      hmapStage hleft hright
  let y : PicEtAff C TS :=
    (baseFieldShuffle F M.1 C TS).symm
      (PicEtAff.mk CM (E₀.baseChange TS)
        ξS)
  let Q := DatG0.FiniteStageTensorFlatteningData.ofFiniteStage (B := B) M D.stage
  let xStage : PicEtAff C (Q.outer.stage ⊗[F] B) :=
    PicEtAff.mapAlg C Q.tensorEquiv.toAlgHom y
  refine ⟨{ stage := Q.outer, xStage := xStage, map_eq := ?_ }⟩
  have hmap :
      PicEtAff.mapAlg C (DatG0.tensorStageNestedAmbientMap M D.stage) y =
        PicEtAff.mk C (E₀.baseChange (K ⊗[F] B)) ξK := by
    let φM : TS →ₐ[M.1] K ⊗[F] B :=
      DatG0.tensorStageNestedAmbientMapOverIntermediate M D.stage
    let cS : (E₀.baseChange TS).Carrier ≃ₐ[D.stage.stage]
        D.stage.stage ⊗[M.1] E₀.Carrier :=
      DatG0.etaleCoverPushoutCarrierEquiv
        (M := M.1) (S := D.stage.stage) (T := TS) E₀
    let cK : (E₀.baseChange (K ⊗[F] B)).Carrier ≃ₐ[K]
        K ⊗[M.1] E₀.Carrier :=
      DatG0.etaleCoverTensorStageCarrierEquiv M E₀
    let nS : D.stage.stage ⊗[M.1] E₀.Carrier →ₐ[M.1]
        K ⊗[M.1] E₀.Carrier := D.stage.tensorMap (A := E₀.Carrier)
    let cSM := cS.toAlgHom.restrictScalars M.1
    let cSInvM := cS.symm.toAlgHom.restrictScalars M.1
    let cKInvM := cK.symm.toAlgHom.restrictScalars M.1
    let n : (E₀.baseChange TS).Carrier →ₐ[M.1]
        (E₀.baseChange (K ⊗[F] B)).Carrier :=
      cKInvM.comp (nS.comp cSM)
    have hcore : PicEtAff.mapAlg CM φM
          (PicEtAff.mk CM (E₀.baseChange TS) ξS) =
        PicEtAff.mk CM (E₀.baseChange (K ⊗[F] B)) ξM := by
      apply PicEtAff.mapAlg_mk_eq_mk CM φM (E₀.baseChange TS)
        (E₀.baseChange (K ⊗[F] B)) ξS ξM n
      · intro a
        let gS : TS →ₐ[M.1] (E₀.baseChange TS).Carrier :=
          (Algebra.ofId TS (E₀.baseChange TS).Carrier).restrictScalars M.1
        let gK : (K ⊗[F] B) →ₐ[M.1]
            (E₀.baseChange (K ⊗[F] B)).Carrier :=
          (Algebra.ofId (K ⊗[F] B) (E₀.baseChange (K ⊗[F] B)).Carrier).restrictScalars M.1
        let fS : D.stage.stage ⊗[M.1] R →ₐ[M.1]
            D.stage.stage ⊗[M.1] E₀.Carrier :=
          (AlgebraicJacobian.scalarExtensionMapOfAlgHom
            (R := M.1) (K := D.stage.stage) fM).restrictScalars M.1
        let fK : K ⊗[M.1] R →ₐ[M.1]
            K ⊗[M.1] E₀.Carrier :=
          (AlgebraicJacobian.scalarExtensionMapOfAlgHom
            (R := M.1) (K := K) fM).restrictScalars M.1
        let nR : D.stage.stage ⊗[M.1] R →ₐ[M.1]
            K ⊗[M.1] R := D.stage.tensorMap (A := R)
        let eK : K ⊗[M.1] R ≃ₐ[K] K ⊗[F] B :=
          DatG0.etaleCoverTensorStageBaseEquiv (F := F) (K := K) (B := B) M
        let eKM := eK.toAlgHom.restrictScalars M.1
        let fS' := AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M.1) (K := D.stage.stage) fM
        have hnat := DatG0.etaleCoverPushoutCarrierEquiv_symm_naturality
          (M := M.1) (S := D.stage.stage) (R := R) (T := TS) E₀
        have hself :
            (Algebra.IsPushout.equiv M.1 D.stage.stage R TS).toAlgHom =
              AlgHom.id D.stage.stage TS := by
          apply DFunLike.ext _ _
          intro z
          induction z using TensorProduct.induction_on with
          | zero => simp
          | add x y hx hy => simp only [map_add, hx, hy]
          | tmul s r =>
              change (Algebra.IsPushout.equiv M.1 D.stage.stage R TS)
                  (s ⊗ₜ[M.1] r) = s ⊗ₜ[M.1] r
              rw [Algebra.IsPushout.equiv_tmul]
              change (s ⊗ₜ[M.1] (1 : R)) *
                ((1 : D.stage.stage) ⊗ₜ[M.1] r) = s ⊗ₜ[M.1] r
              rw [Algebra.TensorProduct.tmul_mul_tmul]
              simp
        rw [hself] at hnat
        have hS : cSM.comp gS = fS := by
          apply AlgHom.ext
          intro z
          have hz := DFunLike.congr_fun hnat z
          change cS.symm (fS' z) = gS z at hz
          change cS (gS z) = fS z
          rw [← hz, cS.apply_symm_apply]
        have hTower : nS.comp fS = fK.comp nR := by
          have h := AlgebraicJacobian.scalarExtensionMapOfAlgHom_tower fM
          simpa only [nS, nR, fS, fK, DatG0.FiniteStageData.tensorMap] using h
        have hK0 := DatG0.etaleCoverTensorStageCarrierEquiv_symm_naturality M E₀
        have hK : cKInvM.comp fK = gK.comp eKM := by
          exact congrArg (fun h => h.restrictScalars M.1) hK0
        have hnaturality : n.comp gS = gK.comp φM := by
          change (cKInvM.comp (nS.comp cSM)).comp gS =
            gK.comp (eKM.comp nR)
          rw [AlgHom.comp_assoc, AlgHom.comp_assoc, hS, ← AlgHom.comp_assoc,
            hTower, AlgHom.comp_assoc, hK, AlgHom.comp_assoc]
        exact DFunLike.congr_fun hnaturality a
      · have hξS : (ξS : relPic CM (overSpec M.1 (E₀.baseChange TS).Carrier)) =
            relPicAlgMap CM cSInvM D.qStage := by
          rfl
        rw [hξS, ← relPicAlgMap_comp]
        have hcS : cSM.comp cSInvM =
            AlgHom.id M.1 (D.stage.stage ⊗[M.1] E₀.Carrier) := by
          apply DFunLike.ext _ _
          intro z
          exact cS.apply_symm_apply z
        have hn : n.comp cSInvM = tensorStageDataCarrierMap M E₀ D.stage := by
          change (cKInvM.comp (nS.comp cSM)).comp cSInvM = cKInvM.comp nS
          rw [AlgHom.comp_assoc, AlgHom.comp_assoc, hcS, AlgHom.id_comp]
        rw [hn]
        exact tensorStageData_map_eq (B := B) M pi E₀ ξM D
    have hback :
        (baseFieldShuffle F M.1 C (K ⊗[F] B)).symm
            (PicEtAff.mk CM (E₀.baseChange (K ⊗[F] B)) ξM) =
          PicEtAff.mk C (E₀.baseChange (K ⊗[F] B)) ξK := by
      rw [← baseFieldShuffle_mk]
      exact (baseFieldShuffle F M.1 C (K ⊗[F] B)).symm_apply_apply _
    calc
      PicEtAff.mapAlg C (DatG0.tensorStageNestedAmbientMap M D.stage) y =
          PicEtAff.mapAlg C (φM.restrictScalars F) y := by rfl
      _ = (baseFieldShuffle F M.1 C (K ⊗[F] B)).symm
          (PicEtAff.mapAlg CM φM
            (baseFieldShuffle F M.1 C TS y)) := by
          rw [mapAlg_baseFieldShuffle_symm]
      _ = (baseFieldShuffle F M.1 C (K ⊗[F] B)).symm
          (PicEtAff.mapAlg CM φM
            (PicEtAff.mk CM (E₀.baseChange TS) ξS)) := by
          simp only [y, MulEquiv.apply_symm_apply]
      _ = (baseFieldShuffle F M.1 C (K ⊗[F] B)).symm
          (PicEtAff.mk CM (E₀.baseChange (K ⊗[F] B)) ξM) := by
          rw [hcore]
      _ = PicEtAff.mk C (E₀.baseChange (K ⊗[F] B)) ξK := hback
  change PicEtAff.mapAlg C (Q.outer.tensorMap (A := B))
      (PicEtAff.mapAlg C Q.tensorEquiv.toAlgHom y) = x
  rw [← PicEtAff.mapAlg_comp, Q.compatibility]
  exact hmap.trans hx

end

end AlgebraicGeometry
