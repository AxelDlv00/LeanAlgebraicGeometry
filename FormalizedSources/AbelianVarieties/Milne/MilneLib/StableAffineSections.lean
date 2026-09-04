/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.StableAffineCover
import Mathlib.AlgebraicGeometry.Morphisms.Separated

/-!
# Stable affine opens and their section actions

For a scheme with a group action, a stable open carries the contravariant
action on its ring of sections.  This is the local algebraic input for the
invariant-ring chart construction.  We also record that affine stable opens
have affine pairwise overlaps when the ambient scheme is separated.  Neither
statement constructs a global quotient.
-/

set_option autoImplicit false

universe w u

open CategoryTheory AlgebraicGeometry
open scoped AlgebraicGeometry

namespace MilneLib
namespace StableGroupAction

variable {G : Type w} [Group G] {X : Scheme.{u}}
  (act : G →* Aut X)

/-! ## Transport along equal morphisms -/

lemma appLE_congr_hom {Y Z : Scheme.{u}} {f f' : Y ⟶ Z} (e : f = f')
    {U : Z.Opens} {V : Y.Opens} (h : V ≤ f ⁻¹ᵁ U) :
    f.appLE U V h = f'.appLE U V (e ▸ h) := by
  subst e
  rfl

lemma resLE_congr_hom {Y Z : Scheme.{u}} {f f' : Y ⟶ Z} (e : f = f')
    {U : Z.Opens} {V : Y.Opens} (h : V ≤ f ⁻¹ᵁ U) :
    f.resLE U V h = f'.resLE U V (e ▸ h) := by
  subst e
  rfl

/-! ## The action on sections -/

/-- Pull sections back along one element of the action, identifying the
preimage of a stable open with the open itself. -/
noncomputable def actApp {U : X.Opens} (hU : IsStableOpen act U) (g : G) :
    Γ(X, U) ⟶ Γ(X, U) :=
  (act g).hom.appLE U U (hU g).ge

lemma actApp_one {U : X.Opens} (hU : IsStableOpen act U) :
    actApp act hU 1 = 𝟙 Γ(X, U) := by
  rw [actApp, appLE_congr_hom (act_one_hom act)]
  exact (Scheme.Hom.appLE_eq_app (𝟙 X)).trans (Scheme.Hom.id_app U)

/-- Section transport is contravariantly functorial in the scheme action. -/
lemma actApp_mul {U : X.Opens} (hU : IsStableOpen act U) (g t : G) :
    actApp act hU (g * t) = actApp act hU g ≫ actApp act hU t := by
  rw [actApp, appLE_congr_hom (act_mul_hom act g t)]
  exact (Scheme.Hom.appLE_comp_appLE _ _ _ _ _ _ _).symm

@[reassoc (attr := simp)]
lemma actApp_actApp_inv {U : X.Opens} (hU : IsStableOpen act U) (g : G) :
    actApp act hU g ≫ actApp act hU g⁻¹ = 𝟙 Γ(X, U) := by
  rw [← actApp_mul, mul_inv_cancel, actApp_one]

@[reassoc (attr := simp)]
lemma actApp_inv_actApp {U : X.Opens} (hU : IsStableOpen act U) (g : G) :
    actApp act hU g⁻¹ ≫ actApp act hU g = 𝟙 Γ(X, U) := by
  rw [← actApp_mul, inv_mul_cancel, actApp_one]

/-- The left action on sections; inversion compensates for the contravariance of
pullback along scheme morphisms. -/
@[reducible]
noncomputable def sectionsMulSemiringAction {U : X.Opens}
    (hU : IsStableOpen act U) : MulSemiringAction G Γ(X, U) where
  smul g s := (actApp act hU g⁻¹).hom s
  one_smul s := by
    change (actApp act hU 1⁻¹).hom s = s
    rw [inv_one, actApp_one]
    rfl
  mul_smul g t s := by
    change (actApp act hU (g * t)⁻¹).hom s =
      (actApp act hU g⁻¹).hom ((actApp act hU t⁻¹).hom s)
    rw [mul_inv_rev, actApp_mul]
    rfl
  smul_zero g := map_zero (actApp act hU g⁻¹).hom
  smul_add g s t := map_add (actApp act hU g⁻¹).hom s t
  smul_one g := map_one (actApp act hU g⁻¹).hom
  smul_mul g s t := map_mul (actApp act hU g⁻¹).hom s t

lemma sectionsMulSemiringAction_smul_def {U : X.Opens}
    (hU : IsStableOpen act U) (g : G) (s : Γ(X, U)) :
    letI := sectionsMulSemiringAction act hU
    g • s = (actApp act hU g⁻¹).hom s := rfl

/-- Restriction between stable opens is equivariant for the section action. -/
lemma actApp_map {U V : X.Opens} (hU : IsStableOpen act U)
    (hV : IsStableOpen act V) (hVU : V ≤ U) (g : G) :
    actApp act hU g ≫ X.presheaf.map (homOfLE hVU).op =
      X.presheaf.map (homOfLE hVU).op ≫ actApp act hV g := by
  rw [actApp, actApp, Scheme.Hom.appLE_map, Scheme.Hom.map_appLE]

/-! ## Restrictions to stable opens -/

