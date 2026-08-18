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
  letI : Algebra.IsAlgebraic P.L.1 k := by infer_instance
  letI : Algebra.IsAlgebraic P.M.1 k := by infer_instance
  let A : Type u :=
    P.N.1 ⊗[P.M.1]
      (P.M.1 ⊗[P.L.1]
        DatG0.FiniteRelationAlgebra P.L.1
          (P.n (Sum.inl U)) (P.m (Sum.inl U)) (P.relation (Sum.inl U)))
  let B : Type u :=
    P.N.1 ⊗[P.M.1]
      (P.M.1 ⊗[P.L.1]
        DatG0.FiniteRelationAlgebra P.L.1
          (P.n (Sum.inr (U, V))) (P.m (Sum.inr (U, V)))
          (P.relation (Sum.inr (U, V))))
  let r : A →ₐ[P.N.1] B :=
    AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := P.M.1) (K := P.N.1)
        (P.mapM (Sum.inl (Sum.inl (U, V))))
  let aMap : P.N.1 →+* A := algebraMap P.N.1 A
  let bMap : P.N.1 →+* B := algebraMap P.N.1 B
  let g : Spec (.of k) ⟶ Spec (.of P.N.1) :=
    Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))
  have hf :
      P.glueData.f U V = Spec.map (CommRingCat.ofHom r.toRingHom) := by
    exact glueData_f C P U V
  have hi :
      P.glueData.ι U ≫ P.gluedMap =
        Spec.map (CommRingCat.ofHom aMap) := by
    exact glueData_ι_gluedMap C P U
  have hAffineStructure :
      Spec.map (CommRingCat.ofHom r.toRingHom) ≫
          Spec.map (CommRingCat.ofHom aMap) =
        Spec.map (CommRingCat.ofHom bMap) := by
    rw [← Spec.map_comp]
    rw [← CommRingCat.ofHom_comp]
    congr 1
    ext x
    exact r.commutes x
  have hStructure :
      P.glueData.f U V ≫ P.glueData.ι U ≫ P.gluedMap =
        Spec.map (CommRingCat.ofHom bMap) := by
    rw [hf, hi]
    exact hAffineStructure
  let overlapIso :
      pullback (Spec.map (CommRingCat.ofHom bMap)) g ≅
        (pic0FiniteStageAffineOverlap C U V).1.toScheme :=
    overlapBaseChangeIso C P U V
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
      overlapIso ≪≫
      (isPullback_opens_inf U.1.1 V.1.1).isoPullback

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
