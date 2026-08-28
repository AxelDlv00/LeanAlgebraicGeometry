/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageRestrictionBaseChange

/-!
# The overlap component of finite-stage Picard base change

The overlaps produced by `Scheme.Pullback.gluing` are nested pullbacks. We first
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
intersecting it with `V`. The only input about `W` is its displayed pullback
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
-- The proposition body exposes the package's dependent finite-subextension models.
set_option maxHeartbeats 12800000 in
/-- Opaque carrier for compatibility of the left overlap leg with the glued
structure map. The wrapper keeps dependent overlap-ring instances out of the
public declaration header. -/
noncomputable def overlapGluedMapProp
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) : Prop := by
  letI : Algebra.IsAlgebraic P.L.1 k := by infer_instance
  letI : Algebra.IsAlgebraic P.M.1 k := by infer_instance
  exact
    P.glueData.f U V ≫ P.glueData.ι U ≫ P.gluedMap =
      Spec.map (CommRingCat.ofHom
        (algebraMap P.N.1
          (Pic0FiniteStageOverlapBaseChangeRing
            C P.L P.n P.m P.relation P.M P.N U V)))

set_option synthInstance.maxHeartbeats 3200000 in
-- Unfolding the opaque proposition recovers the same dependent model instances.
set_option maxHeartbeats 12800000 in
/-- The left overlap leg followed by the glued structure map is the affine
structure morphism of the finite-stage overlap. -/
theorem overlap_gluedMap
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    overlapGluedMapProp C P U V := by
  letI : Algebra.IsAlgebraic P.L.1 k := by infer_instance
  letI : Algebra.IsAlgebraic P.M.1 k := by infer_instance
  unfold overlapGluedMapProp
  rw [glueData_ι_gluedMap, glueData_f]
  let A :=
    Pic0FiniteStageChartBaseChangeRing
      C P.L P.n P.m P.relation P.M P.N U
  let B :=
    Pic0FiniteStageOverlapBaseChangeRing
      C P.L P.n P.m P.relation P.M P.N U V
  let r : A →ₐ[P.N.1] B := restrictionBaseChangeAlgHom C P U V
  change Spec.map (CommRingCat.ofHom r.toRingHom) ≫
      Spec.map (CommRingCat.ofHom (algebraMap P.N.1 A)) =
    Spec.map (CommRingCat.ofHom (algebraMap P.N.1 B))
  rw [← Spec.map_comp, ← CommRingCat.ofHom_comp]
  congr 1
  ext x
  exact r.commutes x

set_option synthInstance.maxHeartbeats 3200000 in
-- The component proof unfolds the package's nested finite-extension towers.
set_option maxHeartbeats 12800000 in
/-- The overlap component comparing `Scheme.Pullback.gluing` with the exact
separably closed atlas. -/
noncomputable def gluingOverlapBaseChangeIso
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
      (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).V (U, V) ≅
      (pic0FiniteStageAffineOverlap C U V).1.toScheme := by
  letI : Algebra.IsAlgebraic P.L.1 k := by infer_instance
  letI : Algebra.IsAlgebraic P.M.1 k := by infer_instance
  have h := overlap_gluedMap C P U V
  change
    P.glueData.f U V ≫ P.glueData.ι U ≫ P.gluedMap =
      Spec.map (CommRingCat.ofHom
        (algebraMap P.N.1
          (Pic0FiniteStageOverlapBaseChangeRing
            C P.L P.n P.m P.relation P.M P.N U V))) at h
  exact
    nestedPullbackFlatteningIso
        (P.glueData.ι U) (P.glueData.ι V) P.gluedMap
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))
        (P.glueData.f U V) (P.glueData.t U V ≫ P.glueData.f V U)
        (by simp) (P.glueData.vPullbackConeIsLimit U V) ≪≫
      pullback.congrHom h rfl ≪≫
      overlapBaseChangeIso C P U V

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
