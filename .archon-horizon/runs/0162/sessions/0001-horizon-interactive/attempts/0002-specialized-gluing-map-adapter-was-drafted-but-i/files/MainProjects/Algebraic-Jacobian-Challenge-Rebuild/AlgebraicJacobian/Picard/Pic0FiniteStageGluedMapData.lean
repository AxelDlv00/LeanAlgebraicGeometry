/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Descent.FiniteStagePullbackData
import AlgebraicJacobian.Descent.GluedMapData
import AlgebraicJacobian.Picard.Pic0FiniteStageChartBaseChange
import AlgebraicJacobian.Picard.Pic0FiniteStageGluedOver

/-!
# Packaged finite-stage gluing maps and overlap pullbacks

The finite-stage gluing construction has a large proof-local block of algebra
instances.  Consumers should only need the resulting map and the chosen overlap
cones.  This adapter exposes both as explicit data, so later declarations do not
reconstruct `HasPullback` or unfold `gluedMap` merely to recover a projection.
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

/-- The structure morphism of a finite-stage glue, with all chart restrictions named. -/
noncomputable def gluedMapData
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) :
    AlgebraicJacobian.GluedMapData P.glueData (Spec (.of P.N.1)) :=
  { map := P.gluedMap
    chartMap := fun U =>
      Spec.map (CommRingCat.ofHom
        (algebraMap P.N.1
          (Pic0FiniteStageChartBaseChangeRing
            C P.L P.n P.m P.relation P.M P.N U)))
    chartMap_factor := fun U => glueData_ι_gluedMap C P U }

@[simp]
theorem gluedMapData_map
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) :
    (P.gluedMapData C).map = P.gluedMap :=
  rfl

@[simp]
theorem gluedMapData_chartMap
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) (U : Pic0FiniteStageChartIndex C) :
    (P.gluedMapData C).chartMap U =
      Spec.map (CommRingCat.ofHom
        (algebraMap P.N.1
          (Pic0FiniteStageChartBaseChangeRing
            C P.L P.n P.m P.relation P.M P.N U))) :=
  rfl

/-- The chosen overlap cone from the glue datum, packaged without a `HasPullback`
inference at the use site. -/
noncomputable def overlapPullbackData
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    AlgebraicJacobian.PullbackData (P.glueData.ι U) (P.glueData.ι V) :=
  { cone := P.glueData.vPullbackCone U V
    isLimit := P.glueData.vPullbackConeIsLimit U V }

@[simp]
theorem overlapPullbackData_fst
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    (P.overlapPullbackData C U V).fst = P.glueData.f U V :=
  rfl

@[simp]
theorem overlapPullbackData_snd
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    (P.overlapPullbackData C U V).snd = P.glueData.t U V ≫ P.glueData.f V U :=
  rfl

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
