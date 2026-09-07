/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter2LineBundleGluingPullbackIso
import HartshorneLib.Chapter4ProjectiveTwistingSheaf

/-!
# Coordinate sections of an arbitrary projective pullback

The homogeneous coordinates pull back along any morphism to projective space.
Each pulled-back coordinate is a frame on the inverse image of its standard
chart. Transport along an isomorphism with a line bundle gives a family of
global sections, without a completeness or linear-independence assumption.
This is the section-extraction step in the converse of Hartshorne IV.3.1.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

universe u

open CategoryTheory Opposite TopologicalSpace AlgebraicGeometry

namespace Hartshorne.ProjectiveTwist

noncomputable section

variable {k : Type u} [Field k] {J : Type} {X : Scheme.{u}}

attribute [local instance] MvPolynomial.gradedAlgebra

variable (f : X ⟶ Proj (MvPolynomial.homogeneousSubmodule J k))

/-- Pullback of a homogeneous coordinate, on any source open. -/
def pullbackCoordinateSection (j : J) (W : X.Opens) :
    Γ((Scheme.Modules.pullback f).obj (twistingSheafOne (k := k) (J := J)), W) :=
  ModulePullbackFrames.baseMap f twistingSheafOne le_top (coordinateSection j ⊤)

/-- Pulled-back coordinate sections commute with source restriction. -/
theorem pullbackCoordinateSection_restrict {W V : X.Opens} (h : V ≤ W) (j : J) :
    ((Scheme.Modules.pullback f).obj twistingSheafOne).presheaf.map (homOfLE h).op
        (pullbackCoordinateSection f j W) = pullbackCoordinateSection f j V := by
  simpa only [pullbackCoordinateSection, coordinateSection_restrict] using
    ModulePullbackFrames.baseMap_res f (twistingSheafOne (k := k) (J := J))
      (W' := W) (W'' := V) (V' := ⊤) (V'' := ⊤) le_top le_top le_rfl h
      (coordinateSection j ⊤)

/-- Over a standard chart the global coordinate pullback agrees with the
pullback of the coordinate restricted to that chart. -/
theorem pullbackCoordinateSection_eq_baseMap (i j : J) {W : X.Opens}
    (hW : W ≤ f ⁻¹ᵁ chart i) :
    pullbackCoordinateSection f j W =
    ModulePullbackFrames.baseMap f twistingSheafOne hW
        (coordinateSection j (chart i)) := by
  have h := ModulePullbackFrames.baseMap_res f
    (twistingSheafOne (k := k) (J := J))
    (W' := W) (W'' := W) (V' := ⊤) (V'' := chart i)
    le_top hW le_top le_rfl (coordinateSection j ⊤)
  simpa only [pullbackCoordinateSection, show homOfLE (le_refl W) = 𝟙 W from rfl, op_id,
    ((Scheme.Modules.pullback f).obj twistingSheafOne).presheaf.map_id,
    AddCommGrpCat.hom_id, AddMonoidHom.id_apply,
    coordinateSection_restrict] using h

/-- The coordinate frame transported to a source open contained in its
inverse image. -/
def pullbackCoordinateFrame (i : J) (V : X.Opens) (hV : V ≤ f ⁻¹ᵁ chart i) :
    (Scheme.Modules.restrictFunctor V.ι).obj
        ((Scheme.Modules.pullback f).obj (twistingSheafOne (k := k) (J := J))) ≅
      SheafOfModules.unit V.toScheme.ringCatSheaf :=
  ModulePullbackFrames.pullbackFrameIso f (chart i) V hV twistingSheafOne
    (trivialization (k := k) i)

/-- The homogeneous coordinate is one in the standard chart trivialization. -/
theorem trivialization_coordinateSection_self (i : J) :
    ((trivialization (k := k) i).hom.app ⊤).hom
      (((twistingSheafOne (k := k) (J := J)).presheaf.map
        (eqToHom (Scheme.Opens.ι_image_top (chart (k := k) i))).op).hom
          (coordinateSection i (chart i))) = (1 : Γ((chart (k := k) i).toScheme, ⊤)) := by
  exact LineBundleGluing.trivialization_hom_app_top_eq_one
    (matchingCocycle (k := k)) i (coordinateSection (k := k) i (chart i))
    (sectionTriv_coordinateSection_self i (W := chart i) le_rfl)

