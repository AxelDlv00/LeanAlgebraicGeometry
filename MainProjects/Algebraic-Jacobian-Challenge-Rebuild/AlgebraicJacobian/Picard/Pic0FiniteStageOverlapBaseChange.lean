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

end

end AlgebraicGeometry
