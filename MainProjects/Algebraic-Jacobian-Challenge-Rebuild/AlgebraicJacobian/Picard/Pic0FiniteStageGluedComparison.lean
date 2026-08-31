/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageGluingOverlapIsoSnd

/-!
# The global finite-stage Picard gluing comparison

The chart and overlap comparisons identify the two multicoequalizer diagrams, hence
their glued schemes.  Composing this global comparison with compatibility of gluing
and base change identifies the scalar extension of the finite-stage model with the
exact separably closed Picard representer.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

noncomputable section

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] [IsSepClosed k]

namespace Pic0FiniteStageGluePackage

private noncomputable abbrev baseChangedGlueData
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) : Scheme.GlueData :=
  Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
    (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))

set_option synthInstance.maxHeartbeats 3200000 in
-- Descending the chart maps checks the dependent overlap comparison once.
set_option maxHeartbeats 12800000 in
set_option backward.isDefEq.respectTransparency false in
private noncomputable def gluingGluedHom
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) :
    (baseChangedGlueData C P).glued ⟶
      (pic0SepClosedAtlasGlueData C).glued := by
  fapply Multicoequalizer.desc
  · intro U
    exact (gluingChartIso C P U).hom ≫
      (pic0SepClosedAtlasGlueData C).ι U
  · rintro ⟨U, V⟩
    change
      (baseChangedGlueData C P).f U V ≫
          ((gluingChartIso C P U).hom ≫
            (pic0SepClosedAtlasGlueData C).ι U) =
        ((baseChangedGlueData C P).t U V ≫
            (baseChangedGlueData C P).f V U) ≫
          ((gluingChartIso C P V).hom ≫
            (pic0SepClosedAtlasGlueData C).ι V)
    calc
      _ = ((baseChangedGlueData C P).f U V ≫
            (gluingChartIso C P U).hom) ≫
          (pic0SepClosedAtlasGlueData C).ι U :=
        (Category.assoc _ _ _).symm
      _ = ((gluingOverlapIso C P U V).hom ≫
            (pic0SepClosedAtlasGlueData C).f U V) ≫
          (pic0SepClosedAtlasGlueData C).ι U :=
        congrArg (fun q => q ≫ (pic0SepClosedAtlasGlueData C).ι U)
          (gluingOverlapIso_fst C P U V)
      _ = (gluingOverlapIso C P U V).hom ≫
          ((pic0SepClosedAtlasGlueData C).f U V ≫
            (pic0SepClosedAtlasGlueData C).ι U) :=
        Category.assoc _ _ _
      _ = (gluingOverlapIso C P U V).hom ≫
          ((pic0SepClosedAtlasGlueData C).t U V ≫
            (pic0SepClosedAtlasGlueData C).f V U ≫
              (pic0SepClosedAtlasGlueData C).ι V) :=
        congrArg (fun q => (gluingOverlapIso C P U V).hom ≫ q)
          ((pic0SepClosedAtlasGlueData C).glue_condition U V).symm
      _ = ((gluingOverlapIso C P U V).hom ≫
            ((pic0SepClosedAtlasGlueData C).t U V ≫
              (pic0SepClosedAtlasGlueData C).f V U)) ≫
          (pic0SepClosedAtlasGlueData C).ι V := by
        simp only [Category.assoc]
      _ = (((baseChangedGlueData C P).t U V ≫
              (baseChangedGlueData C P).f V U) ≫
            (gluingChartIso C P V).hom) ≫
          (pic0SepClosedAtlasGlueData C).ι V :=
        congrArg (fun q => q ≫ (pic0SepClosedAtlasGlueData C).ι V)
          (gluingOverlapIso_snd C P U V).symm
      _ = _ := Category.assoc _ _ _

