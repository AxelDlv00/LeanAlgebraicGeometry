/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.TensorObjSubstrate.PullbackTensorIso
import AlgebraicJacobian.Picard.TensorObjInverse

/-!
# The pullback–tensor comparison with one trivialised factor

This file records the **one-sided closure** of the pullback–tensor comparison
`Scheme.Modules.pullbackTensorMap f P Q : f^*(P ⊗ Q) ⟶ f^*P ⊗ f^*Q`
(`Picard/TensorObjSubstrate.lean`): the specific comparison map is invertible for
a second factor `Q ≅ 𝒪_X` and an **arbitrary** first factor `P`.

## Why this shape, and what it is for

The campaign milestone D2' (`AJC.picrep.divgrassmannian`) needs the comparison at
`P ⊗ L^{⊗m}` where `P` is a *quotient sheaf of a divisor family* — not locally
free, not trivialisable — and `L^{⊗m}` is a line bundle. The landed
`Modules.pullbackTensorIsoOfLocallyTrivial`
(`Picard/TensorObjSubstrate/PullbackTensorIso.lean:153`) requires **both**
factors locally trivial, so it does not apply; the general statement
`Modules.pullbackTensorMap_isIso` (`Picard/QuotFunctorDef.lean:458`) is a
`sorry`. Between those two lies exactly the shape a twist needs, and this file
measures how much of it is free.

## What is proved here

* `pullbackTensorMap_isIso_of_right_iso_unit` — **PROVED, sorry-free**: if the
  second factor is *isomorphic to* the structure sheaf, invertibility transfers
  from the unconditional structure-sheaf case
  `pullbackTensorMap_isIso_of_right_unit`. The first factor is arbitrary. The
  transfer uses the unconditional naturality square `pullbackTensorMap_natural`.

* `pullbackTensorMap_isIso_of_right_locallyTrivial` — the chart-local assembly:
  a locally trivial second factor suffices, while the first factor remains
  arbitrary.

## The honest accounting

An earlier version carried the on-the-nose right-unit case as the unproduced
class `PullbackTensorRightUnit`. That residual is now deleted. The closure is
shorter than a second sheaf-level coherence chase: presheaf pullback's free
`Functor.OplaxMonoidal.right_unitality_hom` factors the cotensorator through the
unit comparison; the existing sheafification/unit-square theorem makes that
comparison invertible, and the sheafification localizer is stable under left
whiskering. Thus:

* **left-hand unit case, arbitrary second factor** — unconditional
  (`pullbackTensorMap_isIso_of_left_unit`), from that square;
* **right-hand unit case, arbitrary first factor** — unconditional for the
  *specific map* (`pullbackTensorMap_isIso_of_right_unit`);
* **right-hand trivialised factor, arbitrary first factor** — unconditional
  after supplying only the displayed trivialisation.

The consumers are the D2'/D4' Quot/Grassmannian steps on the Picard
representability route.

## References

Stacks 01CD (`tensor-product-pullback`), the unconditional statement this file
approximates. Blueprint: `lem:pullback_tensor_map_isiso`,
`lem:pullback_tensor_iso_loctriv`.
-/

set_option autoImplicit false

universe u

open CategoryTheory

namespace AlgebraicGeometry

namespace Scheme.Modules

/-- Extract the middle morphism of an isomorphic four-fold composite when the
other three morphisms are isomorphisms. -/
private lemma isIso_of_isIso_comp4_mid {C : Type*} [Category C]
    {W X Y Z T : C} {a : W ⟶ X} {b : X ⟶ Y} {c : Y ⟶ Z} {d : Z ⟶ T}
    (h : IsIso (a ≫ b ≫ c ≫ d)) (ha : IsIso a) (hc : IsIso c) (hd : IsIso d) :
    IsIso b := by
  haveI := h
  haveI := ha
  haveI := hc
  haveI := hd
  haveI : IsIso (b ≫ c ≫ d) := IsIso.of_isIso_comp_left a (b ≫ c ≫ d)
  exact IsIso.of_isIso_comp_right b (c ≫ d)

/-- **One-sided transfer along an isomorphism of the second factor.**

If `Q ≅ 𝒪_X` then `pullbackTensorMap f P Q` is invertible for an
**arbitrary** first factor `P`.

