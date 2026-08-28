/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter2
import Mathlib.CategoryTheory.Sites.LeftExact
import Mathlib.Topology.Sheaves.Sheafify
import Mathlib.Topology.Sheaves.Functors
import Mathlib.Topology.Sheaves.Stalks

/-!
# Hartshorne II.1: Sheaves

This file gives the source-facing names used for the basic presheaf, stalk,
sheafification, and direct-image constructions.  The constructions themselves
are the corresponding mathlib ones; the wrappers keep the chapter API small
and avoid committing to a particular presentation of inverse image.
-/

namespace Hartshorne

noncomputable section

open CategoryTheory CategoryTheory.Limits TopologicalSpace Opposite

universe u v w

abbrev Presheaf (C : Type u) [Category.{v} C] (X : TopCat.{w}) :=
  TopCat.Presheaf C X

abbrev Sheaf (C : Type u) [Category.{v} C] (X : TopCat.{w}) :=
  TopCat.Sheaf C X

abbrev IsSheaf {C : Type u} [Category.{v} C] {X : TopCat.{w}}
    (F : Presheaf C X) : Prop :=
  TopCat.Presheaf.IsSheaf F

abbrev Stalk {C : Type u} [Category.{v} C] {X : TopCat.{v}}
    (F : Presheaf C X) [HasColimits C] (x : X) : C :=
  TopCat.Presheaf.stalk F x

def stalkMap {C : Type u} [Category.{v} C] {X : TopCat.{v}}
    {F G : Presheaf C X} [HasColimits C] (φ : F ⟶ G) (x : X) :
    Stalk F x ⟶ Stalk G x :=
  (TopCat.Presheaf.stalkFunctor C x).map φ

@[simp] theorem stalkMap_id {C : Type u} [Category.{v} C] {X : TopCat.{v}}
    {F : Presheaf C X} [HasColimits C] (x : X) :
    stalkMap (𝟙 F) x = 𝟙 _ := by
  simp [stalkMap]

@[simp, reassoc] theorem stalkMap_comp {C : Type u} [Category.{v} C] {X : TopCat.{v}}
    {F G H : Presheaf C X} [HasColimits C] (f : F ⟶ G) (g : G ⟶ H) (x : X) :
    stalkMap (f ≫ g) x = stalkMap f x ≫ stalkMap g x := by
  simp [stalkMap]

def germ {C : Type u} [Category.{v} C] {X : TopCat.{v}} [HasColimits C]
    (F : Presheaf C X) (U : Opens X) (x : X) (hx : x ∈ U) :
    F.obj (op U) ⟶ Stalk F x :=
  TopCat.Presheaf.germ F U x hx

@[reassoc] theorem germ_restrict {C : Type u} [Category.{v} C] {X : TopCat.{v}}
    [HasColimits C]
    (F : Presheaf C X) {U V : Opens X} (i : U ⟶ V) (x : X) (hx : x ∈ U) :
    F.map i.op ≫ germ F U x hx = germ F V x (i.le hx) := by
  exact TopCat.Presheaf.germ_res F i x hx

abbrev TypePresheaf (X : TopCat.{u}) := TopCat.Presheaf (Type u) X

abbrev TypeSheaf (X : TopCat.{u}) := TopCat.Sheaf (Type u) X

noncomputable def sheafification {X : TopCat.{u}} (F : TypePresheaf X) :
    TypeSheaf X :=
  F.sheafify

theorem sheafification_condition {X : TopCat.{u}} (F : TypePresheaf X) :
    IsSheaf (sheafification F).presheaf := by
  exact (sheafification F).property

theorem sheafification_isSheaf {X : TopCat.{u}} (F : TypePresheaf X) :
    IsSheaf (sheafification F).presheaf := by
  exact sheafification_condition F

noncomputable def sheafification_stalkIso {X : TopCat.{u}}
    (F : TypePresheaf X) (x : X) :
    Stalk (sheafification F).presheaf x ≅ Stalk F x := by
  exact F.sheafifyStalkIso x

noncomputable def categoricalSheafification {X : TopCat.{u}} (F : TypePresheaf X) :
    TypeSheaf X :=
  (CategoryTheory.presheafToSheaf
    (Opens.grothendieckTopology X) (Type u)).obj F

