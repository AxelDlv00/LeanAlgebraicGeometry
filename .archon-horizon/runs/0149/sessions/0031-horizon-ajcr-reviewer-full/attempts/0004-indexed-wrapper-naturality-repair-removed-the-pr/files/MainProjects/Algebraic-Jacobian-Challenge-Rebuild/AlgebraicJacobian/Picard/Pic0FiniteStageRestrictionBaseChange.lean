/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageAffineBaseChange
import AlgebraicJacobian.Picard.Pic0FiniteStageGluingBaseChange

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
  (pic0FiniteStageRestrictionBaseChange
      C P.L P.n P.m P.relation P.M P.mapM P.N U V :
    Pic0FiniteStageChartBaseChangeRing
        C P.L P.n P.m P.relation P.M P.N U →ₐ[P.N.1]
      Pic0FiniteStageOverlapBaseChangeRing
        C P.L P.n P.m P.relation P.M P.N U V)

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
    k ⊗[P.N.1]
        Pic0FiniteStageChartBaseChangeRing
          C P.L P.n P.m P.relation P.M P.N U ≃ₐ[k]
      Pic0FiniteStageRing C (Sum.inl U) :=
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
    k ⊗[P.N.1]
        Pic0FiniteStageOverlapBaseChangeRing
          C P.L P.n P.m P.relation P.M P.N U V ≃ₐ[k]
      Pic0FiniteStageRing C (Sum.inr (U, V)) :=
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
  affineBaseChangeIso P.N.1 k
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
  affineBaseChangeIso P.N.1 k
      (Pic0FiniteStageOverlapBaseChangeRing
        C P.L P.n P.m P.relation P.M P.N U V) ≪≫
    Scheme.Spec.mapIso
      (overlapFinalBaseChangeEquiv
        C P U V).symm.toRingEquiv.toCommRingCatIso.op

set_option synthInstance.maxHeartbeats 3200000 in
-- Naturality elaborates the final comparison equivalences and their inverses.
set_option maxHeartbeats 12800000 in
/-- Scalar extension of the finite-stage restriction intertwines the final-ring
comparisons with the exact restriction on affine coordinate rings. -/
theorem restrictionSpec_naturality
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    Spec.map (CommRingCat.ofHom
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := P.N.1) (K := k)
          (restrictionBaseChangeAlgHom C P U V)).toRingHom) ≫
      (Scheme.Spec.mapIso
        (chartFinalBaseChangeEquiv
          C P U).symm.toRingEquiv.toCommRingCatIso.op).hom =
    (Scheme.Spec.mapIso
      (overlapFinalBaseChangeEquiv
        C P U V).symm.toRingEquiv.toCommRingCatIso.op).hom ≫
      Spec.map (CommRingCat.ofHom
        (exactRestrictionAlgHom C U V).toRingHom) := by
  letI : Algebra.IsAlgebraic P.L.1 k := by infer_instance
  letI : Algebra.IsAlgebraic P.M.1 k := by infer_instance
  let eSource := chartFinalBaseChangeEquiv C P U
  let eTarget := overlapFinalBaseChangeEquiv C P U V
  let f := AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := P.N.1) (K := k) (restrictionBaseChangeAlgHom C P U V)
  let g := exactRestrictionAlgHom C U V
  have hnat : eTarget.toAlgHom.comp f = g.comp eSource.toAlgHom := by
    simpa only [eTarget, eSource, f, g, overlapFinalBaseChangeEquiv,
      chartFinalBaseChangeEquiv, restrictionBaseChangeAlgHom,
      exactRestrictionAlgHom] using
      (pic0FiniteStageFinalBaseChangeEquiv_naturality
        C P.L P.n P.m P.relation P.e P.M P.mapM P.hmapM P.N
          (Sum.inl (Sum.inl (U, V))))
  have hinv : f.comp eSource.symm.toAlgHom = eTarget.symm.toAlgHom.comp g := by
    ext x
    apply eTarget.injective
    have hx := DFunLike.congr_fun hnat (eSource.symm x)
    simpa using hx
  simp only [Functor.mapIso_hom, Iso.op_hom, Scheme.Spec_map,
    Quiver.Hom.unop_op]
  rw [← Spec.map_comp, ← Spec.map_comp]
  congr 1
  simpa only [← CommRingCat.ofHom_comp] using congrArg CommRingCat.ofHom hinv

