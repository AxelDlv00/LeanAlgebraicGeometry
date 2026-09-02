/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.PicEtTensorStageCover

/-!
# Carrier comparison for tensor-stage etale covers

The carrier of an etale cover after base change from `M tensor[F] B` to
`K tensor[F] B` is canonically the simpler tensor product `K tensor[M] E.Carrier`.
This is the carrier model consumed by relative-Picard tensor-stage descent.
-/

set_option autoImplicit false

universe u

open scoped TensorProduct

namespace AlgebraicGeometry.DatG0

noncomputable section

set_option synthInstance.maxHeartbeats 100000 in
-- The dependent tensor signature needs a deeper search than the project default.
set_option maxSynthPendingDepth 16 in
/-- Reassociate the carrier of a base-changed finite tensor-stage cover as a tensor
product over the finite field stage. -/
noncomputable def etaleCoverTensorStageCarrierEquiv
    {F K B : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] [CommRing B] [Algebra F B]
    (M : FinSubext F K) (E₀ : Algebra.EtaleCover (M.1 ⊗[F] B)) :
    let iota : M.1 ⊗[F] B →ₐ[F] K ⊗[F] B :=
      Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
    letI : Algebra (M.1 ⊗[F] B) (K ⊗[F] B) :=
      iota.toRingHom.toAlgebra
    (E₀.baseChange (K ⊗[F] B)).Carrier ≃ₐ[K]
      K ⊗[M.1] E₀.Carrier := by
  dsimp only
  let iota : M.1 ⊗[F] B →ₐ[F] K ⊗[F] B :=
    Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
  letI : Algebra (M.1 ⊗[F] B) (K ⊗[F] B) :=
    iota.toRingHom.toAlgebra
  haveI : IsScalarTower M.1 (M.1 ⊗[F] B) (K ⊗[F] B) :=
    @IsScalarTower.of_algebraMap_eq M.1 (M.1 ⊗[F] B) (K ⊗[F] B)
      inferInstance inferInstance inferInstance inferInstance inferInstance inferInstance
      (fun a => by
        change (a : K) ⊗ₜ[F] (1 : B) = iota (a ⊗ₜ[F] (1 : B))
        simp [iota])
  letI : Algebra.IsPushout M.1 K (M.1 ⊗[F] B) (K ⊗[F] B) :=
    tensorStageMap_isPushout M
  exact ((E₀.baseChangeEquiv (K ⊗[F] B)).restrictScalars K).trans
    (Algebra.IsPushout.cancelBaseChangeAlg
      M.1 K (M.1 ⊗[F] B) (K ⊗[F] B) E₀.Carrier)

set_option synthInstance.maxHeartbeats 100000 in
-- Unfolding the dependent carrier comparison is expensive for the elaborator.
set_option maxHeartbeats 800000 in
set_option maxSynthPendingDepth 16 in
/-- The tensor-stage carrier comparison sends the canonical copy of a cover
element to the corresponding pure tensor. -/
@[simp]
theorem etaleCoverTensorStageCarrierEquiv_baseChange_tmul
    {F K B : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] [CommRing B] [Algebra F B]
    (M : FinSubext F K) (E₀ : Algebra.EtaleCover (M.1 ⊗[F] B))
    (x : E₀.Carrier) :
    let iota : M.1 ⊗[F] B →ₐ[F] K ⊗[F] B :=
      Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
    letI : Algebra (M.1 ⊗[F] B) (K ⊗[F] B) :=
      iota.toRingHom.toAlgebra
    etaleCoverTensorStageCarrierEquiv M E₀
        ((E₀.baseChangeEquiv (K ⊗[F] B)).symm
          (1 ⊗ₜ[M.1 ⊗[F] B] x)) =
      1 ⊗ₜ[M.1] x := by
  dsimp only
  let iota : M.1 ⊗[F] B →ₐ[F] K ⊗[F] B :=
    Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
  letI : Algebra (M.1 ⊗[F] B) (K ⊗[F] B) :=
    iota.toRingHom.toAlgebra
  haveI : IsScalarTower M.1 (M.1 ⊗[F] B) (K ⊗[F] B) :=
    @IsScalarTower.of_algebraMap_eq M.1 (M.1 ⊗[F] B) (K ⊗[F] B)
      inferInstance inferInstance inferInstance inferInstance inferInstance inferInstance
      (fun a => by
        change (a : K) ⊗ₜ[F] (1 : B) = iota (a ⊗ₜ[F] (1 : B))
        simp [iota])
  letI : Algebra.IsPushout M.1 K (M.1 ⊗[F] B) (K ⊗[F] B) :=
    tensorStageMap_isPushout M
  rw [etaleCoverTensorStageCarrierEquiv]
  change Algebra.IsPushout.cancelBaseChangeAlg
        M.1 K (M.1 ⊗[F] B) (K ⊗[F] B) E₀.Carrier
          ((E₀.baseChangeEquiv (K ⊗[F] B))
            ((E₀.baseChangeEquiv (K ⊗[F] B)).symm
              (1 ⊗ₜ[M.1 ⊗[F] B] x))) =
      1 ⊗ₜ[M.1] x
  rw [(E₀.baseChangeEquiv (K ⊗[F] B)).apply_symm_apply]
  exact Algebra.IsPushout.cancelBaseChangeAlg_tmul
    M.1 K (M.1 ⊗[F] B) (K ⊗[F] B) E₀.Carrier x

set_option synthInstance.maxHeartbeats 100000 in
-- Unfolding the dependent carrier comparison is expensive for the elaborator.
set_option maxHeartbeats 800000 in
set_option maxSynthPendingDepth 16 in
/-- Inverse generator formula for the tensor-stage carrier comparison. -/
@[simp]
theorem etaleCoverTensorStageCarrierEquiv_symm_tmul
    {F K B : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] [CommRing B] [Algebra F B]
    (M : FinSubext F K) (E₀ : Algebra.EtaleCover (M.1 ⊗[F] B))
    (x : E₀.Carrier) :
    let iota : M.1 ⊗[F] B →ₐ[F] K ⊗[F] B :=
      Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
    letI : Algebra (M.1 ⊗[F] B) (K ⊗[F] B) :=
      iota.toRingHom.toAlgebra
    (etaleCoverTensorStageCarrierEquiv M E₀).symm
        (1 ⊗ₜ[M.1] x) =
      (E₀.baseChangeEquiv (K ⊗[F] B)).symm
        (1 ⊗ₜ[M.1 ⊗[F] B] x) := by
  dsimp only
  apply (etaleCoverTensorStageCarrierEquiv M E₀).injective
  rw [(etaleCoverTensorStageCarrierEquiv M E₀).apply_symm_apply]
  exact (etaleCoverTensorStageCarrierEquiv_baseChange_tmul M E₀ x).symm

end

end AlgebraicGeometry.DatG0
