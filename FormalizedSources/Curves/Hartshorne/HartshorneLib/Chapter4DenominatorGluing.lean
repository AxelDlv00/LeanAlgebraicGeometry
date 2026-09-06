/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4DenominatorCocycle

/-!
# The divisor module in denominator coordinates

Division by a specified exact-order denominator identifies divisor sections
with regular functions on every subopen of its chart. These identifications
commute with restriction and glue to an isomorphism from `O(D)` to the
matching-family module. On the selected fixed-basis cover, each basis section
has its regularized ratio as its component. The comparison with the actual
projective pullback of `O(1)` is a separate step.
-/

set_option autoImplicit false

universe u

open CategoryTheory Opposite TopologicalSpace AlgebraicGeometry

namespace Hartshorne

noncomputable section

attribute [local instance] functionFieldOverModule Scheme.overModule divisorSectionsModule

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]
variable {D : CurveDivisor k X} {n : ℕ}

namespace LocalRatioCoordinateData

variable (a : LocalRatioCoordinateData D n)
variable (hden : ∀ (z : X.left) (hz : z ≠ genericPoint X.left), z ∈ a.chart.U →
  orderAt X.hom hz (a.sections a.denominator_index : X.left.functionField) =
    divisorBound D hz)

/-- The ambient-open denominator comparison is linear over regular functions. -/
def denominatorSectionEquivZero {W : X.left.Opens} (hW : W ≤ a.chart.U) :
    divisorSections D W ≃ₗ[Γ(X.left, W)] divisorSections (0 : CurveDivisor k X) W where
  toFun := a.denominatorIsoZeroOnApp hden hW
  invFun := a.denominatorIsoZeroOnInvApp hden hW
  left_inv := a.denominatorIsoZeroOnInvApp_hom hden hW
  right_inv := a.denominatorIsoZeroOnApp_inv hden hW
  map_add' s t := by
    by_cases hWne : (W : Set X.left).Nonempty
    · apply Subtype.ext
      rw [denominatorIsoZeroOnApp_coe a hden hW hWne]
      change ((s : X.left.functionField) + (t : X.left.functionField)) / _ =
        (a.denominatorIsoZeroOnApp hden hW s : X.left.functionField) +
          (a.denominatorIsoZeroOnApp hden hW t : X.left.functionField)
      rw [denominatorIsoZeroOnApp_coe a hden hW hWne,
        denominatorIsoZeroOnApp_coe a hden hW hWne]
      exact add_div _ _ _
    · letI := divisorSections_subsingleton_of_empty (D := (0 : CurveDivisor k X)) hWne
      exact Subsingleton.elim _ _
  map_smul' c s := by
    by_cases hWne : (W : Set X.left).Nonempty
    · apply Subtype.ext
      change (a.denominatorIsoZeroOnApp hden hW (divisorSectionAction D W c s) :
          X.left.functionField) =
        (divisorSectionAction 0 W c (a.denominatorIsoZeroOnApp hden hW s) :
          X.left.functionField)
      rw [denominatorIsoZeroOnApp_coe a hden hW hWne,
        divisorSectionAction_coe_of_nonempty _ _ hWne,
        divisorSectionAction_coe_of_nonempty _ _ hWne,
        denominatorIsoZeroOnApp_coe a hden hW hWne, mul_div_assoc]
    · letI := divisorSections_subsingleton_of_empty (D := (0 : CurveDivisor k X)) hWne
      exact Subsingleton.elim _ _

/-- The actual structure-sheaf comparison for the zero divisor, on sections. -/
def zeroSectionEquiv (W : X.left.Opens) :
    divisorSections (0 : CurveDivisor k X) W ≃ₗ[Γ(X.left, W)] Γ(X.left, W) :=
  ((PresheafOfModules.evaluation _ (op W)).mapIso
    ((SheafOfModules.forget _).mapIso (divisorModuleZeroIso (k := k) (X := X)).symm)).toLinearEquiv