set_option synthInstance.maxHeartbeats 3200000 in
-- Projecting the descended map unfolds the multicoequalizer descriptor.
set_option maxHeartbeats 12800000 in
set_option backward.isDefEq.respectTransparency false in
@[reassoc]
private theorem gluingGluedHom_ι
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U : Pic0FiniteStageChartIndex C) :
    (baseChangedGlueData C P).ι U ≫ gluingGluedHom C P =
      (gluingChartIso C P U).hom ≫
        (pic0SepClosedAtlasGlueData C).ι U := by
  unfold gluingGluedHom
  exact Multicoequalizer.π_desc _ _ _ _ _

set_option synthInstance.maxHeartbeats 3200000 in
-- Cancelling the overlap isomorphism retains the dependent glued objects.
set_option maxHeartbeats 12800000 in
set_option backward.isDefEq.respectTransparency false in
private theorem gluingOverlapIso_inv_fst
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    (pic0SepClosedAtlasGlueData C).f U V ≫
        (gluingChartIso C P U).inv =
      (gluingOverlapIso C P U V).inv ≫
        (baseChangedGlueData C P).f U V := by
  apply (cancel_epi (gluingOverlapIso C P U V).hom).1
  calc
    _ = ((gluingOverlapIso C P U V).hom ≫
          (pic0SepClosedAtlasGlueData C).f U V) ≫
        (gluingChartIso C P U).inv :=
      (Category.assoc _ _ _).symm
    _ = (((baseChangedGlueData C P).f U V ≫
          (gluingChartIso C P U).hom)) ≫
        (gluingChartIso C P U).inv :=
      congrArg (fun q => q ≫ (gluingChartIso C P U).inv)
        (gluingOverlapIso_fst C P U V).symm
    _ = (baseChangedGlueData C P).f U V := by simp
    _ = (gluingOverlapIso C P U V).hom ≫
        ((gluingOverlapIso C P U V).inv ≫
          (baseChangedGlueData C P).f U V) := by simp

set_option synthInstance.maxHeartbeats 3200000 in
-- The right inverse projection crosses both transition legs of the glue data.
set_option maxHeartbeats 12800000 in
set_option backward.isDefEq.respectTransparency false in
private theorem gluingOverlapIso_inv_snd
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    ((pic0SepClosedAtlasGlueData C).t U V ≫
        (pic0SepClosedAtlasGlueData C).f V U) ≫
      (gluingChartIso C P V).inv =
    (gluingOverlapIso C P U V).inv ≫
      ((baseChangedGlueData C P).t U V ≫
        (baseChangedGlueData C P).f V U) := by
  apply (cancel_epi (gluingOverlapIso C P U V).hom).1
  calc
    _ = ((gluingOverlapIso C P U V).hom ≫
          ((pic0SepClosedAtlasGlueData C).t U V ≫
            (pic0SepClosedAtlasGlueData C).f V U)) ≫
        (gluingChartIso C P V).inv :=
      (Category.assoc _ _ _).symm
    _ = (((baseChangedGlueData C P).t U V ≫
            (baseChangedGlueData C P).f V U) ≫
          (gluingChartIso C P V).hom) ≫
        (gluingChartIso C P V).inv :=
      congrArg (fun q => q ≫ (gluingChartIso C P V).inv)
        (gluingOverlapIso_snd C P U V).symm
    _ = (baseChangedGlueData C P).t U V ≫
        (baseChangedGlueData C P).f V U := by simp
    _ = (gluingOverlapIso C P U V).hom ≫
        ((gluingOverlapIso C P U V).inv ≫
          ((baseChangedGlueData C P).t U V ≫
            (baseChangedGlueData C P).f V U)) := by simp

