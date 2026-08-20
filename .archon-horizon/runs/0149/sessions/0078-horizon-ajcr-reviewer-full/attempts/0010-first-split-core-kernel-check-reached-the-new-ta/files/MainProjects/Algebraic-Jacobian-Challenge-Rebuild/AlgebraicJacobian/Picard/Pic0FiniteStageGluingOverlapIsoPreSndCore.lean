/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageGluingDiagramIso
import AlgebraicJacobian.Picard.Pic0FiniteStageGluingRightBaseChange

/-!
# Core formulas for the source factorization of the right gluing leg

This module records the transition formula and the fixed-parameter pullback
projection equations used by the two projection branches of the right gluing
comparison.
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
theorem baseChangedGluing_t_fst_fst
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).t U V ≫
      (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).f V U ≫
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
theorem baseChangedGluing_t_fst_snd
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).t U V ≫
      (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).f V U ≫
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

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