/-- Division by the denominator, valued in the actual structure sheaf. -/
def denominatorSectionEquiv {W : X.left.Opens} (hW : W ≤ a.chart.U) :
    divisorSections D W ≃ₗ[Γ(X.left, W)] Γ(X.left, W) :=
  (a.denominatorSectionEquivZero hden hW).trans (zeroSectionEquiv W)

lemma zeroSectionEquiv_restrict {W V : X.left.Opens} (h : V ≤ W)
    (s : divisorSections (0 : CurveDivisor k X) W) :
    zeroSectionEquiv V (divisorSectionsRes 0 h s) =
      X.left.resHom h (zeroSectionEquiv W s) := by
  exact ConcreteCategory.congr_hom
    ((Scheme.Modules.Hom.mapPresheaf (divisorModuleZeroIso (k := k) (X := X)).inv).naturality
      (homOfLE h).op) s

/-- Denominator coordinates commute with restriction to every smaller open. -/
lemma denominatorSectionEquiv_restrict {W V : X.left.Opens}
    (hW : W ≤ a.chart.U) (h : V ≤ W) (s : divisorSections D W) :
    a.denominatorSectionEquiv hden (h.trans hW) (divisorSectionsRes D h s) =
      X.left.resHom h (a.denominatorSectionEquiv hden hW s) := by
  change zeroSectionEquiv V (a.denominatorIsoZeroOnApp hden (h.trans hW)
      (divisorSectionsRes D h s)) = _
  rw [a.denominatorIsoZeroOnApp_restrict hden hW h, zeroSectionEquiv_restrict]
  rfl

/-- The denominator coordinates satisfy the structure-sheaf matching law. -/
lemma denominatorSectionEquiv_transition
    (b : LocalRatioCoordinateData D n)
    (hb : ∀ (z : X.left) (hz : z ≠ genericPoint X.left), z ∈ b.chart.U →
      orderAt X.hom hz (b.sections b.denominator_index : X.left.functionField) =
        divisorBound D hz)
    (r : LocalRatioRegularization a) (hab : a.SameSectionValues b)
    {W : X.left.Opens} (hWa : W ≤ a.chart.U) (hWb : W ≤ b.chart.U)
    (s : divisorSections D W) :
    a.denominatorSectionEquiv hden hWa s =
      LocalRatioRegularization.restrictSection hWa
          (r.regularized b.denominator_index) *
        b.denominatorSectionEquiv hb hWb s := by
  change zeroSectionEquiv W (a.denominatorIsoZeroOnApp hden hWa s) = _
  rw [a.denominatorIsoZeroOnApp_transition hden b hb r hab hWa hWb]
  exact (zeroSectionEquiv W).map_smul _ _

/-- The specified divisor coordinates are sent to their regularized ratios. -/
lemma denominatorSectionEquiv_sections (r : LocalRatioRegularization a)
    {W : X.left.Opens} (hW : W ≤ a.chart.U) (j : Fin (n + 1)) :
    a.denominatorSectionEquiv hden hW (divisorSectionsRes D hW (a.sections j)) =
      X.left.resHom hW (r.regularized j) := by
  change zeroSectionEquiv W
    (a.denominatorIsoZeroOnApp hden hW (divisorSectionsRes D hW (a.sections j))) = _
  apply (zeroSectionEquiv W).symm.injective
  rw [LinearEquiv.symm_apply_apply]
  change a.denominatorIsoZeroOnApp hden hW (divisorSectionsRes D hW (a.sections j)) =
    moduleToDivisorZeroPresheafApp W (X.left.resHom hW (r.regularized j))
  by_cases hWne : (W : Set X.left).Nonempty
  · apply Subtype.ext
    rw [a.denominatorIsoZeroOnApp_coe hden hW hWne, divisorSectionsRes_coe _ hWne,
      moduleToDivisorZeroPresheafApp_coe_of_nonempty hWne]
    exact (r.restricted_value_eq hW hWne j).symm
  · letI := divisorSections_subsingleton_of_empty (D := (0 : CurveDivisor k X)) hWne
    exact Subsingleton.elim _ _

end LocalRatioCoordinateData

namespace LocalRatioDenominatorCocycle

