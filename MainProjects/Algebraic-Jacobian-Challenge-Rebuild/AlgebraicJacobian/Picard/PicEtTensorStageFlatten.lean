/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.FiniteStageData
import AlgebraicJacobian.Descent.TensorProductFieldTowerMap

/-!
# Flattening nested finite tensor stages

A finite stage over a finite intermediate field is already finite over the original
field.  This file packages that observation together with the canonical cancellation
equivalence on tensor products and its compatibility with the ambient tensor map.
-/

set_option autoImplicit false

universe u

open scoped TensorProduct

namespace AlgebraicGeometry.DatG0

noncomputable section

namespace FiniteStageData

/-- Regard a finite stage over `M` as a finite stage over the original field.  The
underlying subset of the ambient field is unchanged. -/
noncomputable def flattenTower
    {F K : Type u} [Field F] [Field K] [Algebra F K]
    (M : FinSubext F K) (S : FiniteStageData M.1 K) :
    FiniteStageData F K where
  stage := ((IntermediateField.extendScalars.orderIso M.1).symm S.stage).1
  finiteWitness := by
    change FiniteDimensional F S.stage
    letI : FiniteDimensional F M.1 := M.2
    letI : FiniteDimensional M.1 S.stage := S.finiteWitness
    exact FiniteDimensional.trans F M.1 S.stage

@[simp]
theorem flattenTower_stage
    {F K : Type u} [Field F] [Field K] [Algebra F K]
    (M : FinSubext F K) (S : FiniteStageData M.1 K) :
    (S.flattenTower M).stage =
      ((IntermediateField.extendScalars.orderIso M.1).symm S.stage).1 :=
  rfl

@[simp]
theorem flattenTower_coe
    {F K : Type u} [Field F] [Field K] [Algebra F K]
    (M : FinSubext F K) (S : FiniteStageData M.1 K) :
    ((S.flattenTower M).stage : Set K) = (S.stage : Set K) :=
  rfl

end FiniteStageData

set_option maxSynthPendingDepth 16 in
/-- The actual map from a nested finite-stage tensor carrier to the ambient tensor
carrier: first include the inner finite stage into `K`, then cancel the intermediate
field `M`. -/
noncomputable def tensorStageNestedAmbientMap
    {F K B : Type u} [Field F] [Field K] [Algebra F K]
    [CommRing B] [Algebra F B]
    (M : FinSubext F K) (S : FiniteStageData M.1 K) :
    S.stage ⊗[M.1] (M.1 ⊗[F] B) →ₐ[F] K ⊗[F] B :=
  ((Algebra.TensorProduct.cancelBaseChange F M.1 K K B).toAlgHom.restrictScalars F).comp
    ((S.tensorMap (A := M.1 ⊗[F] B)).restrictScalars F)

set_option maxSynthPendingDepth 16 in
/-- The reusable comparison package for flattening a nested finite tensor stage. -/
structure FiniteStageTensorFlatteningData
    (F K B : Type u) [Field F] [Field K] [Algebra F K]
    [CommRing B] [Algebra F B]
    (M : FinSubext F K) (S : FiniteStageData M.1 K) where
  outer : FiniteStageData F K
  outer_stage :
    outer.stage = ((IntermediateField.extendScalars.orderIso M.1).symm S.stage).1
  tensorEquiv :
    S.stage ⊗[M.1] (M.1 ⊗[F] B) ≃ₐ[F] outer.stage ⊗[F] B
  compatibility :
    (outer.tensorMap (A := B)).comp tensorEquiv.toAlgHom =
      tensorStageNestedAmbientMap M S

namespace FiniteStageTensorFlatteningData

set_option synthInstance.maxHeartbeats 100000 in
set_option maxHeartbeats 800000 in
set_option maxSynthPendingDepth 16 in
/-- Construct the nested-stage flattening package from the canonical restricted stage
and tensor cancellation equivalence. -/
noncomputable def ofFiniteStage
    {F K B : Type u} [Field F] [Field K] [Algebra F K]
    [CommRing B] [Algebra F B]
    (M : FinSubext F K) (S : FiniteStageData M.1 K) :
    FiniteStageTensorFlatteningData F K B M S := by
  let outer := S.flattenTower M
  refine
    { outer := outer
      outer_stage := rfl
      tensorEquiv :=
        (Algebra.TensorProduct.cancelBaseChange F M.1 M.1 S.stage B).restrictScalars F
      compatibility := ?_ }
  apply DFunLike.ext _ _
  intro z
  induction z using TensorProduct.induction_on with
  | zero => simp
  | add x y hx hy => simp only [map_add, hx, hy]
  | tmul x y =>
      induction y using TensorProduct.induction_on with
      | zero => simp
      | add y z hy hz => simp only [TensorProduct.tmul_add, map_add, hy, hz]
      | tmul m b =>
          change (S.flattenTower M).tensorMap (A := B)
              (Algebra.TensorProduct.cancelBaseChange F M.1 M.1 S.stage B
                (x ⊗ₜ[M.1] (m ⊗ₜ[F] b))) =
            (m • (x : K)) ⊗ₜ[F] b
          rw [Algebra.TensorProduct.cancelBaseChange_tmul]
          change (Algebra.TensorProduct.map
              (S.flattenTower M).inclusion (AlgHom.id F B))
              ((m • x) ⊗ₜ[F] b) =
            (m • (x : K)) ⊗ₜ[F] b
          rw [Algebra.TensorProduct.map_tmul]
          have hsmul : ((m • x : S.stage) : K) = m • (x : K) := by
            rfl
          change (((m • x : S.stage) : K) ⊗ₜ[F] b) =
            (m • (x : K)) ⊗ₜ[F] b
          rw [hsmul]

@[simp]
theorem ofFiniteStage_outer
    {F K B : Type u} [Field F] [Field K] [Algebra F K]
    [CommRing B] [Algebra F B]
    (M : FinSubext F K) (S : FiniteStageData M.1 K) :
    (ofFiniteStage (B := B) M S).outer = S.flattenTower M :=
  rfl

end FiniteStageTensorFlatteningData

end

end AlgebraicGeometry.DatG0