/-- A homogeneous coordinate has value one in its induced pullback frame. -/
theorem pullbackCoordinateFrame_coordinateSection (i : J) (V : X.Opens)
    (hV : V ≤ f ⁻¹ᵁ chart i) :
    ((pullbackCoordinateFrame f i V hV).hom.app ⊤).hom
        (pullbackCoordinateSection f i (V.ι ''ᵁ (⊤ : V.toScheme.Opens))) =
      (1 : Γ(V.toScheme, ⊤)) := by
  let hOpen : V.ι ''ᵁ (⊤ : V.toScheme.Opens) ≤ f ⁻¹ᵁ chart i := by simpa using hV
  have hFrame : pullbackCoordinateFrame f i V hV =
      ModulePullbackFrames.pullbackFrameIso f (chart i) V hV
        (twistingSheafOne (k := k) (J := J)) (trivialization (k := k) i) := rfl
  rw [pullbackCoordinateSection_eq_baseMap f i i hOpen, hFrame]
  exact ModulePullbackFrames.pullbackFrameIso_baseMap_one f (chart i) V hV
    (twistingSheafOne (k := k) (J := J)) (trivialization (k := k) i)
    (coordinateSection (k := k) i (chart i))
    (LineBundleGluing.trivialization_hom_app_top_eq_one
      (matchingCocycle (k := k)) i (coordinateSection (k := k) i (chart i))
      (sectionTriv_coordinateSection_self i (W := chart i) le_rfl))

variable {M : X.Modules}
  (e : (Scheme.Modules.pullback f).obj (twistingSheafOne (k := k) (J := J)) ≅ M)

/-- Coordinate sections transported through a specified pullback isomorphism.
They need not be linearly independent or span all global sections. -/
def coordinateSectionOfIso (j : J) (W : X.Opens) : Γ(M, W) :=
  e.hom.app W (pullbackCoordinateSection f j W)

/-- The transported coordinates form compatible sections of the target module. -/
theorem coordinateSectionOfIso_restrict {W V : X.Opens} (h : V ≤ W) (j : J) :
    M.presheaf.map (homOfLE h).op (coordinateSectionOfIso f e j W) =
      coordinateSectionOfIso f e j V := by
  have hn := ConcreteCategory.congr_hom
    ((Scheme.Modules.Hom.mapPresheaf e.hom).naturality (homOfLE h).op)
    (pullbackCoordinateSection f j W)
  change (e.hom.app V).hom
    (((Scheme.Modules.pullback f).obj twistingSheafOne).presheaf.map (homOfLE h).op
      (pullbackCoordinateSection f j W)) = _ at hn
  rw [pullbackCoordinateSection_restrict] at hn
  exact hn.symm

/-- The transported coordinate frame on a source chart. -/
def coordinateFrameOfIso (i : J) (V : X.Opens) (hV : V ≤ f ⁻¹ᵁ chart i) :
    (Scheme.Modules.restrictFunctor V.ι).obj M ≅
      SheafOfModules.unit V.toScheme.ringCatSheaf :=
  (Scheme.Modules.restrictFunctor V.ι).mapIso e.symm ≪≫
    pullbackCoordinateFrame f i V hV

/-- The restriction of the global coordinate section is one in its frame. -/
theorem coordinateFrameOfIso_coordinateSection (i : J) (V : X.Opens)
    (hV : V ≤ f ⁻¹ᵁ chart i) :
    ((coordinateFrameOfIso f e i V hV).hom.app ⊤).hom
        (M.presheaf.map
          (homOfLE (le_top : V.ι ''ᵁ (⊤ : V.toScheme.Opens) ≤ ⊤)).op
            (coordinateSectionOfIso f e i ⊤)) = (1 : Γ(V.toScheme, ⊤)) := by
  rw [coordinateSectionOfIso_restrict]
  change ((pullbackCoordinateFrame f i V hV).hom.app ⊤).hom
    ((e.inv.app _).hom ((e.hom.app _).hom
      (pullbackCoordinateSection f i (V.ι ''ᵁ (⊤ : V.toScheme.Opens))))) = _
  rw [← AddCommGrpCat.comp_apply, ← Scheme.Modules.Hom.comp_app, e.hom_inv_id,
    Scheme.Modules.Hom.id_app]
  exact pullbackCoordinateFrame_coordinateSection f i V hV

/-- Every source point lies in a chart on which one of the global pulled-back
coordinates is a frame. -/
theorem exists_coordinateFrameOfIso (x : X) :
    ∃ (i : J) (V : X.Opens) (_ : x ∈ V)
      (eV : (Scheme.Modules.restrictFunctor V.ι).obj M ≅
        SheafOfModules.unit V.toScheme.ringCatSheaf),
      (eV.hom.app ⊤).hom
        (M.presheaf.map
          (homOfLE (le_top : V.ι ''ᵁ (⊤ : V.toScheme.Opens) ≤ ⊤)).op
            (coordinateSectionOfIso f e i ⊤)) = (1 : Γ(V.toScheme, ⊤)) := by
  have hx : f x ∈ ⨆ i : J, chart (k := k) i := by rw [iSup_chart]; trivial
  obtain ⟨i, hi⟩ := Opens.mem_iSup.mp hx
  exact ⟨i, f ⁻¹ᵁ chart i, hi, coordinateFrameOfIso f e i _ le_rfl,
    coordinateFrameOfIso_coordinateSection f e i _ le_rfl⟩

end
end Hartshorne.ProjectiveTwist
