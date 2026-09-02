/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.PicEtTensorStageCarrier
import AlgebraicJacobian.Picard.Pic0FiniteStageTensorPushoutComparison

/-!
# Overlaps of tensor-stage etale covers

The carrier comparison for a base-changed etale cover extends to its self-overlap.
This file records the comparison and its compatibility with the two canonical faces.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits
open scoped TensorProduct

namespace AlgebraicGeometry.DatG0

noncomputable section

set_option synthInstance.maxHeartbeats 100000 in
set_option maxSynthPendingDepth 16 in
/-- Cancelling the intermediate finite field in the tensor-stage base ring. -/
noncomputable def etaleCoverTensorStageBaseEquiv
    {F K B : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] [CommRing B] [Algebra F B]
    (M : FinSubext F K) :
    K ⊗[M.1] (M.1 ⊗[F] B) ≃ₐ[K] K ⊗[F] B :=
  Algebra.TensorProduct.cancelBaseChange F M.1 K K B

set_option synthInstance.maxHeartbeats 100000 in
-- The dependent tensor signature needs a deeper and longer instance search.
set_option maxHeartbeats 800000 in
set_option maxSynthPendingDepth 16 in
/-- The tensor-stage carrier comparison commutes with the structure map from the
base ring. -/
theorem etaleCoverTensorStageCarrierEquiv_symm_naturality
    {F K B : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] [CommRing B] [Algebra F B]
    (M : FinSubext F K) (E₀ : Algebra.EtaleCover (M.1 ⊗[F] B)) :
    let stage := M.1 ⊗[F] B
    let ambient := K ⊗[F] B
    let f : stage →ₐ[M.1] E₀.Carrier :=
      (Algebra.ofId stage E₀.Carrier).restrictScalars M.1
    let iota : stage →ₐ[F] ambient :=
      Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
    letI : Algebra stage ambient := iota.toRingHom.toAlgebra
    let eA : (K ⊗[M.1] stage) ≃ₐ[K] ambient :=
      etaleCoverTensorStageBaseEquiv (F := F) (K := K) (B := B) M
    let eE : (K ⊗[M.1] E₀.Carrier) ≃ₐ[K]
        (E₀.baseChange ambient).Carrier :=
      (etaleCoverTensorStageCarrierEquiv M E₀).symm
    let g : ambient →ₐ[K] (E₀.baseChange ambient).Carrier :=
      (Algebra.ofId ambient (E₀.baseChange ambient).Carrier).restrictScalars K
    eE.toAlgHom.comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M.1) (K := K) f) =
      g.comp eA.toAlgHom := by
  dsimp only
  let iota : M.1 ⊗[F] B →ₐ[F] K ⊗[F] B :=
    Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
  letI : Algebra (M.1 ⊗[F] B) (K ⊗[F] B) :=
    iota.toRingHom.toAlgebra
  haveI : IsScalarTower M.1 (M.1 ⊗[F] B) (K ⊗[F] B) :=
    @IsScalarTower.of_algebraMap_eq M.1 (M.1 ⊗[F] B) (K ⊗[F] B)
      inferInstance inferInstance inferInstance inferInstance inferInstance inferInstance
      (fun m => by
        change (m : K) ⊗ₜ[F] (1 : B) = iota (m ⊗ₜ[F] (1 : B))
        simp [iota])
  apply Algebra.TensorProduct.ext_ring
  ext a
  simp only [AlgHom.coe_comp, AlgHom.coe_restrictScalars', AlgEquiv.coe_algHom,
    Function.comp_apply, Algebra.TensorProduct.includeRight_apply,
    AlgebraicJacobian.scalarExtensionMapOfAlgHom_tmul, Algebra.ofId_apply,
    etaleCoverTensorStageCarrierEquiv_symm_tmul,
    etaleCoverTensorStageBaseEquiv, Algebra.TensorProduct.cancelBaseChange_tmul]
  apply (E₀.baseChangeEquiv (K ⊗[F] B)).injective
  rw [(E₀.baseChangeEquiv (K ⊗[F] B)).apply_symm_apply]
  rw [(E₀.baseChangeEquiv (K ⊗[F] B)).commutes]
  rw [show algebraMap (M.1 ⊗[F] B) E₀.Carrier
        ((1 : M.1) ⊗ₜ[F] a) =
      ((1 : M.1) ⊗ₜ[F] a) • (1 : E₀.Carrier) by
    simp [Algebra.smul_def]]
  rw [TensorProduct.tmul_smul
    (R := M.1 ⊗[F] B) (R' := M.1 ⊗[F] B)]
  simp [RingHom.algebraMap_toAlgebra, iota, Algebra.smul_def]

/-- The left face of the self-overlap of the base-changed etale cover. -/
noncomputable def etaleCoverTensorStageOverlapFaceLeft
    {F K B : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] [CommRing B] [Algebra F B]
    (M : FinSubext F K) (E₀ : Algebra.EtaleCover (M.1 ⊗[F] B)) :
    let stage := M.1 ⊗[F] B
    let ambient := K ⊗[F] B
    let iota : stage →ₐ[F] ambient :=
      Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
    letI : Algebra stage ambient := iota.toRingHom.toAlgebra
    let U := (E₀.baseChange ambient).Carrier
    U →ₐ[K] U ⊗[ambient] U := by
  dsimp only
  let iota : M.1 ⊗[F] B →ₐ[F] K ⊗[F] B :=
    Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
  letI : Algebra (M.1 ⊗[F] B) (K ⊗[F] B) :=
    iota.toRingHom.toAlgebra
  exact (Algebra.TensorProduct.includeLeft :
    (E₀.baseChange (K ⊗[F] B)).Carrier →ₐ[K ⊗[F] B]
      (E₀.baseChange (K ⊗[F] B)).Carrier ⊗[K ⊗[F] B]
        (E₀.baseChange (K ⊗[F] B)).Carrier).restrictScalars K

/-- The right face of the self-overlap of the base-changed etale cover. -/
noncomputable def etaleCoverTensorStageOverlapFaceRight
    {F K B : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] [CommRing B] [Algebra F B]
    (M : FinSubext F K) (E₀ : Algebra.EtaleCover (M.1 ⊗[F] B)) :
    let stage := M.1 ⊗[F] B
    let ambient := K ⊗[F] B
    let iota : stage →ₐ[F] ambient :=
      Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
    letI : Algebra stage ambient := iota.toRingHom.toAlgebra
    let U := (E₀.baseChange ambient).Carrier
    U →ₐ[K] U ⊗[ambient] U := by
  dsimp only
  let iota : M.1 ⊗[F] B →ₐ[F] K ⊗[F] B :=
    Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
  letI : Algebra (M.1 ⊗[F] B) (K ⊗[F] B) :=
    iota.toRingHom.toAlgebra
  exact (Algebra.TensorProduct.includeRight :
    (E₀.baseChange (K ⊗[F] B)).Carrier →ₐ[K ⊗[F] B]
      (E₀.baseChange (K ⊗[F] B)).Carrier ⊗[K ⊗[F] B]
        (E₀.baseChange (K ⊗[F] B)).Carrier).restrictScalars K

set_option synthInstance.maxHeartbeats 100000 in
-- The categorical pushout comparison elaborates through several dependent tensor types.
set_option maxHeartbeats 1600000 in
set_option maxSynthPendingDepth 16 in
/-- Scalar extension of the finite-stage self-overlap is canonically the
self-overlap of the base-changed cover. -/
noncomputable def etaleCoverTensorStageOverlapEquiv
    {F K B : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] [CommRing B] [Algebra F B]
    (M : FinSubext F K) (E₀ : Algebra.EtaleCover (M.1 ⊗[F] B)) :
    let stage := M.1 ⊗[F] B
    let ambient := K ⊗[F] B
    let iota : stage →ₐ[F] ambient :=
      Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
    letI : Algebra stage ambient := iota.toRingHom.toAlgebra
    let f : stage →ₐ[M.1] E₀.Carrier :=
      (Algebra.ofId stage E₀.Carrier).restrictScalars M.1
    K ⊗[M.1] Pic0FiniteStageTensorPushoutRing f f ≃ₐ[K]
      (E₀.baseChange ambient).Carrier ⊗[ambient]
        (E₀.baseChange ambient).Carrier := by
  dsimp only
  let stage := M.1 ⊗[F] B
  let ambient := K ⊗[F] B
  let iota : stage →ₐ[F] ambient :=
    Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
  letI : Algebra stage ambient := iota.toRingHom.toAlgebra
  haveI : IsScalarTower M.1 stage ambient :=
    @IsScalarTower.of_algebraMap_eq M.1 stage ambient
      inferInstance inferInstance inferInstance inferInstance inferInstance inferInstance
      (fun m => by
        change (m : K) ⊗ₜ[F] (1 : B) = iota (m ⊗ₜ[F] (1 : B))
        rw [show iota = Algebra.TensorProduct.map M.1.val (AlgHom.id F B) from rfl,
          Algebra.TensorProduct.map_tmul]
        simp)
  let U := (E₀.baseChange ambient).Carrier
  let f : stage →ₐ[M.1] E₀.Carrier :=
    (Algebra.ofId stage E₀.Carrier).restrictScalars M.1
  let eA : (K ⊗[M.1] stage) ≃ₐ[K] ambient :=
    etaleCoverTensorStageBaseEquiv (F := F) (K := K) (B := B) M
  let eE : (K ⊗[M.1] E₀.Carrier) ≃ₐ[K] U :=
    (etaleCoverTensorStageCarrierEquiv M E₀).symm
  let g : ambient →ₐ[K] U :=
    (Algebra.ofId ambient U).restrictScalars K
  let T := U ⊗[ambient] U
  let j₁ : U →ₐ[K] T :=
    (Algebra.TensorProduct.includeLeft : U →ₐ[ambient] T).restrictScalars K
  let j₂ : U →ₐ[K] T :=
    (Algebra.TensorProduct.includeRight : U →ₐ[ambient] T).restrictScalars K
  have hnat : eE.toAlgHom.comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M.1) (K := K) f) =
      g.comp eA.toAlgHom :=
    etaleCoverTensorStageCarrierEquiv_symm_naturality M E₀
  have hPush : IsPushout
      (CommRingCat.ofHom g.toRingHom)
      (CommRingCat.ofHom g.toRingHom)
      (CommRingCat.ofHom j₁.toRingHom)
      (CommRingCat.ofHom j₂.toRingHom) := by
    change IsPushout
      (CommRingCat.ofHom (algebraMap ambient U))
      (CommRingCat.ofHom (algebraMap ambient U))
      (CommRingCat.ofHom
        (Algebra.TensorProduct.includeLeftRingHom
          (R := ambient) (A := U) (B := U)))
      (CommRingCat.ofHom
        (Algebra.TensorProduct.includeRight
          (R := ambient) (A := U) (B := U)).toRingHom)
    exact CommRingCat.isPushout_tensorProduct ambient U U
  exact finiteStageTensorPushoutComparison
    f f eA eE eE g g j₁ j₂ hnat hnat hPush

