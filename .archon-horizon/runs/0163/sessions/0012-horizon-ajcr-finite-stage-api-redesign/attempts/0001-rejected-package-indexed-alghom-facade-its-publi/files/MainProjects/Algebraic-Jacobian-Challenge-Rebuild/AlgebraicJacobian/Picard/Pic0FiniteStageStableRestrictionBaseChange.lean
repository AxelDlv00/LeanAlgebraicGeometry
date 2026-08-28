/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageScalarExtendedAtlas
import AlgebraicJacobian.Picard.Pic0FiniteStageStableGluePackage

set_option autoImplicit false

universe u

open CategoryTheory TensorProduct
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] [IsSepClosed k]

namespace Pic0FiniteStageStableGluePackage

variable {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]

/-- The stable-package spelling of the left restriction carrier. -/
abbrev restrictionBaseChangeRing
    (P : Pic0FiniteStageStableGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) : Type u :=
  Pic0FiniteStageOverlapBaseChangeRing C P.L P.n P.m P.relation P.M P.N U V

/-- The stable-package spelling of the descended left restriction map. -/
noncomputable def restrictionBaseChange
    (P : Pic0FiniteStageStableGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    Pic0FiniteStageChartBaseChangeRing C P.L P.n P.m P.relation P.M P.N U →ₐ[P.N.1]
      restrictionBaseChangeRing C P U V :=
  pic0FiniteStageRestrictionBaseChange C P.L P.n P.m P.relation P.M P.mapM P.N U V

/-! The reversed overlap transition is exposed beside the restriction leg so callers can
assemble the descent diagram without reopening the legacy package namespace. -/

abbrev transitionBaseChangeRing
    (P : Pic0FiniteStageStableGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) : Type u :=
  Pic0FiniteStageOverlapBaseChangeRing C P.L P.n P.m P.relation P.M P.N V U

noncomputable def transitionBaseChange
    (P : Pic0FiniteStageStableGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    transitionBaseChangeRing C P U V →ₐ[P.N.1]
      restrictionBaseChangeRing C P U V :=
  pic0FiniteStageTransitionBaseChange C P.L P.n P.m P.relation P.M P.mapM P.N U V

end Pic0FiniteStageStableGluePackage

end

end AlgebraicGeometry
