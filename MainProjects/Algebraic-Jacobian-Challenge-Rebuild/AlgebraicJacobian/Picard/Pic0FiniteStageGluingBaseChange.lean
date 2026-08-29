/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageChartBaseChange

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

set_option synthInstance.maxHeartbeats 3200000 in
-- Projecting the package retains nested finite-subextension scalar towers.
set_option maxHeartbeats 12800000 in
/-- The base change of the finite-stage glue is the gluing of its base-changed charts. -/
noncomputable def baseChangeGluingIso
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) :
    pullback P.presentation.map
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) ≅
      (Scheme.Pullback.gluing P.presentation.glueData.openCover P.presentation.map
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).glued :=
  limit.isoLimitCone
    ⟨_, Scheme.Pullback.gluedIsLimit P.presentation.glueData.openCover P.presentation.map
      (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))⟩

set_option synthInstance.maxHeartbeats 3200000 in
-- The chart comparison elaborates the package's dependent scalar towers.
set_option maxHeartbeats 12800000 in
/-- A chart in the base-changed gluing is its corresponding exact Picard chart. -/
noncomputable def gluingChartIso
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U : Pic0FiniteStageChartIndex C) :
    (Scheme.Pullback.gluing P.presentation.glueData.openCover P.presentation.map
      (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).U U ≅
      (pic0SepClosedAtlasOpenCover C).X U :=
  pullback.congrHom (by
    change P.presentation.glueData.ι U ≫ P.presentation.map = _
    simpa only [presentation_glueData, presentation_mapData,
      gluedMapData_chartMap] using P.presentation.chartMap_factor U) rfl ≪≫
    chartBaseChangeIso C P U

/-! As for chart maps, keep the overlap structure map as one named term.  The overlap
carrier is a dependent tensor product; an inferred `Algebra` witness is not interchangeable
with the witness used by the finite-stage comparison. -/

set_option synthInstance.maxHeartbeats 400000 in
set_option maxHeartbeats 12800000 in
/-- The pinned structure map from a finite-stage overlap to the field of definition. -/
noncomputable def overlapBaseChangeMap
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    Spec (CommRingCat.of
      (Pic0FiniteStageOverlapBaseChangeRing
        C P.L P.n P.m P.relation P.M P.N U V)) ⟶ Spec (.of P.N.1) :=
  letI : CommRing
      (Pic0FiniteStageOverlapBaseChangeRing
        C P.L P.n P.m P.relation P.M P.N U V) :=
    pic0FiniteStageOverlapBaseChangeCommRing
      C P.L P.n P.m P.relation P.M P.N U V
  letI : Algebra P.N.1
      (Pic0FiniteStageOverlapBaseChangeRing
        C P.L P.n P.m P.relation P.M P.N U V) :=
    pic0FiniteStageOverlapBaseChangeAlgebra
      C P.L P.n P.m P.relation P.M P.N U V
  Spec.map (CommRingCat.ofHom
    (@algebraMap P.N.1
      (Pic0FiniteStageOverlapBaseChangeRing
        C P.L P.n P.m P.relation P.M P.N U V)
      (inferInstance : CommSemiring P.N.1)
      (pic0FiniteStageOverlapBaseChangeCommRing
        C P.L P.n P.m P.relation P.M P.N U V).toSemiring
      (pic0FiniteStageOverlapBaseChangeAlgebra
        C P.L P.n P.m P.relation P.M P.N U V)))

set_option synthInstance.maxHeartbeats 3200000 in
-- The overlap comparison elaborates the package's dependent scalar towers.
set_option maxHeartbeats 12800000 in
/-- Base change of a finite-stage overlap recovers the corresponding exact affine overlap. -/
noncomputable def overlapBaseChangeIso
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    pullback (overlapBaseChangeMap C P U V)
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) ≅
      (pic0FiniteStageAffineOverlap C U V).1.toScheme :=
  letI : CommRing
      (Pic0FiniteStageOverlapBaseChangeRing
        C P.L P.n P.m P.relation P.M P.N U V) :=
    pic0FiniteStageOverlapBaseChangeCommRing
      C P.L P.n P.m P.relation P.M P.N U V
  letI : Algebra P.N.1
      (Pic0FiniteStageOverlapBaseChangeRing
        C P.L P.n P.m P.relation P.M P.N U V) :=
    pic0FiniteStageOverlapBaseChangeAlgebra
      C P.L P.n P.m P.relation P.M P.N U V
  letI : Algebra P.N.1
      (Pic0FiniteStageFinalModelRing C P.L P.n P.m P.relation P.M P.N
        (Sum.inr (U, V))) :=
    pic0FiniteStageFinalModelRingAlgebra C P.L P.n P.m P.relation P.M P.N
      (Sum.inr (U, V))
  letI : Module P.N.1
      (Pic0FiniteStageFinalModelRing C P.L P.n P.m P.relation P.M P.N
        (Sum.inr (U, V))) :=
    pic0FiniteStageFinalModelRingModule C P.L P.n P.m P.relation P.M P.N
      (Sum.inr (U, V))
  letI : CommRing
      (Pic0FiniteStageFinalModelRing C P.L P.n P.m P.relation P.M P.N
        (Sum.inr (U, V))) :=
    pic0FiniteStageFinalModelRingCommRing C P.L P.n P.m P.relation P.M P.N
      (Sum.inr (U, V))
  letI : CommSemiring
      (Pic0FiniteStageFinalModelRing C P.L P.n P.m P.relation P.M P.N
        (Sum.inr (U, V))) :=
    (inferInstance : CommRing
      (Pic0FiniteStageFinalModelRing C P.L P.n P.m P.relation P.M P.N
        (Sum.inr (U, V)))).toCommSemiring
  letI : Semiring
      (Pic0FiniteStageFinalModelRing C P.L P.n P.m P.relation P.M P.N
        (Sum.inr (U, V))) :=
    (pic0FiniteStageFinalModelRingCommSemiring C P.L P.n P.m P.relation P.M P.N
      (Sum.inr (U, V))).toSemiring
  letI : CommRing
      (k ⊗[P.N.1] Pic0FiniteStageFinalModelRing C P.L P.n P.m P.relation P.M P.N
        (Sum.inr (U, V))) :=
    @Algebra.TensorProduct.instCommRing P.N.1 k
      (Pic0FiniteStageFinalModelRing C P.L P.n P.m P.relation P.M P.N
        (Sum.inr (U, V)))
      (inferInstance : CommSemiring P.N.1)
      (inferInstance : CommRing k)
      (inferInstance : Algebra P.N.1 k)
      (inferInstance : CommSemiring
        (Pic0FiniteStageFinalModelRing C P.L P.n P.m P.relation P.M P.N
          (Sum.inr (U, V))))
      (pic0FiniteStageFinalModelRingAlgebra C P.L P.n P.m P.relation P.M P.N
        (Sum.inr (U, V)))
  letI : CommSemiring
      (k ⊗[P.N.1] Pic0FiniteStageFinalModelRing C P.L P.n P.m P.relation P.M P.N
        (Sum.inr (U, V))) :=
    (inferInstance : CommRing
      (k ⊗[P.N.1] Pic0FiniteStageFinalModelRing C P.L P.n P.m P.relation P.M P.N
        (Sum.inr (U, V)))).toCommSemiring
  letI : Semiring
      (k ⊗[P.N.1] Pic0FiniteStageFinalModelRing C P.L P.n P.m P.relation P.M P.N
        (Sum.inr (U, V))) :=
    (inferInstance : CommSemiring
      (k ⊗[P.N.1] Pic0FiniteStageFinalModelRing C P.L P.n P.m P.relation P.M P.N
        (Sum.inr (U, V)))).toSemiring
  letI : Algebra k
      (k ⊗[P.N.1] Pic0FiniteStageFinalModelRing C P.L P.n P.m P.relation P.M P.N
        (Sum.inr (U, V))) :=
    pic0FiniteStageFinalScalarExtensionAlgebra C P.L P.n P.m P.relation P.M P.N
      (Sum.inr (U, V))
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
