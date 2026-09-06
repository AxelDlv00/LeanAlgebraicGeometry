/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.PicEtAffTensorStageMapBack
import AlgebraicJacobian.Picard.PicEtTensorStageCanonicalHelpers
import AlgebraicJacobian.Picard.PicEtAffZariskiGlue

/-!
# Compatibility of the descended tensor-stage class with its ambient class

The canonical carrier comparisons identify the class constructed from the finite-stage
face equality with the original class after extending the intermediate field.
-/

set_option autoImplicit false

universe u

open CategoryTheory
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

set_option synthInstance.maxHeartbeats 100000 in
-- The etale-cover comparison uses dependent tensor-product scalar structures.
set_option maxHeartbeats 800000 in
set_option maxSynthPendingDepth 16 in
private theorem etaleCover_tensorCarrierEquiv_naturality
    {M S R : Type u} [CommRing M] [CommRing S] [CommRing R]
    [Algebra M S] [Algebra M R] (E : Algebra.EtaleCover R) :
    let TS := S ⊗[M] R
    letI : Algebra R TS := Algebra.TensorProduct.rightAlgebra
    letI := TensorProduct.isPushout (R := M) (S := S) (T := R)
    let cS := DatG0.etaleCoverPushoutCarrierEquiv (M := M) (S := S) (T := TS) E
    let f := (Algebra.ofId R E.Carrier).restrictScalars M
    (cS.toAlgHom.restrictScalars M).comp
      ((Algebra.ofId TS (E.baseChange TS).Carrier).restrictScalars M) =
      (AlgebraicJacobian.scalarExtensionMapOfAlgHom (R := M) (K := S) f).restrictScalars
        M := by
  dsimp only
  let TS := S ⊗[M] R
  letI : Algebra R TS := Algebra.TensorProduct.rightAlgebra
  letI := TensorProduct.isPushout (R := M) (S := S) (T := R)
  let cS := DatG0.etaleCoverPushoutCarrierEquiv (M := M) (S := S) (T := TS) E
  let f := (Algebra.ofId R E.Carrier).restrictScalars M
  let fS := AlgebraicJacobian.scalarExtensionMapOfAlgHom (R := M) (K := S) f
  let gS := (Algebra.ofId TS (E.baseChange TS).Carrier).restrictScalars S
  have hInv : cS.symm.toAlgHom.comp fS = gS := by
    have h := Algebra.IsPushout.cancelBaseChange_symm_comp_lTensor M R E.Carrier S
    change (((E.baseChangeEquiv TS).symm.toAlgHom.restrictScalars S).comp
      (Algebra.IsPushout.cancelBaseChangeAlg M S R TS E.Carrier).symm.toAlgHom).comp
        (Algebra.TensorProduct.lTensor S (IsScalarTower.toAlgHom M R E.Carrier)) = _
    rw [AlgHom.comp_assoc, h]
    apply AlgHom.ext
    intro z
    apply (E.baseChangeEquiv TS).injective
    simp only [AlgHom.comp_apply, AlgHom.coe_restrictScalars', AlgEquiv.coe_algHom,
      AlgEquiv.apply_symm_apply]
    exact ((E.baseChangeEquiv TS).commutes z).symm
  apply AlgHom.ext
  intro z
  have hz := DFunLike.congr_fun hInv z
  change cS.symm (fS z) = gS z at hz
  change cS (gS z) = fS z
  rw [← hz, cS.apply_symm_apply]