set_option synthInstance.maxHeartbeats 3200000 in
-- The pullback square combines affine naturality with the final-ring square.
set_option maxHeartbeats 12800000 in
/-- The base-changed left restriction is the canonical exact restriction under
the tensor-product and final-ring comparisons. -/
theorem restrictionBaseChangeMap_naturality
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    restrictionBaseChangeMap C P U V ≫
        (chartRingBaseChangeIso C P U).hom =
      (overlapRingBaseChangeIso C P U V).hom ≫
        Spec.map (CommRingCat.ofHom
          (exactRestrictionAlgHom C U V).toRingHom) := by
  simp only [restrictionBaseChangeMap, chartRingBaseChangeIso,
    overlapRingBaseChangeIso, Iso.trans_hom]
  have haff := affineBaseChangeIso_naturality P.N.1 k
    (Pic0FiniteStageChartBaseChangeRing
      C P.L P.n P.m P.relation P.M P.N U)
    (Pic0FiniteStageOverlapBaseChangeRing
      C P.L P.n P.m P.relation P.M P.N U V)
    (restrictionBaseChangeAlgHom C P U V)
  calc
    _ = (affineBaseChangeMap P.N.1 k
          (Pic0FiniteStageChartBaseChangeRing
            C P.L P.n P.m P.relation P.M P.N U)
          (Pic0FiniteStageOverlapBaseChangeRing
            C P.L P.n P.m P.relation P.M P.N U V)
          (restrictionBaseChangeAlgHom C P U V) ≫
        (affineBaseChangeIso P.N.1 k
          (Pic0FiniteStageChartBaseChangeRing
            C P.L P.n P.m P.relation P.M P.N U)).hom) ≫
        (Scheme.Spec.mapIso
          (chartFinalBaseChangeEquiv
            C P U).symm.toRingEquiv.toCommRingCatIso.op).hom :=
      (Category.assoc _ _ _).symm
    _ = ((affineBaseChangeIso P.N.1 k
          (Pic0FiniteStageOverlapBaseChangeRing
            C P.L P.n P.m P.relation P.M P.N U V)).hom ≫
        Spec.map (CommRingCat.ofHom
          (AlgebraicJacobian.scalarExtensionMapOfAlgHom
            (R := P.N.1) (K := k)
            (restrictionBaseChangeAlgHom C P U V)).toRingHom)) ≫
        (Scheme.Spec.mapIso
          (chartFinalBaseChangeEquiv
            C P U).symm.toRingEquiv.toCommRingCatIso.op).hom :=
      congrArg
        (fun h => h ≫ (Scheme.Spec.mapIso
          (chartFinalBaseChangeEquiv
            C P U).symm.toRingEquiv.toCommRingCatIso.op).hom) haff
    _ = (affineBaseChangeIso P.N.1 k
          (Pic0FiniteStageOverlapBaseChangeRing
            C P.L P.n P.m P.relation P.M P.N U V)).hom ≫
        (Spec.map (CommRingCat.ofHom
          (AlgebraicJacobian.scalarExtensionMapOfAlgHom
            (R := P.N.1) (K := k)
            (restrictionBaseChangeAlgHom C P U V)).toRingHom) ≫
          (Scheme.Spec.mapIso
            (chartFinalBaseChangeEquiv
              C P U).symm.toRingEquiv.toCommRingCatIso.op).hom) :=
      Category.assoc _ _ _
    _ = (affineBaseChangeIso P.N.1 k
          (Pic0FiniteStageOverlapBaseChangeRing
            C P.L P.n P.m P.relation P.M P.N U V)).hom ≫
        ((Scheme.Spec.mapIso
          (overlapFinalBaseChangeEquiv
            C P U V).symm.toRingEquiv.toCommRingCatIso.op).hom ≫
          Spec.map (CommRingCat.ofHom
            (exactRestrictionAlgHom C U V).toRingHom)) :=
      congrArg
        (fun h => (affineBaseChangeIso P.N.1 k
          (Pic0FiniteStageOverlapBaseChangeRing
            C P.L P.n P.m P.relation P.M P.N U V)).hom ≫ h)
        (restrictionSpec_naturality C P U V)
    _ = _ := (Category.assoc _ _ _).symm

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
