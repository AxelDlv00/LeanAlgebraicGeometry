/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4SchemeModuleFiber

/-!
# Fiber evaluation from a local frame

The unit-module stalk maps linearly to the structure-sheaf stalk, taking the
germ of the unit section to one.  The maximal ideal cannot contain one, so the
unit has nonzero ordinary fiber.  A section which is one in a local frame
therefore also has nonzero ordinary fiber.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

universe u

open CategoryTheory Limits Opposite TopologicalSpace
open AlgebraicGeometry

namespace Hartshorne

noncomputable section

namespace ModulePullbackFrames

variable {Y : Scheme.{u}}

/-- Additive comparison from the stalk of the unit module to the structure-sheaf
stalk.  The two stalks are filtered colimits of the same neighbourhood diagram;
the explicit comparison avoids treating the unit-module stalk as definitionally
equal to the ring stalk. -/
noncomputable def unitStalkToRing (Y : Scheme.{u}) (y : Y) :
    Scheme.Modules.Stalk (SheafOfModules.unit Y.ringCatSheaf) y →+
      Y.presheaf.stalk y := by
  exact (colimit.desc ((OpenNhds.inclusion y).op ⋙
    (SheafOfModules.unit Y.ringCatSheaf).val.presheaf)
    ((forget₂ RingCat AddCommGrpCat).mapCocone
      ((forget₂ CommRingCat RingCat).mapCocone
        (colimit.cocone ((OpenNhds.inclusion y).op ⋙ Y.presheaf))))).hom

@[simp] lemma unitStalkToRing_germ (y : Y) (U : Y.Opens) (hy : y ∈ U)
    (s : Γ(Y, U)) :
    unitStalkToRing Y y
      ((TopCat.Presheaf.germ (SheafOfModules.unit Y.ringCatSheaf).val.presheaf
        U y hy).hom s) = (Y.presheaf.germ U y hy).hom s := by
  exact ConcreteCategory.congr_hom (colimit.ι_desc
    ((forget₂ RingCat AddCommGrpCat).mapCocone
      ((forget₂ CommRingCat RingCat).mapCocone
        (colimit.cocone ((OpenNhds.inclusion y).op ⋙ Y.presheaf))))
    (op (⟨U, hy⟩ : OpenNhds y))) s

attribute [local instance] Scheme.Modules.stalkModule

/-- The unit-stalk comparison respects multiplication by local functions. -/
noncomputable def unitStalkLinearMap (Y : Scheme.{u}) (y : Y) :
    Scheme.Modules.Stalk (SheafOfModules.unit Y.ringCatSheaf) y →ₗ[Y.presheaf.stalk y]
      Y.presheaf.stalk y where
  toAddHom := unitStalkToRing Y y
  map_smul' r s := by
    dsimp only [RingHom.id_apply]
    let M := (SheafOfModules.unit Y.ringCatSheaf).val
    obtain ⟨U, hyU, r₀, rfl⟩ := TopCat.Presheaf.exists_germ_eq Y.presheaf r
    obtain ⟨V, hyV, s₀, rfl⟩ := TopCat.Presheaf.exists_germ_eq M.presheaf s
    let W : Y.Opens := U ⊓ V
    have hyW : y ∈ W := ⟨hyU, hyV⟩
    let iWU : W ⟶ U := homOfLE inf_le_left
    let iWV : W ⟶ V := homOfLE inf_le_right
    rw [← TopCat.Presheaf.germ_res_apply Y.presheaf iWU y hyW r₀,
      ← TopCat.Presheaf.germ_res_apply M.presheaf iWV y hyW s₀,
      ← PresheafOfModules.germ_smul (R := Y.presheaf) M y W hyW]
    change unitStalkToRing Y y
      ((TopCat.Presheaf.germ M.presheaf W y hyW).hom
        ((Y.presheaf.map iWU.op).hom r₀ * (Y.presheaf.map iWV.op).hom s₀)) =
      (Y.presheaf.germ W y hyW).hom ((Y.presheaf.map iWU.op).hom r₀) *
        unitStalkToRing Y y ((TopCat.Presheaf.germ M.presheaf W y hyW).hom
          ((Y.presheaf.map iWV.op).hom s₀))
    rw [unitStalkToRing_germ, unitStalkToRing_germ, map_mul]

