/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageOverlapBaseChange

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

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] [IsSepClosed k]

namespace Pic0FiniteStageGluePackage

set_option synthInstance.maxHeartbeats 3200000 in
-- The comparison unfolds the package's dependent finite-subextension towers.
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
  letI : Algebra.IsAlgebraic P.L.1 k := by infer_instance
  letI : Algebra.IsAlgebraic P.M.1 k := by infer_instance
  let g : Spec (.of k) ⟶ Spec (.of P.N.1) :=
    Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))
  have hAffineStructure :
      Spec.map (CommRingCat.ofHom
          (restrictionBaseChangeAlgHom C P U V).toRingHom) ≫
        Spec.map (CommRingCat.ofHom
          (algebraMap P.N.1
            (Pic0FiniteStageChartBaseChangeRing
              C P.L P.n P.m P.relation P.M P.N U))) =
      Spec.map (CommRingCat.ofHom
        (algebraMap P.N.1
          (Pic0FiniteStageOverlapBaseChangeRing
            C P.L P.n P.m P.relation P.M P.N U V))) := by
    rw [← Spec.map_comp]
    rw [← CommRingCat.ofHom_comp]
    congr 1
    ext x
    exact (restrictionBaseChangeAlgHom C P U V).commutes x
  have hStructure :
      P.glueData.f U V ≫ P.glueData.ι U ≫ P.gluedMap =
        Spec.map (CommRingCat.ofHom
          (algebraMap P.N.1
            (Pic0FiniteStageOverlapBaseChangeRing
              C P.L P.n P.m P.relation P.M P.N U V))) := by
    rw [glueData_ι_gluedMap C P U, glueData_f C P U V]
    exact hAffineStructure
  exact
    nestedPullbackFlatteningIso
        (P.glueData.ι U) (P.glueData.ι V) P.gluedMap g
        (P.glueData.f U V)
        (P.glueData.t U V ≫ P.glueData.f V U)
        (by
          simpa only [Category.assoc] using
            (P.glueData.glue_condition U V).symm)
        (P.glueData.vPullbackConeIsLimit U V) ≪≫
      pullback.congrHom hStructure rfl ≪≫
      overlapBaseChangeIso C P U V ≪≫
      (isPullback_opens_inf U.1.1 V.1.1).isoPullback

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
