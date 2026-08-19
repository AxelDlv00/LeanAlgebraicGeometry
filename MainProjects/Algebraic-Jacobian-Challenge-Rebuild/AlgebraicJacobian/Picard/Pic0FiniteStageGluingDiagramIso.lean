/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageOverlapBaseChange
import AlgebraicJacobian.Picard.Pic0FiniteStageRestrictionNaturality

/-!
# The finite-stage Picard gluing diagram after base change

The chart and overlap comparisons identify the multispan diagram obtained by
base-changing the finite-stage gluing with the canonical diagram of the exact
separably closed atlas.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits TensorProduct
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

/-- The spectrum of an algebra homomorphism lies over the base spectrum. -/
theorem specMap_algHom_comp_algebraMap
    {R A B : Type u} [CommRing R] [CommRing A] [CommRing B]
    [Algebra R A] [Algebra R B] (r : A →ₐ[R] B) :
    Spec.map (CommRingCat.ofHom r.toRingHom) ≫
        Spec.map (CommRingCat.ofHom (algebraMap R A)) =
      Spec.map (CommRingCat.ofHom (algebraMap R B)) := by
  rw [← Spec.map_comp]
  rw [← CommRingCat.ofHom_comp]
  congr 1
  ext x
  exact r.commutes x

@[reassoc]
theorem pullback_congrHom_hom_fst
    {X Y Z : Scheme.{u}} {f₁ f₂ : X ⟶ Z} {g₁ g₂ : Y ⟶ Z}
    (h₁ : f₁ = f₂) (h₂ : g₁ = g₂)
    [HasPullback f₁ g₁] [HasPullback f₂ g₂] :
    (pullback.congrHom h₁ h₂).hom ≫ pullback.fst f₂ g₂ =
      pullback.fst f₁ g₁ := by
  subst f₂
  subst g₂
  simp [pullback.congrHom, pullback.map]

@[reassoc]
theorem pullback_congrHom_hom_snd
    {X Y Z : Scheme.{u}} {f₁ f₂ : X ⟶ Z} {g₁ g₂ : Y ⟶ Z}
    (h₁ : f₁ = f₂) (h₂ : g₁ = g₂)
    [HasPullback f₁ g₁] [HasPullback f₂ g₂] :
    (pullback.congrHom h₁ h₂).hom ≫ pullback.snd f₂ g₂ =
      pullback.snd f₁ g₁ := by
  subst f₂
  subst g₂
  simp [pullback.congrHom, pullback.map]

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] [IsSepClosed k]

namespace Pic0FiniteStageGluePackage

set_option synthInstance.maxHeartbeats 3200000 in
-- The composite retains the package's dependent finite-subextension towers.
set_option maxHeartbeats 12800000 in
/-- The finite-stage overlap structure map becomes the canonical structure map
after scalar extension to the separably closed field. -/
theorem glueData_f_comp_inclusion_comp_gluedMap
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    P.glueData.f U V ≫ P.glueData.ι U ≫ P.gluedMap =
      Spec.map (CommRingCat.ofHom
        (algebraMap P.N.1
          (Pic0FiniteStageOverlapBaseChangeRing
            C P.L P.n P.m P.relation P.M P.N U V))) := by
  rw [glueData_f C P U V, glueData_ι_gluedMap C P U]
  exact specMap_algHom_comp_algebraMap
    (restrictionBaseChangeAlgHom C P U V)

/-- The spectrum of the exact left restriction, followed by the chart's affine
identification, is the affine-overlap identification. -/
theorem exactRestrictionAlgHom_fromSpec
    (U V : Pic0FiniteStageChartIndex C) :
    Spec.map (CommRingCat.ofHom
        (exactRestrictionAlgHom C U V).toRingHom) ≫
        U.1.2.fromSpec =
      (pic0FiniteStageAffineOverlap C U V).2.fromSpec := by
  change Spec.map (CommRingCat.ofHom
      (pic0FiniteStageRestrictionLeft C U V).toRingHom) ≫
      U.1.2.fromSpec = _
  change Spec.map
      ((pic0_sepClosed_representableBy (C := C)).1.left.presheaf.map
        (homOfLE (pic0FiniteStageAffineOverlap_le_left C U V)).op) ≫
      U.1.2.fromSpec = _
  exact U.1.2.map_fromSpec (pic0FiniteStageAffineOverlap C U V).2
    (homOfLE (pic0FiniteStageAffineOverlap_le_left C U V)).op

