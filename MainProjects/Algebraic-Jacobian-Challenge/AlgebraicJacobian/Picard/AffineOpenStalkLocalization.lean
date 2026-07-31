/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.AffineStalkLocalization

/-!
# Affine-open transport for stalk reconstruction

This file transports the `Spec`-level reconstruction theorem of
`AffineStalkLocalization` to an affine open of an arbitrary scheme.  Restriction
along `IsAffineOpen.fromSpec` identifies sections on the affine open with top
sections on its spectrum model.
-/

open CategoryTheory AlgebraicGeometry Opposite TopologicalSpace

universe u

namespace AlgebraicGeometry.Scheme.Modules

variable {X : Scheme.{u}}

set_option backward.isDefEq.respectTransparency false in
/-- Sections over an affine open, mapped to top sections after restricting the
module to the canonical spectrum chart. -/
noncomputable def fromSpecRestrictTopHom
    (M : X.Modules) {U : X.Opens} (hU : IsAffineOpen U) :
    let R := Γ(X, U)
    let j := hU.fromSpec
    M.val.obj (op U) ⟶
      (moduleSpecΓFunctor (R := R)).obj ((restrictFunctor j).obj M) := by
  let R := Γ(X, U)
  let j := hU.fromSpec
  let F := (restrictFunctor j).obj M
  have eT : j ''ᵁ (⊤ : (Spec R).Opens) = U :=
    (Scheme.Hom.image_top_eq_opensRange j).trans hU.opensRange_fromSpec
  let q : Γ(M, U) ⟶ Γ(M, j ''ᵁ (⊤ : (Spec R).Opens)) :=
    M.presheaf.map (eqToHom eT).op
  have hqRing : ∀ r : R,
      (X.presheaf.map (eqToHom eT).op).hom r =
        (j.appIso (⊤ : (Spec R).Opens)).inv.hom
          ((Scheme.ΓSpecIso R).inv.hom r) := by
    intro r
    have hfwd := fromSpec_image_top_section_coherence hU eT
    haveI : IsIso (X.presheaf.map (eqToHom eT.symm).op) := inferInstance
    apply (ConcreteCategory.bijective_of_isIso
      (X.presheaf.map (eqToHom eT.symm).op)).1
    rw [← ConcreteCategory.comp_apply, ← X.presheaf.map_comp, ← op_comp,
      eqToHom_trans, eqToHom_refl, op_id, X.presheaf.map_id]
    change r =
      (X.presheaf.map (eqToHom eT.symm).op).hom
        ((j.appIso (⊤ : (Spec R).Opens)).inv.hom
          ((Scheme.ΓSpecIso R).inv.hom r))
    rw [hfwd, CommRingCat.comp_apply, Iso.inv_hom_id_apply, Iso.inv_hom_id_apply]
  exact ConcreteCategory.ofHom (C := ModuleCat R)
    { toFun := q.hom
      map_add' := q.hom.map_add
      map_smul' := fun r m => by
        rw [Scheme.Modules.smul_Spec_def (M := F)]
        change M.val.map (eqToHom eT).op (r • m) =
          (j.appIso (⊤ : (Spec R).Opens)).inv.hom
            ((Scheme.ΓSpecIso R).inv.hom r) • q.hom m
        have hmap := Scheme.Modules.map_smul M (eqToHom eT) r m
        change M.val.map (eqToHom eT).op (r • m) =
          (X.presheaf.map (eqToHom eT).op).hom r • q.hom m at hmap
        rw [hmap, hqRing] }

set_option backward.isDefEq.respectTransparency false in
/-- Restriction along the spectrum chart does not change the section module
over the corresponding affine open. -/
theorem fromSpecRestrictTopHom_isIso
    (M : X.Modules) {U : X.Opens} (hU : IsAffineOpen U) :
    IsIso (fromSpecRestrictTopHom M hU) := by
  rw [ConcreteCategory.isIso_iff_bijective]
  let R := Γ(X, U)
  let j := hU.fromSpec
  have eT : j ''ᵁ (⊤ : (Spec R).Opens) = U :=
    (Scheme.Hom.image_top_eq_opensRange j).trans hU.opensRange_fromSpec
  change Function.Bijective
    (ConcreteCategory.hom (M.presheaf.map (eqToHom eT).op))
  haveI : IsIso (M.presheaf.map (eqToHom eT).op) := inferInstance
  exact ConcreteCategory.bijective_of_isIso _

end AlgebraicGeometry.Scheme.Modules