noncomputable def categoricalSheafificationUnit {X : TopCat.{u}} (F : TypePresheaf X) :
    F ⟶ (categoricalSheafification F).presheaf :=
  (CategoryTheory.sheafificationAdjunction
    (Opens.grothendieckTopology X) (Type u)).unit.app F

noncomputable def categoricalSheafificationLift {X : TopCat.{u}} {G : TypeSheaf X}
    (F : TypePresheaf X) (η : F ⟶ G.presheaf) :
    (categoricalSheafification F).presheaf ⟶ G.presheaf :=
  CategoryTheory.sheafifyLift (Opens.grothendieckTopology X) η G.property

@[reassoc (attr := simp)]
theorem categoricalSheafificationUnit_lift {X : TopCat.{u}} {G : TypeSheaf X}
    (F : TypePresheaf X) (η : F ⟶ G.presheaf) :
    categoricalSheafificationUnit F ≫ categoricalSheafificationLift F η = η :=
  CategoryTheory.toSheafify_sheafifyLift
    (Opens.grothendieckTopology X) η G.property

theorem categoricalSheafificationLift_unique {X : TopCat.{u}} {G : TypeSheaf X}
    (F : TypePresheaf X) (η : F ⟶ G.presheaf)
    (γ : (categoricalSheafification F).presheaf ⟶ G.presheaf)
    (h : categoricalSheafificationUnit F ≫ γ = η) :
    γ = categoricalSheafificationLift F η := by
  apply CategoryTheory.sheafifyLift_unique
    (Opens.grothendieckTopology X) η G.property γ
  exact h

theorem categoricalSheafificationUnit_stalk_isIso {X : TopCat.{u}}
    (F : TypePresheaf X) (x : X) :
    IsIso ((TopCat.Presheaf.stalkFunctor (Type u) x).map
      (categoricalSheafificationUnit F)) := by
  exact TopCat.Presheaf.stalkFunctor_map_unit_toSheafify_isIso x (Type u) F

def directImage {C : Type u} [Category.{v} C] {X Y : TopCat.{w}} (f : X ⟶ Y) :
    Sheaf C X ⥤ Sheaf C Y :=
  TopCat.Sheaf.pushforward C f

def presheafDirectImage {X Y : TopCat.{u}} (f : X ⟶ Y) :
    Presheaf CommRingCat X ⥤ Presheaf CommRingCat Y :=
  TopCat.Presheaf.pushforward CommRingCat f

noncomputable def presheafInverseImage {X Y : TopCat.{u}} (f : X ⟶ Y) :
    Presheaf CommRingCat Y ⥤ Presheaf CommRingCat X :=
  TopCat.Presheaf.pullback CommRingCat f

noncomputable def sheafInverseImage {X Y : TopCat.{u}} (f : X ⟶ Y) :
    Sheaf CommRingCat Y ⥤ Sheaf CommRingCat X :=
  TopCat.Sheaf.pullback CommRingCat f

noncomputable def sheafInverseImageDirectImageAdjunction
    {X Y : TopCat.{u}} (f : X ⟶ Y) :
    sheafInverseImage f ⊣ directImage f :=
  TopCat.Sheaf.pullbackPushforwardAdjunction CommRingCat f

theorem directImage_presheaf_isSheaf {C : Type u} [Category.{v} C]
    {X Y : TopCat.{w}} (f : X ⟶ Y) {F : Presheaf C X} (hF : IsSheaf F) :
    IsSheaf ((TopCat.Presheaf.pushforward C f).obj F) :=
  TopCat.Sheaf.pushforward_sheaf_of_sheaf f hF

theorem sheaf_iso_iff_stalkMap_iso
    {C : Type u} [Category.{v} C] {X : TopCat.{v}}
    {FC : C → C → Type*} {CC : C → Type v}
    [∀ X Y : C, FunLike (FC X Y) (CC X) (CC Y)]
    [ConcreteCategory C FC] [HasColimits C]
    [PreservesFilteredColimits (CategoryTheory.forget C)] [HasLimits C]
    [PreservesLimits (CategoryTheory.forget C)]
    [(CategoryTheory.forget C).ReflectsIsomorphisms]
    {F G : Sheaf C X} (f : F ⟶ G) :
    IsIso f ↔ ∀ x : X, IsIso (stalkMap f.hom x) := by
  exact TopCat.Presheaf.isIso_iff_stalkFunctor_map_iso f

end

end Hartshorne