set_option synthInstance.maxHeartbeats 100000 in
-- The canonical etale-cover carriers carry dependent tensor-product scalar structures.
set_option maxHeartbeats 3200000 in
set_option maxSynthPendingDepth 16 in
/-- Extending the descended tensor-stage class recovers the original ambient class. -/
theorem tensorStageData_map_descentClass
    {F K B : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] [CommRing B] [Algebra F B]
    (M : DatG0.FinSubext F K) (C : Over (Spec (.of M.1))) :
    let R := M.1 ⊗[F] B
    let TK := K ⊗[F] B
    let iota : R →ₐ[F] TK :=
      Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
    letI : Algebra R TK := iota.toRingHom.toAlgebra
    ∀ (E : Algebra.EtaleCover R) (S : DatG0.FiniteStageData M.1 K)
      (ξ : descentClasses C (E.baseChange TK))
      (q : relPic C (overSpec M.1 (S.stage ⊗[M.1] E.Carrier))),
    relPicAlgMap C (tensorStageDataCarrierMap M E S) q = ξ →
    let f := (Algebra.ofId R E.Carrier).restrictScalars M.1
    ∀ hfaces : relPicAlgMap C
        ((AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M.1) (K := S.stage) (finiteStageTensorPushoutFaceLeft f f)).restrictScalars
            M.1) q =
      relPicAlgMap C
        ((AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M.1) (K := S.stage) (finiteStageTensorPushoutFaceRight f f)).restrictScalars
            M.1) q,
    let TS := S.stage ⊗[M.1] R
    letI : Algebra R TS := Algebra.TensorProduct.rightAlgebra
    letI := TensorProduct.isPushout (R := M.1) (S := S.stage) (T := R)
    PicEtAff.mapAlg C (DatG0.tensorStageNestedAmbientMapOverIntermediate M S)
        (PicEtAff.mk C (E.baseChange TS)
          (descentClassOfPushoutFaceEq C E q hfaces)) =
      PicEtAff.mk C (E.baseChange TK) ξ := by
  dsimp only
  let R := M.1 ⊗[F] B
  let TK := K ⊗[F] B
  let iota : R →ₐ[F] TK :=
    Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
  letI : Algebra R TK := iota.toRingHom.toAlgebra
  intro E S ξ q hmap hfaces
  let TS := S.stage ⊗[M.1] R
  letI : Algebra R TS := Algebra.TensorProduct.rightAlgebra
  letI := TensorProduct.isPushout (R := M.1) (S := S.stage) (T := R)
  let ξS := descentClassOfPushoutFaceEq (S := S.stage) (T := TS) C E q hfaces
  let φ : TS →ₐ[M.1] TK := DatG0.tensorStageNestedAmbientMapOverIntermediate M S
  let cS : (E.baseChange TS).Carrier ≃ₐ[S.stage] S.stage ⊗[M.1] E.Carrier :=
    DatG0.etaleCoverPushoutCarrierEquiv (M := M.1) (S := S.stage) (T := TS) E
  let cK : (E.baseChange TK).Carrier ≃ₐ[K] K ⊗[M.1] E.Carrier :=
    DatG0.etaleCoverTensorStageCarrierEquiv M E
  let nS : S.stage ⊗[M.1] E.Carrier →ₐ[M.1] K ⊗[M.1] E.Carrier :=
    S.tensorMap (A := E.Carrier)
  let cSM := cS.toAlgHom.restrictScalars M.1
  let cSInvM := cS.symm.toAlgHom.restrictScalars M.1
  let cKInvM := cK.symm.toAlgHom.restrictScalars M.1
  let n : (E.baseChange TS).Carrier →ₐ[M.1] (E.baseChange TK).Carrier :=
    cKInvM.comp (nS.comp cSM)
  apply PicEtAff.mapAlg_mk_eq_mk C φ (E.baseChange TS) (E.baseChange TK) ξS ξ n
  · intro a
    let gS : TS →ₐ[M.1] (E.baseChange TS).Carrier :=
      (Algebra.ofId TS (E.baseChange TS).Carrier).restrictScalars M.1
    let gK : TK →ₐ[M.1] (E.baseChange TK).Carrier :=
      (Algebra.ofId TK (E.baseChange TK).Carrier).restrictScalars M.1
    let f := (Algebra.ofId R E.Carrier).restrictScalars M.1
    let fS : S.stage ⊗[M.1] R →ₐ[M.1] S.stage ⊗[M.1] E.Carrier :=
      (AlgebraicJacobian.scalarExtensionMapOfAlgHom
        (R := M.1) (K := S.stage) f).restrictScalars M.1
    let fK : K ⊗[M.1] R →ₐ[M.1] K ⊗[M.1] E.Carrier :=
      (AlgebraicJacobian.scalarExtensionMapOfAlgHom
        (R := M.1) (K := K) f).restrictScalars M.1
    let nR : S.stage ⊗[M.1] R →ₐ[M.1] K ⊗[M.1] R := S.tensorMap (A := R)
    let eK : K ⊗[M.1] R ≃ₐ[K] TK :=
      DatG0.etaleCoverTensorStageBaseEquiv (F := F) (K := K) (B := B) M
    let eKM := eK.toAlgHom.restrictScalars M.1
    have hS : cSM.comp gS = fS :=
      etaleCover_tensorCarrierEquiv_naturality (M := M.1) (S := S.stage) E
    have hTower : nS.comp fS = fK.comp nR := by
      apply Algebra.TensorProduct.ext
      · exact AlgHom.ext fun _ => rfl
      · exact AlgHom.ext fun _ => rfl
    have hK0 := DatG0.etaleCoverTensorStageCarrierEquiv_symm_naturality M E
    have hK : cKInvM.comp fK = gK.comp eKM := by
      exact congrArg (fun h => h.restrictScalars M.1) hK0
    have hnaturality : n.comp gS = gK.comp φ := by
      change (cKInvM.comp (nS.comp cSM)).comp gS = gK.comp (eKM.comp nR)
      rw [AlgHom.comp_assoc, AlgHom.comp_assoc, hS, hTower,
        ← AlgHom.comp_assoc, hK, AlgHom.comp_assoc]
    exact DFunLike.congr_fun hnaturality a
  · have hξS : (ξS : relPic C (overSpec M.1 (E.baseChange TS).Carrier)) =
        relPicAlgMap C cSInvM q := by
      rfl
    rw [hξS, ← relPicAlgMap_comp]
    have hcS : cSM.comp cSInvM = AlgHom.id M.1 (S.stage ⊗[M.1] E.Carrier) := by
      exact (cS.restrictScalars M.1).comp_symm
    have hn : n.comp cSInvM = tensorStageDataCarrierMap M E S := by
      change (cKInvM.comp (nS.comp cSM)).comp cSInvM = cKInvM.comp nS
      rw [AlgHom.comp_assoc, AlgHom.comp_assoc, hcS, AlgHom.comp_id]
    rw [hn]
    exact hmap

end

end AlgebraicGeometry
