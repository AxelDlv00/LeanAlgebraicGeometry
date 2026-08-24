/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageRightLegEquality

/-!
# The scalar-extended right finite-stage Picard restriction

The right restriction is the reversed left restriction followed by the ordered-overlap
transition.  Composing the named scalar-extension maps retains their dependent carrier
instances during fresh elaboration.  The composite agrees with the directly descended
right restriction in the indexed finite family.
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

set_option synthInstance.maxHeartbeats 3200000 in
-- The named scalar-extension maps retain the dependent carrier instances.
set_option maxHeartbeats 12800000 in
/-- The right restriction at the final finite stage: restrict from the right
chart to the reversed overlap, then apply the ordered-overlap transition. -/
noncomputable def rightRestrictionBaseChangeAlgHom
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) (U V : Pic0FiniteStageChartIndex C) := by
  exact
    (pic0FiniteStageTransitionBaseChange
      C P.L P.n P.m P.relation P.M P.mapM P.N U V).comp
      (pic0FiniteStageRestrictionBaseChange
        C P.L P.n P.m P.relation P.M P.mapM P.N V U)

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

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
