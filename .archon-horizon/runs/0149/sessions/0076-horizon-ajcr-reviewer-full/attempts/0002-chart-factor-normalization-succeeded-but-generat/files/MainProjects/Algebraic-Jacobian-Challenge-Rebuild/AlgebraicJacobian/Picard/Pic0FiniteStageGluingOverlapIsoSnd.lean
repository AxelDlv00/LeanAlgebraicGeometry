/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageGluingDiagramIso
import AlgebraicJacobian.Picard.Pic0FiniteStageRightRestrictionNaturality

/-!
# The right leg of the finite-stage Picard gluing comparison

The overlap comparison in `Pic0FiniteStageGluingDiagramIso` respects the second
multispan leg as well as the first.  This is the remaining local naturality
equation needed to assemble the chart and overlap comparisons into a natural
isomorphism of gluing diagrams.
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
set_option maxHeartbeats 12800000 in
@[reassoc]
theorem rightRestrictionBaseChangeMap_fst
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    rightRestrictionBaseChangeMap C P U V ≫
        pullback.fst
          (Spec.map (CommRingCat.ofHom
            (algebraMap P.N.1
              (Pic0FiniteStageChartBaseChangeRing
                C P.L P.n P.m P.relation P.M P.N V))))
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) =
      pullback.fst
          (Spec.map (CommRingCat.ofHom
            (algebraMap P.N.1
              (Pic0FiniteStageOverlapBaseChangeRing
                C P.L P.n P.m P.relation P.M P.N U V))))
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) ≫
        Spec.map (CommRingCat.ofHom
          (rightRestrictionBaseChangeAlgHom C P U V).toRingHom) := by
  exact affineBaseChangeMap_fst P.N.1 k
    (Pic0FiniteStageChartBaseChangeRing
      C P.L P.n P.m P.relation P.M P.N V)
    (Pic0FiniteStageOverlapBaseChangeRing
      C P.L P.n P.m P.relation P.M P.N U V)
    (rightRestrictionBaseChangeAlgHom C P U V)

set_option synthInstance.maxHeartbeats 3200000 in
set_option maxHeartbeats 12800000 in
@[reassoc]
theorem rightRestrictionBaseChangeMap_snd
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    rightRestrictionBaseChangeMap C P U V ≫
        pullback.snd
          (Spec.map (CommRingCat.ofHom
            (algebraMap P.N.1
              (Pic0FiniteStageChartBaseChangeRing
                C P.L P.n P.m P.relation P.M P.N V))))
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) =
      pullback.snd
        (Spec.map (CommRingCat.ofHom
          (algebraMap P.N.1
            (Pic0FiniteStageOverlapBaseChangeRing
              C P.L P.n P.m P.relation P.M P.N U V))))
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) := by
  exact affineBaseChangeMap_snd P.N.1 k
    (Pic0FiniteStageChartBaseChangeRing
      C P.L P.n P.m P.relation P.M P.N V)
    (Pic0FiniteStageOverlapBaseChangeRing
      C P.L P.n P.m P.relation P.M P.N U V)
    (rightRestrictionBaseChangeAlgHom C P U V)

