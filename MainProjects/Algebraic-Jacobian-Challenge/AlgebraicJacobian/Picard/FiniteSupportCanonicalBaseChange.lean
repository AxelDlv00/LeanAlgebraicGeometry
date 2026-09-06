/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.FiniteSupportPushforwardFiber

/-!
# Canonical base change for modules with finite schematic support

The canonical pullback-pushforward comparison is invertible for a module
with finite schematic support. The proof identifies its two adjunction
descriptions and applies affine base change on the support. This supplies
the comparison used by divisor evaluation under arbitrary base change.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

noncomputable section

namespace AlgebraicGeometry

open Scheme

set_option backward.isDefEq.respectTransparency false in
private theorem pullback_hom_ext_baseMap
    {X Y : Scheme.{u}} (g : X ⟶ Y) (M : Y.Modules) (N : X.Modules)
    (a b : (Modules.pullback g).obj M ⟶ N)
    (h : ∀ (V : Y.Opens) (m : Γ(M, V)),
      (a.app (g ⁻¹ᵁ V)).hom (pullback_app_isoTensor_baseMap g M le_rfl m) =
      (b.app (g ⁻¹ᵁ V)).hom (pullback_app_isoTensor_baseMap g M le_rfl m)) :
    a = b := by
  apply ((Modules.pullbackPushforwardAdjunction g).homEquiv _ _).injective
  simp only [Adjunction.homEquiv_unit]
  ext V m
  have hb : pullback_app_isoTensor_baseMap g M le_rfl m =
      (((Modules.pullbackPushforwardAdjunction g).unit.app M).app V).hom m := by
    change (((Modules.pullback g).obj M).presheaf.map
      (homOfLE (le_refl (g ⁻¹ᵁ V))).op).hom
        ((((Modules.pullbackPushforwardAdjunction g).unit.app M).app V).hom m) = _
    rw [show (homOfLE (le_refl (g ⁻¹ᵁ V))).op = 𝟙 (Opposite.op (g ⁻¹ᵁ V)) from rfl,
      CategoryTheory.Functor.map_id]
    rfl
  change (a.app (g ⁻¹ᵁ V)).hom
      ((((Modules.pullbackPushforwardAdjunction g).unit.app M).app V).hom m) =
    (b.app (g ⁻¹ᵁ V)).hom
      ((((Modules.pullbackPushforwardAdjunction g).unit.app M).app V).hom m)
  rw [← hb]
  exact h V m

set_option backward.isDefEq.respectTransparency false in
/-- The pullback-adjunction and pushforward-adjunction descriptions of the
canonical base-change morphism agree. -/
theorem canonicalBaseChangeMap_eq_pushforwardBaseChangeMap
    {X X' S S' : Scheme.{u}}
    {f : X ⟶ S} {g : S' ⟶ S} {g' : X' ⟶ X} {f' : X' ⟶ S'}
    (sq : IsPullback g' f' f g) (F : X.Modules) :
    (canonicalBaseChangeMap sq).app F = pushforwardBaseChangeMap f g f' g' sq.w F := by
  apply pullback_hom_ext_baseMap g _ _
  intro V m
  have e : f' ⁻¹ᵁ (g ⁻¹ᵁ V) ≤ g' ⁻¹ᵁ (f ⁻¹ᵁ V) := by
    rw [← Scheme.Hom.comp_preimage, ← Scheme.Hom.comp_preimage, sq.w]
  exact (canonicalBaseChangeMap_app_baseMap_compat sq F le_rfl e m).trans
    (pushforwardBaseChangeMap_app_baseMap f g f' g' sq.w F le_rfl e m).symm

