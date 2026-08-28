/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageGluingRightBaseChange

/-!
# The source factorization for the right gluing leg

This module identifies the right leg of the base-changed gluing diagram before
the final comparison with the canonical separably closed atlas.
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
-- The explicit transition formula avoids unfolding the full glue datum downstream.
theorem glueData_t
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    P.glueData.t U V =
      Spec.map (CommRingCat.ofHom
        (pic0FiniteStageTransitionBaseChange
          C P.L P.n P.m P.relation P.M P.mapM P.N U V).toRingHom) := by
  rfl

set_option synthInstance.maxHeartbeats 3200000 in
-- Raw ring maps avoid introducing hidden algebra instances in dependent glue carriers.
set_option maxHeartbeats 12800000 in
theorem specMap_ringHom_comp
    {A B D : Type u} [CommRing A] [CommRing B] [CommRing D]
    (f : A →+* B) (g : B →+* D) :
    Spec.map (CommRingCat.ofHom g) ≫
        Spec.map (CommRingCat.ofHom f) =
      Spec.map (CommRingCat.ofHom (g.comp f)) := by
  calc
    _ = Spec.map (CommRingCat.ofHom f ≫ CommRingCat.ofHom g) :=
      (Spec.map_comp (CommRingCat.ofHom f) (CommRingCat.ofHom g)).symm
    _ = _ := congrArg
      (fun q : CommRingCat.of A ⟶ CommRingCat.of D => Spec.map q)
      (CommRingCat.ofHom_comp f g).symm

set_option synthInstance.maxHeartbeats 3200000 in
-- The named scalar-extension maps retain the dependent carrier instances.
set_option maxHeartbeats 12800000 in
-- Functoriality is stated propositionally so later proofs do not rely on deep defeq.
theorem glueData_t_comp_f_eq_spec_rightRestriction
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    P.glueData.t U V ≫ P.glueData.f V U =
      Spec.map (CommRingCat.ofHom
        (rightRestrictionBaseChangeAlgHom C P U V).toRingHom) := by
  calc
    P.glueData.t U V ≫ P.glueData.f V U =
        Spec.map (CommRingCat.ofHom
          (pic0FiniteStageTransitionBaseChange
            C P.L P.n P.m P.relation P.M P.mapM P.N U V).toRingHom) ≫
          P.glueData.f V U :=
      congrArg (fun q => q ≫ P.glueData.f V U) (glueData_t C P U V)
    _ = Spec.map (CommRingCat.ofHom
          (pic0FiniteStageTransitionBaseChange
            C P.L P.n P.m P.relation P.M P.mapM P.N U V).toRingHom) ≫
        Spec.map (CommRingCat.ofHom
          (pic0FiniteStageRestrictionBaseChange
            C P.L P.n P.m P.relation P.M P.mapM P.N V U).toRingHom) :=
      congrArg
        (fun q => Spec.map (CommRingCat.ofHom
          (pic0FiniteStageTransitionBaseChange
            C P.L P.n P.m P.relation P.M P.mapM P.N U V).toRingHom) ≫ q)
        (glueData_f C P V U)
    _ = Spec.map (CommRingCat.ofHom
          ((pic0FiniteStageTransitionBaseChange
            C P.L P.n P.m P.relation P.M P.mapM P.N U V).comp
           (pic0FiniteStageRestrictionBaseChange
            C P.L P.n P.m P.relation P.M P.mapM P.N V U)).toRingHom) :=
      specMap_ringHom_comp
        (pic0FiniteStageRestrictionBaseChange
          C P.L P.n P.m P.relation P.M P.mapM P.N V U).toRingHom
        (pic0FiniteStageTransitionBaseChange
          C P.L P.n P.m P.relation P.M P.mapM P.N U V).toRingHom
    _ = _ := rfl

set_option synthInstance.maxHeartbeats 3200000 in
-- Fixing every gluing parameter prevents the cover index from reverting to a hidden `.J`.
set_option maxHeartbeats 12800000 in
private theorem baseChangedGluing_t_fst_fst
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    ((Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).t U V ≫
        (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).f V U) ≫
      pullback.fst
        (P.glueData.ι V ≫ P.gluedMap)
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) =
    pullback.snd
      (pullback.fst
          (P.glueData.ι U ≫ P.gluedMap)
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) ≫
        P.glueData.ι U)
      (P.glueData.ι V) := by
  exact Scheme.Pullback.t_fst_fst
    P.glueData.openCover P.gluedMap
      (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) U V

