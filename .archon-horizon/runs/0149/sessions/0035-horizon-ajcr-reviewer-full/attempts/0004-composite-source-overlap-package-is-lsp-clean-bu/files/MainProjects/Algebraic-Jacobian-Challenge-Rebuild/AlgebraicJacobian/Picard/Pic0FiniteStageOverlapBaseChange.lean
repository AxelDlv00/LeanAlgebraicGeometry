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

/-- The spectrum of an algebra homomorphism lies over the base spectrum. -/
theorem specMap_algHom_comp_algebraMap
    {R A B : Type u} [CommRing R] [CommRing A] [CommRing B]
    [Algebra R A] [Algebra R B] (r : A →ₐ[R] B) :
    Spec.map (CommRingCat.ofHom r.toRingHom) ≫
        Spec.map (CommRingCat.ofHom (algebraMap R A)) =
      Spec.map (CommRingCat.ofHom (algebraMap R B)) := by
  change
    Scheme.Spec.map (CommRingCat.ofHom r.toRingHom).op ≫
        Scheme.Spec.map (CommRingCat.ofHom (algebraMap R A)).op =
      Scheme.Spec.map (CommRingCat.ofHom (algebraMap R B)).op
  rw [← Scheme.Spec.map_comp]
  congr 1
  apply Quiver.Hom.unop_inj
  ext x
  exact r.commutes x

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] [IsSepClosed k]

namespace Pic0FiniteStageGluePackage

set_option synthInstance.maxHeartbeats 3200000 in
-- Projecting the package retains nested finite-subextension scalar towers.
set_option maxHeartbeats 12800000 in
/-- The composite restriction followed by the chart structure map has the exact
base structure map, so its pullback is the package overlap base change. -/
noncomputable def overlapCompositeBaseChangeIso
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    pullback
        (Spec.map (CommRingCat.ofHom
            (restrictionBaseChangeAlgHom C P U V).toRingHom) ≫
          Spec.map (CommRingCat.ofHom
            (algebraMap P.N.1
              (Pic0FiniteStageChartBaseChangeRing
                C P.L P.n P.m P.relation P.M P.N U))))
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) ≅
      (pic0FiniteStageAffineOverlap C U V).1.toScheme :=
  pullback.congrHom
      (specMap_algHom_comp_algebraMap (restrictionBaseChangeAlgHom C P U V)) rfl ≪≫
    overlapBaseChangeIso C P U V

set_option synthInstance.maxHeartbeats 3200000 in
-- The nested gluing unfolds both package restrictions and finite-stage towers.
set_option maxHeartbeats 12800000 in
/-- The nested overlap in the base-changed gluing is the exact affine overlap. -/
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
      (P.glueData.f U V)
      (P.glueData.t U V ≫ P.glueData.f V U)
      (by simpa only [Category.assoc] using
        (P.glueData.glue_condition U V).symm)
      (P.glueData.vPullbackConeIsLimit U V) ≪≫
    pullback.congrHom (by
      rw [glueData_f C P U V, glueData_ι_gluedMap C P U]
      rfl) rfl ≪≫
    overlapCompositeBaseChangeIso C P U V

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