set_option backward.isDefEq.respectTransparency false in
set_option maxHeartbeats 1600000 in
-- Normalizing the nested pushforward section carriers exceeds the default budget.
set_option maxRecDepth 4000 in
private theorem canonicalBaseChangeMap_pushforward_comp
    {Z Z' X X' S S' : Scheme.{u}}
    {f : X ⟶ S} {g : S' ⟶ S} {g' : X' ⟶ X} {f' : X' ⟶ S'}
    {i : Z ⟶ X} {j : Z' ⟶ X'} {a : Z' ⟶ Z}
    (sq : IsPullback g' f' f g) (sq₁ : IsPullback a j i g') (N : Z.Modules) :
    (Modules.pullback g).map ((Modules.pushforwardComp i f).inv.app N) ≫
      (canonicalBaseChangeMap sq).app ((Modules.pushforward i).obj N) ≫
      (Modules.pushforward f').map ((canonicalBaseChangeMap sq₁).app N) =
    (canonicalBaseChangeMap (sq₁.paste_vert sq)).app N ≫
      (Modules.pushforwardComp j f').inv.app ((Modules.pullback a).obj N) := by
  apply pullback_hom_ext_baseMap g _ _
  intro V m
  have e : f' ⁻¹ᵁ (g ⁻¹ᵁ V) ≤ g' ⁻¹ᵁ (f ⁻¹ᵁ V) := by
    rw [← Scheme.Hom.comp_preimage, ← Scheme.Hom.comp_preimage, sq.w]
  have e₁ : j ⁻¹ᵁ (f' ⁻¹ᵁ (g ⁻¹ᵁ V)) ≤ a ⁻¹ᵁ (i ⁻¹ᵁ (f ⁻¹ᵁ V)) := by
    have h := (sq₁.paste_vert sq).w
    rw [← Scheme.Hom.comp_preimage, ← Scheme.Hom.comp_preimage,
      ← Scheme.Hom.comp_preimage, ← Scheme.Hom.comp_preimage, Category.assoc a i f, h]
  change (((canonicalBaseChangeMap sq₁).app N).app
      (f' ⁻¹ᵁ (g ⁻¹ᵁ V))).hom
        ((((canonicalBaseChangeMap sq).app ((Modules.pushforward i).obj N)).app
          (g ⁻¹ᵁ V)).hom
            ((((Modules.pullback g).map ((Modules.pushforwardComp i f).inv.app N)).app
              (g ⁻¹ᵁ V)).hom
                (pullback_app_isoTensor_baseMap g
                  ((Modules.pushforward (i ≫ f)).obj N) le_rfl m))) =
    (((canonicalBaseChangeMap (sq₁.paste_vert sq)).app N).app (g ⁻¹ᵁ V)).hom
      (pullback_app_isoTensor_baseMap g ((Modules.pushforward (i ≫ f)).obj N) le_rfl m)
  have h₁ := pullback_map_app_isoTensor_baseMap g
    ((Modules.pushforwardComp i f).inv.app N) le_rfl m
  have h₂ := canonicalBaseChangeMap_app_baseMap_compat sq
    ((Modules.pushforward i).obj N) le_rfl e m
  have h₃ := canonicalBaseChangeMap_app_baseMap_compat sq₁ N e e₁ m
  have h₄ := canonicalBaseChangeMap_app_baseMap_compat (sq₁.paste_vert sq) N le_rfl e₁ m
  exact (congrArg (fun z => (((canonicalBaseChangeMap sq₁).app N).app
      (f' ⁻¹ᵁ (g ⁻¹ᵁ V))).hom
        ((((canonicalBaseChangeMap sq).app ((Modules.pushforward i).obj N)).app
          (g ⁻¹ᵁ V)).hom z)) h₁).trans
    ((congrArg (fun z => (((canonicalBaseChangeMap sq₁).app N).app
      (f' ⁻¹ᵁ (g ⁻¹ᵁ V))).hom z) h₂).trans (h₃.trans h₄.symm))

set_option backward.isDefEq.respectTransparency false in
set_option maxHeartbeats 1600000 in
-- The two affine instances expand the support pullback and its composite morphism.
set_option synthInstance.maxHeartbeats 400000 in
/-- The canonical comparison for a quasi-coherent module with finite
schematic support is invertible under every base change. This is the
finite-support form of affine pushforward base change, with no flatness
hypothesis on the morphism changing the base. -/
theorem canonicalBaseChangeMap_isIso_of_isFinite_schematicSupport
    {X X' S S' : Scheme.{u}}
    {f : X ⟶ S} {g : S' ⟶ S} {g' : X' ⟶ X} {f' : X' ⟶ S'}
    (sq : IsPullback g' f' f g) (F : X.Modules) [F.IsQuasicoherent]
    (hfin : IsFinite (Modules.schematicSupportι F ≫ f)) :
    IsIso ((canonicalBaseChangeMap sq).app F) := by
  let i := Modules.schematicSupportι F
  let N := (Modules.pullback i).obj F
  let j := pullback.snd i g'
  let a := pullback.fst i g'
  haveI : IsAffineHom i :=
    inferInstanceAs (IsAffineHom F.annihilator.subschemeι)
  haveI : IsFinite (i ≫ f) := hfin
  haveI : IsAffineHom (i ≫ f) := inferInstance
  have sq₁ : IsPullback a j i g' := IsPullback.of_hasPullback _ _
  have sqZ : IsPullback a (j ≫ f') (i ≫ f) g := sq₁.paste_vert sq
  haveI : IsAffineHom j :=
    MorphismProperty.pullback_snd _ _ (inferInstance : IsAffineHom i)
  haveI : IsAffineHom (j ≫ f') := MorphismProperty.of_isPullback sqZ inferInstance
  haveI : N.IsQuasicoherent := pullback_isQuasicoherent_hom i F inferInstance
  haveI : IsIso ((canonicalBaseChangeMap sq₁).app N) := by
    rw [canonicalBaseChangeMap_eq_pushforwardBaseChangeMap]
    exact isIso_pushforwardBaseChangeMap_of_isPullback sq₁ N
  haveI : IsIso ((canonicalBaseChangeMap sqZ).app N) := by
    rw [canonicalBaseChangeMap_eq_pushforwardBaseChangeMap]
    exact isIso_pushforwardBaseChangeMap_of_isPullback sqZ N
  have hp := canonicalBaseChangeMap_pushforward_comp sq sq₁ N
  haveI : IsIso
      ((Modules.pullback g).map ((Modules.pushforwardComp i f).inv.app N) ≫
        (canonicalBaseChangeMap sq).app ((Modules.pushforward i).obj N) ≫
        (Modules.pushforward f').map ((canonicalBaseChangeMap sq₁).app N)) := by
    rw [hp]
    infer_instance
  haveI : IsIso ((canonicalBaseChangeMap sq).app ((Modules.pushforward i).obj N) ≫
      (Modules.pushforward f').map ((canonicalBaseChangeMap sq₁).app N)) :=
    IsIso.of_isIso_comp_left
      ((Modules.pullback g).map ((Modules.pushforwardComp i f).inv.app N)) _
  haveI : IsIso ((canonicalBaseChangeMap sq).app ((Modules.pushforward i).obj N)) :=
    IsIso.of_isIso_comp_right _
      ((Modules.pushforward f').map ((canonicalBaseChangeMap sq₁).app N))
  let e : F ≅ (Modules.pushforward i).obj N := Modules.schematicSupportDescentIso F
  have hn := (canonicalBaseChangeMap sq).naturality e.hom
  haveI : IsIso ((canonicalBaseChangeMap sq).app F ≫
      (Modules.pullback g' ⋙ Modules.pushforward f').map e.hom) := by
    rw [← hn]
    infer_instance
  exact IsIso.of_isIso_comp_right _
    ((Modules.pullback g' ⋙ Modules.pushforward f').map e.hom)

end AlgebraicGeometry