variable {ι : Type u} (a : ι → LocalRatioCoordinateData D n)
  (r : (i : ι) → LocalRatioRegularization (a i))
  (hsame : ∀ i j, (a i).SameSectionValues (a j))
  (hden : ∀ i (z : X.left) (hz : z ≠ genericPoint X.left), z ∈ (a i).chart.U →
    orderAt X.hom hz ((a i).sections (a i).denominator_index : X.left.functionField) =
      divisorBound D hz)

private lemma divisor_res_res {W V T : X.left.Opens} (hTV : T ≤ V) (hVW : V ≤ W)
    (s : divisorSections D W) :
    divisorSectionsRes D hTV (divisorSectionsRes D hVW s) =
      divisorSectionsRes D (hTV.trans hVW) s := by
  rw [divisorSectionsRes_comp hTV hVW]
  rfl

/-- A divisor section gives a matching family of regular denominator coordinates. -/
def toGluedApp (W : X.left.Opens) :
    divisorSections D W →ₗ[Γ(X.left, W)]
      LineBundleGluing.sectionSubmodule (fun i => (a i).chart.U)
        (fun i j => transitionUnit a r i j (hsame i j)) W where
  toFun s := ⟨fun i => (a i).denominatorSectionEquiv (hden i) inf_le_right
    (divisorSectionsRes D inf_le_left s), by
    intro i j
    change X.left.resHom _ ((a i).denominatorSectionEquiv (hden i) inf_le_right
        (divisorSectionsRes D inf_le_left s)) =
      X.left.resHom _ (transitionUnit a r i j (hsame i j)).val *
        X.left.resHom _ ((a j).denominatorSectionEquiv (hden j) inf_le_right
          (divisorSectionsRes D inf_le_left s))
    rw [← LocalRatioCoordinateData.denominatorSectionEquiv_restrict,
      ← LocalRatioCoordinateData.denominatorSectionEquiv_restrict,
      divisor_res_res, divisor_res_res, transitionUnit_val]
    change (a i).denominatorSectionEquiv (hden i) _ (divisorSectionsRes D _ s) =
      X.left.resHom _ (X.left.resHom _ ((r i).regularized (a j).denominator_index)) * _
    rw [Scheme.resHom_resHom]
    exact (a i).denominatorSectionEquiv_transition (hden i) (a j) (hden j)
      (r i) (hsame i j) _ _ _⟩
  map_add' s t := by
    apply Subtype.ext
    funext i
    change (a i).denominatorSectionEquiv (hden i) inf_le_right
        (divisorSectionsRes D inf_le_left (s + t)) =
      (a i).denominatorSectionEquiv (hden i) inf_le_right
          (divisorSectionsRes D inf_le_left s) +
        (a i).denominatorSectionEquiv (hden i) inf_le_right
          (divisorSectionsRes D inf_le_left t)
    rw [map_add, map_add]
  map_smul' c s := by
    apply Subtype.ext
    funext i
    change (a i).denominatorSectionEquiv (hden i) inf_le_right
        (divisorSectionsRes D inf_le_left (divisorSectionAction D W c s)) =
      X.left.resHom inf_le_left c *
        (a i).denominatorSectionEquiv (hden i) inf_le_right
          (divisorSectionsRes D inf_le_left s)
    rw [divisorSectionsRes_action (homOfLE inf_le_left).op]
    exact ((a i).denominatorSectionEquiv (hden i) inf_le_right).map_smul _ _

/-- Restricting the divisor and then taking coordinates restricts each component. -/
lemma toGluedApp_restrict {W V : X.left.Opens} (h : V ≤ W) (s : divisorSections D W) :
    toGluedApp a r hsame hden V (divisorSectionsRes D h s) =
      LineBundleGluing.res.{u, u} _ _ h (toGluedApp a r hsame hden W s) := by
  apply Subtype.ext
  funext i
  change (a i).denominatorSectionEquiv (hden i) inf_le_right
      (divisorSectionsRes D inf_le_left (divisorSectionsRes D h s)) =
    X.left.resHom (inf_le_inf_right (a i).chart.U h)
      ((a i).denominatorSectionEquiv (hden i) inf_le_right
        (divisorSectionsRes D inf_le_left s))
  rw [← LocalRatioCoordinateData.denominatorSectionEquiv_restrict,
    divisor_res_res, divisor_res_res]