set_option synthInstance.maxHeartbeats 3200000 in
set_option maxHeartbeats 12800000 in
set_option backward.isDefEq.respectTransparency false in
theorem gluingOverlapIso_pre_snd
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    ((Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).t U V ≫
        (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).f V U) ≫
        (pullback.congrHom (glueData_ι_gluedMap C P V) rfl).hom =
      (gluingOverlapFlatteningIso C P U V).hom ≫
        (pullback.congrHom
          (glueData_f_comp_inclusion_comp_gluedMap C P U V) rfl).hom ≫
        rightRestrictionBaseChangeMap C P U V := by
  apply pullback.hom_ext
    (f := Spec.map (CommRingCat.ofHom
      (algebraMap P.N.1
        (Pic0FiniteStageChartBaseChangeRing
          C P.L P.n P.m P.relation P.M P.N V))))
    (g := Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))
  · simp only [Category.assoc]
    refine Eq.trans
      (congrArg
        (fun q =>
          ((Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
            (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).t U V ≫
              (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
                (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).f V U) ≫ q)
        (pullback_congrHom_hom_fst (glueData_ι_gluedMap C P V) rfl)) ?_
    refine Eq.trans ?_
      (congrArg
        (fun q =>
          (gluingOverlapFlatteningIso C P U V).hom ≫
            (pullback.congrHom
              (glueData_f_comp_inclusion_comp_gluedMap C P U V) rfl).hom ≫ q)
        (rightRestrictionBaseChangeMap_fst (C := C) P U V)).symm
    refine Eq.trans ?_
      (congrArg
        (fun q => (gluingOverlapFlatteningIso C P U V).hom ≫ q)
        (pullback_congrHom_hom_fst_assoc
          (glueData_f_comp_inclusion_comp_gluedMap C P U V) rfl
          (Spec.map (CommRingCat.ofHom
            (rightRestrictionBaseChangeAlgHom C P U V).toRingHom)))).symm
    exact (gluingOverlapFlatteningIso_hom_comp_fst_comp_t_f C P U V).symm
  · simp only [Category.assoc]
    refine Eq.trans
      (congrArg
        (fun q =>
          ((Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
            (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).t U V ≫
              (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
                (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).f V U) ≫ q)
        (pullback_congrHom_hom_snd (glueData_ι_gluedMap C P V) rfl)) ?_
    refine Eq.trans ?_
      (congrArg
        (fun q =>
          (gluingOverlapFlatteningIso C P U V).hom ≫
            (pullback.congrHom
              (glueData_f_comp_inclusion_comp_gluedMap C P U V) rfl).hom ≫ q)
        (rightRestrictionBaseChangeMap_snd (C := C) P U V)).symm
    refine Eq.trans ?_
      (congrArg
        (fun q => (gluingOverlapFlatteningIso C P U V).hom ≫ q)
        (pullback_congrHom_hom_snd
          (glueData_f_comp_inclusion_comp_gluedMap C P U V) rfl)).symm
    exact (gluingOverlapFlatteningIso_hom_comp_snd C P U V).symm

/-- The spectrum of the exact right restriction, followed by the right chart's
affine identification, is the affine-overlap identification. -/
theorem exactRightRestrictionAlgHom_fromSpec
    (U V : Pic0FiniteStageChartIndex C) :
    Spec.map (CommRingCat.ofHom
        (exactRightRestrictionAlgHom C U V).toRingHom) ≫
        V.1.2.fromSpec =
      (pic0FiniteStageAffineOverlap C U V).2.fromSpec := by
  change Spec.map (CommRingCat.ofHom
      (pic0FiniteStageRestrictionRight C U V).toRingHom) ≫
      V.1.2.fromSpec = _
  change Spec.map
      ((pic0_sepClosed_representableBy (C := C)).1.left.presheaf.map
        (homOfLE (pic0FiniteStageAffineOverlap_le_right C U V)).op) ≫
      V.1.2.fromSpec = _
  exact V.1.2.map_fromSpec (pic0FiniteStageAffineOverlap C U V).2
    (homOfLE (pic0FiniteStageAffineOverlap_le_right C U V)).op

set_option synthInstance.maxHeartbeats 3200000 in
set_option maxHeartbeats 12800000 in
set_option backward.isDefEq.respectTransparency false in
/-- The overlap comparison respects the right multispan projection. -/
theorem gluingOverlapIso_snd
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    ((Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).t U V ≫
        (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).f V U) ≫
        (gluingChartIso C P V).hom =
      (gluingOverlapIso C P U V).hom ≫
        ((pic0SepClosedAtlasGlueData C).t U V ≫
          (pic0SepClosedAtlasGlueData C).f V U) := by
  have chart_fac :
      (chartBaseChangeIso C P V).hom ≫ V.1.1.ι =
        (chartRingBaseChangeIso C P V).hom ≫ V.1.2.fromSpec := by
    calc
      _ = (chartRingBaseChangeIso C P V).hom ≫
          (V.1.2.isoSpec.inv ≫ V.1.1.ι) := by
        simp only [chartBaseChangeIso, chartRingBaseChangeIso,
          chartFinalBaseChangeEquiv, affineBaseChangeIso, Iso.trans_hom,
          Iso.symm_hom, Category.assoc]
      _ = _ := congrArg (fun q => (chartRingBaseChangeIso C P V).hom ≫ q)
        V.1.2.isoSpec_inv_ι
  have overlap_fac :
      (overlapBaseChangeIso C P U V).hom ≫
          (pic0FiniteStageAffineOverlap C U V).1.ι =
      (overlapRingBaseChangeIso C P U V).hom ≫
          (pic0FiniteStageAffineOverlap C U V).2.fromSpec := by
    calc
      _ = (overlapRingBaseChangeIso C P U V).hom ≫
          ((pic0FiniteStageAffineOverlap C U V).2.isoSpec.inv ≫
            (pic0FiniteStageAffineOverlap C U V).1.ι) := by
        simp only [overlapBaseChangeIso, overlapRingBaseChangeIso,
          overlapFinalBaseChangeEquiv, affineBaseChangeIso, Iso.trans_hom,
          Iso.symm_hom, Category.assoc]
      _ = _ := congrArg
        (fun q => (overlapRingBaseChangeIso C P U V).hom ≫ q)
        (pic0FiniteStageAffineOverlap C U V).2.isoSpec_inv_ι
  apply (cancel_mono V.1.1.ι).1
  simp only [gluingChartIso, Iso.trans_hom, Category.assoc]
  rw [chart_fac]
  rw [reassoc_of% gluingOverlapIso_pre_snd C P U V]
  simp only [gluingOverlapIso, Iso.trans_hom, Category.assoc]
  rw [reassoc_of% rightRestrictionBaseChangeMap_naturality C P U V]
  rw [reassoc_of% exactRightRestrictionAlgHom_fromSpec C U V]
  simp only [pic0SepClosedAtlasGlueData, Scheme.Cover.gluedCover_f,
    Scheme.Cover.gluedCover_t, pullbackSymmetry_hom_comp_fst]
  rw [IsPullback.isoPullback_hom_snd_assoc, Scheme.homOfLE_ι]
  rw [reassoc_of% overlap_fac]

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
