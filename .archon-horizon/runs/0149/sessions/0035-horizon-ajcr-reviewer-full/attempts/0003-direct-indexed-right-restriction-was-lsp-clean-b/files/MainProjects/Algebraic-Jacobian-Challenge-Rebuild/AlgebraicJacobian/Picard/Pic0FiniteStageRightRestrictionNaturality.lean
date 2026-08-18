/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageRestrictionNaturality

/-!
# Naturality of the right finite-stage Picard restriction

The finite-stage model family contains the right restriction as its own indexed
map.  Specializing final base-change naturality to this index identifies its
pullback with the exact right restriction in the separably closed atlas.
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
-- Projecting the package unfolds dependent tensor-product instances.
set_option maxHeartbeats 12800000 in
/-- Scalar extension of the directly descended right restriction.  Its indexed
source and target keep the canonical model-ring instances definitionally fixed. -/
noncomputable def rightRestrictionBaseChangeAlgHom
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) (U V : Pic0FiniteStageChartIndex C) :
    Pic0FiniteStageFinalModelRing
        C P.L P.n P.m P.relation P.M P.N (Sum.inl V) →ₐ[P.N.1]
      Pic0FiniteStageFinalModelRing
        C P.L P.n P.m P.relation P.M P.N (Sum.inr (U, V)) :=
  AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := P.M.1) (K := P.N.1) (P.mapM (Sum.inl (Sum.inr (U, V))))

/-- The exact right restriction, presented with the same indexed source and
target as the descended finite family. -/
noncomputable def exactRightRestrictionAlgHom
    (U V : Pic0FiniteStageChartIndex C) :
    Pic0FiniteStageRing C (Sum.inl V) →ₐ[k]
      Pic0FiniteStageRing C (Sum.inr (U, V)) :=
  pic0FiniteStageMap C (Sum.inl (Sum.inr (U, V)))

set_option synthInstance.maxHeartbeats 3200000 in
-- The indexed source and target retain the package's canonical instances.
set_option maxHeartbeats 12800000 in
/-- Pullback of the directly descended right restriction from the overlap to
its right chart. -/
noncomputable def rightRestrictionBaseChangeMap
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    pullback
        (Spec.map (CommRingCat.ofHom
          (algebraMap P.N.1
            (Pic0FiniteStageFinalModelRing
              C P.L P.n P.m P.relation P.M P.N (Sum.inr (U, V))))))
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) ⟶
      pullback
        (Spec.map (CommRingCat.ofHom
          (algebraMap P.N.1
            (Pic0FiniteStageFinalModelRing
              C P.L P.n P.m P.relation P.M P.N (Sum.inl V)))))
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) :=
  affineBaseChangeMap P.N.1 k
    (Pic0FiniteStageFinalModelRing
      C P.L P.n P.m P.relation P.M P.N (Sum.inl V))
    (Pic0FiniteStageFinalModelRing
      C P.L P.n P.m P.relation P.M P.N (Sum.inr (U, V)))
    (rightRestrictionBaseChangeAlgHom C P U V)

set_option synthInstance.maxHeartbeats 3200000 in
-- The generic naturality theorem elaborates the dependent indexed square.
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
          (exactRightRestrictionAlgHom C U V).toRingHom) := by
  letI : Algebra.IsAlgebraic P.L.1 k := by infer_instance
  letI : Algebra.IsAlgebraic P.M.1 k := by infer_instance
  apply affineBaseChangeIso_trans_naturality
    P.N.1 k
    (Pic0FiniteStageFinalModelRing
      C P.L P.n P.m P.relation P.M P.N (Sum.inl V))
    (Pic0FiniteStageFinalModelRing
      C P.L P.n P.m P.relation P.M P.N (Sum.inr (U, V)))
    (Pic0FiniteStageRing C (Sum.inl V))
    (Pic0FiniteStageRing C (Sum.inr (U, V)))
    (rightRestrictionBaseChangeAlgHom C P U V)
    (chartFinalBaseChangeEquiv C P V)
    (overlapFinalBaseChangeEquiv C P U V)
    (exactRightRestrictionAlgHom C U V)
  exact pic0FiniteStageFinalBaseChangeEquiv_naturality
    C P.L P.n P.m P.relation P.e P.M P.mapM P.hmapM P.N
      (Sum.inl (Sum.inr (U, V)))

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
