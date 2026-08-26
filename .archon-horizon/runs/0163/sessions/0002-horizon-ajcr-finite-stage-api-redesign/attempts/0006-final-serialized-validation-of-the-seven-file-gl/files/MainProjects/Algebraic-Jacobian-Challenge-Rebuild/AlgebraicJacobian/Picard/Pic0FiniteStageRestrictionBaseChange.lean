/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageAffineBaseChange

/-!
# Naturality of finite-stage Picard restrictions after base change

The restriction legs in a finite-stage glue package are affine morphisms over the
final finite subextension.  Their pullbacks to the separably closed field agree,
under the final ring comparisons, with the canonical restrictions in the exact
Picard atlas.
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

-- Pin the descended restriction to the same nested tensor witnesses used by the
-- final-stage affine comparison APIs.  The raw scalar-extension definition
-- otherwise asks typeclass search to reconstruct the dependent model carrier.
private noncomputable def restrictionBaseChangeAlgHomCanonical
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    @AlgHom P.N.1
      (Pic0FiniteStageChartBaseChangeRing C P.L P.n P.m P.relation P.M P.N U)
      (Pic0FiniteStageOverlapBaseChangeRing C P.L P.n P.m P.relation P.M P.N U V)
      (inferInstance : CommSemiring P.N.1)
      (pic0FiniteStageFinalModelRingCommRing C P.L P.n P.m P.relation P.M P.N
        (Sum.inl U)).toSemiring
      (pic0FiniteStageOverlapBaseChangeRingCommRing C P.L P.n P.m P.relation P.M P.N U V).toSemiring
      (pic0FiniteStageFinalModelRingAlgebra C P.L P.n P.m P.relation P.M P.N
        (Sum.inl U))
      (pic0FiniteStageOverlapBaseChangeRingAlgebra C P.L P.n P.m P.relation P.M P.N U V) := by
  exact pic0FiniteStageModelScalarExtensionMap
    C P.L P.n P.m P.relation P.M P.N (Sum.inl U) (Sum.inr (U, V))
    (P.mapM (Sum.inl (Sum.inl (U, V))))

set_option synthInstance.maxHeartbeats 3200000 in
-- Projecting the package unfolds the dependent finite-subextension towers.
set_option maxHeartbeats 12800000 in
/-- The left restriction leg of the glue package is the spectrum of the
scalar-extended descended restriction. -/
theorem glueData_f
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    P.glueData.f U V =
      Spec.map (CommRingCat.ofHom
        (pic0FiniteStageRestrictionBaseChange
          C P.L P.n P.m P.relation P.M P.mapM P.N U V).toRingHom) := by
  change P.glueData.f U V =
    Spec.map (CommRingCat.ofHom
      (restrictionBaseChangeAlgHomCanonical C P U V).toRingHom)
  rfl

set_option synthInstance.maxHeartbeats 3200000 in
-- The annotation fixes the source and target instances hidden by dependent indices.
set_option maxHeartbeats 12800000 in
/-- The scalar-extended descended restriction, with its chart and overlap types
fixed opaquely for use by the affine base-change API. -/
noncomputable def restrictionBaseChangeAlgHom
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    Pic0FiniteStageChartBaseChangeRing
        C P.L P.n P.m P.relation P.M P.N U →ₐ[P.N.1]
      Pic0FiniteStageOverlapBaseChangeRing
        C P.L P.n P.m P.relation P.M P.N U V :=
  restrictionBaseChangeAlgHomCanonical C P U V

/-- The exact left restriction with indexed source and target rings.  Keeping
the indexed rings avoids relying on typeclass transparency for their aliases. -/
noncomputable def exactRestrictionAlgHom
    (U V : Pic0FiniteStageChartIndex C) :
    Pic0FiniteStageRing C (Sum.inl U) →ₐ[k]
      Pic0FiniteStageRing C (Sum.inr (U, V)) :=
  pic0FiniteStageMap C (Sum.inl (Sum.inl (U, V)))

set_option synthInstance.maxHeartbeats 3200000 in
-- The annotation fixes the indexed exact-ring instance on the chart target.
set_option maxHeartbeats 12800000 in
/-- Final scalar-extension comparison for a chart, with an indexed exact-ring
target. -/
noncomputable def chartFinalBaseChangeEquiv
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U : Pic0FiniteStageChartIndex C) :
    @AlgEquiv k
      (k ⊗[P.N.1]
        Pic0FiniteStageChartBaseChangeRing
          C P.L P.n P.m P.relation P.M P.N U)
      (Pic0FiniteStageRing C (Sum.inl U))
      (inferInstance : CommSemiring k)
      (pic0FiniteStageFinalScalarExtensionSemiring C P.L P.n P.m P.relation P.M P.N
        (Sum.inl U))
      (instCommRingPic0FiniteStageRing C (Sum.inl U)).toSemiring
      (pic0FiniteStageFinalScalarExtensionAlgebra C P.L P.n P.m P.relation P.M P.N
        (Sum.inl U))
      (instAlgebraPic0FiniteStageRing C (Sum.inl U)) :=
  pic0FiniteStageFinalBaseChangeEquiv
    C P.L P.n P.m P.relation P.e P.M P.N (Sum.inl U)