set_option synthInstance.maxHeartbeats 3200000 in
-- Explicit legs avoid unfolding the package while rewriting gluing projections.
set_option maxHeartbeats 12800000 in
@[reassoc]
theorem restrictionBaseChangeMap_fst
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    restrictionBaseChangeMap C P U V ≫
        pullback.fst
          (Spec.map (CommRingCat.ofHom
            (algebraMap P.N.1
              (Pic0FiniteStageChartBaseChangeRing
                C P.L P.n P.m P.relation P.M P.N U))))
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) =
      pullback.fst
          (Spec.map (CommRingCat.ofHom
            (algebraMap P.N.1
              (Pic0FiniteStageOverlapBaseChangeRing
                C P.L P.n P.m P.relation P.M P.N U V))))
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) ≫
        Spec.map (CommRingCat.ofHom
          (restrictionBaseChangeAlgHom C P U V).toRingHom) := by
  exact affineBaseChangeMap_fst P.N.1 k
    (Pic0FiniteStageChartBaseChangeRing
      C P.L P.n P.m P.relation P.M P.N U)
    (Pic0FiniteStageOverlapBaseChangeRing
      C P.L P.n P.m P.relation P.M P.N U V)
    (restrictionBaseChangeAlgHom C P U V)

set_option synthInstance.maxHeartbeats 3200000 in
-- Explicit legs avoid unfolding the package while rewriting gluing projections.
set_option maxHeartbeats 12800000 in
@[reassoc]
theorem restrictionBaseChangeMap_snd
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    restrictionBaseChangeMap C P U V ≫
        pullback.snd
          (Spec.map (CommRingCat.ofHom
            (algebraMap P.N.1
              (Pic0FiniteStageChartBaseChangeRing
                C P.L P.n P.m P.relation P.M P.N U))))
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) =
      pullback.snd
        (Spec.map (CommRingCat.ofHom
          (algebraMap P.N.1
            (Pic0FiniteStageOverlapBaseChangeRing
              C P.L P.n P.m P.relation P.M P.N U V))))
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) := by
  exact affineBaseChangeMap_snd P.N.1 k
    (Pic0FiniteStageChartBaseChangeRing
      C P.L P.n P.m P.relation P.M P.N U)
    (Pic0FiniteStageOverlapBaseChangeRing
      C P.L P.n P.m P.relation P.M P.N U V)
    (restrictionBaseChangeAlgHom C P U V)