set_option synthInstance.maxHeartbeats 3200000 in
-- The corresponding base projection uses the same fixed cover-index boundary.
set_option maxHeartbeats 12800000 in
private theorem baseChangedGluing_t_fst_snd
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    ((Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).t U V ≫
        (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).f V U) ≫
      pullback.snd
        (P.glueData.ι V ≫ P.gluedMap)
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) =
    (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).f U V ≫
      pullback.snd
        (P.glueData.ι U ≫ P.gluedMap)
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) := by
  exact Scheme.Pullback.t_fst_snd
    P.glueData.openCover P.gluedMap
      (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) U V

set_option synthInstance.maxHeartbeats 3200000 in
-- The first projection keeps the final chart and base pullback explicit.
set_option maxHeartbeats 12800000 in
set_option backward.isDefEq.respectTransparency false in
private theorem gluingOverlapIso_pre_snd_fst
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    (((Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).t U V ≫
        (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).f V U) ≫
        (pullback.congrHom (glueData_ι_gluedMap C P V) rfl).hom) ≫
      pullback.fst
        (Spec.map (CommRingCat.ofHom
          (algebraMap P.N.1
            (Pic0FiniteStageChartBaseChangeRing
              C P.L P.n P.m P.relation P.M P.N V))))
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) =
    (((gluingOverlapFlatteningIso C P U V).hom ≫
        (pullback.congrHom
          (glueData_f_comp_inclusion_comp_gluedMap C P U V) rfl).hom) ≫
        rightRestrictionBaseChangeMap C P U V) ≫
      pullback.fst
        (Spec.map (CommRingCat.ofHom
          (algebraMap P.N.1
            (Pic0FiniteStageChartBaseChangeRing
              C P.L P.n P.m P.relation P.M P.N V))))
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) := by
  simp only [Category.assoc]
  have hι_fst :
      (pullback.congrHom (glueData_ι_gluedMap C P V) rfl).hom ≫
          pullback.fst
            (Spec.map (CommRingCat.ofHom
              (algebraMap P.N.1
                (Pic0FiniteStageChartBaseChangeRing
                  C P.L P.n P.m P.relation P.M P.N V))))
            (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) =
        pullback.fst (P.glueData.ι V ≫ P.gluedMap)
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) :=
    pullback_congrHom_hom_fst (glueData_ι_gluedMap C P V) rfl
  have hfst :
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
            (rightRestrictionBaseChangeAlgHom C P U V).toRingHom) :=
    rightRestrictionBaseChangeMap_fst (C := C) (P := P) (U := U) (V := V)
  have hcongr_fst :
      (pullback.congrHom
          (glueData_f_comp_inclusion_comp_gluedMap C P U V) rfl).hom ≫
        pullback.fst
          (Spec.map (CommRingCat.ofHom
            (algebraMap P.N.1
              (Pic0FiniteStageOverlapBaseChangeRing
                C P.L P.n P.m P.relation P.M P.N U V))))
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) ≫
        Spec.map (CommRingCat.ofHom
          (rightRestrictionBaseChangeAlgHom C P U V).toRingHom) =
      pullback.fst
        (P.glueData.f U V ≫ P.glueData.ι U ≫ P.gluedMap)
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) ≫
        Spec.map (CommRingCat.ofHom
          (rightRestrictionBaseChangeAlgHom C P U V).toRingHom) :=
    pullback_congrHom_hom_fst_assoc
      (glueData_f_comp_inclusion_comp_gluedMap C P U V) rfl
      (Spec.map (CommRingCat.ofHom
        (rightRestrictionBaseChangeAlgHom C P U V).toRingHom))
  refine Eq.trans
    (congrArg
      (fun q =>
        ((Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).t U V ≫
            (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
              (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).f V U) ≫ q)
      hι_fst) ?_
  refine Eq.trans (baseChangedGluing_t_fst_fst C P U V) ?_
  refine Eq.trans ?_
    (congrArg
      (fun q =>
        (gluingOverlapFlatteningIso C P U V).hom ≫
          (pullback.congrHom
            (glueData_f_comp_inclusion_comp_gluedMap C P U V) rfl).hom ≫ q)
      hfst).symm
  refine Eq.trans ?_
    (congrArg
      (fun q => (gluingOverlapFlatteningIso C P U V).hom ≫ q)
      hcongr_fst).symm
  refine Eq.trans ?_
    (congrArg
      (fun q => (gluingOverlapFlatteningIso C P U V).hom ≫
        pullback.fst
          (P.glueData.f U V ≫ P.glueData.ι U ≫ P.gluedMap)
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) ≫ q)
      (glueData_t_comp_f_eq_spec_rightRestriction C P U V))
  exact (gluingOverlapFlatteningIso_hom_comp_fst_comp_t_f C P U V).symm

