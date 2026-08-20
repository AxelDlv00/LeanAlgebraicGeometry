/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageGluingOverlapIsoPreSndTFstSnd

/-!
# The second projection of the right gluing-leg source factorization

This module proves the second pullback projection equation before the final
comparison with the canonical separably closed atlas.
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
-- The second projection keeps the chart/base pullback transport opaque.
set_option maxHeartbeats 12800000 in
set_option backward.isDefEq.respectTransparency false in
theorem gluingOverlapIso_pre_snd_snd
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
        (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).t U V ≫
            (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
              (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).f V U ≫ q)
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

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
