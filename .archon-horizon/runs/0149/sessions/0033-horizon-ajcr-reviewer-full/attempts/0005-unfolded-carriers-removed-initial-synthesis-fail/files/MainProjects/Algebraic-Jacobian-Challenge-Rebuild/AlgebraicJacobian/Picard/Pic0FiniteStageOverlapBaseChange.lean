/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageRestrictionBaseChange

/-!
# The overlap component of finite-stage Picard base change

The overlaps produced by `Scheme.Pullback.gluing` are nested pullbacks.  We first
flatten that categorical presentation, using the certified pullback presentation of
the original overlap, and then apply the existing affine overlap comparison.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits TensorProduct
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

/-- Flatten the nested pullback obtained by first base-changing `U` and then
intersecting it with `V`.  The only input about `W` is its displayed pullback
presentation as `U ×_X V`. -/
noncomputable def nestedPullbackFlatteningIso
    {U V X Y Z W : Scheme.{u}}
    (iU : U ⟶ X) (iV : V ⟶ X) (f : X ⟶ Z) (g : Y ⟶ Z)
    (a : W ⟶ U) (b : W ⟶ V)
    (hab : a ≫ iU = b ≫ iV)
    (hW : IsLimit (PullbackCone.mk a b hab)) :
    pullback (pullback.fst (iU ≫ f) g ≫ iU) iV ≅
      pullback (a ≫ iU ≫ f) g := by
  let e : W ≅ pullback iU iV :=
    hW.conePointUniqueUpToIso (pullback.isLimit iU iV)
  have e_inv_fst : e.inv ≫ a = pullback.fst iU iV := by
    change e.inv ≫ (PullbackCone.mk a b hab).fst = _
    exact IsLimit.conePointUniqueUpToIso_inv_comp hW
      (pullback.isLimit iU iV) WalkingCospan.left
  exact
    asIso (pullback.map
      (pullback.fst (iU ≫ f) g ≫ iU) iV
      (pullback.snd g (iU ≫ f) ≫ iU) iV
      (pullbackSymmetry (iU ≫ f) g).hom (𝟙 V) (𝟙 X)
      (by simp) (by simp)) ≪≫
    pullbackAssoc g (iU ≫ f) iU iV ≪≫
    pullbackSymmetry g (pullback.fst iU iV ≫ (iU ≫ f)) ≪≫
    asIso (pullback.map
      (pullback.fst iU iV ≫ (iU ≫ f)) g
      (a ≫ iU ≫ f) g
      e.inv (𝟙 Y) (𝟙 Z)
      (by
        simpa only [Category.comp_id, Category.assoc] using
          congrArg (fun q => q ≫ iU ≫ f) e_inv_fst.symm)
      (by simp))

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] [IsSepClosed k]

namespace Pic0FiniteStageGluePackage

