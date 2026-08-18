/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageRestrictionNaturality
import AlgebraicJacobian.Picard.Pic0FiniteStageRightLegEquality

/-!
# Naturality of the right finite-stage Picard restriction

The right restriction is the reversed left restriction followed by the ordered-overlap
transition. Its finite-stage composite equals the directly descended right restriction,
so the indexed final base-change square gives the corresponding scheme-level naturality.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits TensorProduct
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] [IsSepClosed k]

namespace Pic0FiniteStageGluePackage

set_option synthInstance.maxHeartbeats 3200000 in
-- The raw carriers fix the reversed chart and forward overlap instances.
set_option maxHeartbeats 12800000 in
/-- The right restriction at the final finite stage: restrict from the right
chart to the reversed overlap, then apply the ordered-overlap transition. -/
noncomputable def rightRestrictionBaseChangeAlgHom
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) (U V : Pic0FiniteStageChartIndex C) :
    (P.N.1 ⊗[P.M.1]
      (P.M.1 ⊗[P.L.1]
        DatG0.FiniteRelationAlgebra P.L.1
          (P.n (Sum.inl V)) (P.m (Sum.inl V)) (P.relation (Sum.inl V)))) →ₐ[P.N.1]
    (P.N.1 ⊗[P.M.1]
      (P.M.1 ⊗[P.L.1]
        DatG0.FiniteRelationAlgebra P.L.1
          (P.n (Sum.inr (U, V))) (P.m (Sum.inr (U, V)))
          (P.relation (Sum.inr (U, V))))) := by
  letI : Algebra.IsAlgebraic P.L.1 k := by infer_instance
  letI : Algebra.IsAlgebraic P.M.1 k := by infer_instance
  exact
    (AlgebraicJacobian.scalarExtensionMapOfAlgHom
        (R := P.M.1) (K := P.N.1) (P.mapM (Sum.inr (U, V)))).comp
      (AlgebraicJacobian.scalarExtensionMapOfAlgHom
        (R := P.M.1) (K := P.N.1)
          (P.mapM (Sum.inl (Sum.inl (V, U)))))

set_option synthInstance.maxHeartbeats 3200000 in
-- The equality retains the same dependent tensor-product instances.
set_option maxHeartbeats 12800000 in
/-- The composite final-stage right restriction is the directly descended
right restriction in the indexed finite family. -/
theorem rightRestrictionBaseChangeAlgHom_eq_direct
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) (U V : Pic0FiniteStageChartIndex C) :
    rightRestrictionBaseChangeAlgHom C P U V =
      AlgebraicJacobian.scalarExtensionMapOfAlgHom
        (R := P.M.1) (K := P.N.1)
        (P.mapM (Sum.inl (Sum.inr (U, V)))) := by
  exact scalarExtension_transition_comp_restrictionLeft_eq_right C P U V

set_option synthInstance.maxHeartbeats 3200000 in
-- The explicit pullbacks fix the reversed chart ring.
set_option maxHeartbeats 12800000 in
/-- Pullback of the composite final-stage right restriction from the forward
overlap to the right chart. -/
noncomputable def rightRestrictionBaseChangeMap
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    pullback
        (Spec.map (CommRingCat.ofHom
          (algebraMap P.N.1
            (Pic0FiniteStageOverlapBaseChangeRing
              C P.L P.n P.m P.relation P.M P.N U V))))
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) ⟶
      pullback
        (Spec.map (CommRingCat.ofHom
          (algebraMap P.N.1
            (Pic0FiniteStageChartBaseChangeRing
              C P.L P.n P.m P.relation P.M P.N V))))
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) :=
  affineBaseChangeMap P.N.1 k
    (Pic0FiniteStageChartBaseChangeRing
      C P.L P.n P.m P.relation P.M P.N V)
    (Pic0FiniteStageOverlapBaseChangeRing
      C P.L P.n P.m P.relation P.M P.N U V)
    (rightRestrictionBaseChangeAlgHom C P U V)

set_option synthInstance.maxHeartbeats 3200000 in
-- The direct indexed square supplies the ring compatibility after one rewrite.
set_option maxHeartbeats 12800000 in
/-- The right finite-stage restriction agrees after base change with the exact
right restriction of the separably closed Picard atlas. -/
theorem rightRestrictionBaseChangeMap_naturality
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    rightRestrictionBaseChangeMap C P U V ≫
        (chartRingBaseChangeIso C P V).hom =
      (overlapRingBaseChangeIso C P U V).hom ≫
        Spec.map (CommRingCat.ofHom
          (pic0FiniteStageRestrictionRight C U V).toRingHom) := by
  letI : Algebra.IsAlgebraic P.L.1 k := by infer_instance
  letI : Algebra.IsAlgebraic P.M.1 k := by infer_instance
  apply affineBaseChangeIso_trans_naturality
    P.N.1 k
    (P.N.1 ⊗[P.M.1]
      (P.M.1 ⊗[P.L.1]
        DatG0.FiniteRelationAlgebra P.L.1
          (P.n (Sum.inl V)) (P.m (Sum.inl V)) (P.relation (Sum.inl V))))
    (P.N.1 ⊗[P.M.1]
      (P.M.1 ⊗[P.L.1]
        DatG0.FiniteRelationAlgebra P.L.1
          (P.n (Sum.inr (U, V))) (P.m (Sum.inr (U, V)))
          (P.relation (Sum.inr (U, V)))))
    (Pic0FiniteStageRing C (Sum.inl V))
    (Pic0FiniteStageRing C (Sum.inr (U, V)))
    (rightRestrictionBaseChangeAlgHom C P U V)
    (chartFinalBaseChangeEquiv C P V)
    (overlapFinalBaseChangeEquiv C P U V)
    (pic0FiniteStageRestrictionRight C U V)
  rw [rightRestrictionBaseChangeAlgHom_eq_direct C P U V]
  exact pic0FiniteStageFinalBaseChangeEquiv_naturality
    C P.L P.n P.m P.relation P.e P.M P.mapM P.hmapM P.N
      (Sum.inl (Sum.inr (U, V)))

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