/-- The actual divisor module maps to the sheaf glued from its denominator units. -/
def toGlued : divisorModule D ⟶
    LineBundleGluing.gluedModule (fun i => (a i).chart.U)
      (fun i j => transitionUnit a r i j (hsame i j)) where
  val := PresheafOfModules.homMk
    { app := fun W => AddCommGrpCat.ofHom
        (toGluedApp a r hsame hden W.unop).toAddMonoidHom
      naturality := fun {W V} f => by
        apply AddCommGrpCat.hom_ext
        ext s
        exact toGluedApp_restrict a r hsame hden f.unop.le s }
    (fun W c s => (toGluedApp a r hsame hden W.unop).map_smul c s)

/-- In a chart frame the comparison is exactly division by that denominator. -/
lemma sectionTriv_toGluedApp (i : ι) {W : X.left.Opens} (hW : W ≤ (a i).chart.U)
    (s : divisorSections D W) :
    LineBundleGluing.sectionTriv (isCocycle a r hsame) i hW
        (toGluedApp a r hsame hden W s) =
      (a i).denominatorSectionEquiv (hden i) hW s := by
  change X.left.resHom (le_inf le_rfl hW)
      ((a i).denominatorSectionEquiv (hden i) inf_le_right
        (divisorSectionsRes D inf_le_left s)) = _
  rw [← LocalRatioCoordinateData.denominatorSectionEquiv_restrict,
    divisor_res_res, divisorSectionsRes_id]
  rfl

/-- The comparison is bijective on every subopen of a denominator chart. -/
lemma toGluedApp_bijective_on_chart (i : ι) {W : X.left.Opens}
    (hW : W ≤ (a i).chart.U) : Function.Bijective (toGluedApp a r hsame hden W) := by
  constructor
  · intro s t h
    apply ((a i).denominatorSectionEquiv (hden i) hW).injective
    rw [← sectionTriv_toGluedApp a r hsame hden i hW s,
      ← sectionTriv_toGluedApp a r hsame hden i hW t, h]
  · intro t
    refine ⟨((a i).denominatorSectionEquiv (hden i) hW).symm
      (LineBundleGluing.sectionTriv (isCocycle a r hsame) i hW t), ?_⟩
    apply (LineBundleGluing.sectionTriv (isCocycle a r hsame) i hW).injective
    rw [sectionTriv_toGluedApp, LinearEquiv.apply_symm_apply]