set_option synthInstance.maxHeartbeats 3200000 in
-- Descending the inverse chart maps checks the reverse overlap comparison once.
set_option maxHeartbeats 12800000 in
set_option backward.isDefEq.respectTransparency false in
private noncomputable def gluingGluedInv
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) :
    (pic0SepClosedAtlasGlueData C).glued ⟶
      (baseChangedGlueData C P).glued := by
  fapply Multicoequalizer.desc
  · intro U
    exact (gluingChartIso C P U).inv ≫
      (baseChangedGlueData C P).ι U
  · rintro ⟨U, V⟩
    change
      (pic0SepClosedAtlasGlueData C).f U V ≫
          ((gluingChartIso C P U).inv ≫
            (baseChangedGlueData C P).ι U) =
        ((pic0SepClosedAtlasGlueData C).t U V ≫
            (pic0SepClosedAtlasGlueData C).f V U) ≫
          ((gluingChartIso C P V).inv ≫
            (baseChangedGlueData C P).ι V)
    calc
      _ = ((pic0SepClosedAtlasGlueData C).f U V ≫
            (gluingChartIso C P U).inv) ≫
          (baseChangedGlueData C P).ι U :=
        (Category.assoc _ _ _).symm
      _ = ((gluingOverlapIso C P U V).inv ≫
            (baseChangedGlueData C P).f U V) ≫
          (baseChangedGlueData C P).ι U :=
        congrArg (fun q => q ≫ (baseChangedGlueData C P).ι U)
          (gluingOverlapIso_inv_fst C P U V)
      _ = (gluingOverlapIso C P U V).inv ≫
          ((baseChangedGlueData C P).f U V ≫
            (baseChangedGlueData C P).ι U) :=
        Category.assoc _ _ _
      _ = (gluingOverlapIso C P U V).inv ≫
          ((baseChangedGlueData C P).t U V ≫
            (baseChangedGlueData C P).f V U ≫
              (baseChangedGlueData C P).ι V) :=
        congrArg (fun q => (gluingOverlapIso C P U V).inv ≫ q)
          ((baseChangedGlueData C P).glue_condition U V).symm
      _ = ((gluingOverlapIso C P U V).inv ≫
            ((baseChangedGlueData C P).t U V ≫
              (baseChangedGlueData C P).f V U)) ≫
          (baseChangedGlueData C P).ι V := by
        simp only [Category.assoc]
      _ = (((pic0SepClosedAtlasGlueData C).t U V ≫
              (pic0SepClosedAtlasGlueData C).f V U) ≫
            (gluingChartIso C P V).inv) ≫
          (baseChangedGlueData C P).ι V :=
        congrArg (fun q => q ≫ (baseChangedGlueData C P).ι V)
          (gluingOverlapIso_inv_snd C P U V).symm
      _ = _ := Category.assoc _ _ _

set_option synthInstance.maxHeartbeats 3200000 in
-- Projecting the descended inverse unfolds the multicoequalizer descriptor.
set_option maxHeartbeats 12800000 in
set_option backward.isDefEq.respectTransparency false in
@[reassoc]
private theorem gluingGluedInv_ι
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U : Pic0FiniteStageChartIndex C) :
    (pic0SepClosedAtlasGlueData C).ι U ≫ gluingGluedInv C P =
      (gluingChartIso C P U).inv ≫
        (baseChangedGlueData C P).ι U := by
  unfold gluingGluedInv
  exact Multicoequalizer.π_desc _ _ _ _ _

set_option synthInstance.maxHeartbeats 3200000 in
-- Check the glued inverse law one chart at a time without expanding the full diagram.
set_option maxHeartbeats 12800000 in
set_option backward.isDefEq.respectTransparency false in
private theorem gluingGluedHom_inv
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) :
    gluingGluedHom C P ≫ gluingGluedInv C P = 𝟙 _ := by
  apply Multicoequalizer.hom_ext
  intro U
  calc
    (baseChangedGlueData C P).ι U ≫
        (gluingGluedHom C P ≫ gluingGluedInv C P) =
      ((baseChangedGlueData C P).ι U ≫ gluingGluedHom C P) ≫
        gluingGluedInv C P := (Category.assoc _ _ _).symm
    _ = ((gluingChartIso C P U).hom ≫
          (pic0SepClosedAtlasGlueData C).ι U) ≫
        gluingGluedInv C P :=
      congrArg (fun q => q ≫ gluingGluedInv C P)
        (gluingGluedHom_ι C P U)
    _ = (gluingChartIso C P U).hom ≫
        ((pic0SepClosedAtlasGlueData C).ι U ≫ gluingGluedInv C P) :=
      Category.assoc _ _ _
    _ = (gluingChartIso C P U).hom ≫
        ((gluingChartIso C P U).inv ≫
          (baseChangedGlueData C P).ι U) :=
      congrArg (fun q => (gluingChartIso C P U).hom ≫ q)
        (gluingGluedInv_ι C P U)
    _ = (baseChangedGlueData C P).ι U := by simp
    _ = (baseChangedGlueData C P).ι U ≫ 𝟙 _ := by simp