set_option synthInstance.maxHeartbeats 3200000 in
-- The second projection keeps the chart/base pullback transport opaque.
set_option maxHeartbeats 12800000 in
set_option backward.isDefEq.respectTransparency false in
private theorem gluingOverlapIso_pre_snd_snd
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    (((Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).t U V ≫
        (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).f V U) ≫
        (pullback.congrHom (glueData_ι_gluedMap C P V) rfl).hom) ≫
      pullback.snd
        (Spec.map (CommRingCat.ofHom
          (algebraMap P.N.1
            (Pic0FiniteStageChartBaseChangeRing
              C P.L P.n P.m P.relation P.M P.N V))))
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) =
    (((gluingOverlapFlatteningIso C P U V).hom ≫
        (pullback.congrHom
          (glueData_f_comp_inclusion_comp_gluedMap C P U V) rfl).hom) ≫
        rightRestrictionBaseChangeMap C P U V) ≫
      pullback.snd
        (Spec.map (CommRingCat.ofHom
          (algebraMap P.N.1
            (Pic0FiniteStageChartBaseChangeRing
              C P.L P.n P.m P.relation P.M P.N V))))
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) := by
  simp only [Category.assoc]
  have hι_snd :
      (pullback.congrHom (glueData_ι_gluedMap C P V) rfl).hom ≫
          pullback.snd
            (Spec.map (CommRingCat.ofHom
              (algebraMap P.N.1
                (Pic0FiniteStageChartBaseChangeRing
                  C P.L P.n P.m P.relation P.M P.N V))))
            (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) =
        pullback.snd (P.glueData.ι V ≫ P.gluedMap)
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) :=
    pullback_congrHom_hom_snd (glueData_ι_gluedMap C P V) rfl
  have hsnd :
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
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) :=
    rightRestrictionBaseChangeMap_snd (C := C) (P := P) (U := U) (V := V)
  have hcongr_snd :
      (pullback.congrHom
          (glueData_f_comp_inclusion_comp_gluedMap C P U V) rfl).hom ≫
        pullback.snd
          (Spec.map (CommRingCat.ofHom
            (algebraMap P.N.1
              (Pic0FiniteStageOverlapBaseChangeRing
                C P.L P.n P.m P.relation P.M P.N U V))))
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) =
      pullback.snd
        (P.glueData.f U V ≫ P.glueData.ι U ≫ P.gluedMap)
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) :=
    pullback_congrHom_hom_snd
      (glueData_f_comp_inclusion_comp_gluedMap C P U V) rfl
  refine Eq.trans
    (congrArg
      (fun q =>
        ((Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).t U V ≫
            (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
              (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).f V U) ≫ q)
      hι_snd) ?_
  refine Eq.trans (baseChangedGluing_t_fst_snd C P U V) ?_
  refine Eq.trans ?_
    (congrArg
      (fun q =>
        (gluingOverlapFlatteningIso C P U V).hom ≫
          (pullback.congrHom
            (glueData_f_comp_inclusion_comp_gluedMap C P U V) rfl).hom ≫ q)
      hsnd).symm
  refine Eq.trans ?_
    (congrArg
      (fun q => (gluingOverlapFlatteningIso C P U V).hom ≫ q)
      hcongr_snd).symm
  exact (gluingOverlapFlatteningIso_hom_comp_snd C P U V).symm

set_option synthInstance.maxHeartbeats 3200000 in
-- Assemble the separately cached projection factorizations.
set_option maxHeartbeats 12800000 in
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
  · simpa only [Category.assoc] using
      gluingOverlapIso_pre_snd_fst C P U V
  · simpa only [Category.assoc] using
      gluingOverlapIso_pre_snd_snd C P U V

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

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
