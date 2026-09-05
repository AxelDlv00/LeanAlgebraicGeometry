/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivGrassmannianClass
import AlgebraicJacobian.Picard.PullbackTensorOneSided

/-!
# Base change of the divisor Grassmannian twist

This file supplies the first naturality layer for the divisor-to-Grassmannian
construction.  Pulling a divisor family from `T` to `T'` canonically compares
the pullback of its twisted sheaf with the twisted sheaf of the pulled-back
family.  For the locally trivial twists used in the Grassmannian construction,
the two sheaves are isomorphic.

Source: Kleiman, *The Picard scheme*, `th:LinSys`, especially the functoriality
in the test scheme `T` stated at TeX lines 2000--2004.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory

namespace AlgebraicGeometry

namespace Scheme

namespace Modules

/-- Extract the middle morphism of an isomorphic four-fold composite when the
other three morphisms are isomorphisms. -/
private lemma isIso_of_isIso_comp4_middle {C : Type*} [Category C]
    {W X Y Z T : C} {a : W ⟶ X} {b : X ⟶ Y} {c : Y ⟶ Z} {d : Z ⟶ T}
    (h : IsIso (a ≫ b ≫ c ≫ d)) (ha : IsIso a) (hc : IsIso c) (hd : IsIso d) :
    IsIso b := by
  haveI := h
  haveI := ha
  haveI := hc
  haveI := hd
  haveI : IsIso (b ≫ c ≫ d) := IsIso.of_isIso_comp_left a (b ≫ c ≫ d)
  exact IsIso.of_isIso_comp_right b (c ≫ d)

