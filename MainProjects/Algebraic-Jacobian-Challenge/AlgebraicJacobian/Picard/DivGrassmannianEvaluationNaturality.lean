/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivGrassmannianNaturality

/-!
# Base change of the divisor Grassmannian evaluation

The canonical evaluation morphism used by the divisor-to-Grassmannian
construction commutes with arbitrary change of test scheme.  The proof
combines composition of the pullback-pushforward base-change transformations
with the compatibility of the twisted divisor quotient under pullback.

This is the project's D2 adaptation of the base-change mechanism behind the
functoriality in Kleiman, *The Picard scheme*, `th:LinSys` (TeX lines
2000--2004).  That source concerns rank-one linear systems; the theorem here
does not assert that linear-system representability result.

The equality of canonical maps proved here does not assert that the target
base-change comparison is an isomorphism.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry
namespace Scheme

set_option backward.isDefEq.respectTransparency false in
private lemma grassmannian_pullback_square_pasting
    {S X : Scheme.{u}} (π : X ⟶ S) {T T' : Over S} (ψ : T' ⟶ T)
    (M : S.Modules) :
    (Modules.pullback (pullback.snd π T'.hom)).map
        (pullbackTriangleIso (Over.w ψ) M).inv ≫
      (((Modules.pullbackComp (pullback.snd π T'.hom) ψ.left) ≪≫
        Modules.pullbackCongr (quotBaseMap_snd π ψ).symm ≪≫
        (Modules.pullbackComp (quotBaseMap π ψ) (pullback.snd π T.hom)).symm).hom.app
          ((Modules.pullback T.hom).obj M)) ≫
      (Modules.pullback (quotBaseMap π ψ)).map
        ((((Modules.pullbackComp (pullback.snd π T.hom) T.hom) ≪≫
          Modules.pullbackCongr (pullback.condition (f := π) (g := T.hom)).symm ≪≫
          (Modules.pullbackComp (pullback.fst π T.hom) π).symm).hom.app M)) ≫
      (pullbackTriangleIso (quotBaseMap_fst π ψ)
        ((Modules.pullback π).obj M)).hom =
    (((Modules.pullbackComp (pullback.snd π T'.hom) T'.hom) ≪≫
      Modules.pullbackCongr (pullback.condition (f := π) (g := T'.hom)).symm ≪≫
      (Modules.pullbackComp (pullback.fst π T'.hom) π).symm).hom.app M) := by
  let a := quotBaseMap π ψ
  let p := pullback.snd π T.hom
  let p' := pullback.snd π T'.hom
  let b := pullback.fst π T.hom
  let b' := pullback.fst π T'.hom
  have hs : a ≫ p = p' ≫ ψ.left := quotBaseMap_snd π ψ
  have hf : a ≫ b = b' := quotBaseMap_fst π ψ
  have hc : p ≫ T.hom = b ≫ π := pullback.condition.symm
  have hc' : p' ≫ T'.hom = b' ≫ π := pullback.condition.symm
  have hfinal : (a ≫ p) ≫ T.hom = b' ≫ π := by
    rw [Category.assoc, hc, ← Category.assoc, hf]
  have hfinal' : a ≫ (b ≫ π) = b' ≫ π := by rw [← Category.assoc, hf]
  have h₁ := Modules.pullback_comp_app_coherence p' ψ.left hs T.hom
    (Over.w ψ) hfinal hc' M
  have h₂ := Modules.pullback_comp_app_coherence a p rfl T.hom
    hc hfinal hfinal' M
  have h₃ := Modules.pullback_comp_app_coherence a b hf.symm π
    rfl rfl hfinal' M
  simp only [Modules.pullbackCongr_hom_app, Modules.pullbackCongr_inv_app,
    eqToHom_refl, Category.id_comp, Category.comp_id] at h₂ h₃
  apply (cancel_mono ((Modules.pullbackComp b' π).hom.app M)).1
  apply (cancel_epi ((Modules.pullback p').map
    (pullbackTriangleIso (Over.w ψ) M).hom)).1
  dsimp only [a, p, p', b, b'] at *
  simp only [Category.assoc, ← Functor.map_comp_assoc, Iso.hom_inv_id]
  simp only [pullbackTriangleIso, Iso.trans_hom,
    Iso.app_hom, Iso.symm_hom, NatTrans.comp_app, Category.assoc,
    Iso.inv_hom_id_app, Category.comp_id]
  simp only [Modules.pullbackCongr_hom_app, Modules.pullbackCongr_inv_app] at h₁ ⊢
  rw [h₃]
  simp only [← Functor.map_comp_assoc]
  simp only [Category.assoc, Iso.inv_hom_id_app, Category.comp_id]
  rw [← h₂]
  simp only [Iso.inv_hom_id_app_assoc]
  erw [CategoryTheory.Functor.map_id, Category.id_comp]
  exact h₁

set_option backward.defeqAttrib.useBackward true in
set_option backward.isDefEq.respectTransparency false in
private lemma mate_pasting_component
    {A B C D E F : Type*} [Category A] [Category B] [Category C]
    [Category D] [Category E] [Category F]
    {L₁ : A ⥤ B} {R₁ : B ⥤ A} {L₂ : C ⥤ D} {R₂ : D ⥤ C}
    {L₃ : E ⥤ F} {R₃ : F ⥤ E}
    {G₁ : A ⥤ C} {G₂ : C ⥤ E} {G₀ : A ⥤ E}
    {H₁ : B ⥤ D} {H₂ : D ⥤ F} {H₀ : B ⥤ F}
    (adj₁ : L₁ ⊣ R₁) (adj₂ : L₂ ⊣ R₂) (adj₃ : L₃ ⊣ R₃)
    (α₁ : TwoSquare G₁ L₁ L₂ H₁) (α₂ : TwoSquare G₂ L₂ L₃ H₂)
    (α₀ : TwoSquare G₀ L₁ L₃ H₀)
    (s : G₀ ⟶ G₁ ⋙ G₂) (t : H₁ ⋙ H₂ ⟶ H₀)
    (h : ∀ M, L₃.map (s.app M) ≫ α₂.app (G₁.obj M) ≫
      H₂.map (α₁.app M) ≫ t.app (L₁.obj M) = α₀.app M) (N : B) :
    s.app (R₁.obj N) ≫ G₂.map ((mateEquiv adj₁ adj₂ α₁).app N) ≫
      (mateEquiv adj₂ adj₃ α₂).app (H₁.obj N) ≫ R₃.map (t.app N) =
      (mateEquiv adj₁ adj₃ α₀).app N := by
  apply (adj₃.homEquiv _ _).symm.injective
  simp only [Adjunction.homEquiv_counit, Functor.map_comp, Category.assoc]
  erw [adj₃.counit.naturality (t.app N)]
  simp only [CategoryTheory.Functor.comp_obj, CategoryTheory.Functor.id_map]
  erw [reassoc_of% (mateEquiv_counit adj₂ adj₃ α₂ (H₁.obj N))]
  erw [α₂.naturality_assoc ((mateEquiv adj₁ adj₂ α₁).app N)]
  simp only [CategoryTheory.Functor.comp_map]
  rw [← H₂.map_comp_assoc, mateEquiv_counit adj₁ adj₂ α₁,
    H₂.map_comp, Category.assoc]
  erw [t.naturality (adj₁.counit.app N)]
  calc
    _ = α₀.app (R₁.obj N) ≫ H₀.map (adj₁.counit.app N) := by
      change L₃.map (s.app (R₁.obj N)) ≫ α₂.app (G₁.obj (R₁.obj N)) ≫
        H₂.map (α₁.app (R₁.obj N)) ≫ t.app (L₁.obj (R₁.obj N)) ≫
        H₀.map (adj₁.counit.app N) = _
      simpa only [Category.assoc] using
        congrArg (fun m => m ≫ H₀.map (adj₁.counit.app N)) (h (R₁.obj N))
    _ = _ := (mateEquiv_counit adj₁ adj₃ α₀ N).symm

set_option backward.isDefEq.respectTransparency false in
/-- Canonical base change through two successive test schemes agrees with
base change directly to the final test scheme. -/
theorem canonicalBaseChangeMap_quotBaseSquare_comp
    {S X : Scheme.{u}} (π : X ⟶ S) {T T' : Over S} (ψ : T' ⟶ T)
    (L : X.Modules) :
    (pullbackTriangleIso (Over.w ψ) ((Modules.pushforward π).obj L)).inv ≫
      (Modules.pullback ψ.left).map
        ((canonicalBaseChangeMap (IsPullback.of_hasPullback π T.hom)).app L) ≫
      (canonicalBaseChangeMap (quotBaseSquare π ψ)).app
        ((Modules.pullback (pullback.fst π T.hom)).obj L) ≫
      (Modules.pushforward (pullback.snd π T'.hom)).map
        (pullbackTriangleIso (quotBaseMap_fst π ψ) L).hom =
      (canonicalBaseChangeMap (IsPullback.of_hasPullback π T'.hom)).app L := by
  exact mate_pasting_component
    (Modules.pullbackPushforwardAdjunction π)
    (Modules.pullbackPushforwardAdjunction (pullback.snd π T.hom))
    (Modules.pullbackPushforwardAdjunction (pullback.snd π T'.hom))
    (((Modules.pullbackComp (pullback.snd π T.hom) T.hom) ≪≫
      Modules.pullbackCongr (pullback.condition (f := π) (g := T.hom)).symm ≪≫
      (Modules.pullbackComp (pullback.fst π T.hom) π).symm).hom)
    (((Modules.pullbackComp (pullback.snd π T'.hom) ψ.left) ≪≫
      Modules.pullbackCongr (quotBaseMap_snd π ψ).symm ≪≫
      (Modules.pullbackComp (quotBaseMap π ψ) (pullback.snd π T.hom)).symm).hom)
    (((Modules.pullbackComp (pullback.snd π T'.hom) T'.hom) ≪≫
      Modules.pullbackCongr (pullback.condition (f := π) (g := T'.hom)).symm ≪≫
      (Modules.pullbackComp (pullback.fst π T'.hom) π).symm).hom)
    (((Modules.pullbackComp ψ.left T.hom) ≪≫
      Modules.pullbackCongr (Over.w ψ)).inv)
    (((Modules.pullbackComp (quotBaseMap π ψ) (pullback.fst π T.hom)) ≪≫
      Modules.pullbackCongr (quotBaseMap_fst π ψ)).hom)
    (grassmannian_pullback_square_pasting π ψ) L

namespace DivFamily

set_option backward.isDefEq.respectTransparency false in
/-- The project's D2 divisor-to-Grassmannian evaluation commutes with arbitrary
change of test scheme, through the canonical base-change and twist comparisons.
This adapts the base-change mechanism behind Kleiman's `th:LinSys` functoriality.
No flatness hypothesis is needed for this equality of canonical maps. -/
theorem grassmannianEval_pullback
    {S X : Scheme.{u}} {π : X ⟶ S} {T T' : Over S}
    (L : X.Modules) (x : DivFamily π T) (ψ : T' ⟶ T) :
    (pullbackTriangleIso (Over.w ψ) ((Modules.pushforward π).obj L)).inv ≫
      (Modules.pullback ψ.left).map (x.grassmannianEval L) ≫
      (canonicalBaseChangeMap (quotBaseSquare π ψ)).app (x.twist L) ≫
      (Modules.pushforward (pullback.snd π T'.hom)).map
        (twistPullbackMap L x ψ) =
      (x.pullbackAlong ψ).grassmannianEval L := by
  have htwist : (Modules.pullback (quotBaseMap π ψ)).map (x.twistQuotientMap L) ≫
      twistPullbackMap L x ψ =
      (pullbackTriangleIso (quotBaseMap_fst π ψ) L).hom ≫
        (x.pullbackAlong ψ).twistQuotientMap L := by
    apply (cancel_epi (pullbackTriangleIso (quotBaseMap_fst π ψ) L).inv).1
    simpa only [Category.assoc, Iso.inv_hom_id_assoc] using
      twistPullbackMap_comp_twistQuotientMap L x ψ
  simp only [grassmannianEval, Functor.map_comp, Category.assoc]
  erw [(canonicalBaseChangeMap (quotBaseSquare π ψ)).naturality_assoc
    (x.twistQuotientMap L)]
  simp only [CategoryTheory.Functor.comp_map]
  rw [← Functor.map_comp, htwist, Functor.map_comp]
  simpa only [Category.assoc] using congrArg
    (fun m => m ≫ (Modules.pushforward (pullback.snd π T'.hom)).map
      ((x.pullbackAlong ψ).twistQuotientMap L))
    (canonicalBaseChangeMap_quotBaseSquare_comp π ψ L)

end DivFamily

end Scheme
end AlgebraicGeometry
