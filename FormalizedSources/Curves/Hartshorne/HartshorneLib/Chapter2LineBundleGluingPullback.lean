/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter2LineBundleGluing

/-!
# Pullback of matching sections

A morphism of schemes pulls matching sections back to any refinement of the
inverse-image cover. When the transition units agree under pullback, this gives
a morphism from the pulled-back glued module to the module on the refined
cover. This is the comparison used for the projective twisting sheaf in IV.3.
-/

set_option autoImplicit false

open CategoryTheory Opposite TopologicalSpace AlgebraicGeometry

namespace Hartshorne.LineBundleGluing

universe u v

noncomputable section

section Restriction

variable {X Y : Scheme.{u}} (f : X ⟶ Y)

lemma resHom_appLE {W : Y.Opens} {V V' : X.Opens}
    (hV : V ≤ f ⁻¹ᵁ W) (h : V' ≤ V) (s : Γ(Y, W)) :
    X.resHom h (f.appLE W V hV s) = f.appLE W V' (h.trans hV) s := by
  exact ConcreteCategory.congr_hom (f.appLE_map hV (homOfLE h).op) s

lemma appLE_resHom {W W' : Y.Opens} {V : X.Opens}
    (hW : W' ≤ W) (hV : V ≤ f ⁻¹ᵁ W') (s : Γ(Y, W)) :
    f.appLE W' V hV (Y.resHom hW s) =
      f.appLE W V (hV.trans ((Opens.map f.base).map (homOfLE hW)).le) s := by
  exact ConcreteCategory.congr_hom (f.map_appLE hV (homOfLE hW).op) s

end Restriction

variable {X Y : Scheme.{max u v}} (f : X ⟶ Y)

variable {I : Type (max u v)} {J : Type v} (U : J → Y.Opens) (V : I → X.Opens)
  (g : ∀ i j, Γ(Y, U i ⊓ U j)ˣ) (h : ∀ i j, Γ(X, V i ⊓ V j)ˣ)
  (τ : I → J) (hV : ∀ i, V i ≤ f ⁻¹ᵁ U (τ i))
  (htrans : ∀ i j,
    f.appLE (U (τ i) ⊓ U (τ j)) (V i ⊓ V j)
      (le_inf (inf_le_left.trans (hV i)) (inf_le_right.trans (hV j)))
      (g (τ i) (τ j)).val = (h i j).val)

/-- Pull a matching family back componentwise along a refinement of the cover. -/
def pullbackSections (W : Y.Opens) :
    sectionSubmodule U g W →+ sectionSubmodule V h (f ⁻¹ᵁ W) where
  toFun s := ⟨fun i => f.appLE (W ⊓ U (τ i)) (f ⁻¹ᵁ W ⊓ V i)
    (le_inf inf_le_left (inf_le_right.trans (hV i))) (s.val (τ i)), by
    intro i j
    change X.resHom _ (f.appLE _ _ _ (s.val (τ i))) =
      X.resHom _ (h i j).val * X.resHom _ (f.appLE _ _ _ (s.val (τ j)))
    rw [resHom_appLE, resHom_appLE, ← htrans i j, resHom_appLE]
    have hs := congrArg
      (f.appLE (W ⊓ U (τ i) ⊓ U (τ j)) (f ⁻¹ᵁ W ⊓ V i ⊓ V j)
        (le_inf (le_inf (inf_le_left.trans inf_le_left)
          (inf_le_left.trans (inf_le_right.trans (hV i))))
          (inf_le_right.trans (hV j)))) (s.property (τ i) (τ j))
    simpa only [map_mul, appLE_resHom] using hs⟩
  map_zero' := by
    apply Subtype.ext
    funext i
    exact map_zero _
  map_add' s t := by
    apply Subtype.ext
    funext i
    exact map_add _ _ _

@[simp]
lemma pullbackSections_apply (W : Y.Opens) (s : sectionSubmodule U g W) (i : I) :
    (pullbackSections f U V g h τ hV htrans W s).val i =
      f.appLE (W ⊓ U (τ i)) (f ⁻¹ᵁ W ⊓ V i)
        (le_inf inf_le_left (inf_le_right.trans (hV i))) (s.val (τ i)) := rfl

/-- Componentwise pullback commutes with the restriction maps of both sheaves. -/
lemma pullbackSections_res {W W' : Y.Opens} (hW : W' ≤ W)
    (s : sectionSubmodule U g W) :
    pullbackSections f U V g h τ hV htrans W' (res U g hW s) =
      res V h ((Opens.map f.base).map (homOfLE hW)).le
        (pullbackSections f U V g h τ hV htrans W s) := by
  apply Subtype.ext
  funext i
  simp only [pullbackSections_apply, res_apply, resHom_appLE, appLE_resHom]

/-- Pulling a scalar and a matching section back respects scalar multiplication. -/
lemma pullbackSections_smul (W : Y.Opens) (c : Γ(Y, W))
    (s : sectionSubmodule U g W) :
    pullbackSections f U V g h τ hV htrans W
        (((gluedModule U g).smul c).hom s) =
      ((gluedModule V h).smul (f.app W c)).hom
        (pullbackSections f U V g h τ hV htrans W s) := by
  apply Subtype.ext
  funext i
  change f.appLE _ _ _ (Y.resHom inf_le_left c * s.val (τ i)) =
    X.resHom inf_le_left (f.app W c) * f.appLE _ _ _ (s.val (τ i))
  rw [map_mul, appLE_resHom, f.app_eq_appLE, resHom_appLE]

/-- In a selected local frame, pullback is the usual pullback of regular functions. -/
lemma sectionTriv_pullbackSections
    (hc : IsCocycle U g) (hd : IsCocycle V h) (i : I)
    {W : Y.Opens} {A : X.Opens} (hW : W ≤ U (τ i))
    (hA : A ≤ V i) (e : A ≤ f ⁻¹ᵁ W) (s : sectionSubmodule U g W) :
    sectionTriv hd i hA
        (res V h e (pullbackSections f U V g h τ hV htrans W s)) =
      f.appLE W A e (sectionTriv hc (τ i) hW s) := by
  change X.resHom _ (X.resHom _ (f.appLE _ _ _ (s.val (τ i)))) =
    f.appLE _ _ _ (Y.resHom _ (s.val (τ i)))
  simp only [resHom_appLE, appLE_resHom]

/-- Pullback of matching sections as a morphism into the direct image. -/
def toPushforward : gluedModule U g ⟶ (Scheme.Modules.pushforward f).obj (gluedModule V h) where
  val := PresheafOfModules.homMk
    { app := fun W => AddCommGrpCat.ofHom
        (pullbackSections f U V g h τ hV htrans W.unop)
      naturality := fun {W W'} a => by
        apply AddCommGrpCat.hom_ext
        ext s
        exact pullbackSections_res f U V g h τ hV htrans a.unop.le s }
    (fun W c s => pullbackSections_smul f U V g h τ hV htrans W.unop c s)

/-- The adjoint comparison from the actual pullback to the refined glued module. -/
def pullbackHom : (Scheme.Modules.pullback f).obj (gluedModule U g) ⟶ gluedModule V h :=
  ((Scheme.Modules.pullbackPushforwardAdjunction f).homEquiv _ _).symm
    (toPushforward f U V g h τ hV htrans)

/-- The adjoint comparison pulls matching sections back by the explicit formula. -/
lemma unit_comp_pushforward_pullbackHom :
    (Scheme.Modules.pullbackPushforwardAdjunction f).unit.app (gluedModule U g) ≫
      (Scheme.Modules.pushforward f).map (pullbackHom f U V g h τ hV htrans) =
        toPushforward f U V g h τ hV htrans := by
  exact ((Scheme.Modules.pullbackPushforwardAdjunction f).homEquiv _ _).apply_symm_apply _

end
end Hartshorne.LineBundleGluing