/-- The local denominator comparisons glue to an isomorphism of scheme modules. -/
theorem isIso_toGlued (hcover : ⨆ i, (a i).chart.U = ⊤) :
    IsIso (toGlued a r hsame hden) := by
  let B := { W : X.left.Opens // ∃ i, W ≤ (a i).chart.U }
  have hb : Opens.IsBasis (Set.range (fun V : B => V.val)) := by
    rw [Opens.isBasis_iff_nbhd]
    intro W x hx
    have hxcover : x ∈ ⨆ i, (a i).chart.U := by rw [hcover]; trivial
    obtain ⟨i, hi⟩ := Opens.mem_iSup.mp hxcover
    exact ⟨W ⊓ (a i).chart.U, ⟨⟨_, i, inf_le_right⟩, rfl⟩, ⟨hx, hi⟩, inf_le_left⟩
  let F : TopCat.Sheaf AddCommGrpCat (X.left : TopCat) :=
    ⟨(divisorModule D).presheaf, (divisorModule D).isSheaf⟩
  let G : TopCat.Sheaf AddCommGrpCat (X.left : TopCat) :=
    ⟨(LineBundleGluing.gluedModule (fun i => (a i).chart.U)
      (fun i j => transitionUnit a r i j (hsame i j))).presheaf,
      Scheme.Modules.isSheaf _⟩
  let f : F ⟶ G := ⟨(toGlued a r hsame hden).mapPresheaf⟩
  have hf : IsIso f := by
    apply TopCat.Sheaf.isIso_iff_isIso_basis hb
    intro W
    rw [ConcreteCategory.isIso_iff_bijective]
    obtain ⟨i, hi⟩ := W.property
    exact toGluedApp_bijective_on_chart a r hsame hden i hi
  let e := (TopCat.Sheaf.forget AddCommGrpCat (X.left : TopCat)).mapIso
    (@asIso _ _ F G f hf)
  haveI : IsIso ((Scheme.Modules.toPresheaf X.left).map (toGlued a r hsame hden)) :=
    inferInstanceAs (IsIso e.hom)
  exact isIso_of_reflects_iso (toGlued a r hsame hden) (Scheme.Modules.toPresheaf X.left)

/-- `O(D)` is the matching-family sheaf for its specified denominator cover. -/
def divisorModuleIsoGlued (hcover : ⨆ i, (a i).chart.U = ⊤) :
    divisorModule D ≅ LineBundleGluing.gluedModule (fun i => (a i).chart.U)
      (fun i j => transitionUnit a r i j (hsame i j)) := by
  haveI := isIso_toGlued a r hsame hden hcover
  exact asIso (toGlued a r hsame hden)

end LocalRatioDenominatorCocycle

namespace BasePointFreeLocalRatioCover

variable (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
  (hD : BasePointFreeLinearSystem D)

/-- The selected denominator cover presents `O(D)` as a glued scheme module.
The presentation retains the choices of denominator indices and opens. -/
def divisorModuleIsoSelectedGlued :
    divisorModule D ≅ LineBundleGluing.gluedModule
      (fun x => (selectedCoordinates basis hD x).chart.U)
      (fun x y => LocalRatioDenominatorCocycle.transitionUnit
        (selectedCoordinates basis hD) (selectedRegularization basis hD) x y
        (selectedCoordinates_sameSectionValues basis hD x y)) :=
  LocalRatioDenominatorCocycle.divisorModuleIsoGlued
    (selectedCoordinates basis hD) (selectedRegularization basis hD)
    (selectedCoordinates_sameSectionValues basis hD)
    (selectedCoordinates_denominatorOrderEq basis hD)
    (selectedCoordinates_isOpenCover_of_smoothCurve basis hD)

/-- Every basis section is represented by its normalized projective coordinate
in each chart of the selected presentation. -/
lemma divisorModuleIsoSelectedGlued_basisSection (W : X.left.Opens)
    (j : Fin (n + 1)) (x : NonGenericPoint X) :
    ((divisorModuleIsoSelectedGlued basis hD).hom.app W
        (show Γ(divisorModule D, W) from
          divisorSectionsRes D le_top (basisSections basis j))).val x =
      X.left.resHom inf_le_right ((selectedRegularization basis hD x).regularized j) := by
  change (selectedCoordinates basis hD x).denominatorSectionEquiv
      (selectedCoordinates_denominatorOrderEq basis hD x) inf_le_right
      (divisorSectionsRes D inf_le_left
        (divisorSectionsRes D le_top (basisSections basis j))) = _
  have hres : divisorSectionsRes D inf_le_left
        (divisorSectionsRes D le_top (basisSections basis j)) =
      divisorSectionsRes D
        (inf_le_right : W ⊓ (selectedCoordinates basis hD x).chart.U ≤ _)
        ((selectedCoordinates basis hD x).sections j) := by
    change divisorSectionsRes D inf_le_left
        (divisorSectionsRes D le_top (basisSections basis j)) =
      divisorSectionsRes D inf_le_right
        (divisorSectionsRes D le_top (basisSections basis j))
    rw [← LinearMap.comp_apply, ← divisorSectionsRes_comp,
      ← LinearMap.comp_apply, ← divisorSectionsRes_comp]
  rw [hres]
  exact LocalRatioCoordinateData.denominatorSectionEquiv_sections _ _ _ _ _

end BasePointFreeLocalRatioCover

end
end Hartshorne
