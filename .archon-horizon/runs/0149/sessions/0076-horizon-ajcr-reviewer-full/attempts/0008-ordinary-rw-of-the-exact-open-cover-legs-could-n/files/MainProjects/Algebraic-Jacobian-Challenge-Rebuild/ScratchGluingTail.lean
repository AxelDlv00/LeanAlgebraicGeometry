import AlgebraicJacobian.Picard.Pic0FiniteStageGluingBaseChange
import AlgebraicJacobian.Picard.Pic0FiniteStageRestrictionNaturality

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
set_option backward.isDefEq.respectTransparency false in
example
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    (chartBaseChangeIso C P U).hom ≫ U.1.1.ι =
      (chartRingBaseChangeIso C P U).hom ≫ U.1.2.fromSpec := by
  calc
    _ = (chartRingBaseChangeIso C P U).hom ≫
        (U.1.2.isoSpec.inv ≫ U.1.1.ι) := by
      simp only [chartBaseChangeIso, chartRingBaseChangeIso,
        chartFinalBaseChangeEquiv, affineBaseChangeIso, Iso.trans_hom,
        Iso.symm_hom, Category.assoc]
    _ = _ := congrArg (fun q => (chartRingBaseChangeIso C P U).hom ≫ q)
      U.1.2.isoSpec_inv_ι

set_option synthInstance.maxHeartbeats 3200000 in
set_option maxHeartbeats 12800000 in
set_option backward.isDefEq.respectTransparency false in
example
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
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

set_option synthInstance.maxHeartbeats 3200000 in
set_option maxHeartbeats 12800000 in
set_option backward.isDefEq.respectTransparency false in
example
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    restrictionBaseChangeMap C P U V ≫
          (chartRingBaseChangeIso C P U).hom ≫ U.1.2.fromSpec =
      (overlapRingBaseChangeIso C P U V).hom ≫
        (pic0FiniteStageAffineOverlap C U V).2.fromSpec := by
  have exact_fac :
      Spec.map (CommRingCat.ofHom
          (exactRestrictionAlgHom C U V).toRingHom) ≫ U.1.2.fromSpec =
        (pic0FiniteStageAffineOverlap C U V).2.fromSpec := by
    change Spec.map
        ((pic0_sepClosed_representableBy (C := C)).1.left.presheaf.map
          (homOfLE (pic0FiniteStageAffineOverlap_le_left C U V)).op) ≫
        U.1.2.fromSpec = _
    exact U.1.2.map_fromSpec (pic0FiniteStageAffineOverlap C U V).2
      (homOfLE (pic0FiniteStageAffineOverlap_le_left C U V)).op
  rw [← Category.assoc, restrictionBaseChangeMap_naturality C P U V]
  rw [Category.assoc, exact_fac]

set_option maxHeartbeats 3200000 in
example (U V : Pic0FiniteStageChartIndex C) :
    (isPullback_opens_inf U.1.1 V.1.1).isoPullback.hom ≫
          (pic0SepClosedAtlasGlueData C).f U V ≫ U.1.1.ι =
      (pic0FiniteStageAffineOverlap C U V).1.ι := by
  have cover_f (W : Pic0FiniteStageChartIndex C) :
      (pic0SepClosedAtlasOpenCover C).f W = W.1.1.ι := by
    simp only [pic0SepClosedAtlasOpenCover,
      Scheme.openCoverOfIsOpenCover_f]
  simp only [Category.assoc, pic0SepClosedAtlasGlueData,
    Scheme.Cover.gluedCover_f]
  rw [cover_f U, cover_f V]
  rw [IsPullback.isoPullback_hom_fst_assoc, Scheme.homOfLE_ι]

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
