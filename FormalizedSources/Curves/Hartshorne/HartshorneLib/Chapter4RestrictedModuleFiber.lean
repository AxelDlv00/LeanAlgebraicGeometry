/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4SchemeModuleFiber

/-!
# Ordinary module fibers under open restriction

The restriction isomorphism of module stalks is semilinear over the open
immersion's map of local rings.  It transports vanishing in ordinary fibers.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

universe u

open CategoryTheory Opposite TopologicalSpace AlgebraicGeometry

namespace Hartshorne.Scheme.Modules

noncomputable section

variable {X Y : Scheme.{u}} (f : X ⟶ Y) [IsOpenImmersion f] (M : Y.Modules) (x : X)

attribute [local instance] stalkModule

/-- Germs of module sections respect multiplication by local functions. -/
lemma germ_smul (U : Y.Opens) (y : Y) (hy : y ∈ U) (r : Γ(Y, U)) (s : Γ(M, U)) :
    letI : Module (Y.presheaf.stalk y) (M.presheaf.stalk y) := stalkModule M y
    (M.presheaf.germ U y hy).hom (r • s) =
      (Y.presheaf.germ U y hy).hom r •
        ((M.presheaf.germ U y hy).hom s : Stalk M y) := by
  letI : Module (Y.presheaf.stalk y) (M.presheaf.stalk y) := stalkModule M y
  exact PresheafOfModules.germ_smul (R := Y.presheaf) M.val y U hy r s

/-- The additive restriction map on module stalks. -/
def restrictStalkMap : Stalk M (f x) →+ Stalk ((Scheme.Modules.restrictFunctor f).obj M) x :=
  ((Scheme.Modules.restrictStalkNatIso f x).inv.app M).hom

/-- On germs supported in the image, restriction uses the same section. -/
lemma restrictStalkMap_germ_image (U : X.Opens) (hx : x ∈ U)
    (s : Γ(M, f ''ᵁ U)) :
    restrictStalkMap f M x ((M.presheaf.germ (f ''ᵁ U) (f x)
      (by exact ⟨x, hx, rfl⟩)).hom s) =
        (((Scheme.Modules.restrictFunctor f).obj M).presheaf.germ U x hx).hom s := by
  exact ConcreteCategory.congr_hom
    (Scheme.Modules.germ_restrictStalkNatIso_inv_app f x M hx) s

/-- The restriction map on stalks takes an arbitrary germ to its restricted germ. -/
lemma restrictStalkMap_germ (U : Y.Opens) (hx : f x ∈ U) (s : Γ(M, U)) :
    restrictStalkMap f M x ((M.presheaf.germ U (f x) hx).hom s) =
      (((Scheme.Modules.restrictFunctor f).obj M).presheaf.germ (f ⁻¹ᵁ U) x hx).hom
        (M.presheaf.map (homOfLE (f.image_preimage_le U)).op s) := by
  have hi : f x ∈ f ''ᵁ f ⁻¹ᵁ U := ⟨x, hx, rfl⟩
  have hg := TopCat.Presheaf.germ_res_apply M.presheaf
    (homOfLE (f.image_preimage_le U)) (f x) hi s
  change (M.presheaf.germ (f ''ᵁ f ⁻¹ᵁ U) (f x) hi).hom
    ((M.presheaf.map (homOfLE (f.image_preimage_le U)).op).hom s) =
      (M.presheaf.germ U (f x) hx).hom s at hg
  rw [← hg, restrictStalkMap_germ_image]

