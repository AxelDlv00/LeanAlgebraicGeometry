/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors, The Hartshorne Contributors
-/
import Mathlib.AlgebraicGeometry.Modules.Sheaf
import Mathlib.AlgebraicGeometry.Restrict
import Mathlib.Algebra.Category.ModuleCat.Sheaf.PullbackFree
import Mathlib.Topology.Sheaves.Stalks

/-!
# Pullback of local module frames

The adjunction-unit and restriction-coherence proofs are adapted from
`AlgebraicJacobian/Cohomology/NativePushforwardBaseChange{Affine,Mate,Open,Tensor}.lean`
and `AlgebraicJacobian/Picard/Pic0RankOneNativeBaseChangePullback.lean`.
Here the restriction comparison allows any source open contained in the inverse
image of the target open.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

universe u

open CategoryTheory Limits Opposite TopologicalSpace AlgebraicGeometry
open Scheme Scheme.Modules

namespace Hartshorne.ModulePullbackFrames

/-- A morphism of scheme modules is an isomorphism if its restrictions to a family of opens
covering every point are isomorphisms.  The proof transports the restricted stalk maps across
`restrictStalkNatIso`, then reflects the resulting isomorphism of underlying abelian sheaves. -/
theorem isIso_of_isIso_restrict_cover
    {X : Scheme.{u}} {M N : X.Modules} (φ : M ⟶ N)
    {ι : Type*} (U : ι → X.Opens)
    (hcov : ∀ x : X, ∃ i, x ∈ U i)
    (hiso : ∀ i, IsIso ((restrictFunctor (U i).ι).map φ)) :
    IsIso φ := by
  let f := (SheafOfModules.toSheaf.{u} X.ringCatSheaf).map φ
  have hstalk (x : X) :
      IsIso ((TopCat.Presheaf.stalkFunctor Ab x).map f.hom) := by
    change IsIso ((TopCat.Presheaf.stalkFunctor Ab x).map ((toPresheaf X).map φ))
    obtain ⟨i, hx⟩ := hcov x
    let xU : (U i).toScheme := ⟨x, hx⟩
    letI hres : IsIso ((restrictFunctor (U i).ι).map φ) := hiso i
    haveI hpres : IsIso ((toPresheaf (U i).toScheme).map
        ((restrictFunctor (U i).ι).map φ)) :=
      Functor.map_isIso _ _
    haveI hr : IsIso ((TopCat.Presheaf.stalkFunctor Ab xU).map
        ((toPresheaf (U i).toScheme).map ((restrictFunctor (U i).ι).map φ))) :=
      Functor.map_isIso _ _
    let eM := (restrictStalkNatIso (U i).ι xU).app M
    let eN := (restrictStalkNatIso (U i).ι xU).app N
    letI heM : IsIso eM.hom := eM.isIso_hom
    letI heN : IsIso eN.hom := eN.isIso_hom
    have hnat :
        (TopCat.Presheaf.stalkFunctor Ab xU).map
              ((toPresheaf (U i).toScheme).map ((restrictFunctor (U i).ι).map φ)) ≫
            eN.hom =
          eM.hom ≫ (TopCat.Presheaf.stalkFunctor Ab x).map
            ((toPresheaf X).map φ) := by
      exact (restrictStalkNatIso (U i).ι xU).hom.naturality φ
    haveI hcompLeft : IsIso (
        (TopCat.Presheaf.stalkFunctor Ab xU).map
              ((toPresheaf (U i).toScheme).map ((restrictFunctor (U i).ι).map φ)) ≫
            eN.hom) :=
      IsIso.comp_isIso
    haveI hcompRight : IsIso (eM.hom ≫
        (TopCat.Presheaf.stalkFunctor Ab x).map ((toPresheaf X).map φ)) := by
      rw [← hnat]
      exact hcompLeft
    exact IsIso.of_isIso_comp_left eM.hom _
  letI (x : X) := hstalk x
  haveI : IsIso f := TopCat.Presheaf.isIso_of_stalkFunctor_map_iso f
  haveI : IsIso ((toPresheaf X).map φ) := by
    change IsIso f.hom
    infer_instance
  exact isIso_of_reflects_iso φ (toPresheaf X)


private noncomputable def unitAtOpen
    {X Y : Scheme.{u}} (g : Y ⟶ X) (N : X.Modules) (V : X.Opens) :
    Γ(N, V) →ₗ[Γ(X, V)]
      Γ((Scheme.Modules.pushforward g).obj ((Scheme.Modules.pullback g).obj N), V) :=
  (((Scheme.Modules.pullbackPushforwardAdjunction g).unit.app N).val.app (.op V)).hom

