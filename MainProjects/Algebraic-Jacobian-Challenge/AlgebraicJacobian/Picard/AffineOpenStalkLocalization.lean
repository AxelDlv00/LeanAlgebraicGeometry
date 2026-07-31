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
/-- The canonical spectrum chart identifies the restriction of an affine-open
coordinate function to its image with the corresponding spectrum section. -/
lemma fromSpec_restrict_ring_section_top
    {U : X.Opens} (hU : IsAffineOpen U)
    (eT : hU.fromSpec ''ᵁ (⊤ : (Spec Γ(X, U)).Opens) = U) (r : Γ(X, U)) :
    (X.presheaf.map (eqToHom eT).op).hom r =
      (hU.fromSpec.appIso (⊤ : (Spec Γ(X, U)).Opens)).inv.hom
        ((Scheme.ΓSpecIso Γ(X, U)).inv.hom r) := by
  have hfwd := fromSpec_image_top_section_coherence hU eT
  haveI : IsIso (X.presheaf.map (eqToHom eT.symm).op) := inferInstance
  apply (ConcreteCategory.bijective_of_isIso
    (X.presheaf.map (eqToHom eT.symm).op)).1
  rw [← ConcreteCategory.comp_apply, ← X.presheaf.map_comp, ← op_comp,
    eqToHom_trans, eqToHom_refl, op_id, X.presheaf.map_id]
  change r =
    (X.presheaf.map (eqToHom eT.symm).op).hom
      ((hU.fromSpec.appIso (⊤ : (Spec Γ(X, U)).Opens)).inv.hom
        ((Scheme.ΓSpecIso Γ(X, U)).inv.hom r))
  rw [hfwd, CommRingCat.comp_apply, Iso.inv_hom_id_apply, Iso.inv_hom_id_apply]

set_option backward.isDefEq.respectTransparency false in
/-- The section-ring comparison for the canonical spectrum chart commutes with
restriction from the affine open to every open of its spectrum model. -/
lemma fromSpec_restrict_ring_section
    {U : X.Opens} (hU : IsAffineOpen U)
    (V : (Spec Γ(X, U)).Opens) (r : Γ(X, U)) :
    let j := hU.fromSpec
    let eT : j ''ᵁ (⊤ : (Spec Γ(X, U)).Opens) = U :=
      (Scheme.Hom.image_top_eq_opensRange j).trans hU.opensRange_fromSpec
    let hVU : j ''ᵁ V ≤ U := (j.image_mono le_top).trans_eq eT
    (j.appIso V).inv.hom
        (((Spec Γ(X, U)).presheaf.map (homOfLE (le_top : V ≤ ⊤)).op).hom
          ((Scheme.ΓSpecIso Γ(X, U)).inv.hom r)) =
      (X.presheaf.map (homOfLE hVU).op).hom r := by
  let j := hU.fromSpec
  let eT : j ''ᵁ (⊤ : (Spec Γ(X, U)).Opens) = U :=
    (Scheme.Hom.image_top_eq_opensRange j).trans hU.opensRange_fromSpec
  let hVU : j ''ᵁ V ≤ U := (j.image_mono le_top).trans_eq eT
  have hnat := j.appIso_inv_naturality
    (homOfLE (le_top : V ≤ (⊤ : (Spec Γ(X, U)).Opens))).op
  have happ := ConcreteCategory.congr_hom hnat
    ((Scheme.ΓSpecIso Γ(X, U)).inv.hom r)
  simp only [CategoryTheory.comp_apply] at happ
  rw [← fromSpec_restrict_ring_section_top hU eT r] at happ
  refine happ.trans ?_
  rw [← ConcreteCategory.comp_apply, ← X.presheaf.map_comp]
  congr 1

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
          ((Scheme.ΓSpecIso R).inv.hom r) :=
    fromSpec_restrict_ring_section_top hU eT
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

/-- A stalk over the canonical spectrum chart, regarded as a module over the
coordinate ring of the affine open through the ambient germ map. -/
noncomputable abbrev affineOpenStalkModule
    (M : X.Modules) {U : X.Opens} (hU : IsAffineOpen U)
    (p : PrimeSpectrum.Top Γ(X, U)) :
    Module Γ(X, U)
      (↑(TopCat.Presheaf.stalk M.val.presheaf (hU.fromSpec p)) : Type u) := by
  letI : Module (X.presheaf.stalk (hU.fromSpec p))
      (↑(TopCat.Presheaf.stalk M.val.presheaf (hU.fromSpec p)) : Type u) :=
    presheafStalkModule M.val (hU.fromSpec p)
  have hpU : (hU.fromSpec p : X) ∈ U := by
    change hU.fromSpec p ∈ (U : Set X)
    rw [← hU.range_fromSpec]
    exact Set.mem_range_self p
  exact Module.compHom _ (X.presheaf.germ U (hU.fromSpec p) hpU).hom

end AlgebraicGeometry.Scheme.Modules
