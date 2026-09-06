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

private lemma tensorObjIsoOfIso_hom_local {X : Scheme.{u}} {M M' N N' : X.Modules}
    (e : M ≅ M') (e' : N ≅ N') :
    (tensorObjIsoOfIso e e').hom = tensorObj_functoriality e.hom e'.hom := rfl

set_option maxHeartbeats 2500000 in
-- Naturality crosses the sheafification carrier and needs extra elaboration time.
private lemma right_unitor_naturality_local {W : Scheme.{u}} {M M' : W.Modules} (g : M ≅ M') :
    tensorObjIsoOfIso g (Iso.refl (SheafOfModules.unit W.ringCatSheaf))
        ≪≫ tensorObj_right_unitor M'
      = tensorObj_right_unitor M ≪≫ g := by
  apply Iso.ext
  have hpre : MonoidalCategory.tensorHom
        (C := _root_.PresheafOfModules (W.presheaf ⋙ forget₂ CommRingCat RingCat))
        ((SheafOfModules.forget W.ringCatSheaf).map g.hom)
        (𝟙 ((SheafOfModules.forget W.ringCatSheaf).obj (SheafOfModules.unit W.ringCatSheaf)))
      ≫ ((PresheafOfModules.monoidalCategoryStruct (R := W.presheaf)).rightUnitor M'.val).hom
      = ((PresheafOfModules.monoidalCategoryStruct (R := W.presheaf)).rightUnitor M.val).hom
        ≫ (SheafOfModules.forget W.ringCatSheaf).map g.hom := by
    exact MonoidalCategory.rightUnitor_naturality _
  simp only [tensorObjIsoOfIso, tensorObj_right_unitor, Iso.trans_hom, Functor.mapIso_hom,
    MonoidalCategory.tensorIso_hom, Functor.mapIso_refl, Iso.refl_hom, Category.assoc]
  rw [← Category.assoc]
  erw [← Functor.map_comp, hpre, Functor.map_comp, Category.assoc]
  erw [(PresheafOfModules.sheafificationAdjunction (𝟙 W.ringCatSheaf.obj)).counit.naturality g.hom]
  rfl

set_option maxHeartbeats 2500000 in
-- Expanding the sheafification unit and counit is heartbeat-heavy.
private lemma right_image_collapse_local {Y : Scheme.{u}} (P : _root_.PresheafOfModules
    (Y.presheaf ⋙ forget₂ CommRingCat RingCat)) :
    (sheafifyTensorUnitIso (X := Y) P
          (𝟙_ (_root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat)))).hom
        ≫ (tensorObjIsoOfIso
            (Iso.refl ((PresheafOfModules.sheafification (R := Y.ringCatSheaf)
              (𝟙 Y.ringCatSheaf.obj)).obj P))
            (sheafifyUnitIso (Y := Y))).hom
        ≫ (tensorObj_right_unitor ((PresheafOfModules.sheafification (R := Y.ringCatSheaf)
            (𝟙 Y.ringCatSheaf.obj)).obj P)).hom
      = (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).map
          ((PresheafOfModules.monoidalCategoryStruct (R := Y.presheaf)).rightUnitor P).hom := by
  rw [sheafifyTensorUnitIso_hom_eq', tensorObjIsoOfIso, tensorObj_right_unitor]
  simp only [Iso.trans_hom, Functor.mapIso_hom, asIso_hom, Iso.app_hom,
    MonoidalCategory.tensorIso_hom, Iso.refl_hom]
  have hpre :
      (MonoidalCategory.tensorHom
          (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
          ((PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
            (𝟙 Y.ringCatSheaf.obj)).unit.app P)
          ((PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
            (𝟙 Y.ringCatSheaf.obj)).unit.app
            (𝟙_ (_root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))))
        ≫ MonoidalCategory.tensorHom
            (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
            ((Iso.refl ((PresheafOfModules.sheafification (R := Y.ringCatSheaf)
              (𝟙 Y.ringCatSheaf.obj)).obj P)).hom.val)
            ((sheafifyUnitIso (Y := Y)).hom.val))
        ≫ ((PresheafOfModules.monoidalCategoryStruct (R := Y.presheaf)).rightUnitor
            ((PresheafOfModules.sheafification (R := Y.ringCatSheaf)
              (𝟙 Y.ringCatSheaf.obj)).obj P).val).hom
      = ((PresheafOfModules.monoidalCategoryStruct (R := Y.presheaf)).rightUnitor P).hom
        ≫ (PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
            (𝟙 Y.ringCatSheaf.obj)).unit.app P := by
    have htri : (PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
            (𝟙 Y.ringCatSheaf.obj)).unit.app
            (𝟙_ (_root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat)))
          ≫ (sheafifyUnitIso (Y := Y)).hom.val = 𝟙 _ := by
      rw [sheafifyUnitIso]
      have h := (PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
          (𝟙 Y.ringCatSheaf.obj)).right_triangle_components (SheafOfModules.unit Y.ringCatSheaf)
      simp only [Iso.app_hom, asIso_hom] at h ⊢
      exact h
    simp only [Iso.refl_hom, SheafOfModules.id_val]
    rw [MonoidalCategory.tensorHom_comp_tensorHom,
      ← MonoidalCategory.rightUnitor_naturality]
    congr 1
    exact congrArg₂ (fun a b => MonoidalCategory.tensorHom
      (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat)) a b)
      (Category.comp_id _) htri
  erw [← Functor.map_comp_assoc, ← Functor.map_comp_assoc]
  refine Eq.trans (congrArg (fun m =>
      (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).map m ≫
      (PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
        (𝟙 Y.ringCatSheaf.obj)).counit.app
        ((PresheafOfModules.sheafification (R := Y.ringCatSheaf)
          (𝟙 Y.ringCatSheaf.obj)).obj P)) hpre) ?_
  beta_reduce
  erw [Functor.map_comp_assoc]
  have htr := (PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
    (𝟙 Y.ringCatSheaf.obj)).left_triangle_components P
  exact (congrArg (fun z => (PresheafOfModules.sheafification (R := Y.ringCatSheaf)
    (𝟙 Y.ringCatSheaf.obj)).map
      ((PresheafOfModules.monoidalCategoryStruct
        (R := Y.presheaf)).rightUnitor P).hom ≫ z) htr).trans
    (Category.comp_id _)

set_option maxHeartbeats 2500000 in
-- This comparison crosses nested presheaf-to-sheaf identifications.
private lemma right_unitor_pullback_eq_sheafify_local {X Y : Scheme.{u}} (f : Y ⟶ X)
    (M : X.Modules) :
    letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
        (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
        (f.toRingCatSheafHom).hom
    (sheafifyTensorUnitIso (X := Y)
          ((PresheafOfModules.pullback φ').obj M.val)
          (𝟙_ (_root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat)))).hom
        ≫ (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).map
            (MonoidalCategory.tensorHom
              (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
              ((SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f M).hom)
              ((SheafOfModules.forget Y.ringCatSheaf).map (sheafifyUnitIso (Y := Y)).hom))
        ≫ (tensorObj_right_unitor ((pullback f).obj M)).hom
      = (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).map
          ((PresheafOfModules.monoidalCategoryStruct (R := Y.presheaf)).rightUnitor
            ((PresheafOfModules.pullback (f.toRingCatSheafHom).hom).obj M.val)).hom
        ≫ (pullbackValIso f M).hom := by
  have hw : (PresheafOfModules.sheafification (R := Y.ringCatSheaf)
        (𝟙 Y.ringCatSheaf.obj)).map
        (MonoidalCategory.tensorHom
          (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
          ((SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f M).hom)
          ((SheafOfModules.forget Y.ringCatSheaf).map (sheafifyUnitIso (Y := Y)).hom))
      = (tensorObjIsoOfIso (pullbackValIso f M) (sheafifyUnitIso (Y := Y))).hom := rfl
  erw [hw]
  have hsplit : tensorObjIsoOfIso (pullbackValIso f M) (sheafifyUnitIso (Y := Y))
      = tensorObjIsoOfIso
          (Iso.refl ((PresheafOfModules.sheafification (R := Y.ringCatSheaf)
            (𝟙 Y.ringCatSheaf.obj)).obj
            ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj M.val)))
          (sheafifyUnitIso (Y := Y))
        ≪≫ tensorObjIsoOfIso (pullbackValIso f M)
          (Iso.refl (SheafOfModules.unit Y.ringCatSheaf)) := by
    have h := (tensorObjIsoOfIso_trans
      (e₁ := Iso.refl ((PresheafOfModules.sheafification (R := Y.ringCatSheaf)
        (𝟙 Y.ringCatSheaf.obj)).obj
        ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj M.val)))
      (e₂ := pullbackValIso f M)
      (e'₁ := sheafifyUnitIso (Y := Y))
      (e'₂ := Iso.refl (SheafOfModules.unit Y.ringCatSheaf)))
    erw [Iso.refl_trans, Iso.trans_refl] at h
    exact h
  rw [hsplit]
  simp only [Iso.trans_hom]
  have hcollapse := right_image_collapse_local (Y := Y)
    ((PresheafOfModules.pullback (f.toRingCatSheafHom).hom).obj M.val)
  have hnat := right_unitor_naturality_local (W := Y) (pullbackValIso f M)
  have hnat_hom := congrArg Iso.hom hnat
  simp only [Iso.trans_hom] at hnat_hom
  let A := (sheafifyTensorUnitIso (X := Y)
    ((PresheafOfModules.pullback (f.toRingCatSheafHom).hom).obj M.val)
    (𝟙_ (_root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat)))).hom
  let B := (tensorObjIsoOfIso
    (Iso.refl ((PresheafOfModules.sheafification (R := Y.ringCatSheaf)
      (𝟙 Y.ringCatSheaf.obj)).obj
      ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj M.val)))
    (sheafifyUnitIso (Y := Y))).hom
  let C := (tensorObjIsoOfIso (pullbackValIso f M)
      (Iso.refl (SheafOfModules.unit Y.ringCatSheaf))).hom
  let R := (tensorObj_right_unitor
      ((PresheafOfModules.sheafification (R := Y.ringCatSheaf)
        (𝟙 Y.ringCatSheaf.obj)).obj
        ((PresheafOfModules.pullback (f.toRingCatSheafHom).hom).obj M.val))).hom
  let V := (pullbackValIso f M).hom
  have h1 := congrArg (fun z => A ≫ B ≫ z) hnat_hom
  have h2 := congrArg (fun z => z ≫ V) hcollapse
  have h12 := h1.trans h2
  convert h12 using 1 <;> rfl

private lemma pullbackUnitIso_eq_sheafify_eta_local {X Y : Scheme.{u}} (f : Y ⟶ X) :
    letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
        (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
        (f.toRingCatSheafHom).hom
    (pullbackUnitIso f).hom
      = (pullbackValIso f (SheafOfModules.unit X.ringCatSheaf)).inv ≫
          (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).map
            (Functor.OplaxMonoidal.η (PresheafOfModules.pullback φ')) ≫ sheafifyUnitIso.hom := by
  exact (pullbackEtaUnitSquare f).symm

private lemma pullbackTensorMap_eq_sheafify_delta_local {X Y : Scheme.{u}} (f : Y ⟶ X)
    (M N : X.Modules) :
    letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
        (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
        (f.toRingCatSheafHom).hom
    pullbackTensorMap f M N
      = (SheafOfModules.sheafificationCompPullback f.toRingCatSheafHom).hom.app
            (PresheafOfModules.Monoidal.tensorObj M.val N.val)
          ≫ (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).map
              (Functor.OplaxMonoidal.δ (PresheafOfModules.pullback φ') M.val N.val)
          ≫ (sheafifyTensorUnitIso (X := Y)
              ((PresheafOfModules.pullback φ').obj M.val)
              ((PresheafOfModules.pullback φ').obj N.val)).hom
          ≫ (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).map
              (MonoidalCategory.tensorHom
                (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
                ((SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f M).hom)
                ((SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f N).hom)) :=
  rfl

private lemma pullback_map_tensorObj_right_unitor_eq_local {X Y : Scheme.{u}} (f : Y ⟶ X)
    (M : X.Modules) :
    (pullback f).map (tensorObj_right_unitor M).hom
      = (SheafOfModules.sheafificationCompPullback f.toRingCatSheafHom).hom.app
            (PresheafOfModules.Monoidal.tensorObj M.val
              (SheafOfModules.unit X.ringCatSheaf).val)
        ≫ (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).map
            ((PresheafOfModules.pullback (f.toRingCatSheafHom).hom).map
              ((PresheafOfModules.monoidalCategoryStruct (R := X.presheaf)).rightUnitor M.val).hom)
        ≫ (pullbackValIso f M).hom := by
  rw [tensorObj_right_unitor]
  simp only [Iso.trans_hom, Functor.mapIso_hom, asIso_hom, Iso.app_hom]
  erw [Functor.map_comp]
  have hc : (pullback f).map
        ((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
          (𝟙 X.ringCatSheaf.obj)).counit.app M)
      = (SheafOfModules.sheafificationCompPullback f.toRingCatSheafHom).hom.app M.val
          ≫ (pullbackValIso f M).hom := by
    rw [pullbackValIso, Iso.trans_hom, Iso.symm_hom, Functor.mapIso_hom]
    exact Eq.symm (Iso.hom_inv_id_app_assoc _ _ _)
  have hnat := (SheafOfModules.sheafificationCompPullback f.toRingCatSheafHom).hom.naturality
    ((PresheafOfModules.monoidalCategoryStruct (R := X.presheaf)).rightUnitor M.val).hom
  erw [hc]
  exact (Category.assoc _ _ _).symm.trans
    ((congrArg (· ≫ (pullbackValIso f M).hom) hnat).trans (Category.assoc _ _ _))

set_option maxHeartbeats 2500000 in
-- The unit-whisker calculation reassociates sheafified tensor composites.
private lemma pullbackUnitIso_rightWhisker_eq_sheafify_eta_local {X Y : Scheme.{u}}
    (f : Y ⟶ X) (M : X.Modules) :
    letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
        (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
        (f.toRingCatSheafHom).hom
    (sheafifyTensorUnitIso (X := Y)
          ((PresheafOfModules.pullback φ').obj M.val)
          ((PresheafOfModules.pullback φ').obj
            (SheafOfModules.unit X.ringCatSheaf).val)).hom
        ≫ (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).map
            (MonoidalCategory.tensorHom
              (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
              ((SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f M).hom)
              ((SheafOfModules.forget Y.ringCatSheaf).map
                (pullbackValIso f (SheafOfModules.unit X.ringCatSheaf)).hom))
        ≫ (tensorObjIsoOfIso (Iso.refl ((pullback f).obj M)) (pullbackUnitIso f)).hom
      = (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).map
            ((PresheafOfModules.pullback φ').obj M.val ◁
              Functor.OplaxMonoidal.η (PresheafOfModules.pullback φ'))
        ≫ (sheafifyTensorUnitIso (X := Y)
              ((PresheafOfModules.pullback φ').obj M.val)
              (𝟙_ (_root_.PresheafOfModules
                (Y.presheaf ⋙ forget₂ CommRingCat RingCat)))).hom
        ≫ (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).map
            (MonoidalCategory.tensorHom
              (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
              ((SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f M).hom)
              ((SheafOfModules.forget Y.ringCatSheaf).map (sheafifyUnitIso (Y := Y)).hom)) := by
  rw [tensorObjIsoOfIso_hom_local, pullbackUnitIso_eq_sheafify_eta_local f, Iso.refl_hom]
  letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
      (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
      (Hom.toRingCatSheafHom f).hom
  rw [tensorObj_functoriality]
  erw [← Functor.map_comp]
  conv_rhs => erw [reassoc_of% (sheafifyTensorUnitIso_hom_natural (X := Y)
    (𝟙 ((PresheafOfModules.pullback φ').obj M.val))
    (Functor.OplaxMonoidal.η (PresheafOfModules.pullback φ')))]
  refine (congrArg₂ (· ≫ ·) rfl
      ((congrArg (PresheafOfModules.sheafification (R := Y.ringCatSheaf)
        (𝟙 Y.ringCatSheaf.obj)).map ?hpre).trans (Functor.map_comp _ _ _))).trans
    (Category.assoc _ _ _).symm
  case hpre =>
    simp only [SheafOfModules.comp_val, SheafOfModules.forget_map]
    have hc : (pullbackValIso f (SheafOfModules.unit X.ringCatSheaf)).hom.val
          ≫ (pullbackValIso f (SheafOfModules.unit X.ringCatSheaf)).inv.val = 𝟙 _ := by
      have h0 := congrArg (SheafOfModules.forget Y.ringCatSheaf).map
        (Iso.hom_inv_id (pullbackValIso f (SheafOfModules.unit X.ringCatSheaf)))
      simp only [SheafOfModules.comp_val, SheafOfModules.forget_map,
        SheafOfModules.id_val] at h0 ⊢
      exact h0
    refine (MonoidalCategory.tensorHom_comp_tensorHom
          (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
          _ _ _ _).trans
      (Eq.trans ?_ (MonoidalCategory.tensorHom_comp_tensorHom
        (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
        _ _ _ _).symm)
    congr 1
    · erw [CategoryTheory.Functor.map_id]
      aesop_cat
    · exact (Category.assoc _ _ _).symm.trans
        ((congrArg (· ≫ _) hc).trans (Category.id_comp _))

set_option maxHeartbeats 4000000 in
-- The full coherence proof assembles the sheafification comparison maps.
/-- The pullback tensor comparison preserves the right unit.  This is the
right-handed monoidal coherence used in the base-change naturality of
Kleiman's linear-system construction (`th:LinSys`, TeX lines 2000--2004). -/
theorem pullbackTensorMap_right_unitality {X Y : Scheme.{u}} (f : Y ⟶ X)
    (M : X.Modules) :
    pullbackTensorMap f M (SheafOfModules.unit X.ringCatSheaf)
        ≫ (tensorObjIsoOfIso (Iso.refl ((pullback f).obj M)) (pullbackUnitIso f)).hom
        ≫ (tensorObj_right_unitor ((pullback f).obj M)).hom
      = (pullback f).map (tensorObj_right_unitor M).hom := by
  letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
      (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
      (f.toRingCatSheafHom).hom
  rw [pullbackTensorMap_eq_sheafify_delta_local f M
      (SheafOfModules.unit X.ringCatSheaf),
    pullback_map_tensorObj_right_unitor_eq_local f M]
  have hru := Functor.OplaxMonoidal.right_unitality_hom
    (PresheafOfModules.pullback φ') M.val
  have hHRU : (PresheafOfModules.sheafification (R := Y.ringCatSheaf)
        (𝟙 Y.ringCatSheaf.obj)).map
        (Functor.OplaxMonoidal.δ (PresheafOfModules.pullback φ') M.val
          (SheafOfModules.unit X.ringCatSheaf).val)
      ≫ (PresheafOfModules.sheafification (R := Y.ringCatSheaf)
          (𝟙 Y.ringCatSheaf.obj)).map
          ((PresheafOfModules.pullback φ').obj M.val ◁
            Functor.OplaxMonoidal.η (PresheafOfModules.pullback φ'))
      ≫ (PresheafOfModules.sheafification (R := Y.ringCatSheaf)
          (𝟙 Y.ringCatSheaf.obj)).map
          ((PresheafOfModules.monoidalCategoryStruct (R := Y.presheaf)).rightUnitor
            ((PresheafOfModules.pullback φ').obj M.val)).hom
      = (PresheafOfModules.sheafification (R := Y.ringCatSheaf)
          (𝟙 Y.ringCatSheaf.obj)).map
          ((PresheafOfModules.pullback φ').map
            ((PresheafOfModules.monoidalCategoryStruct
              (R := X.presheaf)).rightUnitor M.val).hom) := by
    rw [← Functor.map_comp, ← Functor.map_comp]
    exact congrArg _ hru
  erw [← hHRU]
  have hR3 := pullbackUnitIso_rightWhisker_eq_sheafify_eta_local f M
  have hR2 := right_unitor_pullback_eq_sheafify_local f M
  refine (Category.assoc _ _ _).trans ?_
  congr 1
  refine (Category.assoc _ _ _).trans (Eq.trans ?_ (Category.assoc _ _ _).symm)
  congr 1
  refine (Category.assoc _ _ _).trans ?_
  exact (((reassoc_of% hR3) (((pullback f).obj M).tensorObj_right_unitor.hom)).trans
      (congrArg (fun t => (PresheafOfModules.sheafification (R := Y.ringCatSheaf)
          (𝟙 Y.ringCatSheaf.obj)).map
            ((PresheafOfModules.pullback φ').obj M.val ◁
              Functor.OplaxMonoidal.η (PresheafOfModules.pullback φ')) ≫ t) hR2)).trans
    (Category.assoc _ _ _).symm

private lemma pullbackTensorMap_right_unitality_inv_local {X Y : Scheme.{u}}
    (f : Y ⟶ X) (M : X.Modules) :
    (pullback f).map (tensorObj_right_unitor M).inv ≫
        pullbackTensorMap f M (SheafOfModules.unit X.ringCatSheaf) ≫
        (tensorObjIsoOfIso (Iso.refl ((pullback f).obj M)) (pullbackUnitIso f)).hom
      = (tensorObj_right_unitor ((pullback f).obj M)).inv := by
  have h := pullbackTensorMap_right_unitality f M
  rw [← cancel_mono (tensorObj_right_unitor ((pullback f).obj M)).hom]
  simp only [Category.assoc, Iso.inv_hom_id]
  rw [h]
  simp

private lemma right_unitor_naturality_inv_local {W : Scheme.{u}} {M M' : W.Modules}
    (g : M ≅ M') :
    g.inv ≫ (tensorObj_right_unitor M).inv ≫
        (tensorObjIsoOfIso g (Iso.refl (SheafOfModules.unit W.ringCatSheaf))).hom
      = (tensorObj_right_unitor M').inv := by
  have h := congrArg Iso.hom (right_unitor_naturality_local g)
  simp only [Iso.trans_hom] at h
  rw [← cancel_mono (tensorObj_right_unitor M').hom]
  simp only [Category.assoc, Iso.inv_hom_id]
  rw [h]
  simp


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

private lemma unit_triangle_local {S X : Scheme.{u}} {π : X ⟶ S} {T T' : Over S}
    (ψ : T' ⟶ T) :
    (Modules.pullbackUnitIso (quotBaseMap π ψ)).inv ≫
        (Modules.pullback (quotBaseMap π ψ)).map
          (Modules.pullbackUnitIso (pullback.fst π T.hom)).inv =
      (Modules.pullbackUnitIso (pullback.fst π T'.hom)).inv ≫
        (pullbackTriangleIso (quotBaseMap_fst π ψ)
          (SheafOfModules.unit X.ringCatSheaf)).inv := by
  have hcomp := Modules.pullbackUnitIso_comp (pullback.fst π T.hom)
    (quotBaseMap π ψ)
  have hcong := Modules.pullbackCongr_hom_app_unit (quotBaseMap_fst π ψ)
  have hforward :
      (pullbackTriangleIso (quotBaseMap_fst π ψ)
          (SheafOfModules.unit X.ringCatSheaf)).hom ≫
        (Modules.pullbackUnitIso (pullback.fst π T'.hom)).hom =
      (Modules.pullback (quotBaseMap π ψ)).map
          (Modules.pullbackUnitIso (pullback.fst π T.hom)).hom ≫
        (Modules.pullbackUnitIso (quotBaseMap π ψ)).hom := by
    unfold pullbackTriangleIso
    rw [Iso.trans_hom, Category.assoc]
    rw [hcong]
    exact hcomp
  let C := pullbackTriangleIso (quotBaseMap_fst π ψ)
      (SheafOfModules.unit X.ringCatSheaf)
  let D := Modules.pullbackUnitIso (pullback.fst π T'.hom)
  let A := Modules.pullbackUnitIso (quotBaseMap π ψ)
  let G := Modules.pullbackUnitIso (pullback.fst π T.hom)
  have hiso : C ≪≫ D =
      (Modules.pullback (quotBaseMap π ψ)).mapIso G ≪≫ A := by
    apply Iso.ext
    exact hforward
  have hinv := congrArg Iso.inv hiso
  simpa only [Iso.trans_inv, Functor.mapIso_inv] using hinv.symm

private lemma map_tensorHom_comp2_local {C D : Type*} [Category C] [MonoidalCategory C]
    [Category D] (F : C ⥤ D) {a₀ a₁ a₂ b₀ b₁ b₂ : C}
    (a : a₀ ⟶ a₁) (b : a₁ ⟶ a₂) (c : b₀ ⟶ b₁) (d : b₁ ⟶ b₂) :
    F.map (MonoidalCategory.tensorHom a c) ≫ F.map (MonoidalCategory.tensorHom b d) =
      F.map (MonoidalCategory.tensorHom (a ≫ b) (c ≫ d)) := by
  rw [← F.map_comp, MonoidalCategory.tensorHom_comp_tensorHom]

private lemma tensorObj_functoriality_comp2_local {Y : Scheme.{u}}
    {M₀ M₁ M₂ N₀ N₁ N₂ : Y.Modules}
    (a : M₀ ⟶ M₁) (b : M₁ ⟶ M₂) (c : N₀ ⟶ N₁) (d : N₁ ⟶ N₂) :
    Modules.tensorObj_functoriality a c ≫ Modules.tensorObj_functoriality b d =
      Modules.tensorObj_functoriality (a ≫ b) (c ≫ d) := by
  simp only [Modules.tensorObj_functoriality]
  exact map_tensorHom_comp2_local
    (C := _root_.PresheafOfModules
      (Y.presheaf ⋙ forget₂ CommRingCat RingCat)) _ _ _ _ _

set_option maxHeartbeats 4000000 in
-- The naturality chase crosses several reducible module carriers.
set_option backward.isDefEq.respectTransparency false in
/-- Pulling back a twisted divisor quotient and applying the canonical twist
comparison gives the twisted quotient of the pulled-back family.  This is the
map-level functoriality required by Kleiman's `th:LinSys` construction (TeX
lines 2000--2004). -/
lemma twistPullbackMap_comp_twistQuotientMap
    {S X : Scheme.{u}} {π : X ⟶ S} {T T' : Over S}
    (L : X.Modules) (x : DivFamily π T) (ψ : T' ⟶ T) :
    (pullbackTriangleIso (quotBaseMap_fst π ψ) L).inv ≫
        (Modules.pullback (quotBaseMap π ψ)).map (x.twistQuotientMap L) ≫
      twistPullbackMap L x ψ =
        (x.pullbackAlong ψ).twistQuotientMap L := by
  unfold twistPullbackMap twistQuotientMap
  rw [Functor.map_comp]
  simp only [Category.assoc]
  have hnat := Modules.pullbackTensorMap_natural (f := quotBaseMap π ψ)
    (a := 𝟙 ((Modules.pullback (pullback.fst π T.hom)).obj L))
    (b := (Modules.pullbackUnitIso (pullback.fst π T.hom)).inv ≫ x.q)
  have hnat' := congrArg (fun m =>
      (pullbackTriangleIso (quotBaseMap_fst π ψ) L).inv ≫
        (Modules.pullback (quotBaseMap π ψ)).map
          ((Modules.pullback (pullback.fst π T.hom)).obj L).tensorObj_right_unitor.inv ≫
        m ≫
        (Modules.tensorObjIsoOfIso (pullbackTriangleIso (quotBaseMap_fst π ψ) L)
          (Iso.refl ((Modules.pullback (quotBaseMap π ψ)).obj x.F))).hom) hnat
  calc
    _ = (pullbackTriangleIso (quotBaseMap_fst π ψ) L).inv ≫
        (Modules.pullback (quotBaseMap π ψ)).map
          ((Modules.pullback (pullback.fst π T.hom)).obj L).tensorObj_right_unitor.inv ≫
        ((Modules.pullback (quotBaseMap π ψ)).map
            (Modules.tensorObj_functoriality (𝟙
              ((Modules.pullback (pullback.fst π T.hom)).obj L))
              ((Modules.pullbackUnitIso (pullback.fst π T.hom)).inv ≫ x.q)) ≫
          Modules.pullbackTensorMap (quotBaseMap π ψ)
            ((Modules.pullback (pullback.fst π T.hom)).obj L) x.F) ≫
        (Modules.tensorObjIsoOfIso (pullbackTriangleIso (quotBaseMap_fst π ψ) L)
          (Iso.refl ((Modules.pullback (quotBaseMap π ψ)).obj x.F))).hom := by
      simp only [Category.assoc]
    _ = (pullbackTriangleIso (quotBaseMap_fst π ψ) L).inv ≫
        (Modules.pullback (quotBaseMap π ψ)).map
          ((Modules.pullback (pullback.fst π T.hom)).obj L).tensorObj_right_unitor.inv ≫
        (Modules.pullbackTensorMap (quotBaseMap π ψ)
            ((Modules.pullback (pullback.fst π T.hom)).obj L)
            (SheafOfModules.unit (pullback π T.hom).ringCatSheaf) ≫
          Modules.tensorObj_functoriality
            ((Modules.pullback (quotBaseMap π ψ)).map
              (𝟙 ((Modules.pullback (pullback.fst π T.hom)).obj L)))
            ((Modules.pullback (quotBaseMap π ψ)).map
              ((Modules.pullbackUnitIso (pullback.fst π T.hom)).inv ≫ x.q))) ≫
        (Modules.tensorObjIsoOfIso (pullbackTriangleIso (quotBaseMap_fst π ψ) L)
          (Iso.refl ((Modules.pullback (quotBaseMap π ψ)).obj x.F))).hom := hnat'
    _ = _ := by
      let f := quotBaseMap π ψ
      let M := (Modules.pullback (pullback.fst π T.hom)).obj L
      let M' := (Modules.pullback (pullback.fst π T'.hom)).obj L
      let U := Modules.pullbackUnitIso f
      let A := pullbackTriangleIso (quotBaseMap_fst π ψ) L
      let B := pullbackTriangleIso (quotBaseMap_fst π ψ)
        (SheafOfModules.unit X.ringCatSheaf)
      let c := U.inv ≫
        (Modules.pullback f).map (Modules.pullbackUnitIso (pullback.fst π T.hom)).inv ≫
        (Modules.pullback f).map x.q
      have hfactor :
          Modules.tensorObj_functoriality
              ((Modules.pullback f).map (𝟙 M))
              ((Modules.pullback f).map
                ((Modules.pullbackUnitIso (pullback.fst π T.hom)).inv ≫ x.q)) =
            (Modules.tensorObjIsoOfIso (Iso.refl ((Modules.pullback f).obj M)) U).hom ≫
              Modules.tensorObj_functoriality (𝟙 ((Modules.pullback f).obj M)) c := by
        rw [Modules.tensorObjIsoOfIso_hom_local]
        rw [tensorObj_functoriality_comp2_local]
        congr 1
        · simp
        · dsimp only [c]
          rw [Functor.map_comp]
          exact (Iso.hom_inv_id_assoc U
            ((Modules.pullback f).map (Modules.pullbackUnitIso
              (pullback.fst π T.hom)).inv ≫ (Modules.pullback f).map x.q)).symm
      rw [hfactor]
      simp only [Category.assoc]
      have hunit := Modules.pullbackTensorMap_right_unitality_inv_local f M
      erw [reassoc_of% hunit]
      have hswap :
          Modules.tensorObj_functoriality (𝟙 ((Modules.pullback f).obj M)) c ≫
              (Modules.tensorObjIsoOfIso A
                (Iso.refl ((Modules.pullback f).obj x.F))).hom =
            (Modules.tensorObjIsoOfIso A
                (Iso.refl (SheafOfModules.unit (pullback π T'.hom).ringCatSheaf))).hom ≫
              Modules.tensorObj_functoriality (𝟙 M') c := by
        rw [Modules.tensorObjIsoOfIso_hom_local,
          Modules.tensorObjIsoOfIso_hom_local]
        rw [tensorObj_functoriality_comp2_local,
          tensorObj_functoriality_comp2_local]
        exact congrArg (fun z => Modules.tensorObj_functoriality z c)
          (Category.comp_id A.hom).symm
      have hn := Modules.right_unitor_naturality_inv_local A
      rw [hswap]
      erw [reassoc_of% hn]
      have htri := unit_triangle_local (S := S) (X := X) (π := π) ψ
      dsimp only [c, U, f]
      rw [← Category.assoc, htri]
      rfl


end DivFamily

end Scheme

end AlgebraicGeometry
