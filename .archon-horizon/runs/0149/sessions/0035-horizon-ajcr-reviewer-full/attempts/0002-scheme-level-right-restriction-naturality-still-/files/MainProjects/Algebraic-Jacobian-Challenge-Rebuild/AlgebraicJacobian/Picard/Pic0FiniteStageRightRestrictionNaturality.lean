/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageRestrictionNaturality

/-!
# Naturality of the right finite-stage Picard restriction

The right restriction is the reversed left restriction followed by the ordered-overlap
transition.  Combining the two final base-change naturality squares identifies this composite
with the exact right restriction in the separably closed atlas.
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
-- The annotation fixes the reversed chart and forward overlap instances.
set_option maxHeartbeats 12800000 in
/-- The right restriction at the final finite stage: first restrict from the
right chart to the reversed overlap, then apply the ordered-overlap transition. -/
noncomputable def rightRestrictionBaseChangeAlgHom
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) (U V : Pic0FiniteStageChartIndex C) :
    Pic0FiniteStageChartBaseChangeRing
        C P.L P.n P.m P.relation P.M P.N V →ₐ[P.N.1]
      Pic0FiniteStageOverlapBaseChangeRing
        C P.L P.n P.m P.relation P.M P.N U V :=
  (pic0FiniteStageTransitionBaseChange
      C P.L P.n P.m P.relation P.M P.mapM P.N U V).comp
    (restrictionBaseChangeAlgHom C P V U)

set_option synthInstance.maxHeartbeats 3200000 in
-- Specializing the generic pullback map infers the reversed chart ring.
set_option maxHeartbeats 12800000 in
/-- Pullback of the finite-stage right restriction from the forward overlap to
the right chart. -/
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
-- The local ring square combines two dependent final-stage comparisons.
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
    (Pic0FiniteStageChartBaseChangeRing
      C P.L P.n P.m P.relation P.M P.N V)
    (Pic0FiniteStageOverlapBaseChangeRing
      C P.L P.n P.m P.relation P.M P.N U V)
    (Pic0FiniteStageRing C (Sum.inl V))
    (Pic0FiniteStageRing C (Sum.inr (U, V)))
    (rightRestrictionBaseChangeAlgHom C P U V)
    (chartFinalBaseChangeEquiv C P V)
    (overlapFinalBaseChangeEquiv C P U V)
    (pic0FiniteStageRestrictionRight C U V)
  have htransition := pic0FiniteStageFinalBaseChangeEquiv_naturality
    C P.L P.n P.m P.relation P.e P.M P.mapM P.hmapM P.N
      (Sum.inr (U, V))
  change
    (overlapFinalBaseChangeEquiv C P U V).toAlgHom.comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom (R := P.N.1) (K := k)
          (pic0FiniteStageTransitionBaseChange
            C P.L P.n P.m P.relation P.M P.mapM P.N U V)) =
      (pic0FiniteStageTransition C (U, V)).comp
        (overlapFinalBaseChangeEquiv C P V U).toAlgHom at htransition
  have hrestriction := pic0FiniteStageFinalBaseChangeEquiv_naturality
    C P.L P.n P.m P.relation P.e P.M P.mapM P.hmapM P.N
      (Sum.inl (Sum.inl (V, U)))
  change
    (overlapFinalBaseChangeEquiv C P V U).toAlgHom.comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom (R := P.N.1) (K := k)
          (restrictionBaseChangeAlgHom C P V U)) =
      (pic0FiniteStageRestrictionLeft C V U).comp
        (chartFinalBaseChangeEquiv C P V).toAlgHom at hrestriction
  have hright :
      (pic0FiniteStageTransition C (U, V)).comp
          (pic0FiniteStageRestrictionLeft C V U) =
        pic0FiniteStageRestrictionRight C U V := by
    apply DFunLike.ext _ _
    intro x
    change
      ((pic0_sepClosed_representableBy (C := C)).1.left.resHom
        (show U.1.1 ⊓ V.1.1 ≤ V.1.1 ⊓ U.1.1 by rw [inf_comm]))
        (((pic0_sepClosed_representableBy (C := C)).1.left.resHom
          (show V.1.1 ⊓ U.1.1 ≤ V.1.1 from inf_le_left)) x) =
      ((pic0_sepClosed_representableBy (C := C)).1.left.resHom
        (show U.1.1 ⊓ V.1.1 ≤ V.1.1 from inf_le_right)) x
    rw [Scheme.resHom_resHom]
  change
    (overlapFinalBaseChangeEquiv C P U V).toAlgHom.comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom (R := P.N.1) (K := k)
          ((pic0FiniteStageTransitionBaseChange
              C P.L P.n P.m P.relation P.M P.mapM P.N U V).comp
            (restrictionBaseChangeAlgHom C P V U))) =
      (pic0FiniteStageRestrictionRight C U V).comp
        (chartFinalBaseChangeEquiv C P V).toAlgHom
  rw [← AlgebraicJacobian.scalarExtensionMapOfAlgHom_comp]
  calc
    _ = ((overlapFinalBaseChangeEquiv C P U V).toAlgHom.comp
          (AlgebraicJacobian.scalarExtensionMapOfAlgHom (R := P.N.1) (K := k)
            (pic0FiniteStageTransitionBaseChange
              C P.L P.n P.m P.relation P.M P.mapM P.N U V))).comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom (R := P.N.1) (K := k)
          (restrictionBaseChangeAlgHom C P V U)) := (AlgHom.comp_assoc _ _ _).symm
    _ = ((pic0FiniteStageTransition C (U, V)).comp
          (overlapFinalBaseChangeEquiv C P V U).toAlgHom).comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom (R := P.N.1) (K := k)
          (restrictionBaseChangeAlgHom C P V U)) :=
      congrArg (fun f => f.comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom (R := P.N.1) (K := k)
          (restrictionBaseChangeAlgHom C P V U))) htransition
    _ = (pic0FiniteStageTransition C (U, V)).comp
        ((overlapFinalBaseChangeEquiv C P V U).toAlgHom.comp
          (AlgebraicJacobian.scalarExtensionMapOfAlgHom (R := P.N.1) (K := k)
            (restrictionBaseChangeAlgHom C P V U))) := AlgHom.comp_assoc _ _ _
    _ = (pic0FiniteStageTransition C (U, V)).comp
        ((pic0FiniteStageRestrictionLeft C V U).comp
          (chartFinalBaseChangeEquiv C P V).toAlgHom) :=
      congrArg (fun f => (pic0FiniteStageTransition C (U, V)).comp f) hrestriction
    _ = ((pic0FiniteStageTransition C (U, V)).comp
          (pic0FiniteStageRestrictionLeft C V U)).comp
        (chartFinalBaseChangeEquiv C P V).toAlgHom := (AlgHom.comp_assoc _ _ _).symm
    _ = (pic0FiniteStageRestrictionRight C U V).comp
        (chartFinalBaseChangeEquiv C P V).toAlgHom :=
      congrArg (fun f => f.comp (chartFinalBaseChangeEquiv C P V).toAlgHom) hright

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