set_option synthInstance.maxHeartbeats 3200000 in
-- The two projections reduce to the specialized flattening identities.
set_option maxHeartbeats 12800000 in
set_option backward.isDefEq.respectTransparency false in
theorem gluingOverlapIso_pre_fst
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).f U V ≫
        (pullback.congrHom (glueData_ι_gluedMap C P U) rfl).hom =
      (gluingOverlapFlatteningIso C P U V).hom ≫
        (pullback.congrHom
          (glueData_f_comp_inclusion_comp_gluedMap C P U V) rfl).hom ≫
        restrictionBaseChangeMap C P U V := by
  apply pullback.hom_ext
    (f := Spec.map (CommRingCat.ofHom
      (algebraMap P.N.1
        (Pic0FiniteStageChartBaseChangeRing
          C P.L P.n P.m P.relation P.M P.N U))))
    (g := Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))
  · simp only [Category.assoc]
    refine Eq.trans
      (congrArg
        (fun q =>
          (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
            (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).f U V ≫ q)
        (pullback_congrHom_hom_fst (glueData_ι_gluedMap C P U) rfl)) ?_
    refine Eq.trans ?_
      (congrArg
        (fun q =>
          (gluingOverlapFlatteningIso C P U V).hom ≫
            (pullback.congrHom
              (glueData_f_comp_inclusion_comp_gluedMap C P U V) rfl).hom ≫ q)
        (restrictionBaseChangeMap_fst (C := C) P U V)).symm
    refine Eq.trans ?_
      (congrArg
        (fun q => (gluingOverlapFlatteningIso C P U V).hom ≫ q)
        (pullback_congrHom_hom_fst_assoc
          (glueData_f_comp_inclusion_comp_gluedMap C P U V) rfl
          (Spec.map (CommRingCat.ofHom
            (restrictionBaseChangeAlgHom C P U V).toRingHom)))).symm
    refine Eq.trans ?_
      (congrArg
        (fun q =>
          (gluingOverlapFlatteningIso C P U V).hom ≫
            pullback.fst
              (P.glueData.f U V ≫ P.glueData.ι U ≫ P.gluedMap)
              (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) ≫ q)
        (glueData_f C P U V))
    exact (gluingOverlapFlatteningIso_hom_comp_fst_comp_f C P U V).symm
  · simp only [Category.assoc]
    refine Eq.trans
      (congrArg
        (fun q =>
          (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
            (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).f U V ≫ q)
        (pullback_congrHom_hom_snd (glueData_ι_gluedMap C P U) rfl)) ?_
    refine Eq.trans ?_
      (congrArg
        (fun q =>
          (gluingOverlapFlatteningIso C P U V).hom ≫
            (pullback.congrHom
              (glueData_f_comp_inclusion_comp_gluedMap C P U V) rfl).hom ≫ q)
        (restrictionBaseChangeMap_snd (C := C) P U V)).symm
    refine Eq.trans ?_
      (congrArg
        (fun q => (gluingOverlapFlatteningIso C P U V).hom ≫ q)
        (pullback_congrHom_hom_snd
          (glueData_f_comp_inclusion_comp_gluedMap C P U V) rfl)).symm
    exact (gluingOverlapFlatteningIso_hom_comp_snd C P U V).symm

set_option synthInstance.maxHeartbeats 3200000 in
-- Raw tensor carriers keep the dependent finite-subextension instances visible.
set_option maxHeartbeats 12800000 in
/-- An overlap in the base-changed finite-stage gluing is the corresponding
overlap in the canonical gluing diagram of the exact Picard atlas. -/
noncomputable def gluingOverlapIso
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).V (U, V) ≅
      (pic0SepClosedAtlasGlueData C).V (U, V) := by
  exact
    gluingOverlapFlatteningIso C P U V ≪≫
      pullback.congrHom (glueData_f_comp_inclusion_comp_gluedMap C P U V) rfl ≪≫
      overlapBaseChangeIso C P U V ≪≫
      (isPullback_opens_inf U.1.1 V.1.1).isoPullback

set_option synthInstance.maxHeartbeats 3200000 in
set_option maxHeartbeats 12800000 in
theorem gluingOverlapIso_fst
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).f U V ≫
        (gluingChartIso C P U).hom =
      (gluingOverlapIso C P U V).hom ≫
        (pic0SepClosedAtlasGlueData C).f U V := by
  have chart_fac :
      (chartBaseChangeIso C P U).hom ≫ U.1.1.ι =
        (chartRingBaseChangeIso C P U).hom ≫ U.1.2.fromSpec := by
    simp only [chartBaseChangeIso, chartRingBaseChangeIso,
      affineBaseChangeIso, Iso.trans_hom, Category.assoc,
      IsAffineOpen.isoSpec_inv_ι]
  have overlap_fac :
      (overlapBaseChangeIso C P U V).hom ≫
          (pic0FiniteStageAffineOverlap C U V).1.ι =
        (overlapRingBaseChangeIso C P U V).hom ≫
          (pic0FiniteStageAffineOverlap C U V).2.fromSpec := by
    simp only [overlapBaseChangeIso, overlapRingBaseChangeIso,
      affineBaseChangeIso, Iso.trans_hom, Category.assoc,
      IsAffineOpen.isoSpec_inv_ι]
  rw [← cancel_mono U.1.1.ι]
  simp only [gluingChartIso, gluingOverlapIso, Iso.trans_hom,
    pic0SepClosedAtlasGlueData, Scheme.Cover.gluedCover, Category.assoc]
  rw [chart_fac]
  rw [reassoc_of% gluingOverlapIso_pre_fst C P U V]
  rw [reassoc_of% restrictionBaseChangeMap_naturality C P U V]
  rw [reassoc_of% exactRestrictionAlgHom_fromSpec C U V]
  rw [IsPullback.isoPullback_hom_fst_assoc, Scheme.homOfLE_ι]
  rw [overlap_fac]

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
