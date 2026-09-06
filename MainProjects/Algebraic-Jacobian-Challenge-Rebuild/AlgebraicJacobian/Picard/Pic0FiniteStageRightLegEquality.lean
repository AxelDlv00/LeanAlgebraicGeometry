/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageGluePackage
import AlgebraicJacobian.Picard.Pic0FiniteStageModelRightLeg

/-!
# The right leg of the finite-stage Picard glue datum

The canonical transition models identify the reversed left restriction with
the forward right restriction. This file specializes those identities to the
models and final field of the finite-stage glue package.
-/

set_option autoImplicit false

universe u

open CategoryTheory TensorProduct
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] [IsSepClosed k]

namespace Pic0FiniteStageGluePackage

/-- On the exact Picard atlas, transition from the reversed overlap followed
by its left restriction is the right restriction of the forward overlap. -/
theorem transition_comp_restrictionLeft_eq_restrictionRight
    (U V : Pic0FiniteStageChartIndex C) :
    (pic0FiniteStageTransition C (U, V)).comp
        (pic0FiniteStageRestrictionLeft C V U) =
      pic0FiniteStageRestrictionRight C U V :=
  Pic0FiniteStageTransitionModelsData.transition_comp_restrictionLeft_eq_restrictionRight C U V

/-- The exact right-leg equation transported to the ambient tensor-product
models used by the finite-stage package. -/
theorem transportedMap_transition_comp_restrictionLeft_eq_right
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    (pic0FiniteStageTransportedMap C P.context.models.L P.context.models.n
        P.context.models.m P.context.models.relation P.context.models.e
        (Sum.inr (U, V))).comp
        (pic0FiniteStageTransportedMap C P.context.models.L P.context.models.n
          P.context.models.m P.context.models.relation P.context.models.e
          (Sum.inl (Sum.inl (V, U)))) =
      pic0FiniteStageTransportedMap C P.context.models.L P.context.models.n
        P.context.models.m P.context.models.relation P.context.models.e
        (Sum.inl (Sum.inr (U, V))) :=
  P.context.models.transportedMap_transition_comp_restrictionLeft_eq_right C U V

/-- The descended transition followed by the descended reversed left
restriction is the descended forward right restriction. -/
theorem mapM_transition_comp_restrictionLeft_eq_right
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    (P.context.models.mapM (Sum.inr (U, V))).comp
        (P.context.models.mapM (Sum.inl (Sum.inl (V, U)))) =
      P.context.models.mapM (Sum.inl (Sum.inr (U, V))) :=
  P.context.models.mapM_transition_comp_restrictionLeft_eq_right C U V

set_option synthInstance.maxHeartbeats 400000 in
-- The three scalar extensions retain dependent model-ring algebra instances.
set_option maxHeartbeats 3200000 in
-- Elaborating their shared tensor carrier exceeds the default heartbeat bound.
/-- Scalar extension to the package's final finite subextension preserves the
transition/restriction equation. -/
theorem scalarExtension_transition_comp_restrictionLeft_eq_right
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    (AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := P.context.models.M.1) (K := P.context.triple.N.1)
      (P.context.models.mapM (Sum.inr (U, V)))).comp
      (AlgebraicJacobian.scalarExtensionMapOfAlgHom
        (R := P.context.models.M.1) (K := P.context.triple.N.1)
        (P.context.models.mapM (Sum.inl (Sum.inl (V, U))))) =
    AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := P.context.models.M.1) (K := P.context.triple.N.1)
      (P.context.models.mapM (Sum.inl (Sum.inr (U, V)))) :=
  P.context.models.scalarExtension_transition_comp_restrictionLeft_eq_right
    C P.context.triple.N U V

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
