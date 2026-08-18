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

set_option backward.isDefEq.respectTransparency false in
/-- The first projection of the flattened pullback recovers the first projection
of the inner pullback after composing with the first leg of the displayed overlap. -/
@[reassoc]
theorem nestedPullbackFlatteningIso_hom_comp_fst_comp_a
    {U V X Y Z W : Scheme.{u}}
    (iU : U ⟶ X) (iV : V ⟶ X) (f : X ⟶ Z) (g : Y ⟶ Z)
    (a : W ⟶ U) (b : W ⟶ V)
    (hab : a ≫ iU = b ≫ iV)
    (hW : IsLimit (PullbackCone.mk a b hab)) :
    (nestedPullbackFlatteningIso iU iV f g a b hab hW).hom ≫
        pullback.fst (a ≫ iU ≫ f) g ≫ a =
      pullback.fst (pullback.fst (iU ≫ f) g ≫ iU) iV ≫
        pullback.fst (iU ≫ f) g := by
  let e : W ≅ pullback iU iV :=
    hW.conePointUniqueUpToIso (pullback.isLimit iU iV)
  have e_inv_fst : e.inv ≫ a = pullback.fst iU iV := by
    change e.inv ≫ (PullbackCone.mk a b hab).fst = _
    exact IsLimit.conePointUniqueUpToIso_inv_comp hW
      (pullback.isLimit iU iV) WalkingCospan.left
  simp only [nestedPullbackFlatteningIso, Iso.trans_hom, asIso_hom,
    pullback.map, Category.assoc, pullback.lift_fst_assoc,
    pullbackSymmetry_hom_comp_fst_assoc]
  rw [e_inv_fst]
  simp

set_option backward.isDefEq.respectTransparency false in
/-- The first projection of the flattened pullback recovers the outer second
projection after composing with the second leg of the displayed overlap. -/
@[reassoc]
theorem nestedPullbackFlatteningIso_hom_comp_fst_comp_b
    {U V X Y Z W : Scheme.{u}}
    (iU : U ⟶ X) (iV : V ⟶ X) (f : X ⟶ Z) (g : Y ⟶ Z)
    (a : W ⟶ U) (b : W ⟶ V)
    (hab : a ≫ iU = b ≫ iV)
    (hW : IsLimit (PullbackCone.mk a b hab)) :
    (nestedPullbackFlatteningIso iU iV f g a b hab hW).hom ≫
        pullback.fst (a ≫ iU ≫ f) g ≫ b =
      pullback.snd (pullback.fst (iU ≫ f) g ≫ iU) iV := by
  let e : W ≅ pullback iU iV :=
    hW.conePointUniqueUpToIso (pullback.isLimit iU iV)
  have e_inv_snd : e.inv ≫ b = pullback.snd iU iV := by
    change e.inv ≫ (PullbackCone.mk a b hab).snd = _
    exact IsLimit.conePointUniqueUpToIso_inv_comp hW
      (pullback.isLimit iU iV) WalkingCospan.right
  simp only [nestedPullbackFlatteningIso, Iso.trans_hom, asIso_hom,
    pullback.map, Category.assoc, pullback.lift_fst_assoc,
    pullbackSymmetry_hom_comp_fst_assoc]
  rw [e_inv_snd]
  simp

set_option backward.isDefEq.respectTransparency false in
/-- The second projection of the flattened pullback is the second projection of
the inner pullback after the outer first projection. -/
@[reassoc]
theorem nestedPullbackFlatteningIso_hom_comp_snd
    {U V X Y Z W : Scheme.{u}}
    (iU : U ⟶ X) (iV : V ⟶ X) (f : X ⟶ Z) (g : Y ⟶ Z)
    (a : W ⟶ U) (b : W ⟶ V)
    (hab : a ≫ iU = b ≫ iV)
    (hW : IsLimit (PullbackCone.mk a b hab)) :
    (nestedPullbackFlatteningIso iU iV f g a b hab hW).hom ≫
        pullback.snd (a ≫ iU ≫ f) g =
      pullback.fst (pullback.fst (iU ≫ f) g ≫ iU) iV ≫
        pullback.snd (iU ≫ f) g := by
  simp [nestedPullbackFlatteningIso, pullback.map, Category.assoc]

end

end AlgebraicGeometry
