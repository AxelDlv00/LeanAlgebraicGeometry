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

private theorem comp_snd_transport
    {X A B R D E Z : Scheme.{u}}
    (t : X ⟶ A) (f : A ⟶ B)
    (i : B ⟶ R) (p : R ⟶ Z) (q : B ⟶ Z) (m : X ⟶ Z)
    (l : X ⟶ D) (c : D ⟶ E)
    (r : E ⟶ R) (s : E ⟶ Z) (d : D ⟶ Z)
    (hι : i ≫ p = q) (ht : t ≫ f ≫ q = m)
    (hmap : r ≫ p = s) (hcongr : c ≫ s = d)
    (hflat : l ≫ d = m) :
    t ≫ f ≫ i ≫ p = l ≫ c ≫ r ≫ p := by
  calc
    _ = t ≫ f ≫ q := congrArg (fun x => t ≫ f ≫ x) hι
    _ = m := ht
    _ = l ≫ d := hflat.symm
    _ = l ≫ c ≫ s := congrArg (fun x => l ≫ x) hcongr.symm
    _ = l ≫ c ≫ r ≫ p :=
      congrArg (fun x => l ≫ c ≫ x) hmap.symm

set_option synthInstance.maxHeartbeats 3200000 in
-- The second projection keeps the chart/base pullback transport opaque.
set_option maxHeartbeats 12800000 in
set_option backward.isDefEq.respectTransparency false in
theorem gluingOverlapIso_pre_snd_snd
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).t U V ≫
      (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).f V U ≫
      (pullback.congrHom (glueData_ι_gluedMap C P V) rfl).hom ≫
      pullback.snd
        (Spec.map (CommRingCat.ofHom
          (algebraMap P.N.1
            (Pic0FiniteStageChartBaseChangeRing
              C P.L P.n P.m P.relation P.M P.N V))))
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) =
    (gluingOverlapFlatteningIso C P U V).hom ≫
      (pullback.congrHom
        (glueData_f_comp_inclusion_comp_gluedMap C P U V) rfl).hom ≫
      rightRestrictionBaseChangeMap C P U V ≫
      pullback.snd
        (Spec.map (CommRingCat.ofHom
          (algebraMap P.N.1
            (Pic0FiniteStageChartBaseChangeRing
              C P.L P.n P.m P.relation P.M P.N V))))
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) := by
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
  exact comp_snd_transport
    ((Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
      (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).t U V)
    ((Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
      (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).f V U)
    ((pullback.congrHom (glueData_ι_gluedMap C P V) rfl).hom)
    (pullback.snd
      (Spec.map (CommRingCat.ofHom
        (algebraMap P.N.1
          (Pic0FiniteStageChartBaseChangeRing
            C P.L P.n P.m P.relation P.M P.N V))))
      (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))))
    (pullback.snd (P.glueData.ι V ≫ P.gluedMap)
      (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))))
    ((Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
      (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).f U V ≫
        pullback.snd (P.glueData.ι U ≫ P.gluedMap)
          (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))))
    (gluingOverlapFlatteningIso C P U V).hom
    ((pullback.congrHom
      (glueData_f_comp_inclusion_comp_gluedMap C P U V) rfl).hom)
    (rightRestrictionBaseChangeMap C P U V)
    (pullback.snd
      (Spec.map (CommRingCat.ofHom
        (algebraMap P.N.1
          (Pic0FiniteStageOverlapBaseChangeRing
            C P.L P.n P.m P.relation P.M P.N U V))))
      (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))))
    (pullback.snd
      (P.glueData.f U V ≫ P.glueData.ι U ≫ P.gluedMap)
      (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))))
    hι_snd (baseChangedGluing_t_fst_snd C P U V)
    hsnd hcongr_snd (gluingOverlapFlatteningIso_hom_comp_snd C P U V)

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
