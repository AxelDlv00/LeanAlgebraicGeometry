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
  rw [glueData_t C P U V, glueData_f C P V U]
  rw [← Spec.map_comp, ← CommRingCat.ofHom_comp]
  rfl

set_option synthInstance.maxHeartbeats 3200000 in
-- The nested pullback comparison requires deep instance synthesis.
set_option maxHeartbeats 12800000 in
-- The explicit two-projection factorization requires the larger elaboration budget.
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
    rw [pullback_congrHom_hom_fst
      (glueData_ι_gluedMap C P V) rfl]
    rw [Scheme.Pullback.t_fst_fst]
    rw [rightRestrictionBaseChangeMap_fst (C := C) P U V]
    rw [pullback_congrHom_hom_fst_assoc
      (glueData_f_comp_inclusion_comp_gluedMap C P U V) rfl
      (Spec.map (CommRingCat.ofHom
        (rightRestrictionBaseChangeAlgHom C P U V).toRingHom))]
    rw [← glueData_t_comp_f_eq_spec_rightRestriction C P U V]
    exact (gluingOverlapFlatteningIso_hom_comp_fst_comp_t_f C P U V).symm
  · simp only [Category.assoc]
    rw [pullback_congrHom_hom_snd
      (glueData_ι_gluedMap C P V) rfl]
    rw [Scheme.Pullback.t_fst_snd]
    rw [rightRestrictionBaseChangeMap_snd (C := C) P U V]
    rw [pullback_congrHom_hom_snd
      (glueData_f_comp_inclusion_comp_gluedMap C P U V) rfl]
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

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