@[simp] lemma unitStalkLinearMap_germ (y : Y) (U : Y.Opens) (hy : y ∈ U)
    (s : Γ(Y, U)) :
    unitStalkLinearMap Y y
      ((TopCat.Presheaf.germ (SheafOfModules.unit Y.ringCatSheaf).val.presheaf
        U y hy).hom s) = (Y.presheaf.germ U y hy).hom s :=
  unitStalkToRing_germ y U hy s

/-- The unit section has nonzero ordinary fiber at every point. -/
theorem unit_fiberEvaluation_ne_zero (Y : Scheme.{u}) (y : Y) :
    Scheme.Modules.fiberEvaluation (SheafOfModules.unit Y.ringCatSheaf) y
      (1 : Γ(Y, ⊤)) ≠ 0 := by
  intro hz
  have hmem := (Scheme.Modules.fiberEvaluation_eq_zero_iff
    (SheafOfModules.unit Y.ringCatSheaf) y (1 : Γ(Y, ⊤))).mp hz
  have hle : IsLocalRing.maximalIdeal (Y.presheaf.stalk y) •
      (⊤ : Submodule (Y.presheaf.stalk y)
        (Scheme.Modules.Stalk (SheafOfModules.unit Y.ringCatSheaf) y)) ≤
      Submodule.comap (unitStalkLinearMap Y y)
        (IsLocalRing.maximalIdeal (Y.presheaf.stalk y)) := by
    refine Submodule.smul_le.mpr fun r hr s _ => ?_
    change unitStalkLinearMap Y y (r • s) ∈
      IsLocalRing.maximalIdeal (Y.presheaf.stalk y)
    rw [(unitStalkLinearMap Y y).map_smul, smul_eq_mul]
    exact Ideal.mul_mem_right _ _ hr
  have hone := hle hmem
  change unitStalkLinearMap Y y
    ((TopCat.Presheaf.germ (SheafOfModules.unit Y.ringCatSheaf).val.presheaf
      ⊤ y (by trivial)).hom (1 : Γ(Y, ⊤))) ∈
        IsLocalRing.maximalIdeal (Y.presheaf.stalk y) at hone
  rw [unitStalkLinearMap_germ, map_one] at hone
  exact (IsLocalRing.maximalIdeal (Y.presheaf.stalk y)).one_notMem hone

/-- A local frame detects nonvanishing in the ordinary fiber.

The section `t` is a section on the restricted scheme `V.toScheme`; `hframe`
says that the frame sends it to the unit section. -/
theorem fiberEvaluation_ne_zero_of_local_frame
    (V : Y.Opens) (M : Y.Modules)
    (e : (Scheme.Modules.restrictFunctor V.ι).obj M ≅
      SheafOfModules.unit V.toScheme.ringCatSheaf)
    (y : V.toScheme)
    (t : Γ((Scheme.Modules.restrictFunctor V.ι).obj M,
      (⊤ : V.toScheme.Opens)))
    (hframe :
      (e.hom.app (⊤ : V.toScheme.Opens)).hom t =
        (1 : Γ(V.toScheme, ⊤))) :
    Scheme.Modules.fiberEvaluation
        ((Scheme.Modules.restrictFunctor V.ι).obj M)
        y t ≠ 0 := by
  intro hz
  have hmap := Scheme.Modules.stalkFiberMap_fiberEvaluation e.hom y t
  rw [hz, map_zero] at hmap
  apply unit_fiberEvaluation_ne_zero V.toScheme y
  change 0 = Scheme.Modules.fiberEvaluation
    (SheafOfModules.unit V.toScheme.ringCatSheaf) y
      ((e.hom.app ⊤).hom t) at hmap
  rw [hframe] at hmap
  exact hmap.symm

end ModulePullbackFrames

end
end Hartshorne