set_option synthInstance.maxHeartbeats 3200000 in
-- Check the reverse glued inverse law through the same pinned chart boundary.
set_option maxHeartbeats 12800000 in
set_option backward.isDefEq.respectTransparency false in
private theorem gluingGluedInv_hom
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) :
    gluingGluedInv C P ≫ gluingGluedHom C P = 𝟙 _ := by
  apply Multicoequalizer.hom_ext
  intro U
  calc
    (pic0SepClosedAtlasGlueData C).ι U ≫
        (gluingGluedInv C P ≫ gluingGluedHom C P) =
      ((pic0SepClosedAtlasGlueData C).ι U ≫ gluingGluedInv C P) ≫
        gluingGluedHom C P := (Category.assoc _ _ _).symm
    _ = ((gluingChartIso C P U).inv ≫
          (baseChangedGlueData C P).ι U) ≫
        gluingGluedHom C P :=
      congrArg (fun q => q ≫ gluingGluedHom C P)
        (gluingGluedInv_ι C P U)
    _ = (gluingChartIso C P U).inv ≫
        ((baseChangedGlueData C P).ι U ≫ gluingGluedHom C P) :=
      Category.assoc _ _ _
    _ = (gluingChartIso C P U).inv ≫
        ((gluingChartIso C P U).hom ≫
          (pic0SepClosedAtlasGlueData C).ι U) :=
      congrArg (fun q => (gluingChartIso C P U).inv ≫ q)
        (gluingGluedHom_ι C P U)
    _ = (pic0SepClosedAtlasGlueData C).ι U := by simp
    _ = (pic0SepClosedAtlasGlueData C).ι U ≫ 𝟙 _ := by simp

set_option synthInstance.maxHeartbeats 3200000 in
-- The record stores opaque inverse laws instead of their dependent proof terms.
set_option maxHeartbeats 12800000 in
set_option backward.isDefEq.respectTransparency false in
/-- The glued base-changed finite-stage atlas is the canonical exact Picard atlas glue. -/
noncomputable def gluingGluedIso
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) :
    (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).glued ≅
      (pic0SepClosedAtlasGlueData C).glued where
  hom := gluingGluedHom C P
  inv := gluingGluedInv C P
  hom_inv_id := gluingGluedHom_inv C P
  inv_hom_id := gluingGluedInv_hom C P

private noncomputable def exactAtlasFromGluedIso :
    (pic0SepClosedAtlasGlueData C).glued ≅
      (pic0_sepClosed_representableBy (C := C)).1.left := by
  change (pic0SepClosedAtlasOpenCover C).gluedCover.glued ≅
    (pic0_sepClosed_representableBy (C := C)).1.left
  exact asIso (pic0SepClosedAtlasOpenCover C).fromGlued

set_option synthInstance.maxHeartbeats 3200000 in
-- Compose the three large glued isomorphisms without unfolding their implementations.
set_option maxHeartbeats 12800000 in
/-- Scalar extension of the descended finite-stage glue recovers the exact separably
closed Picard representing scheme. -/
noncomputable def finiteStageBaseChangeIso
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) :
    pullback P.gluedMap
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) ≅
      (pic0_sepClosed_representableBy (C := C)).1.left :=
  baseChangeGluingIso C P ≪≫
    gluingGluedIso C P ≪≫
      exactAtlasFromGluedIso C

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
