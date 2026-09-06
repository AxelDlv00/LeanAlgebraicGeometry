/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivGrassmannianClass

/-!
# Recovering divisors from an invertible twist

Tensoring by a line bundle reflects isomorphisms of quotient presentations.
This supplies the injectivity step in the divisor-to-Grassmannian comparison.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory

namespace AlgebraicGeometry.Scheme

namespace Modules

attribute [local instance] monoidalCategory braidedCategory

private noncomputable def tensorCounitIso {X : Scheme.{u}} (M : X.Modules) :
    sheafification.obj ((toPresheafOfModules X).obj M) ≅ M :=
  (asIso (PresheafOfModules.sheafificationAdjunction
    (𝟙 X.ringCatSheaf.obj)).counit).app M

set_option backward.isDefEq.respectTransparency false in
private lemma tensorObjIso_naturality_right {X : Scheme.{u}}
    (L : X.Modules) {M N : X.Modules} (f : M ⟶ N) :
    (tensorObjIso L M).hom ≫ tensorObj_functoriality (𝟙 L) f =
      (L ◁ f) ≫ (tensorObjIso L N).hom := by
  dsimp only [tensorObjIso, Iso.trans_hom, MonoidalCategory.tensorIso_hom, Iso.symm_hom]
  change (((tensorCounitIso L).inv ⊗ₘ (tensorCounitIso M).inv) ≫ _) ≫
    sheafification.map
      (MonoidalCategory.whiskerLeft
        (C := _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat))
        L.val f.val) = _
  rw [Category.assoc]
  erw [← Localization.Monoidal.μ_natural_right]
  change _ = (L ◁ f) ≫
    (((tensorCounitIso L).inv ⊗ₘ (tensorCounitIso N).inv) ≫ _)
  rw [← Category.assoc, ← MonoidalCategory.id_tensorHom,
    MonoidalCategory.tensorHom_comp_tensorHom]
  erw [show (tensorCounitIso M).inv ≫ sheafification.map f.val =
      f ≫ (tensorCounitIso N).inv by
    exact ((asIso (PresheafOfModules.sheafificationAdjunction
      (𝟙 X.ringCatSheaf.obj)).counit).inv.naturality f).symm]
  erw [Category.comp_id]
  have h := MonoidalCategory.tensorHom_comp_tensorHom (𝟙 L) f
    (tensorCounitIso L).inv (tensorCounitIso N).inv
  simp only [MonoidalCategory.id_tensorHom, Category.id_comp] at h
  exact (congrArg (fun g => g ≫ _) h.symm).trans (Category.assoc _ _ _)

private noncomputable def fullyFaithfulTensorLeft {X : Scheme.{u}}
    (L : X.Modules) (hL : LineBundle.IsLocallyTrivial L) :
    (tensorLeft L).FullyFaithful := by
  let K := (exists_tensorObj_inverse hL).choose
  let e := (exists_tensorObj_inverse hL).choose_spec.2.some
  let eLK : L ⊗ K ≅ 𝟙_ X.Modules := tensorObjIso L K ≪≫ e
  let eKL : K ⊗ L ≅ 𝟙_ X.Modules :=
    tensorObjIso K L ≪≫ tensorObj_braiding K L ≪≫ e
  let c₁ : tensorLeft L ⋙ tensorLeft K ≅ 𝟭 X.Modules :=
    (tensorLeftTensor K L).symm ≪≫ (curriedTensor X.Modules).mapIso eKL ≪≫
      leftUnitorNatIso X.Modules
  let c₂ : tensorLeft K ⋙ tensorLeft L ≅ 𝟭 X.Modules :=
    (tensorLeftTensor L K).symm ≪≫ (curriedTensor X.Modules).mapIso eLK ≪≫
      leftUnitorNatIso X.Modules
  exact (CategoryTheory.Equivalence.mk (tensorLeft L) (tensorLeft K)
    c₁.symm c₂).fullyFaithfulFunctor

set_option backward.isDefEq.respectTransparency false in
/-- A line-bundle twist reflects an isomorphism between quotient presentations,
including compatibility with their common source. -/
theorem exists_iso_of_tensorObj_quotient_iso {X : Scheme.{u}}
    (L : X.Modules) (hL : LineBundle.IsLocallyTrivial L)
    {A B C : X.Modules} (f : A ⟶ B) (g : A ⟶ C)
    (e : tensorObj L B ≅ tensorObj L C)
    (he : tensorObj_functoriality (𝟙 L) f ≫ e.hom =
      tensorObj_functoriality (𝟙 L) g) :
    ∃ e' : B ≅ C, f ≫ e'.hom = g := by
  let h := fullyFaithfulTensorLeft L hL
  let E : L ⊗ B ≅ L ⊗ C := tensorObjIso L B ≪≫ e ≪≫ (tensorObjIso L C).symm
  refine ⟨h.preimageIso E, h.map_injective ?_⟩
  rw [Functor.map_comp, Functor.FullyFaithful.preimageIso_hom, h.map_preimage]
  change (L ◁ f) ≫ E.hom = L ◁ g
  apply (cancel_mono (tensorObjIso L C).hom).mp
  change ((L ◁ f) ≫ ((tensorObjIso L B).hom ≫ e.hom ≫
    (tensorObjIso L C).inv)) ≫ (tensorObjIso L C).hom = _
  simp only [Category.assoc, Iso.inv_hom_id, Category.comp_id]
  rw [← Category.assoc, ← tensorObjIso_naturality_right, Category.assoc, he,
    tensorObjIso_naturality_right]

end Modules

namespace DivFamily

variable {S X : Scheme.{u}} {π : X ⟶ S} {T : Over S}

set_option backward.isDefEq.respectTransparency false in
/-- A compatible isomorphism of twists by a line bundle identifies the original
relative divisors. This is the reflection step in the Grassmannian embedding. -/
theorem rel_of_twistQuotientMap_iso
    (L : X.Modules) (hL : LineBundle.IsLocallyTrivial L)
    {x y : DivFamily π T} (e : x.twist L ≅ y.twist L)
    (he : x.twistQuotientMap L ≫ e.hom = y.twistQuotientMap L) : x.Rel y := by
  let P := (Modules.pullback (pullback.fst π T.hom)).obj L
  let u := Modules.pullbackUnitIso (pullback.fst π T.hom)
  have ht : Modules.tensorObj_functoriality (𝟙 P) (u.inv ≫ x.q) ≫ e.hom =
      Modules.tensorObj_functoriality (𝟙 P) (u.inv ≫ y.q) := by
    apply (cancel_epi (Modules.tensorObj_right_unitor P).inv).mp
    exact (Category.assoc _ _ _).symm.trans he
  obtain ⟨e', he'⟩ := Modules.exists_iso_of_tensorObj_quotient_iso P
    (hL.pullback (pullback.fst π T.hom)) (u.inv ≫ x.q) (u.inv ≫ y.q) e ht
  exact ⟨e', (cancel_epi u.inv).mp (by simpa only [Category.assoc] using he')⟩

end DivFamily

end AlgebraicGeometry.Scheme