set_option synthInstance.maxHeartbeats 3200000 in
-- The annotation fixes the indexed exact-ring instance on the overlap target.
set_option maxHeartbeats 12800000 in
/-- Final scalar-extension comparison for an overlap, with an indexed
exact-ring target. -/
noncomputable def overlapFinalBaseChangeEquiv
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    @AlgEquiv k
      (k ⊗[P.N.1]
        Pic0FiniteStageOverlapBaseChangeRing
          C P.L P.n P.m P.relation P.M P.N U V)
      (Pic0FiniteStageRing C (Sum.inr (U, V)))
      (inferInstance : CommSemiring k)
      (pic0FiniteStageFinalScalarExtensionSemiring C P.L P.n P.m P.relation P.M P.N
        (Sum.inr (U, V)))
      (instCommRingPic0FiniteStageRing C (Sum.inr (U, V))).toSemiring
      (pic0FiniteStageFinalScalarExtensionAlgebra C P.L P.n P.m P.relation P.M P.N
        (Sum.inr (U, V)))
      (instAlgebraPic0FiniteStageRing C (Sum.inr (U, V))) :=
  pic0FiniteStageFinalBaseChangeEquiv
    C P.L P.n P.m P.relation P.e P.M P.N (Sum.inr (U, V))

set_option synthInstance.maxHeartbeats 3200000 in
-- Specializing the generic pullback map infers both scalar-extended model rings.
set_option maxHeartbeats 12800000 in
/-- Pullback of a finite-stage left restriction from an overlap to its left
chart. -/
noncomputable def restrictionBaseChangeMap
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
              C P.L P.n P.m P.relation P.M P.N U))))
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) :=
  affineBaseChangeMap P.N.1 k
    (Pic0FiniteStageChartBaseChangeRing
      C P.L P.n P.m P.relation P.M P.N U)
    (Pic0FiniteStageOverlapBaseChangeRing
      C P.L P.n P.m P.relation P.M P.N U V)
    (restrictionBaseChangeAlgHom C P U V)

set_option synthInstance.maxHeartbeats 3200000 in
-- The chart comparison cancels the package's nested scalar extensions.
set_option maxHeartbeats 12800000 in
/-- The tensor-product and final-ring comparison for a chart, before applying
the chart's affine-open identification. -/
noncomputable def chartRingBaseChangeIso
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U : Pic0FiniteStageChartIndex C) :
    pullback
        (Spec.map (CommRingCat.ofHom
          (algebraMap P.N.1
            (Pic0FiniteStageChartBaseChangeRing
              C P.L P.n P.m P.relation P.M P.N U))))
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) ≅
      Spec (.of (Pic0FiniteStageRing C (Sum.inl U))) :=
  by
    letI : CommRing
        (Pic0FiniteStageChartBaseChangeRing C P.L P.n P.m P.relation P.M P.N U) :=
      pic0FiniteStageFinalModelRingCommRing C P.L P.n P.m P.relation P.M P.N
        (Sum.inl U)
    letI : CommSemiring
        (Pic0FiniteStageChartBaseChangeRing C P.L P.n P.m P.relation P.M P.N U) :=
      (inferInstance : CommRing
        (Pic0FiniteStageChartBaseChangeRing C P.L P.n P.m P.relation P.M P.N U)).toCommSemiring
    letI : Semiring
        (Pic0FiniteStageChartBaseChangeRing C P.L P.n P.m P.relation P.M P.N U) :=
      (inferInstance : CommSemiring
        (Pic0FiniteStageChartBaseChangeRing C P.L P.n P.m P.relation P.M P.N U)).toSemiring
    letI : Algebra P.N.1
        (Pic0FiniteStageChartBaseChangeRing C P.L P.n P.m P.relation P.M P.N U) :=
      pic0FiniteStageFinalModelRingAlgebra C P.L P.n P.m P.relation P.M P.N
        (Sum.inl U)
    letI : CommRing
        (k ⊗[P.N.1]
          Pic0FiniteStageChartBaseChangeRing C P.L P.n P.m P.relation P.M P.N U) :=
      @Algebra.TensorProduct.instCommRing P.N.1 k
        (Pic0FiniteStageChartBaseChangeRing C P.L P.n P.m P.relation P.M P.N U)
        (inferInstance : CommSemiring P.N.1) (inferInstance : CommRing k)
        (inferInstance : Algebra P.N.1 k)
        (inferInstance : CommSemiring
          (Pic0FiniteStageChartBaseChangeRing C P.L P.n P.m P.relation P.M P.N U))
        (inferInstance : Algebra P.N.1
          (Pic0FiniteStageChartBaseChangeRing C P.L P.n P.m P.relation P.M P.N U))
    letI : CommSemiring
        (k ⊗[P.N.1]
          Pic0FiniteStageChartBaseChangeRing C P.L P.n P.m P.relation P.M P.N U) :=
      (inferInstance : CommRing
        (k ⊗[P.N.1]
          Pic0FiniteStageChartBaseChangeRing C P.L P.n P.m P.relation P.M P.N U)).toCommSemiring
    letI : Semiring
        (k ⊗[P.N.1]
          Pic0FiniteStageChartBaseChangeRing C P.L P.n P.m P.relation P.M P.N U) :=
      pic0FiniteStageFinalScalarExtensionSemiring C P.L P.n P.m P.relation P.M P.N
        (Sum.inl U)
    letI : Algebra k
        (k ⊗[P.N.1]
          Pic0FiniteStageChartBaseChangeRing C P.L P.n P.m P.relation P.M P.N U) :=
      pic0FiniteStageFinalScalarExtensionAlgebra C P.L P.n P.m P.relation P.M P.N
        (Sum.inl U)
    exact affineBaseChangeIso P.N.1 k
        (Pic0FiniteStageChartBaseChangeRing
          C P.L P.n P.m P.relation P.M P.N U) ≪≫
      Scheme.Spec.mapIso
        (chartFinalBaseChangeEquiv C P U).symm.toRingEquiv.toCommRingCatIso.op