/-- Restriction of module stalks is semilinear over the map of local rings. -/
def restrictStalkLinearMap : Stalk M (f x) →ₛₗ[(f.stalkMap x).hom]
    Stalk ((Scheme.Modules.restrictFunctor f).obj M) x where
  toAddHom := restrictStalkMap f M x
  map_smul' r s := by
    obtain ⟨U, hxU, r₀, rfl⟩ := TopCat.Presheaf.exists_germ_eq Y.presheaf r
    obtain ⟨V, hxV, s₀, rfl⟩ := TopCat.Presheaf.exists_germ_eq M.val.presheaf s
    let W : Y.Opens := U ⊓ V
    have hxW : f x ∈ W := ⟨hxU, hxV⟩
    let iWU : W ⟶ U := homOfLE inf_le_left
    let iWV : W ⟶ V := homOfLE inf_le_right
    rw [← TopCat.Presheaf.germ_res_apply Y.presheaf iWU (f x) hxW r₀,
      ← TopCat.Presheaf.germ_res_apply M.val.presheaf iWV (f x) hxW s₀,
      ← PresheafOfModules.germ_smul (R := Y.presheaf) M.val (f x) W hxW]
    change restrictStalkMap f M x
      ((M.presheaf.germ W (f x) hxW).hom
        (((Y.presheaf.map iWU.op).hom r₀) • ((M.presheaf.map iWV.op).hom s₀))) =
      (f.stalkMap x).hom ((Y.presheaf.germ W (f x) hxW).hom
        ((Y.presheaf.map iWU.op).hom r₀)) •
      restrictStalkMap f M x ((M.presheaf.germ W (f x) hxW).hom
        ((M.presheaf.map iWV.op).hom s₀))
    rw [restrictStalkMap_germ, restrictStalkMap_germ,
      Scheme.Hom.germ_stalkMap_apply]
    have hsmul := germ_smul ((Scheme.Modules.restrictFunctor f).obj M)
      (f ⁻¹ᵁ W) x hxW ((f.app W).hom ((Y.presheaf.map iWU.op).hom r₀))
      ((M.presheaf.map (homOfLE (f.image_preimage_le W)).op).hom
        ((M.presheaf.map iWV.op).hom s₀))
    rw [← hsmul]
    congr 1
    change (M.val.map (homOfLE (f.image_preimage_le W)).op).hom
      (((Y.presheaf.map iWU.op).hom r₀) • ((M.presheaf.map iWV.op).hom s₀)) =
      ((f.appIso (f ⁻¹ᵁ W)).inv.hom ((f.app W).hom
        ((Y.presheaf.map iWU.op).hom r₀))) •
      ((M.presheaf.map (homOfLE (f.image_preimage_le W)).op).hom
        ((M.presheaf.map iWV.op).hom s₀))
    rw [← CommRingCat.comp_apply, f.app_appIso_inv]
    exact PresheafOfModules.map_smul M.val _ _ _

/-- Restriction carries the maximal-ideal multiple of the stalk into the
corresponding submodule on the restricted scheme. -/
lemma restrictStalkLinearMap_mem_maximalIdeal_smul (s : Stalk M (f x))
    (hs : s ∈ IsLocalRing.maximalIdeal (Y.presheaf.stalk (f x)) •
      (⊤ : Submodule (Y.presheaf.stalk (f x)) (Stalk M (f x)))) :
    restrictStalkLinearMap f M x s ∈ IsLocalRing.maximalIdeal (X.presheaf.stalk x) •
      (⊤ : Submodule (X.presheaf.stalk x)
        (Stalk ((Scheme.Modules.restrictFunctor f).obj M) x)) := by
  refine Submodule.smul_induction_on hs ?_ ?_
  · intro r hr s _
    rw [(restrictStalkLinearMap f M x).map_smulₛₗ]
    apply Submodule.smul_mem_smul _ Submodule.mem_top
    change r ∈ Ideal.comap (f.stalkMap x).hom
      (IsLocalRing.maximalIdeal (X.presheaf.stalk x))
    rw [IsLocalRing.maximalIdeal_comap]
    exact hr
  · intro s t hs ht
    rw [map_add]
    exact Submodule.add_mem _ hs ht

/-- Nonvanishing of a restricted global section in an ordinary fiber implies
nonvanishing in the corresponding ambient fiber. -/
theorem fiberEvaluation_ne_zero_of_restrict (s : Γ(M, ⊤))
    (hs : fiberEvaluation ((Scheme.Modules.restrictFunctor f).obj M) x
      (M.presheaf.map (homOfLE (le_top : f ''ᵁ (⊤ : X.Opens) ≤ ⊤)).op s) ≠ 0) :
    fiberEvaluation M (f x) s ≠ 0 := by
  intro hz
  apply hs
  apply (fiberEvaluation_eq_zero_iff ((Scheme.Modules.restrictFunctor f).obj M) x _).mpr
  have hmem := restrictStalkLinearMap_mem_maximalIdeal_smul f M x _
    ((fiberEvaluation_eq_zero_iff M (f x) s).mp hz)
  change restrictStalkMap f M x ((M.presheaf.germ ⊤ (f x) (by trivial)).hom s) ∈
    IsLocalRing.maximalIdeal (X.presheaf.stalk x) •
      (⊤ : Submodule (X.presheaf.stalk x)
        (Stalk ((Scheme.Modules.restrictFunctor f).obj M) x)) at hmem
  have hi : f x ∈ f ''ᵁ (⊤ : X.Opens) := ⟨x, trivial, rfl⟩
  have hg := TopCat.Presheaf.germ_res_apply M.presheaf
    (homOfLE (le_top : f ''ᵁ (⊤ : X.Opens) ≤ ⊤)) (f x) hi s
  change (M.presheaf.germ (f ''ᵁ (⊤ : X.Opens)) (f x) hi).hom
    ((M.presheaf.map (homOfLE le_top).op).hom s) =
      (M.presheaf.germ ⊤ (f x) (by trivial)).hom s at hg
  rw [← hg, restrictStalkMap_germ_image] at hmem
  exact hmem

end
end Hartshorne.Scheme.Modules
