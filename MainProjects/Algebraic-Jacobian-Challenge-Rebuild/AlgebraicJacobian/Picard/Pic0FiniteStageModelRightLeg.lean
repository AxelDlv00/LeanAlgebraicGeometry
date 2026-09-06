/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageTransitionModels
import AlgebraicJacobian.Descent.TensorProductFieldTowerMap

/-!
# The right restriction on actual finite-stage models

The transition from the reversed overlap carries its left restriction to the
right restriction of the forward overlap. The comparison squares of the
transition models reflect this identity to their field of definition. Scalar
extension preserves it over every further finite subextension.
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

namespace Pic0FiniteStageTransitionModelsData

/-- On the exact atlas, the transition identifies the two restriction legs. -/
theorem transition_comp_restrictionLeft_eq_restrictionRight
    (U V : Pic0FiniteStageChartIndex C) :
    (pic0FiniteStageTransition C (U, V)).comp
        (pic0FiniteStageRestrictionLeft C V U) =
      pic0FiniteStageRestrictionRight C U V := by
  apply DFunLike.ext _ _
  intro x
  let J := (pic0_sepClosed_representableBy (C := C)).1
  letI : J.left.Over (Spec (.of k)) := ⟨J.hom⟩
  let hLeft : V.1.1 ⊓ U.1.1 ≤ V.1.1 :=
    pic0FiniteStageAffineOverlap_le_left C V U
  let hTransition : U.1.1 ⊓ V.1.1 ≤ V.1.1 ⊓ U.1.1 := by rw [inf_comm]
  let hRight : U.1.1 ⊓ V.1.1 ≤ V.1.1 :=
    pic0FiniteStageAffineOverlap_le_right C U V
  change (J.left.resHom hTransition) ((J.left.resHom hLeft) x) =
    (J.left.resHom hRight) x
  exact Scheme.resHom_resHom hLeft hTransition x

/-- Conjugating the exact restriction identity by the model comparisons. -/
theorem transportedMap_transition_comp_restrictionLeft_eq_right
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (D : Pic0FiniteStageTransitionModelsData C F)
    (U V : Pic0FiniteStageChartIndex C) :
    (pic0FiniteStageTransportedMap C D.L D.n D.m D.relation D.e
        (Sum.inr (U, V))).comp
        (pic0FiniteStageTransportedMap C D.L D.n D.m D.relation D.e
          (Sum.inl (Sum.inl (V, U)))) =
      pic0FiniteStageTransportedMap C D.L D.n D.m D.relation D.e
        (Sum.inl (Sum.inr (U, V))) := by
  have hExact := transition_comp_restrictionLeft_eq_restrictionRight C U V
  apply DFunLike.ext _ _
  intro x
  change
    (D.e (Sum.inr (U, V))).symm
      (pic0FiniteStageTransition C (U, V)
        ((D.e (Sum.inr (V, U)))
          ((D.e (Sum.inr (V, U))).symm
            (pic0FiniteStageRestrictionLeft C V U ((D.e (Sum.inl V)) x))))) =
    (D.e (Sum.inr (U, V))).symm
      (pic0FiniteStageRestrictionRight C U V ((D.e (Sum.inl V)) x))
  rw [(D.e (Sum.inr (V, U))).apply_symm_apply]
  exact congrArg (D.e (Sum.inr (U, V))).symm
    (DFunLike.congr_fun hExact ((D.e (Sum.inl V)) x))

set_option synthInstance.maxHeartbeats 400000 in
-- The three indexed maps retain distinct dependent tensor-product instances.
set_option maxHeartbeats 3200000 in
-- Reflection elaborates all three model maps and comparison squares together.
/-- The actual finite-stage transition carries the reversed left leg to the
forward right leg. -/
theorem mapM_transition_comp_restrictionLeft_eq_right
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (D : Pic0FiniteStageTransitionModelsData C F)
    (U V : Pic0FiniteStageChartIndex C) :
    (D.mapM (Sum.inr (U, V))).comp
        (D.mapM (Sum.inl (Sum.inl (V, U)))) =
      D.mapM (Sum.inl (Sum.inr (U, V))) := by
  apply DatG0.tensorProduct_algHom_comp_eq_of_baseChange D.M
    (D.mapM (Sum.inl (Sum.inl (V, U))))
    (D.mapM (Sum.inr (U, V)))
    (D.mapM (Sum.inl (Sum.inr (U, V))))
    (pic0FiniteStageTransportedMap C D.L D.n D.m D.relation D.e
      (Sum.inl (Sum.inl (V, U))))
    (pic0FiniteStageTransportedMap C D.L D.n D.m D.relation D.e
      (Sum.inr (U, V)))
    (pic0FiniteStageTransportedMap C D.L D.n D.m D.relation D.e
      (Sum.inl (Sum.inr (U, V))))
  · exact D.comparison (Sum.inl (Sum.inl (V, U)))
  · exact D.comparison (Sum.inr (U, V))
  · exact D.comparison (Sum.inl (Sum.inr (U, V)))
  · exact transportedMap_transition_comp_restrictionLeft_eq_right C D U V

set_option synthInstance.maxHeartbeats 400000 in
-- Scalar extension repeats all three indexed source and target models.
set_option maxHeartbeats 3200000 in
-- Rewriting composition compares the dependent tensor-product instances.
/-- The right-leg identity survives extension to any further finite stage. -/
theorem scalarExtension_transition_comp_restrictionLeft_eq_right
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (D : Pic0FiniteStageTransitionModelsData C F)
    (N : DatG0.FinSubext D.M.1 k)
    (U V : Pic0FiniteStageChartIndex C) :
    (AlgebraicJacobian.scalarExtensionMapOfAlgHom (R := D.M.1) (K := N.1)
      (D.mapM (Sum.inr (U, V)))).comp
      (AlgebraicJacobian.scalarExtensionMapOfAlgHom (R := D.M.1) (K := N.1)
        (D.mapM (Sum.inl (Sum.inl (V, U))))) =
    AlgebraicJacobian.scalarExtensionMapOfAlgHom (R := D.M.1) (K := N.1)
      (D.mapM (Sum.inl (Sum.inr (U, V)))) := by
  rw [AlgebraicJacobian.scalarExtensionMapOfAlgHom_comp,
    mapM_transition_comp_restrictionLeft_eq_right C D U V]
  rfl

end Pic0FiniteStageTransitionModelsData

end

end AlgebraicGeometry