/-- The adjunction-unit base map, restricted from `g ⁻¹ᵁ V` to `U`. -/
noncomputable def baseMap
    {X Y : Scheme.{u}} (g : Y ⟶ X) (N : X.Modules)
    {U : Y.Opens} {V : X.Opens} (e : U ≤ g ⁻¹ᵁ V) :
    letI : Algebra Γ(X, V) Γ(Y, U) := (g.appLE V U e).hom.toAlgebra
    letI : Module Γ(X, V) Γ((Scheme.Modules.pullback g).obj N, U) :=
      Module.compHom _ (g.appLE V U e).hom
    Γ(N, V) →ₗ[Γ(X, V)] Γ((Scheme.Modules.pullback g).obj N, U) := by
  letI : Algebra Γ(X, V) Γ(Y, U) := (g.appLE V U e).hom.toAlgebra
  letI : Module Γ(X, V) Γ((Scheme.Modules.pullback g).obj N, U) :=
    Module.compHom _ (g.appLE V U e).hom
  let restr := (((Scheme.Modules.pullback g).obj N).presheaf.map (homOfLE e).op).hom
  let unit := unitAtOpen g N V
  refine
    { toFun := fun x => restr (unit x)
      map_add' := ?_
      map_smul' := ?_ }
  · intro x y
    change restr (unit (x + y)) = restr (unit x) + restr (unit y)
    rw [unit.map_add]
    exact restr.map_add _ _
  · intro r x
    change restr (unit (r • x)) = (g.appLE V U e).hom r • restr (unit x)
    rw [unit.map_smul]
    exact ((Scheme.Modules.pullback g).obj N).map_smul (homOfLE e) _ _

set_option backward.isDefEq.respectTransparency false in
private lemma modules_res_res
    {Y : Scheme.{u}} (N : Y.Modules) {W₁ W₂ W₃ : Y.Opens}
    (i₁ : W₁ ≤ W₂) (i₂ : W₂ ≤ W₃) (i₃ : W₁ ≤ W₃) (x : Γ(N, W₃)) :
    (N.presheaf.map (homOfLE i₁).op).hom ((N.presheaf.map (homOfLE i₂).op).hom x) =
      (N.presheaf.map (homOfLE i₃).op).hom x := by
  rw [← AddCommGrpCat.comp_apply, ← Functor.map_comp, ← op_comp]
  exact (congrArg (fun (i : W₁ ⟶ W₃) =>
    (AddCommGrpCat.Hom.hom (N.presheaf.map i.op)) x) (Subsingleton.elim _ _)).symm

set_option backward.isDefEq.respectTransparency false in
/-- The canonical pullback base map commutes with restriction on both the source and target
opens. -/
lemma baseMap_res
    {X Y : Scheme.{u}} (g : Y ⟶ X) (N : X.Modules)
    {V' V'' : X.Opens} {W' W'' : Y.Opens}
    (hW' : W' ≤ g ⁻¹ᵁ V') (hW'' : W'' ≤ g ⁻¹ᵁ V'')
    (hV : V'' ≤ V') (hW : W'' ≤ W') (x : Γ(N, V')) :
    (((Scheme.Modules.pullback g).obj N).presheaf.map (homOfLE hW).op).hom
        (baseMap g N hW' x) =
      baseMap g N hW''
        ((N.presheaf.map (homOfLE hV).op).hom x) := by
  have hnat := congrArg
    (fun (k : Γ(N, V') ⟶
        Γ((Scheme.Modules.pushforward g).obj ((Scheme.Modules.pullback g).obj N), V'')) =>
      (AddCommGrpCat.Hom.hom k) x)
    ((Scheme.Modules.Hom.mapPresheaf
      ((Scheme.Modules.pullbackPushforwardAdjunction g).unit.app N)).naturality
      (homOfLE hV).op)
  have hL := modules_res_res ((Scheme.Modules.pullback g).obj N)
    hW hW' (hW.trans hW')
    ((Scheme.Modules.Hom.app
      ((Scheme.Modules.pullbackPushforwardAdjunction g).unit.app N) V').hom x)
  have hR := modules_res_res ((Scheme.Modules.pullback g).obj N)
    hW'' (Scheme.Hom.preimage_mono g hV) (hW.trans hW')
    ((Scheme.Modules.Hom.app
      ((Scheme.Modules.pullbackPushforwardAdjunction g).unit.app N) V').hom x)
  change (((Scheme.Modules.pullback g).obj N).presheaf.map (homOfLE hW).op).hom
      ((((Scheme.Modules.pullback g).obj N).presheaf.map (homOfLE hW').op).hom
        ((Scheme.Modules.Hom.app
          ((Scheme.Modules.pullbackPushforwardAdjunction g).unit.app N) V').hom x)) =
    (((Scheme.Modules.pullback g).obj N).presheaf.map (homOfLE hW'').op).hom
      ((Scheme.Modules.Hom.app
        ((Scheme.Modules.pullbackPushforwardAdjunction g).unit.app N) V'').hom
        ((N.presheaf.map (homOfLE hV).op).hom x))
  rw [hL]
  refine hR.symm.trans ?_
  exact (congrArg
    (fun w => (((Scheme.Modules.pullback g).obj N).presheaf.map (homOfLE hW'').op).hom w)
    hnat).symm

set_option backward.isDefEq.respectTransparency false in
/-- The canonical pullback base map is natural in the module. -/
lemma baseMap_naturality
    {X Y : Scheme.{u}} (g : Y ⟶ X) {N N' : X.Modules}
    (h : N ⟶ N') {U : Y.Opens} {V : X.Opens} (e : U ≤ g ⁻¹ᵁ V) (x : Γ(N, V)) :
    (Scheme.Modules.Hom.app ((Scheme.Modules.pullback g).map h) U).hom
        (baseMap g N e x) =
      baseMap g N' e ((Scheme.Modules.Hom.app h V).hom x) := by
  have hb := congrArg
    (fun (k : N ⟶ (Scheme.Modules.pushforward g).obj
        ((Scheme.Modules.pullback g).obj N')) =>
      (Scheme.Modules.Hom.app k V).hom x)
    ((Scheme.Modules.pullbackPushforwardAdjunction g).unit.naturality h)
  have ha := congrArg
    (fun (k : Γ((Scheme.Modules.pullback g).obj N, g ⁻¹ᵁ V) ⟶
        Γ((Scheme.Modules.pullback g).obj N', U)) =>
      (AddCommGrpCat.Hom.hom k)
        (((Scheme.Modules.pullbackPushforwardAdjunction g).unit.app N).app V x))
    ((Scheme.Modules.Hom.mapPresheaf ((Scheme.Modules.pullback g).map h)).naturality
      (homOfLE e).op)
  exact ha.trans (congrArg
    (fun w => ((((Scheme.Modules.pullback g).obj N').presheaf.map (homOfLE e).op).hom) w)
    hb.symm)

set_option backward.isDefEq.respectTransparency false in
/-- The canonical pullback base map is compatible with equality of scheme morphisms. -/
lemma baseMap_congr
    {X Y : Scheme.{u}} {g g' : Y ⟶ X} (hgg' : g = g')
    (N : X.Modules) {U : Y.Opens} {V : X.Opens} (e : U ≤ g ⁻¹ᵁ V) (e' : U ≤ g' ⁻¹ᵁ V)
    (x : Γ(N, V)) :
    (Scheme.Modules.Hom.app ((Scheme.Modules.pullbackCongr hgg').hom.app N) U).hom
        (baseMap g N e x) =
      baseMap g' N e' x := by
  subst hgg'
  rfl

set_option backward.isDefEq.respectTransparency false in
set_option maxHeartbeats 1600000 in
-- Expanding the composed adjunction unit traverses nested pullback transports.
/-- The canonical pullback base map is compatible with composition of scheme morphisms. -/
lemma baseMap_comp
    {X Y Z : Scheme.{u}} (f : X ⟶ Y) (g : Y ⟶ Z) (N : Z.Modules)
    {T : X.Opens} {V : Y.Opens} {U : Z.Opens}
    (eV : V ≤ g ⁻¹ᵁ U) (eT : T ≤ f ⁻¹ᵁ V) (eTU : T ≤ (f ≫ g) ⁻¹ᵁ U) (x : Γ(N, U)) :
    (Scheme.Modules.Hom.app ((Scheme.Modules.pullbackComp f g).hom.app N) T).hom
        (baseMap f ((Scheme.Modules.pullback g).obj N) eT
          (baseMap g N eV x)) =
      baseMap (f ≫ g) N eTU x := by
  have hs1 := congrArg
    (fun (k : Γ((Scheme.Modules.pullback g).obj N, g ⁻¹ᵁ U) ⟶
        Γ((Scheme.Modules.pushforward f).obj ((Scheme.Modules.pullback f).obj
          ((Scheme.Modules.pullback g).obj N)), V)) =>
      (AddCommGrpCat.Hom.hom k)
        (((Scheme.Modules.pullbackPushforwardAdjunction g).unit.app N).app U x))
    ((Scheme.Modules.Hom.mapPresheaf
      ((Scheme.Modules.pullbackPushforwardAdjunction f).unit.app
        ((Scheme.Modules.pullback g).obj N))).naturality (homOfLE eV).op)
  have hconj := Scheme.Modules.conjugateEquiv_pullbackComp_inv f g
  have hunit := unit_conjugateEquiv
    ((Scheme.Modules.pullbackPushforwardAdjunction g).comp
      (Scheme.Modules.pullbackPushforwardAdjunction f))
    (Scheme.Modules.pullbackPushforwardAdjunction (f ≫ g))
    ((Scheme.Modules.pullbackComp f g).inv) N
  rw [hconj] at hunit
  have hs2 := congrArg
    (fun (k : N ⟶ (Scheme.Modules.pushforward (f ≫ g)).obj
        ((Scheme.Modules.pullback f).obj ((Scheme.Modules.pullback g).obj N))) =>
      (Scheme.Modules.Hom.app k U).hom x) hunit
  have hs3 := congrArg
    (fun (k : Γ((Scheme.Modules.pullback (f ≫ g)).obj N, (f ≫ g) ⁻¹ᵁ U) ⟶
        Γ((Scheme.Modules.pullback f).obj ((Scheme.Modules.pullback g).obj N), T)) =>
      (AddCommGrpCat.Hom.hom k)
        (((Scheme.Modules.pullbackPushforwardAdjunction (f ≫ g)).unit.app N).app U x))
    ((Scheme.Modules.Hom.mapPresheaf
      ((Scheme.Modules.pullbackComp f g).inv.app N)).naturality (homOfLE eTU).op)
  have hs4 : ∀ (z : Γ((Scheme.Modules.pullback (f ≫ g)).obj N, T)),
      (Scheme.Modules.Hom.app ((Scheme.Modules.pullbackComp f g).hom.app N) T).hom
        ((Scheme.Modules.Hom.app ((Scheme.Modules.pullbackComp f g).inv.app N) T).hom z) =
        z := fun z => congrArg
    (fun (k : (Scheme.Modules.pullback (f ≫ g)).obj N ⟶
        (Scheme.Modules.pullback (f ≫ g)).obj N) =>
      (Scheme.Modules.Hom.app k T).hom z)
    (Iso.inv_hom_id_app (Scheme.Modules.pullbackComp f g) N)
  refine (congrArg (fun w =>
    (Scheme.Modules.Hom.app ((Scheme.Modules.pullbackComp f g).hom.app N) T).hom
      ((((Scheme.Modules.pullback f).obj ((Scheme.Modules.pullback g).obj N)).presheaf.map
        (homOfLE eT).op).hom w)) hs1).trans ?_
  refine (congrArg (fun w =>
    (Scheme.Modules.Hom.app ((Scheme.Modules.pullbackComp f g).hom.app N) T).hom w)
    (modules_res_res ((Scheme.Modules.pullback f).obj ((Scheme.Modules.pullback g).obj N))
      eT ((fun _ ha => eV ha) : f ⁻¹ᵁ V ≤ f ⁻¹ᵁ (g ⁻¹ᵁ U))
      eTU (((Scheme.Modules.pullbackPushforwardAdjunction f).unit.app
          ((Scheme.Modules.pullback g).obj N)).app (g ⁻¹ᵁ U)
        (((Scheme.Modules.pullbackPushforwardAdjunction g).unit.app N).app U x)))).trans ?_
  refine (congrArg (fun w =>
    (Scheme.Modules.Hom.app ((Scheme.Modules.pullbackComp f g).hom.app N) T).hom
      ((((Scheme.Modules.pullback f).obj ((Scheme.Modules.pullback g).obj N)).presheaf.map
        (homOfLE eTU).op).hom w)) hs2).trans ?_
  refine (congrArg (fun w =>
    (Scheme.Modules.Hom.app ((Scheme.Modules.pullbackComp f g).hom.app N) T).hom w)
    hs3.symm).trans ?_
  exact hs4 _

set_option backward.isDefEq.respectTransparency false in
/-- On the full preimage of an open, `baseMap` is exactly the component of
the pullback--pushforward adjunction unit. -/
lemma baseMap_le_refl
    {X Y : Scheme.{u}} (g : Y ⟶ X) (N : X.Modules) (V : X.Opens) (x : Γ(N, V)) :
    baseMap g N (le_refl (g ⁻¹ᵁ V)) x =
      (Scheme.Modules.Hom.app
        ((Scheme.Modules.pullbackPushforwardAdjunction g).unit.app N) V).hom x := by
  change ((((Scheme.Modules.pullback g).obj N).presheaf.map
      (homOfLE (le_refl (g ⁻¹ᵁ V))).op).hom)
      ((Scheme.Modules.Hom.app
        ((Scheme.Modules.pullbackPushforwardAdjunction g).unit.app N) V).hom x) = _
  rw [show (homOfLE (le_refl (g ⁻¹ᵁ V))).op = 𝟙 (Opposite.op (g ⁻¹ᵁ V)) from rfl,
    CategoryTheory.Functor.map_id]
  rfl

theorem unit_hom_ext_top {X : Scheme.{u}} {M : X.Modules}
    (f g : SheafOfModules.unit X.ringCatSheaf ⟶ M)
    (h : f.val.app (.op (⊤ : X.Opens)) (1 : Γ(X, ⊤)) =
      g.val.app (.op (⊤ : X.Opens)) (1 : Γ(X, ⊤))) : f = g := by
  apply (SheafOfModules.fullyFaithfulForget X.ringCatSheaf).map_injective
  apply PresheafOfModules.hom_ext
  intro U
  apply ModuleCat.hom_ext
  apply LinearMap.ext
  intro x
  change Γ(X, U.unop) at x
  change f.val.app U x = g.val.app U x
  rw [show x = x • (1 : Γ(X, U.unop)) by simp, _root_.map_smul, _root_.map_smul]
  congr 1
  have hf := congrArg (fun k ↦ k.hom (1 : Γ(X, ⊤)))
    ((Scheme.Modules.Hom.mapPresheaf f).naturality
      (homOfLE (le_top : U.unop ≤ (⊤ : X.Opens))).op)
  have hg := congrArg (fun k ↦ k.hom (1 : Γ(X, ⊤)))
    ((Scheme.Modules.Hom.mapPresheaf g).naturality
      (homOfLE (le_top : U.unop ≤ (⊤ : X.Opens))).op)
  change f.val.app U ((X.presheaf.map
      (homOfLE (le_top : U.unop ≤ (⊤ : X.Opens))).op).hom 1) =
    (M.presheaf.map (homOfLE (le_top : U.unop ≤ (⊤ : X.Opens))).op).hom
      (f.val.app (.op (⊤ : X.Opens)) (1 : Γ(X, ⊤))) at hf
  change g.val.app U ((X.presheaf.map
      (homOfLE (le_top : U.unop ≤ (⊤ : X.Opens))).op).hom 1) =
    (M.presheaf.map (homOfLE (le_top : U.unop ≤ (⊤ : X.Opens))).op).hom
      (g.val.app (.op (⊤ : X.Opens)) (1 : Γ(X, ⊤))) at hg
  rw [map_one] at hf hg
  exact hf.trans ((congrArg
    (fun z ↦ (M.presheaf.map
      (homOfLE (le_top : U.unop ≤ (⊤ : X.Opens))).op).hom z) h).trans hg.symm)


set_option backward.isDefEq.respectTransparency false in
private lemma modules_res_res_hom
    {Y : Scheme.{u}} (N : Y.Modules) {W₁ W₂ W₃ : Y.Opens}
    (i₁ : W₁ ⟶ W₂) (i₂ : W₂ ⟶ W₃) (i₃ : W₁ ⟶ W₃) (x : Γ(N, W₃)) :
    (N.presheaf.map i₁.op).hom ((N.presheaf.map i₂.op).hom x) =
      (N.presheaf.map i₃.op).hom x := by
  rw [← AddCommGrpCat.comp_apply, ← Functor.map_comp, ← op_comp]
  exact (congrArg (fun (i : W₁ ⟶ W₃) =>
    (AddCommGrpCat.Hom.hom (N.presheaf.map i.op)) x) (Subsingleton.elim _ _)).symm

set_option backward.isDefEq.respectTransparency false in
/-- The restriction-to-pullback comparison is the adjunction unit on sections
over the image of an open immersion. -/
theorem open_hom_baseMap
    {X Y : Scheme.{u}} (f : X ⟶ Y) [IsOpenImmersion f]
    (N : Y.Modules) (y : Γ(N, f.opensRange)) :
    (Scheme.Modules.Hom.app
      ((Scheme.Modules.restrictFunctorIsoPullback f).hom.app N) ⊤).hom
      ((N.presheaf.map (eqToHom (Scheme.Hom.image_top_eq_opensRange f)).op).hom y) =
      baseMap f N
        (le_of_eq (Scheme.Hom.preimage_opensRange f).symm) y := by
  let isoSheaf : (Scheme.Modules.pullback f).obj N ≅ N.restrict f :=
    ((Scheme.Modules.restrictFunctorIsoPullback f).app N).symm
  have hImg : (f ''ᵁ (⊤ : X.Opens) : Y.Opens) = f.opensRange := by
    rw [Scheme.Hom.image_top_eq_opensRange]
  change (Scheme.Modules.Hom.app isoSheaf.inv ⊤).hom
      ((N.presheaf.map (eqToHom hImg).op).hom y) = _
  have hk := congrArg
    (fun (k : N ⟶ (Scheme.Modules.pushforward f).obj
        ((Scheme.Modules.pullback f).obj N)) =>
      (Scheme.Modules.Hom.app k f.opensRange).hom y)
    (Adjunction.unit_leftAdjointUniq_hom_app
      (Scheme.Modules.restrictAdjunction f)
      (Scheme.Modules.pullbackPushforwardAdjunction f) N)
  have hnat := congrArg
    (fun (k : Γ(N.restrict f, f ⁻¹ᵁ f.opensRange) ⟶
        Γ((Scheme.Modules.pullback f).obj N, ⊤)) =>
      (AddCommGrpCat.Hom.hom k)
        ((N.presheaf.map (homOfLE (f.image_preimage_le f.opensRange)).op).hom y))
    ((Scheme.Modules.Hom.mapPresheaf
      ((Scheme.Modules.restrictFunctorIsoPullback f).hom.app N)).naturality
      (homOfLE (le_of_eq (Scheme.Hom.preimage_opensRange f).symm)).op)
  have hcol := modules_res_res_hom N
    (f.opensFunctor.map
      (homOfLE (le_of_eq (Scheme.Hom.preimage_opensRange f).symm)))
    (homOfLE (f.image_preimage_le f.opensRange)) (eqToHom hImg) y
  exact (congrArg (fun w =>
      (Scheme.Modules.Hom.app
        ((Scheme.Modules.restrictFunctorIsoPullback f).hom.app N) ⊤).hom w)
    hcol.symm).trans
    (hnat.trans (congrArg (fun w =>
      ((((Scheme.Modules.pullback f).obj N).presheaf.map
        (homOfLE (le_of_eq (Scheme.Hom.preimage_opensRange f).symm)).op).hom) w) hk))


/-- Restricting a pullback to an open contained in the preimage agrees with
first restricting the module and pulling back along the restricted scheme map. -/
noncomputable def pullbackRestrictIso
    {X Y : Scheme.{u}} (g : Y ⟶ X) (U : X.Opens) (V : Y.Opens) (h : V ≤ g ⁻¹ᵁ U) :
    pullback g ⋙ restrictFunctor V.ι ≅
      restrictFunctor U.ι ⋙ pullback (g.resLE U V h) :=
  Functor.isoWhiskerLeft (pullback g)
      (restrictFunctorIsoPullback V.ι) ≪≫
    pullbackComp V.ι g ≪≫
    pullbackCongr (Scheme.Hom.resLE_comp_ι g h).symm ≪≫
    (pullbackComp (g.resLE U V h) U.ι).symm ≪≫
    Functor.isoWhiskerRight
      (restrictFunctorIsoPullback U.ι).symm (pullback (g.resLE U V h))


theorem pullbackRestrictIso_baseMap_top
    {X Y : Scheme.{u}} (g : Y ⟶ X) (U : X.Opens) (V : Y.Opens) (h : V ≤ g ⁻¹ᵁ U)
    (N : X.Modules) (x : Γ(N, U)) :
    (Scheme.Modules.Hom.app
      ((pullbackRestrictIso g U V h).hom.app N)
        (⊤ : V.toScheme.Opens)).hom
      (baseMap g N
        (show V.ι ''ᵁ (⊤ : V.toScheme.Opens) ≤ g ⁻¹ᵁ U by simpa using h) x) =
      baseMap (g.resLE U V h)
        ((Scheme.Modules.restrictFunctor U.ι).obj N)
        (le_top : (⊤ : V.toScheme.Opens) ≤
          (g.resLE U V h) ⁻¹ᵁ (⊤ : U.toScheme.Opens))
        ((N.presheaf.map
          (eqToHom (Scheme.Opens.ι_image_top U)).op).hom x) := by
  let f := V.ι
  have eRange : f.opensRange ≤ g ⁻¹ᵁ U :=
    (le_of_eq (Scheme.Opens.opensRange_ι V)).trans h
  have eImage : f ''ᵁ (⊤ : V.toScheme.Opens) ≤ g ⁻¹ᵁ U := by
    simpa [f] using h
  have ePreRange : (⊤ : V.toScheme.Opens) ≤ f ⁻¹ᵁ f.opensRange :=
    le_of_eq (Scheme.Hom.preimage_opensRange f).symm
  have eCompSource : (⊤ : V.toScheme.Opens) ≤ (f ≫ g) ⁻¹ᵁ U := by
    intro z _
    exact h z.property
  have hInput :
      ((((Scheme.Modules.pullback g).obj N).presheaf.map
        (eqToHom (Scheme.Hom.image_top_eq_opensRange f)).op).hom
          (baseMap g N eRange x)) =
        baseMap g N eImage x := by
    have heq : eqToHom (Scheme.Hom.image_top_eq_opensRange f) =
        homOfLE (le_of_eq (Scheme.Hom.image_top_eq_opensRange f)) :=
      Subsingleton.elim _ _
    rw [heq]
    simpa only [show homOfLE (le_refl U) = 𝟙 U from rfl,
      eqToHom_refl, op_id, CategoryTheory.Functor.map_id,
      AddCommGrpCat.hom_id, AddMonoidHom.id_apply] using
      (baseMap_res g N eRange eImage le_rfl
        (le_of_eq (Scheme.Hom.image_top_eq_opensRange f)) x)
  have hOpenSource :
      (Scheme.Modules.Hom.app
        ((Scheme.Modules.restrictFunctorIsoPullback f).hom.app
          ((Scheme.Modules.pullback g).obj N)) ⊤).hom
        (baseMap g N eImage x) =
      baseMap f
        ((Scheme.Modules.pullback g).obj N) ePreRange
        (baseMap g N eRange x) := by
    rw [← hInput]
    exact open_hom_baseMap f ((Scheme.Modules.pullback g).obj N)
      (baseMap g N eRange x)
  have hCompSource := baseMap_comp f g N
    (T := (⊤ : V.toScheme.Opens))
    (V := f.opensRange) (U := U)
    eRange ePreRange eCompSource x
  have eCompTarget : (⊤ : V.toScheme.Opens) ≤
      ((g.resLE U V h) ≫ U.ι) ⁻¹ᵁ U := by
    rw [Scheme.Hom.resLE_comp_ι]
    exact eCompSource
  have hCongr := baseMap_congr
    (Scheme.Hom.resLE_comp_ι g h).symm N
    (U := (⊤ : V.toScheme.Opens)) (V := U)
    eCompSource eCompTarget x
  have eOpenTarget : (⊤ : U.toScheme.Opens) ≤ U.ι ⁻¹ᵁ U := by simp
  have ePullbackTarget : (⊤ : V.toScheme.Opens) ≤
      (g.resLE U V h) ⁻¹ᵁ (⊤ : U.toScheme.Opens) := le_top
  have hCompTarget := baseMap_comp
    (g.resLE U V h) U.ι N
    (T := (⊤ : V.toScheme.Opens))
    (V := (⊤ : U.toScheme.Opens)) (U := U)
    eOpenTarget ePullbackTarget eCompTarget x
  have hCompTargetInv :
      (Scheme.Modules.Hom.app
        ((Scheme.Modules.pullbackComp (g.resLE U V h) U.ι).inv.app N) ⊤).hom
        (baseMap ((g.resLE U V h) ≫ U.ι) N eCompTarget x) =
      baseMap (g.resLE U V h)
        ((Scheme.Modules.pullback U.ι).obj N) ePullbackTarget
        (baseMap U.ι N eOpenTarget x) := by
    have h := congrArg
      (fun z => (Scheme.Modules.Hom.app
        ((Scheme.Modules.pullbackComp (g.resLE U V h) U.ι).inv.app N) ⊤).hom z)
      hCompTarget
    simpa only [← AddCommGrpCat.comp_apply, ← Scheme.Modules.Hom.comp_app,
      Iso.inv_hom_id_app, Iso.hom_inv_id_app, Scheme.Modules.Hom.id_app,
      AddCommGrpCat.hom_id, AddMonoidHom.id_apply] using h.symm
  have hTargetRange : U.ι.opensRange = U := Scheme.Opens.opensRange_ι U
  have hUTargetRange : U ≤ U.ι.opensRange := le_of_eq hTargetRange.symm
  let yTarget : Γ(N, U.ι.opensRange) :=
    (N.presheaf.map (eqToHom hTargetRange).op).hom x
  have hyTarget :
      (N.presheaf.map (homOfLE hUTargetRange).op).hom yTarget = x := by
    dsimp only [yTarget]
    rw [← AddCommGrpCat.comp_apply, ← CategoryTheory.Functor.map_comp]
    have hm : (eqToHom hTargetRange).op ≫ (homOfLE hUTargetRange).op = 𝟙 _ :=
      Subsingleton.elim _ _
    rw [hm, CategoryTheory.Functor.map_id]
    change x = x
    rfl
  have hCastTarget :
      (N.presheaf.map
          (eqToHom (Scheme.Hom.image_top_eq_opensRange U.ι)).op).hom yTarget =
        (N.presheaf.map (eqToHom (Scheme.Opens.ι_image_top U)).op).hom x := by
    dsimp only [yTarget]
    rw [← AddCommGrpCat.comp_apply, ← CategoryTheory.Functor.map_comp]
    have hm : (eqToHom hTargetRange).op ≫
        (eqToHom (Scheme.Hom.image_top_eq_opensRange U.ι)).op =
          (eqToHom (Scheme.Opens.ι_image_top U)).op :=
      Subsingleton.elim _ _
    rw [hm]
  have eRangeTarget : (⊤ : U.toScheme.Opens) ≤ U.ι ⁻¹ᵁ U.ι.opensRange :=
    le_of_eq (Scheme.Hom.preimage_opensRange U.ι).symm
  have hBaseTarget :
      baseMap U.ι N eRangeTarget yTarget =
        baseMap U.ι N eOpenTarget x := by
    have hres := baseMap_res U.ι N
      eRangeTarget eOpenTarget hUTargetRange (le_refl (⊤ : U.toScheme.Opens)) yTarget
    rw [hyTarget] at hres
    simpa only [show homOfLE (le_refl (⊤ : U.toScheme.Opens)) = 𝟙 _ from rfl,
      op_id, CategoryTheory.Functor.map_id, AddCommGrpCat.hom_id,
      AddMonoidHom.id_apply] using hres
  have hOpenTargetHom := open_hom_baseMap U.ι N yTarget
  have hOpenTarget :
      (Scheme.Modules.Hom.app
        ((Scheme.Modules.restrictFunctorIsoPullback U.ι).inv.app N) ⊤).hom
        (baseMap U.ι N eOpenTarget x) =
      (N.presheaf.map (eqToHom (Scheme.Opens.ι_image_top U)).op).hom x := by
    have h := congrArg
      (fun z => (Scheme.Modules.Hom.app
        ((Scheme.Modules.restrictFunctorIsoPullback U.ι).inv.app N) ⊤).hom z)
      hOpenTargetHom
    simp only [← AddCommGrpCat.comp_apply, ← Scheme.Modules.Hom.comp_app,
      Iso.hom_inv_id_app, Scheme.Modules.Hom.id_app, AddCommGrpCat.hom_id,
      AddMonoidHom.id_apply] at h
    rw [hCastTarget] at h
    rw [← hBaseTarget]
    exact h.symm
  have hNatural := baseMap_naturality (g.resLE U V h)
    ((Scheme.Modules.restrictFunctorIsoPullback U.ι).inv.app N)
    (U := (⊤ : V.toScheme.Opens))
    (V := (⊤ : U.toScheme.Opens)) ePullbackTarget
    (baseMap U.ι N eOpenTarget x)
  change
    (Scheme.Modules.Hom.app
      ((Scheme.Modules.pullback (g.resLE U V h)).map
        ((Scheme.Modules.restrictFunctorIsoPullback U.ι).inv.app N)) ⊤).hom
      ((Scheme.Modules.Hom.app
        ((Scheme.Modules.pullbackComp (g.resLE U V h) U.ι).inv.app N) ⊤).hom
        ((Scheme.Modules.Hom.app
          ((Scheme.Modules.pullbackCongr
            (Scheme.Hom.resLE_comp_ι g h).symm).hom.app N) ⊤).hom
          ((Scheme.Modules.Hom.app
            ((Scheme.Modules.pullbackComp f g).hom.app N) ⊤).hom
            ((Scheme.Modules.Hom.app
              ((Scheme.Modules.restrictFunctorIsoPullback
                f).hom.app
                ((Scheme.Modules.pullback g).obj N)) ⊤).hom
              (baseMap g N eImage x))))) = _
  rw [hOpenSource, hCompSource, hCongr, hCompTargetInv, hNatural, hOpenTarget]


/-- The canonical isomorphism from the pullback of the unit module to the unit module. -/
noncomputable def pullbackUnitIso {X Y : Scheme.{u}} (f : X ⟶ Y) :
    (Scheme.Modules.pullback f).obj (SheafOfModules.unit Y.ringCatSheaf) ≅
      SheafOfModules.unit X.ringCatSheaf := by
  letI : (Opens.map f.base).Final := CategoryTheory.final_of_representablyFlat _
  exact @asIso _ _ _ _ _ (inferInstance :
    IsIso (SheafOfModules.pullbackObjUnitToUnit f.toRingCatSheafHom))


theorem pullbackUnitIso_baseMap_one {X Y : Scheme.{u}} (g : Y ⟶ X) :
    (Scheme.Modules.Hom.app (pullbackUnitIso g).hom
      (⊤ : Y.Opens)).hom
      (baseMap g
        (SheafOfModules.unit X.ringCatSheaf)
        (le_top : (⊤ : Y.Opens) ≤ g ⁻¹ᵁ (⊤ : X.Opens))
        (1 : Γ(X, ⊤))) = (1 : Γ(Y, ⊤)) := by
  let oneX : Γ(SheafOfModules.unit X.ringCatSheaf, (⊤ : X.Opens)) :=
    (1 : Γ(X, ⊤))
  have h := congrArg
    (fun (f : SheafOfModules.unit X.ringCatSheaf ⟶
        (Scheme.Modules.pushforward g).obj
          (SheafOfModules.unit Y.ringCatSheaf)) =>
      (Scheme.Modules.Hom.app f (⊤ : X.Opens)).hom oneX)
    (SheafOfModules.pullbackPushforwardAdjunction_homEquiv_pullbackObjUnitToUnit
      g.toRingCatSheafHom)
  rw [Adjunction.homEquiv_unit] at h
  rw [Scheme.Modules.Hom.comp_app, AddCommGrpCat.comp_apply] at h
  change
    (Scheme.Modules.Hom.app
      (SheafOfModules.pullbackObjUnitToUnit g.toRingCatSheafHom)
        (g ⁻¹ᵁ (⊤ : X.Opens))).hom
      ((Scheme.Modules.Hom.app
        ((Scheme.Modules.pullbackPushforwardAdjunction g).unit.app
          (SheafOfModules.unit X.ringCatSheaf)) (⊤ : X.Opens)).hom
          (show Γ((𝟭 X.Modules).obj
            (SheafOfModules.unit X.ringCatSheaf), ⊤) from oneX)) =
      (g.app (⊤ : X.Opens)).hom oneX at h
  have hfull :
      (Scheme.Modules.Hom.app (pullbackUnitIso g).hom
        (g ⁻¹ᵁ (⊤ : X.Opens))).hom
        (baseMap g
          (SheafOfModules.unit X.ringCatSheaf)
          (le_refl (g ⁻¹ᵁ (⊤ : X.Opens))) oneX) =
        (g.app (⊤ : X.Opens)).hom oneX := by
    rw [baseMap_le_refl]
    change
      (Scheme.Modules.Hom.app
        (SheafOfModules.pullbackObjUnitToUnit g.toRingCatSheafHom)
          (g ⁻¹ᵁ (⊤ : X.Opens))).hom
        ((Scheme.Modules.Hom.app
          ((Scheme.Modules.pullbackPushforwardAdjunction g).unit.app
            (SheafOfModules.unit X.ringCatSheaf)) (⊤ : X.Opens)).hom
            (show Γ((𝟭 X.Modules).obj
              (SheafOfModules.unit X.ringCatSheaf), ⊤) from oneX)) =
        (g.app (⊤ : X.Opens)).hom oneX
    exact h
  simpa only [oneX, Scheme.Hom.preimage_top] using
    hfull.trans (map_one (g.app ⊤).hom)


/-- A chosen frame on an open induces a frame of its pullback on a smaller preimage open. -/
noncomputable def pullbackFrameIso {X Y : Scheme.{u}} (g : Y ⟶ X)
    (U : X.Opens) (V : Y.Opens) (h : V ≤ g ⁻¹ᵁ U) (N : X.Modules)
    (e : (restrictFunctor U.ι).obj N ≅ SheafOfModules.unit U.toScheme.ringCatSheaf) :
    (restrictFunctor V.ι).obj ((Scheme.Modules.pullback g).obj N) ≅
      SheafOfModules.unit V.toScheme.ringCatSheaf :=
  (pullbackRestrictIso g U V h).app N ≪≫
    (Scheme.Modules.pullback (g.resLE U V h)).mapIso e ≪≫ pullbackUnitIso (g.resLE U V h)

/-- A section equal to one in the chosen frame pulls back to one in the induced frame. -/
theorem pullbackFrameIso_baseMap_one {X Y : Scheme.{u}} (g : Y ⟶ X)
    (U : X.Opens) (V : Y.Opens) (h : V ≤ g ⁻¹ᵁ U) (N : X.Modules)
    (e : (restrictFunctor U.ι).obj N ≅ SheafOfModules.unit U.toScheme.ringCatSheaf)
    (x : Γ(N, U))
    (hx : (e.hom.app ⊤).hom
      ((N.presheaf.map (eqToHom (Scheme.Opens.ι_image_top U)).op).hom x) =
        (1 : Γ(U.toScheme, ⊤))) :
    ((pullbackFrameIso g U V h N e).hom.app ⊤).hom
      (baseMap g N
        (show V.ι ''ᵁ (⊤ : V.toScheme.Opens) ≤ g ⁻¹ᵁ U by simpa using h) x) =
      (1 : Γ(V.toScheme, ⊤)) := by
  change ((pullbackUnitIso (g.resLE U V h)).hom.app ⊤).hom
    ((((Scheme.Modules.pullback (g.resLE U V h)).map e.hom).app ⊤).hom
      ((((pullbackRestrictIso g U V h).hom.app N).app ⊤).hom
        (baseMap g N _ x))) = _
  exact (congrArg
    (fun z => ((pullbackUnitIso (g.resLE U V h)).hom.app ⊤).hom
      ((((Scheme.Modules.pullback (g.resLE U V h)).map e.hom).app ⊤).hom z))
    (pullbackRestrictIso_baseMap_top g U V h N x)).trans <|
      (congrArg (fun z => ((pullbackUnitIso (g.resLE U V h)).hom.app ⊤).hom z)
        (baseMap_naturality (g.resLE U V h) e.hom le_top _)).trans <|
      (congrArg (fun z => ((pullbackUnitIso (g.resLE U V h)).hom.app ⊤).hom
        (baseMap (g.resLE U V h) (SheafOfModules.unit U.toScheme.ringCatSheaf)
          le_top z)) hx).trans (pullbackUnitIso_baseMap_one (g.resLE U V h))

end Hartshorne.ModulePullbackFrames
