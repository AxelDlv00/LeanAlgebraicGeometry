/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageGluingOverlapIsoPreSndFst
import AlgebraicJacobian.Picard.Pic0FiniteStageGluingOverlapIsoPreSndSnd

/-!
# The source factorization for the right gluing leg

This module assembles the two projection equations for the right leg of the
base-changed gluing diagram before the final comparison with the canonical
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
  letI : Algebra.IsAlgebraic P.L.1 k := by infer_instance
  letI : Algebra.IsAlgebraic P.M.1 k := by infer_instance
  let A : Pic0FiniteStageChartIndex C -> Type u := fun W =>
    Pic0FiniteStageChartBaseChangeRing C P.L P.n P.m P.relation P.M P.N W
  let B : Pic0FiniteStageChartIndex C -> Pic0FiniteStageChartIndex C -> Type u := fun W Z =>
    Pic0FiniteStageOverlapBaseChangeRing C P.L P.n P.m P.relation P.M P.N W Z
  letI : ∀ W, CommRing (A W) := fun W => by
    dsimp [A]
    infer_instance
  letI : ∀ W Z, CommRing (B W Z) := fun W Z => by
    dsimp [B]
    infer_instance
  letI : ∀ W, Algebra P.N.1 (A W) := fun W => by
    dsimp [A]
    infer_instance
  letI : ∀ W Z, Algebra P.N.1 (B W Z) := fun W Z => by
    dsimp [B]
    infer_instance
  apply pullback.hom_ext
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