set_option synthInstance.maxHeartbeats 100000 in
-- Unfolding the comparison requires the same dependent tensor hierarchy as its definition.
set_option maxHeartbeats 1600000 in
set_option maxSynthPendingDepth 16 in
/-- The overlap comparison carries the scalar-extended finite-stage left face to
the actual left face of the base-changed self-overlap. -/
theorem etaleCoverTensorStageOverlapEquiv_faceLeft
    {F K B : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] [CommRing B] [Algebra F B]
    (M : FinSubext F K) (E₀ : Algebra.EtaleCover (M.1 ⊗[F] B)) :
    let stage := M.1 ⊗[F] B
    let ambient := K ⊗[F] B
    let iota : stage →ₐ[F] ambient :=
      Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
    letI : Algebra stage ambient := iota.toRingHom.toAlgebra
    let f : stage →ₐ[M.1] E₀.Carrier :=
      (Algebra.ofId stage E₀.Carrier).restrictScalars M.1
    let eE : (K ⊗[M.1] E₀.Carrier) ≃ₐ[K]
        (E₀.baseChange ambient).Carrier :=
      (etaleCoverTensorStageCarrierEquiv M E₀).symm
    (etaleCoverTensorStageOverlapEquiv M E₀).toAlgHom.comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M.1) (K := K) (finiteStageTensorPushoutFaceLeft f f)) =
      (etaleCoverTensorStageOverlapFaceLeft M E₀).comp eE.toAlgHom := by
  dsimp only
  let stage := M.1 ⊗[F] B
  let ambient := K ⊗[F] B
  let iota : stage →ₐ[F] ambient :=
    Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
  letI : Algebra stage ambient := iota.toRingHom.toAlgebra
  haveI : IsScalarTower M.1 stage ambient :=
    @IsScalarTower.of_algebraMap_eq M.1 stage ambient
      inferInstance inferInstance inferInstance inferInstance inferInstance inferInstance
      (fun m => by
        change (m : K) ⊗ₜ[F] (1 : B) = iota (m ⊗ₜ[F] (1 : B))
        rw [show iota = Algebra.TensorProduct.map M.1.val (AlgHom.id F B) from rfl,
          Algebra.TensorProduct.map_tmul]
        simp)
  let U := (E₀.baseChange ambient).Carrier
  let f : stage →ₐ[M.1] E₀.Carrier :=
    (Algebra.ofId stage E₀.Carrier).restrictScalars M.1
  let eA : (K ⊗[M.1] stage) ≃ₐ[K] ambient :=
    etaleCoverTensorStageBaseEquiv (F := F) (K := K) (B := B) M
  let eE : (K ⊗[M.1] E₀.Carrier) ≃ₐ[K] U :=
    (etaleCoverTensorStageCarrierEquiv M E₀).symm
  let g : ambient →ₐ[K] U :=
    (Algebra.ofId ambient U).restrictScalars K
  let T := U ⊗[ambient] U
  let j₁ : U →ₐ[K] T := etaleCoverTensorStageOverlapFaceLeft M E₀
  let j₂ : U →ₐ[K] T := etaleCoverTensorStageOverlapFaceRight M E₀
  have hnat : eE.toAlgHom.comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M.1) (K := K) f) =
      g.comp eA.toAlgHom :=
    etaleCoverTensorStageCarrierEquiv_symm_naturality M E₀
  have hPush : IsPushout
      (CommRingCat.ofHom g.toRingHom)
      (CommRingCat.ofHom g.toRingHom)
      (CommRingCat.ofHom j₁.toRingHom)
      (CommRingCat.ofHom j₂.toRingHom) := by
    change IsPushout
      (CommRingCat.ofHom (algebraMap ambient U))
      (CommRingCat.ofHom (algebraMap ambient U))
      (CommRingCat.ofHom
        (Algebra.TensorProduct.includeLeftRingHom
          (R := ambient) (A := U) (B := U)))
      (CommRingCat.ofHom
        (Algebra.TensorProduct.includeRight
          (R := ambient) (A := U) (B := U)).toRingHom)
    exact CommRingCat.isPushout_tensorProduct ambient U U
  change
    (finiteStageTensorPushoutComparison
        f f eA eE eE g g j₁ j₂ hnat hnat hPush).toAlgHom.comp
      (AlgebraicJacobian.scalarExtensionMapOfAlgHom
        (R := M.1) (K := K) (finiteStageTensorPushoutFaceLeft f f)) =
      j₁.comp eE.toAlgHom
  exact finiteStageTensorPushoutComparison_faceLeft
    f f eA eE eE g g j₁ j₂ hnat hnat hPush