set_option synthInstance.maxHeartbeats 3200000 in
set_option maxHeartbeats 12800000 in
/-- The left overlap leg followed by the glued structure map is the affine
structure morphism of the finite-stage overlap. -/
theorem overlap_gluedMap
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    P.glueData.f U V ≫ P.glueData.ι U ≫ P.gluedMap =
      Spec.map (CommRingCat.ofHom
        (algebraMap P.N.1
          (P.N.1 ⊗[P.M.1]
            Pic0FiniteStageOverlapModelRing
              C P.L P.n P.m P.relation P.M U V))) := by
  letI : CommRing
      (Pic0FiniteStageChartBaseChangeRing
        C P.L P.n P.m P.relation P.M P.N U) := by
    change CommRing (P.N.1 ⊗[P.M.1]
      Pic0FiniteStageChartModelRing C P.L P.n P.m P.relation P.M U)
    infer_instance
  letI : CommRing
      (Pic0FiniteStageOverlapBaseChangeRing
        C P.L P.n P.m P.relation P.M P.N U V) := by
    change CommRing (P.N.1 ⊗[P.M.1]
      Pic0FiniteStageOverlapModelRing C P.L P.n P.m P.relation P.M U V)
    infer_instance
  letI : Algebra P.N.1
      (Pic0FiniteStageChartBaseChangeRing
        C P.L P.n P.m P.relation P.M P.N U) := by
    change Algebra P.N.1 (P.N.1 ⊗[P.M.1]
      Pic0FiniteStageChartModelRing C P.L P.n P.m P.relation P.M U)
    infer_instance
  letI : Algebra P.N.1
      (Pic0FiniteStageOverlapBaseChangeRing
        C P.L P.n P.m P.relation P.M P.N U V) := by
    change Algebra P.N.1 (P.N.1 ⊗[P.M.1]
      Pic0FiniteStageOverlapModelRing C P.L P.n P.m P.relation P.M U V)
    infer_instance
  let r :
      Pic0FiniteStageChartBaseChangeRing
          C P.L P.n P.m P.relation P.M P.N U →ₐ[P.N.1]
        Pic0FiniteStageOverlapBaseChangeRing
          C P.L P.n P.m P.relation P.M P.N U V :=
    restrictionBaseChangeAlgHom C P U V
  letI : Algebra
      (Pic0FiniteStageChartBaseChangeRing
        C P.L P.n P.m P.relation P.M P.N U)
      (Pic0FiniteStageOverlapBaseChangeRing
        C P.L P.n P.m P.relation P.M P.N U V) :=
    pic0FiniteStageAlgebraOfMap r
  letI : IsScalarTower P.N.1
      (Pic0FiniteStageChartBaseChangeRing
        C P.L P.n P.m P.relation P.M P.N U)
      (Pic0FiniteStageOverlapBaseChangeRing
        C P.L P.n P.m P.relation P.M P.N U V) :=
    pic0FiniteStageTowerOfMap r
  let chartMap := Spec.map (CommRingCat.ofHom
    (algebraMap P.N.1
      (Pic0FiniteStageChartBaseChangeRing
        C P.L P.n P.m P.relation P.M P.N U)))
  have hι : P.glueData.ι U ≫ P.gluedMap = chartMap :=
    glueData_ι_gluedMap C P U
  have hf : P.glueData.f U V =
      Spec.map (CommRingCat.ofHom
        (pic0FiniteStageRestrictionBaseChange
          C P.L P.n P.m P.relation P.M P.mapM P.N U V).toRingHom) :=
    glueData_f C P U V
  calc
    _ = P.glueData.f U V ≫ chartMap := by
      simpa only [Category.assoc] using
        congrArg (fun q => P.glueData.f U V ≫ q) hι
    _ = Spec.map (CommRingCat.ofHom
          (pic0FiniteStageRestrictionBaseChange
            C P.L P.n P.m P.relation P.M P.mapM P.N U V).toRingHom) ≫
        chartMap := congrArg (fun q => q ≫ chartMap) hf
    _ = _ := by
      dsimp only [chartMap]
      rw [← Spec.map_comp, ← CommRingCat.ofHom_comp]
      congr 1
      ext x
      simp only [CommRingCat.ofHom_comp, CommRingCat.hom_comp,
        ConcreteCategory.hom_ofHom, RingHom.coe_comp, Function.comp_apply,
        AlgHom.toRingHom_eq_coe, RingHom.coe_coe]
      rw [← IsScalarTower.algebraMap_apply P.N.1
        (Pic0FiniteStageChartBaseChangeRing
          C P.L P.n P.m P.relation P.M P.N U)
        (Pic0FiniteStageOverlapBaseChangeRing
          C P.L P.n P.m P.relation P.M P.N U V)]

set_option synthInstance.maxHeartbeats 3200000 in
set_option maxHeartbeats 12800000 in
/-- The overlap component comparing `Scheme.Pullback.gluing` with the exact
separably closed atlas.  This is the component intended for the future
`NatIso.ofComponents` comparing the two glue data. -/
noncomputable def gluingOverlapBaseChangeIso
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
      (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).V (U, V) ≅
      (pic0FiniteStageAffineOverlap C U V).1.toScheme :=
  nestedPullbackFlatteningIso
      (P.glueData.ι U) (P.glueData.ι V) P.gluedMap
      (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))
      (P.glueData.f U V) (P.glueData.t U V ≫ P.glueData.f V U)
      (by simp) (P.glueData.vPullbackConeIsLimit U V) ≪≫
    pullback.congrHom (overlap_gluedMap C P U V) rfl ≪≫
    overlapBaseChangeIso C P U V

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
