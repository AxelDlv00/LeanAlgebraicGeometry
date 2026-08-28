/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageChartBaseChange
import AlgebraicJacobian.Descent.FiniteStagePullbackData

/-!
# Base change of the finite-stage Picard gluing

The global base change of the finite-stage glued scheme is the scheme obtained by
gluing its locally base-changed charts.  The chart and overlap pullbacks are identified
with the corresponding exact separably closed affine opens.
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

/-! ### A named scalar-extended gluing presentation

`Scheme.Pullback.gluing` is a large dependent term: every occurrence re-runs the
chart pullback instance search and elaborates a fresh projection path.  Name the
chosen presentation once at this boundary.  The legacy declarations below can
still be stated using its projections, while consumers that need the exact object
carry this opaque value instead of repeating the constructor.
-/

set_option synthInstance.maxHeartbeats 3200000 in
set_option maxHeartbeats 12800000 in
noncomputable def baseChangeGlueData
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) : Scheme.GlueData :=
  Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
    (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))

@[simp]
theorem baseChangeGlueData_eq
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) :
    baseChangeGlueData C P =
      Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) :=
  rfl

noncomputable def baseChangeGlued
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) : Scheme.{u} :=
  (baseChangeGlueData C P).glued

set_option synthInstance.maxHeartbeats 3200000 in
-- Projecting the package retains nested finite-subextension scalar towers.
set_option maxHeartbeats 12800000 in
/-- The base change of the finite-stage glue is the gluing of its base-changed charts. -/
noncomputable def baseChangeGluingIso
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) :
  pullback P.gluedMap
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) ≅
      (baseChangeGlueData C P).glued :=
  (AlgebraicJacobian.PullbackData.ofHasPullback
      P.gluedMap (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).comparison
    (AlgebraicJacobian.schemeGluingPullbackData
      P.glueData.openCover P.gluedMap
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))))

set_option synthInstance.maxHeartbeats 3200000 in
-- The chart comparison elaborates the package's dependent scalar towers.
set_option maxHeartbeats 12800000 in
/-- A chart in the base-changed gluing is its corresponding exact Picard chart. -/
noncomputable def gluingChartIso
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U : Pic0FiniteStageChartIndex C) :
    (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
      (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).U U ≅
      (pic0SepClosedAtlasOpenCover C).X U :=
  pullback.congrHom (glueData_ι_gluedMap C P U) rfl ≪≫
    chartBaseChangeIso C P U

set_option synthInstance.maxHeartbeats 3200000 in
-- The overlap comparison elaborates the package's dependent scalar towers.
set_option maxHeartbeats 12800000 in
/-- Base change of a finite-stage overlap recovers the corresponding exact affine overlap. -/
noncomputable def overlapBaseChangeIso
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    pullback
        (Spec.map (CommRingCat.ofHom
          (algebraMap P.N.1
            (Pic0FiniteStageOverlapBaseChangeRing
              C P.L P.n P.m P.relation P.M P.N U V))))
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) ≅
      (pic0FiniteStageAffineOverlap C U V).1.toScheme :=
  pullbackSymmetry _ _ ≪≫
    pullbackSpecIso P.N.1 k
      (Pic0FiniteStageOverlapBaseChangeRing
        C P.L P.n P.m P.relation P.M P.N U V) ≪≫
    Scheme.Spec.mapIso
      (pic0FiniteStageFinalBaseChangeEquiv
        C P.L P.n P.m P.relation P.e P.M P.N
          (Sum.inr (U, V))).symm.toRingEquiv.toCommRingCatIso.op ≪≫
    (pic0FiniteStageAffineOverlap C U V).2.isoSpec.symm

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