set_option synthInstance.maxHeartbeats 100000 in
-- Unfolding the comparison requires the same dependent tensor hierarchy as its definition.
set_option maxHeartbeats 1600000 in
set_option maxSynthPendingDepth 16 in
/-- The overlap comparison carries the scalar-extended finite-stage right face to
the actual right face of the base-changed self-overlap. -/
theorem etaleCoverTensorStageOverlapEquiv_faceRight
    {F K B : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] [CommRing B] [Algebra F B]
    (M : FinSubext F K) (E₀ : Algebra.EtaleCover (M.1 ⊗[F] B)) :
    let stage := M.1 ⊗[F] B
    let ambient := K ⊗[F] B
    let iota : stage →ₐ[F] ambient :=
      Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
    letI : Algebra stage ambient := iota.toRingHom.toAlgebra
    let f : stage →ₐ[M.1] E₀.Carrier :=
      (Algebra.ofId stage E₀.Carrier).restrictScalars M.1
    let eE : (K ⊗[M.1] E₀.Carrier) ≃ₐ[K]
        (E₀.baseChange ambient).Carrier :=
      (etaleCoverTensorStageCarrierEquiv M E₀).symm
    (etaleCoverTensorStageOverlapEquiv M E₀).toAlgHom.comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M.1) (K := K) (finiteStageTensorPushoutFaceRight f f)) =
      (etaleCoverTensorStageOverlapFaceRight M E₀).comp eE.toAlgHom := by
  dsimp only
  let stage := M.1 ⊗[F] B
  let ambient := K ⊗[F] B
  let iota : stage →ₐ[F] ambient :=
    Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
  letI : Algebra stage ambient := iota.toRingHom.toAlgebra
  haveI : IsScalarTower M.1 stage ambient :=
    @IsScalarTower.of_algebraMap_eq M.1 stage ambient
      inferInstance inferInstance inferInstance inferInstance inferInstance inferInstance
      (fun m => by
        change (m : K) ⊗ₜ[F] (1 : B) = iota (m ⊗ₜ[F] (1 : B))
        rw [show iota = Algebra.TensorProduct.map M.1.val (AlgHom.id F B) from rfl,
          Algebra.TensorProduct.map_tmul]
        simp)
  let U := (E₀.baseChange ambient).Carrier
  let f : stage →ₐ[M.1] E₀.Carrier :=
    (Algebra.ofId stage E₀.Carrier).restrictScalars M.1
  let eA : (K ⊗[M.1] stage) ≃ₐ[K] ambient :=
    etaleCoverTensorStageBaseEquiv (F := F) (K := K) (B := B) M
  let eE : (K ⊗[M.1] E₀.Carrier) ≃ₐ[K] U :=
    (etaleCoverTensorStageCarrierEquiv M E₀).symm
  let g : ambient →ₐ[K] U :=
    (Algebra.ofId ambient U).restrictScalars K
  let T := U ⊗[ambient] U
  let j₁ : U →ₐ[K] T := etaleCoverTensorStageOverlapFaceLeft M E₀
  let j₂ : U →ₐ[K] T := etaleCoverTensorStageOverlapFaceRight M E₀
  have hnat : eE.toAlgHom.comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M.1) (K := K) f) =
      g.comp eA.toAlgHom :=
    etaleCoverTensorStageCarrierEquiv_symm_naturality M E₀
  have hPush : IsPushout
      (CommRingCat.ofHom g.toRingHom)
      (CommRingCat.ofHom g.toRingHom)
      (CommRingCat.ofHom j₁.toRingHom)
      (CommRingCat.ofHom j₂.toRingHom) := by
    change IsPushout
      (CommRingCat.ofHom (algebraMap ambient U))
      (CommRingCat.ofHom (algebraMap ambient U))
      (CommRingCat.ofHom
        (Algebra.TensorProduct.includeLeftRingHom
          (R := ambient) (A := U) (B := U)))
      (CommRingCat.ofHom
        (Algebra.TensorProduct.includeRight
          (R := ambient) (A := U) (B := U)).toRingHom)
    exact CommRingCat.isPushout_tensorProduct ambient U U
  change
    (finiteStageTensorPushoutComparison
        f f eA eE eE g g j₁ j₂ hnat hnat hPush).toAlgHom.comp
      (AlgebraicJacobian.scalarExtensionMapOfAlgHom
        (R := M.1) (K := K) (finiteStageTensorPushoutFaceRight f f)) =
      j₂.comp eE.toAlgHom
  exact finiteStageTensorPushoutComparison_faceRight
    f f eA eE eE g g j₁ j₂ hnat hnat hPush

end

end AlgebraicGeometry.DatG0
