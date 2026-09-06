/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4DivisorModule
import HartshorneLib.Chapter4DivisorSheafMul

/-!
# Multiplication isomorphisms of divisor modules

Multiplication by a nonzero rational function is linear for the structure-sheaf
module actions on bounded rational sections. This upgrades the existing
multiplication isomorphism of `k`-module sheaves to an isomorphism of actual
`O_X`-modules.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace
open AlgebraicGeometry

namespace Hartshorne

noncomputable section

attribute [local instance] functionFieldOverModule Scheme.overModule

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]

/-- Multiplication by a function-field unit commutes with the structure-sheaf
action on divisor sections. -/
lemma divisorMulPresheafApp_action (g : X.left.functionFieldˣ)
    (D : CurveDivisor k X) (U : X.left.Opens) (r : Γ(X.left, U))
    (s : divisorSections D U) :
    divisorMulPresheafApp (k := k) g D U (divisorSectionAction D U r s) =
      divisorSectionAction (D - principalDivisor g) U r
        (divisorMulPresheafApp (k := k) g D U s) := by
  classical
  by_cases hU : (U : Set X.left).Nonempty
  · apply Subtype.ext
    rw [divisorMulPresheafApp_coe_of_nonempty g D hU,
      divisorSectionAction_coe_of_nonempty D U hU,
      divisorSectionAction_coe_of_nonempty (D - principalDivisor g) U hU,
      divisorMulPresheafApp_coe_of_nonempty g D hU]
    ac_rfl
  · letI := divisorSections_subsingleton_of_empty
      (D := D - principalDivisor g) hU
    exact Subsingleton.elim _ _

/-- Multiplication by a function-field unit as a morphism of structure-sheaf
modules. -/
noncomputable def divisorMulModule (g : X.left.functionFieldˣ)
    (D : CurveDivisor k X) :
    divisorModule D ⟶ divisorModule (D - principalDivisor g) where
  val := by
    letI sourceInstances : ∀ W,
        Module (X.left.ringCatSheaf.obj.obj W) ((divisorAbPresheaf D).obj W) :=
      fun W => divisorSectionsModule D W.unop
    letI targetInstances : ∀ W,
        Module (X.left.ringCatSheaf.obj.obj W)
          ((divisorAbPresheaf (D - principalDivisor g)).obj W) :=
      fun W => divisorSectionsModule (D - principalDivisor g) W.unop
    exact
      { app := fun U => ModuleCat.ofHom
          { toFun := divisorMulPresheafApp (k := k) g D U.unop
            map_add' := map_add _
            map_smul' := fun r s => divisorMulPresheafApp_action g D U.unop r s }
        naturality := fun {U V} i => by
          ext s
          exact DFunLike.congr_fun
            (congrArg ModuleCat.Hom.hom ((divisorMulPresheaf g D).naturality i)) s }

@[simp]
lemma divisorMulModule_app_apply (g : X.left.functionFieldˣ)
    (D : CurveDivisor k X) (U : X.left.Opens) (s : Γ(divisorModule D, U)) :
    (divisorMulModule g D).app U s =
      divisorMulPresheafApp (k := k) g D U s := by
  rfl

/-- Multiplication by a function-field unit is an isomorphism of divisor
modules. -/
lemma divisorMulModule_isIso (g : X.left.functionFieldˣ)
    (D : CurveDivisor k X) : IsIso (divisorMulModule g D) := by
  rw [Scheme.Modules.Hom.isIso_iff_isIso_app]
  intro U
  rw [ConcreteCategory.isIso_iff_bijective]
  change Function.Bijective (divisorMulPresheafApp (k := k) g D U)
  exact divisorMulPresheafApp_bijective g D U

/-- The divisor-module isomorphism induced by multiplication by the specified
function-field unit `g`; no independence from `g` is asserted. -/
noncomputable def mulEquivDivisorModule (g : X.left.functionFieldˣ)
    (D : CurveDivisor k X) :
    divisorModule D ≅ divisorModule (D - principalDivisor g) := by
  letI := divisorMulModule_isIso g D
  exact asIso (divisorMulModule g D)

end
end Hartshorne