The proof is `pullbackTensorMap_isIso_of_base_unit`'s, with `𝟙 P` in place of a
trivialisation of the first factor: `pullbackTensorMap_natural` is
unconditional, so the naturality square for `(𝟙 P, eQ.hom)` exhibits
`pullbackTensorMap f P Q` as a right factor of a composite of isomorphisms.
The right-unit input is the unconditional
`pullbackTensorMap_isIso_of_right_unit`; only the second factor is constrained,
which is the whole point — the first is the divisor-family quotient of D2',
which is not trivialisable. -/
theorem pullbackTensorMap_isIso_of_right_iso_unit {X Y : Scheme.{u}} (f : Y ⟶ X)
    (P Q : X.Modules) (eQ : Q ≅ SheafOfModules.unit X.ringCatSheaf) :
    IsIso (pullbackTensorMap f P Q) := by
  have hnat := pullbackTensorMap_natural f (𝟙 P) eQ.hom
  haveI : IsIso (tensorObj_functoriality (𝟙 P) eQ.hom) :=
    (tensorObjIsoOfIso (Iso.refl P) eQ).isIso_hom
  haveI : IsIso ((Scheme.Modules.pullback f).map (tensorObj_functoriality (𝟙 P) eQ.hom)) :=
    Functor.map_isIso _ _
  haveI hG : IsIso (tensorObj_functoriality ((Scheme.Modules.pullback f).map (𝟙 P))
      ((Scheme.Modules.pullback f).map eQ.hom)) :=
    (tensorObjIsoOfIso ((Scheme.Modules.pullback f).mapIso (Iso.refl P))
      ((Scheme.Modules.pullback f).mapIso eQ)).isIso_hom
  haveI hL : IsIso ((Scheme.Modules.pullback f).map (tensorObj_functoriality (𝟙 P) eQ.hom) ≫
      pullbackTensorMap f P (SheafOfModules.unit X.ringCatSheaf)) := by
    haveI := pullbackTensorMap_isIso_of_right_unit f P
    infer_instance
  rw [hnat] at hL
  exact IsIso.of_isIso_comp_right (pullbackTensorMap f P Q)
    (tensorObj_functoriality ((Scheme.Modules.pullback f).map (𝟙 P))
      ((Scheme.Modules.pullback f).map eQ.hom))

/-- **The mirror of `pullbackTensorMap_isIso_of_right_iso_unit`**: first factor
isomorphic to `𝒪_X`, second arbitrary. Same naturality argument with `𝟙 Q` in the
second slot. -/
theorem pullbackTensorMap_isIso_of_left_iso_unit {X Y : Scheme.{u}} (f : Y ⟶ X)
    (P Q : X.Modules) (eP : P ≅ SheafOfModules.unit X.ringCatSheaf)
    (h : IsIso (pullbackTensorMap f (SheafOfModules.unit X.ringCatSheaf) Q)) :
    IsIso (pullbackTensorMap f P Q) := by
  have hnat := pullbackTensorMap_natural f eP.hom (𝟙 Q)
  haveI : IsIso (tensorObj_functoriality eP.hom (𝟙 Q)) :=
    (tensorObjIsoOfIso eP (Iso.refl Q)).isIso_hom
  haveI : IsIso ((Scheme.Modules.pullback f).map (tensorObj_functoriality eP.hom (𝟙 Q))) :=
    Functor.map_isIso _ _
  haveI hG : IsIso (tensorObj_functoriality ((Scheme.Modules.pullback f).map eP.hom)
      ((Scheme.Modules.pullback f).map (𝟙 Q))) :=
    (tensorObjIsoOfIso ((Scheme.Modules.pullback f).mapIso eP)
      ((Scheme.Modules.pullback f).mapIso (Iso.refl Q))).isIso_hom
  haveI hL : IsIso ((Scheme.Modules.pullback f).map (tensorObj_functoriality eP.hom (𝟙 Q)) ≫
      pullbackTensorMap f (SheafOfModules.unit X.ringCatSheaf) Q) := inferInstance
  rw [hnat] at hL
  exact IsIso.of_isIso_comp_right (pullbackTensorMap f P Q)
    (tensorObj_functoriality ((Scheme.Modules.pullback f).map eP.hom)
      ((Scheme.Modules.pullback f).map (𝟙 Q)))

/-- **The left-hand unit case is UNCONDITIONAL** — arbitrary second factor, no
gate, no local triviality anywhere.