set_option synthInstance.maxHeartbeats 3200000 in
-- The overlap comparison cancels the package's nested scalar extensions.
set_option maxHeartbeats 12800000 in
/-- The tensor-product and final-ring comparison for an overlap, before applying
the overlap's affine-open identification. -/
noncomputable def overlapRingBaseChangeIso
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    pullback
        (Spec.map (CommRingCat.ofHom
          (algebraMap P.N.1
            (Pic0FiniteStageOverlapBaseChangeRing
              C P.L P.n P.m P.relation P.M P.N U V))))
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) ≅
      Spec (.of (Pic0FiniteStageRing C (Sum.inr (U, V)))) :=
  by
    letI : CommRing
        (Pic0FiniteStageOverlapBaseChangeRing C P.L P.n P.m P.relation P.M P.N U V) :=
      pic0FiniteStageFinalModelRingCommRing C P.L P.n P.m P.relation P.M P.N
        (Sum.inr (U, V))
    letI : CommSemiring
        (Pic0FiniteStageOverlapBaseChangeRing C P.L P.n P.m P.relation P.M P.N U V) :=
      (inferInstance : CommRing
        (Pic0FiniteStageOverlapBaseChangeRing C P.L P.n P.m P.relation P.M P.N U V)).toCommSemiring
    letI : Semiring
        (Pic0FiniteStageOverlapBaseChangeRing C P.L P.n P.m P.relation P.M P.N U V) :=
      (inferInstance : CommSemiring
        (Pic0FiniteStageOverlapBaseChangeRing C P.L P.n P.m P.relation P.M P.N U V)).toSemiring
    letI : Algebra P.N.1
        (Pic0FiniteStageOverlapBaseChangeRing C P.L P.n P.m P.relation P.M P.N U V) :=
      pic0FiniteStageFinalModelRingAlgebra C P.L P.n P.m P.relation P.M P.N
        (Sum.inr (U, V))
    letI : CommRing
        (k ⊗[P.N.1]
          Pic0FiniteStageOverlapBaseChangeRing C P.L P.n P.m P.relation P.M P.N U V) :=
      @Algebra.TensorProduct.instCommRing P.N.1 k
        (Pic0FiniteStageOverlapBaseChangeRing C P.L P.n P.m P.relation P.M P.N U V)
        (inferInstance : CommSemiring P.N.1) (inferInstance : CommRing k)
        (inferInstance : Algebra P.N.1 k)
        (inferInstance : CommSemiring
          (Pic0FiniteStageOverlapBaseChangeRing C P.L P.n P.m P.relation P.M P.N U V))
        (inferInstance : Algebra P.N.1
          (Pic0FiniteStageOverlapBaseChangeRing C P.L P.n P.m P.relation P.M P.N U V))
    letI : CommSemiring
        (k ⊗[P.N.1]
          Pic0FiniteStageOverlapBaseChangeRing C P.L P.n P.m P.relation P.M P.N U V) :=
      (inferInstance : CommRing
        (k ⊗[P.N.1]
          Pic0FiniteStageOverlapBaseChangeRing C P.L P.n P.m P.relation P.M P.N U V)).toCommSemiring
    letI : Semiring
        (k ⊗[P.N.1]
          Pic0FiniteStageOverlapBaseChangeRing C P.L P.n P.m P.relation P.M P.N U V) :=
      pic0FiniteStageFinalScalarExtensionSemiring C P.L P.n P.m P.relation P.M P.N
        (Sum.inr (U, V))
    letI : Algebra k
        (k ⊗[P.N.1]
          Pic0FiniteStageOverlapBaseChangeRing C P.L P.n P.m P.relation P.M P.N U V) :=
      pic0FiniteStageFinalScalarExtensionAlgebra C P.L P.n P.m P.relation P.M P.N
        (Sum.inr (U, V))
    exact affineBaseChangeIso P.N.1 k
        (Pic0FiniteStageOverlapBaseChangeRing
          C P.L P.n P.m P.relation P.M P.N U V) ≪≫
      Scheme.Spec.mapIso
        (overlapFinalBaseChangeEquiv C P U V).symm.toRingEquiv.toCommRingCatIso.op

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