/-- Restrict one action morphism to a stable open. -/
noncomputable def actRes {U : X.Opens} (hU : IsStableOpen act U) (g : G) :
    U.toScheme ⟶ U.toScheme :=
  (act g).hom.resLE U U (hU g).ge

@[reassoc (attr := simp)]
lemma actRes_ι {U : X.Opens} (hU : IsStableOpen act U) (g : G) :
    actRes act hU g ≫ U.ι = U.ι ≫ (act g).hom :=
  Scheme.Hom.resLE_comp_ι _ _

lemma actRes_one {U : X.Opens} (hU : IsStableOpen act U) :
    actRes act hU 1 = 𝟙 U.toScheme := by
  rw [actRes, resLE_congr_hom (act_one_hom act), Scheme.Hom.resLE_id]
  exact Scheme.homOfLE_rfl X U

lemma actRes_mul {U : X.Opens} (hU : IsStableOpen act U) (g t : G) :
    actRes act hU (g * t) = actRes act hU t ≫ actRes act hU g := by
  rw [actRes, resLE_congr_hom (act_mul_hom act g t)]
  exact (Scheme.Hom.resLE_comp_resLE _ _ _ _).symm

@[reassoc (attr := simp)]
lemma actRes_actRes_inv {U : X.Opens} (hU : IsStableOpen act U) (g : G) :
    actRes act hU g ≫ actRes act hU g⁻¹ = 𝟙 U.toScheme := by
  rw [← actRes_mul, inv_mul_cancel, actRes_one]

@[reassoc (attr := simp)]
lemma actRes_inv_actRes {U : X.Opens} (hU : IsStableOpen act U) (g : G) :
    actRes act hU g⁻¹ ≫ actRes act hU g = 𝟙 U.toScheme := by
  rw [← actRes_mul, mul_inv_cancel, actRes_one]

/-! ## Separated affine chart overlaps -/

/-- A stable affine chart for a separated scheme. -/
structure StableAffineOpen [X.IsSeparated] where
  U : X.Opens
  affine : IsAffineOpen U
  stable : IsStableOpen act U

namespace StableAffineOpen

variable [X.IsSeparated]

lemma overlap_stable (i j : StableAffineOpen act) :
    IsStableOpen act (i.U ⊓ j.U) := by
  intro g
  rw [Scheme.Hom.preimage_inf, i.stable g, j.stable g]

lemma overlap_affine (i j : StableAffineOpen act) :
    IsAffineOpen (i.U ⊓ j.U) := by
  exact i.affine.inf j.affine

/-- The affine stable chart represented by the intersection of two charts. -/
def overlap (i j : StableAffineOpen act) : StableAffineOpen act where
  U := i.U ⊓ j.U
  affine := overlap_affine act i j
  stable := overlap_stable act i j

@[simp]
lemma overlap_U (i j : StableAffineOpen act) : (overlap act i j).U = i.U ⊓ j.U :=
  rfl

/-! ## The stable-affine source cover -/

/-- The open cover indexed by all stable affine charts.  The orbit-in-affine
hypothesis is kept explicit, while separatedness is used only to make the
pairwise chart intersections affine. -/
noncomputable def sourceOpenCover [Finite G]
    (h : OrbitsInAffineOpen act) : Scheme.OpenCover X where
  I₀ := StableAffineOpen act
  X i := i.U.toScheme
  f i := i.U.ι
  mem₀ := by
    rw [Scheme.presieve₀_mem_precoverage_iff]
    constructor
    · intro x
      obtain ⟨U, hUa, hx, hU⟩ :=
        exists_stable_affineOpen_of_orbits act h x
      exact ⟨⟨U, hUa, hU⟩, ⟨x, hx⟩, rfl⟩
    · intro i
      infer_instance

@[simp]
theorem sourceOpenCover_f [Finite G]
    (h : OrbitsInAffineOpen act) (i : StableAffineOpen act) :
    (sourceOpenCover act h).f i = i.U.ι :=
  rfl

/-! ## Canonical overlap inclusions -/

/-- The overlap chart maps to its left member. -/
noncomputable def overlapLeft
    (i j : StableAffineOpen act) :
    (overlap act i j).U.toScheme ⟶ i.U.toScheme :=
  X.homOfLE inf_le_left

/-- The overlap chart maps to its right member. -/
noncomputable def overlapRight
    (i j : StableAffineOpen act) :
    (overlap act i j).U.toScheme ⟶ j.U.toScheme :=
  X.homOfLE inf_le_right

instance overlapLeft_isOpenImmersion
    (i j : StableAffineOpen act) : IsOpenImmersion (overlapLeft act i j) := by
  dsimp [overlapLeft]
  infer_instance

instance overlapRight_isOpenImmersion
    (i j : StableAffineOpen act) : IsOpenImmersion (overlapRight act i j) := by
  dsimp [overlapRight]
  infer_instance

@[reassoc (attr := simp)]
theorem overlapLeft_comp_ι
    (i j : StableAffineOpen act) :
    overlapLeft act i j ≫ i.U.ι = (overlap act i j).U.ι :=
  Scheme.homOfLE_ι X inf_le_left

@[reassoc (attr := simp)]
theorem overlapRight_comp_ι
    (i j : StableAffineOpen act) :
    overlapRight act i j ≫ j.U.ι = (overlap act i j).U.ι :=
  Scheme.homOfLE_ι X inf_le_right

end StableAffineOpen

end StableGroupAction
end MilneLib