`f^*(𝒪_X ⊗ M) ⟶ f^*𝒪_X ⊗ f^*M` is an isomorphism for every `f` and every `M`.
This is `Modules.pullbackTensorMap_left_unitality`
(`Picard/TensorObjInverse.lean:2377`) read as an invertibility statement: that
square exhibits `pullbackTensorMap f 𝒪_X M`, post-composed with two
isomorphisms, as `f^*` of the left unitor — itself an isomorphism — so the
comparison is invertible by right cancellation. -/
theorem pullbackTensorMap_isIso_of_left_unit {X Y : Scheme.{u}} (f : Y ⟶ X)
    (M : X.Modules) :
    IsIso (pullbackTensorMap f (SheafOfModules.unit X.ringCatSheaf) M) := by
  have h := pullbackTensorMap_left_unitality f M
  haveI : IsIso ((tensorObjIsoOfIso (pullbackUnitIso f)
      (Iso.refl ((Scheme.Modules.pullback f).obj M))).hom) :=
    (tensorObjIsoOfIso (pullbackUnitIso f) (Iso.refl _)).isIso_hom
  haveI : IsIso ((tensorObj_left_unitor ((Scheme.Modules.pullback f).obj M)).hom) :=
    (tensorObj_left_unitor _).isIso_hom
  haveI h3 : IsIso ((Scheme.Modules.pullback f).map (tensorObj_left_unitor M).hom) :=
    Functor.map_isIso _ _
  rw [← h] at h3
  exact IsIso.of_isIso_comp_right
    (pullbackTensorMap f (SheafOfModules.unit X.ringCatSheaf) M)
    ((tensorObjIsoOfIso (pullbackUnitIso f)
        (Iso.refl ((Scheme.Modules.pullback f).obj M))).hom
      ≫ (tensorObj_left_unitor ((Scheme.Modules.pullback f).obj M)).hom)

/-- **The twist comparison D2' needs, UNCONDITIONALLY**: for an arbitrary `P` and
an `L ≅ 𝒪_X`,
`f^*(P ⊗ L) ≅ f^*P ⊗ f^*L`.

No gate, no local triviality on `P`, and the sorried
`Modules.pullbackTensorMap_isIso` is not consumed. Its hom is now the specific
map `pullbackTensorMap f P L`, not merely an isomorphism obtained by braiding. -/
noncomputable def pullbackTensorIsoOfTwist {X Y : Scheme.{u}} (f : Y ⟶ X)
    (P L : X.Modules) (eL : L ≅ SheafOfModules.unit X.ringCatSheaf) :
    (Scheme.Modules.pullback f).obj (tensorObj P L) ≅
      tensorObj ((Scheme.Modules.pullback f).obj P) ((Scheme.Modules.pullback f).obj L) :=
  @asIso _ _ _ _ (pullbackTensorMap f P L)
    (pullbackTensorMap_isIso_of_right_iso_unit f P L eL)