/-- On a chart where the first factor is trivial, the restriction of the
pullback--tensor comparison is an isomorphism. -/
private lemma pullbackTensorMap_left_chart_isIso {X Y U V : Scheme.{u}}
    (f : Y ⟶ X) (P Q : X.Modules) (j : U ⟶ X) (j' : V ⟶ Y) (g : V ⟶ U)
    [IsOpenImmersion j] [IsOpenImmersion j'] (hcomp : j' ≫ f = g ≫ j)
    (eP : (pullback j).obj P ≅ SheafOfModules.unit U.ringCatSheaf) :
    IsIso ((restrictFunctor j').map (pullbackTensorMap f P Q)) := by
  refine (CategoryTheory.NatIso.isIso_map_iff
    (restrictFunctorIsoPullback j') (pullbackTensorMap f P Q)).mpr ?_
  have hcompiso : IsIso (pullbackTensorMap (j' ≫ f) P Q) := by
    rw [hcomp, pullbackTensorMap_restrict g j P Q]
    haveI hj : IsIso (pullbackTensorMap j P Q) :=
      pullbackTensorMap_isIso_of_isOpenImmersion j P Q
    have hb : IsIso ((pullback g).map (pullbackTensorMap j P Q)) :=
      Functor.map_isIso _ _
    have hc : IsIso (pullbackTensorMap g ((pullback j).obj P)
        ((pullback j).obj Q)) :=
      pullbackTensorMap_isIso_of_left_iso_unit g _ _ eP
        (pullbackTensorMap_isIso_of_left_unit g _)
    have ha : IsIso ((pullbackComp g j).inv.app (tensorObj P Q)) := by
      infer_instance
    have hd : IsIso (tensorObjIsoOfIso ((pullbackComp g j).app P)
        ((pullbackComp g j).app Q)).hom :=
      (tensorObjIsoOfIso ((pullbackComp g j).app P)
        ((pullbackComp g j).app Q)).isIso_hom
    exact IsIso.comp_isIso' ha (IsIso.comp_isIso' hb (IsIso.comp_isIso' hc hd))
  rw [pullbackTensorMap_restrict j' f P Q] at hcompiso
  haveI : IsIso (pullbackTensorMap j' ((pullback f).obj P)
      ((pullback f).obj Q)) :=
    pullbackTensorMap_isIso_of_isOpenImmersion j' _ _
  haveI hinv : IsIso ((pullbackComp j' f).inv.app (tensorObj P Q)) := by
    infer_instance
  exact isIso_of_isIso_comp4_middle hcompiso hinv inferInstance inferInstance

/-- The canonical pullback--tensor comparison is an isomorphism when its first
factor is locally trivial; the second factor is arbitrary.  This is the mirror
of `pullbackTensorMap_isIso_of_right_locallyTrivial`. -/
theorem pullbackTensorMap_isIso_of_left_locallyTrivial {X Y : Scheme.{u}}
    (f : Y ⟶ X) (P Q : X.Modules) (hP : LineBundle.IsLocallyTrivial P) :
    IsIso (pullbackTensorMap f P Q) := by
  have key : ∀ y : Y, ∃ V : Y.Opens, y ∈ V ∧
      IsIso ((restrictFunctor V.ι).map (pullbackTensorMap f P Q)) := by
    intro y
    obtain ⟨U, hxU, _, ⟨eP0⟩⟩ := hP (f.base y)
    have hyU : y ∈ f ⁻¹ᵁ U := hxU
    obtain ⟨V, _, hyV, hVU⟩ :=
      exists_isAffineOpen_mem_and_subset (X := Y) (x := y) hyU
    have eP : (pullback U.ι).obj P ≅
        SheafOfModules.unit (U : Scheme).ringCatSheaf :=
      (restrictFunctorIsoPullback U.ι).symm.app P ≪≫ eP0
    set g : (V : Scheme) ⟶ (U : Scheme) := f.resLE U V hVU
    have hcomp : V.ι ≫ f = g ≫ U.ι := (Scheme.Hom.resLE_comp_ι f hVU).symm
    exact ⟨V, hyV, pullbackTensorMap_left_chart_isIso
      f P Q U.ι V.ι g hcomp eP⟩
  exact isIso_of_isIso_restrict (pullbackTensorMap f P Q)
    (fun y => (key y).choose)
    (fun y => (key y).choose_spec.1)
    (fun y => (key y).choose_spec.2)

end Modules

namespace DivFamily

variable {S X : Scheme.{u}} {π : X ⟶ S} {T T' : Over S}

/-- The canonical comparison from the pullback of a twisted divisor sheaf to
the twist of the pulled-back divisor family.  Its first factor is the canonical
pullback--tensor map; the second identifies the two pullbacks of `L` using
`quotBaseMap_fst`. -/
noncomputable def twistPullbackMap (L : X.Modules) (x : DivFamily π T)
    (ψ : T' ⟶ T) :
    (Modules.pullback (quotBaseMap π ψ)).obj (x.twist L) ⟶
      (x.pullbackAlong ψ).twist L :=
  Modules.pullbackTensorMap (quotBaseMap π ψ)
      ((Modules.pullback (pullback.fst π T.hom)).obj L) x.F ≫
    (Modules.tensorObjIsoOfIso
      (pullbackTriangleIso (quotBaseMap_fst π ψ) L)
      (Iso.refl ((Modules.pullback (quotBaseMap π ψ)).obj x.F))).hom

/-- The canonical twist comparison is invertible when the twisting module is
locally trivial.  No local-triviality hypothesis is imposed on the divisor
sheaf. -/
theorem twistPullbackMap_isIso (L : X.Modules) (x : DivFamily π T)
    (ψ : T' ⟶ T) (hL : LineBundle.IsLocallyTrivial L) :
    IsIso (twistPullbackMap L x ψ) := by
  unfold twistPullbackMap
  have hleft : IsIso (Modules.pullbackTensorMap (quotBaseMap π ψ)
      ((Modules.pullback (pullback.fst π T.hom)).obj L) x.F) :=
    Modules.pullbackTensorMap_isIso_of_left_locallyTrivial _ _ _
      (hL.pullback (pullback.fst π T.hom))
  exact IsIso.comp_isIso' hleft
    (Modules.tensorObjIsoOfIso
      (pullbackTriangleIso (quotBaseMap_fst π ψ) L)
      (Iso.refl ((Modules.pullback (quotBaseMap π ψ)).obj x.F))).isIso_hom

/-- Pullback commutes with the divisor twist when the twisting module is
locally trivial.  Its hom is the canonical comparison `twistPullbackMap`.
This is the sheaf-level base-change input for the functoriality in `T` of
Kleiman's `th:LinSys` (TeX lines 2000--2004). -/
noncomputable def twistPullbackIso (L : X.Modules) (x : DivFamily π T)
    (ψ : T' ⟶ T) (hL : LineBundle.IsLocallyTrivial L) :
    (Modules.pullback (quotBaseMap π ψ)).obj (x.twist L) ≅
      (x.pullbackAlong ψ).twist L :=
  @asIso _ _ _ _ (twistPullbackMap L x ψ) (twistPullbackMap_isIso L x ψ hL)

@[simp]
lemma twistPullbackIso_hom (L : X.Modules) (x : DivFamily π T)
    (ψ : T' ⟶ T) (hL : LineBundle.IsLocallyTrivial L) :
    (twistPullbackIso L x ψ hL).hom = twistPullbackMap L x ψ := rfl

end DivFamily

end Scheme

end AlgebraicGeometry