/-- On a chart where the second factor is trivial, the restriction of the
one-sided pullback--tensor comparison is an isomorphism. -/
private lemma pullbackTensorMap_right_chart_isIso {X Y U V : Scheme.{u}}
    (f : Y ⟶ X) (P Q : X.Modules) (j : U ⟶ X) (j' : V ⟶ Y) (g : V ⟶ U)
    [IsOpenImmersion j] [IsOpenImmersion j'] (hcomp : j' ≫ f = g ≫ j)
    (eQ : (Scheme.Modules.pullback j).obj Q ≅
      SheafOfModules.unit U.ringCatSheaf) :
    IsIso ((Scheme.Modules.restrictFunctor j').map (pullbackTensorMap f P Q)) := by
  refine (CategoryTheory.NatIso.isIso_map_iff
    (Scheme.Modules.restrictFunctorIsoPullback j') (pullbackTensorMap f P Q)).mpr ?_
  have hcompiso : IsIso (pullbackTensorMap (j' ≫ f) P Q) := by
    rw [hcomp, pullbackTensorMap_restrict g j P Q]
    haveI hj : IsIso (pullbackTensorMap j P Q) :=
      pullbackTensorMap_isIso_of_isOpenImmersion j P Q
    have hb : IsIso ((Scheme.Modules.pullback g).map (pullbackTensorMap j P Q)) :=
      Functor.map_isIso _ _
    have hc : IsIso (pullbackTensorMap g ((Scheme.Modules.pullback j).obj P)
        ((Scheme.Modules.pullback j).obj Q)) :=
      pullbackTensorMap_isIso_of_right_iso_unit g _ _ eQ
    have ha : IsIso ((Scheme.Modules.pullbackComp g j).inv.app (tensorObj P Q)) := by
      infer_instance
    have hd : IsIso (tensorObjIsoOfIso ((Scheme.Modules.pullbackComp g j).app P)
        ((Scheme.Modules.pullbackComp g j).app Q)).hom :=
      (tensorObjIsoOfIso ((Scheme.Modules.pullbackComp g j).app P)
        ((Scheme.Modules.pullbackComp g j).app Q)).isIso_hom
    exact IsIso.comp_isIso' ha (IsIso.comp_isIso' hb (IsIso.comp_isIso' hc hd))
  rw [pullbackTensorMap_restrict j' f P Q] at hcompiso
  haveI : IsIso (pullbackTensorMap j' ((Scheme.Modules.pullback f).obj P)
      ((Scheme.Modules.pullback f).obj Q)) :=
    pullbackTensorMap_isIso_of_isOpenImmersion j' _ _
  haveI hinv : IsIso ((Scheme.Modules.pullbackComp j' f).inv.app (tensorObj P Q)) := by
    infer_instance
  exact isIso_of_isIso_comp4_mid hcompiso hinv inferInstance inferInstance

/-- **The one-sided pullback--tensor comparison.** If the second factor is
locally trivial and the first factor is arbitrary, then the specific comparison
`f^*(P ⊗ Q) ⟶ f^*P ⊗ f^*Q` is an isomorphism. -/
theorem pullbackTensorMap_isIso_of_right_locallyTrivial {X Y : Scheme.{u}} (f : Y ⟶ X)
    (P Q : X.Modules) (hQ : LineBundle.IsLocallyTrivial Q) :
    IsIso (pullbackTensorMap f P Q) := by
  have key : ∀ y : Y, ∃ V : Y.Opens, y ∈ V ∧
      IsIso ((Scheme.Modules.restrictFunctor V.ι).map (pullbackTensorMap f P Q)) := by
    intro y
    obtain ⟨U, hxU, _, ⟨eQ0⟩⟩ := hQ (f.base y)
    have hyU : y ∈ f ⁻¹ᵁ U := hxU
    obtain ⟨V, _, hyV, hVU⟩ :=
      exists_isAffineOpen_mem_and_subset (X := Y) (x := y) hyU
    have eQ : (Scheme.Modules.pullback U.ι).obj Q ≅
        SheafOfModules.unit (U : Scheme).ringCatSheaf :=
      (Scheme.Modules.restrictFunctorIsoPullback U.ι).symm.app Q ≪≫ eQ0
    set g : (V : Scheme) ⟶ (U : Scheme) := f.resLE U V hVU with hg_def
    have hcomp : V.ι ≫ f = g ≫ U.ι := (Scheme.Hom.resLE_comp_ι f hVU).symm
    exact ⟨V, hyV, pullbackTensorMap_right_chart_isIso
      f P Q U.ι V.ι g hcomp eQ⟩
  exact isIso_of_isIso_restrict (pullbackTensorMap f P Q)
    (fun y => (key y).choose)
    (fun y => (key y).choose_spec.1)
    (fun y => (key y).choose_spec.2)

/-- The `Iso` packaging of `pullbackTensorMap_isIso_of_right_locallyTrivial`,
for consumers that want `f^*(P ⊗ Q) ≅ f^*P ⊗ f^*Q` as data. Its hom is
definitionally the specific comparison map. -/
noncomputable def pullbackTensorIsoOfRightLocallyTrivial {X Y : Scheme.{u}} (f : Y ⟶ X)
    (P Q : X.Modules) (hQ : LineBundle.IsLocallyTrivial Q) :
    (Scheme.Modules.pullback f).obj (tensorObj P Q) ≅
      tensorObj ((Scheme.Modules.pullback f).obj P) ((Scheme.Modules.pullback f).obj Q) :=
  @asIso _ _ _ _ (pullbackTensorMap f P Q)
    (pullbackTensorMap_isIso_of_right_locallyTrivial f P Q hQ)

end Scheme.Modules

end AlgebraicGeometry
