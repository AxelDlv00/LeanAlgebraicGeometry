/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotientFiniteAtlasSections
import Mathlib.AlgebraicGeometry.GammaSpecAdjunction

/-!
# Invariant morphisms into affine targets

The image calculation for sections of the glued quotient descends invariant
morphisms into affine schemes. The Gamma-Spec adjunction turns the descended
map of global sections into a scheme morphism, and injectivity of pullback
on global sections gives uniqueness.
-/

set_option autoImplicit false

universe u

open CategoryTheory AlgebraicGeometry Opposite

namespace MilneLib

/-- A morphism into an affine scheme factors uniquely through a map whose
global-section pullback is injective, provided its sections are in the image
of that pullback. -/
theorem existsUnique_factor_toSpec_of_appTop_injective_of_range
    {X Y : Scheme.{u}} {R : Type u} [CommRing R]
    (q : X ⟶ Y) (f : X ⟶ Spec (CommRingCat.of R))
    (hq : Function.Injective q.appTop.hom)
    (hf : Set.range f.appTop.hom ⊆ Set.range q.appTop.hom) :
    ∃! u : Y ⟶ Spec (CommRingCat.of R), q ≫ u = f := by
  let e : Γ(Y, ⊤) ≃+* q.appTop.hom.range :=
    RingEquiv.ofBijective q.appTop.hom.rangeRestrict
      ⟨fun a b hab => hq (congrArg Subtype.val hab),
        q.appTop.hom.rangeRestrict_surjective⟩
  let φ : CommRingCat.of R ⟶ Γ(X, ⊤) := (Scheme.ΓSpecIso _).inv ≫ f.appTop
  let ψ : CommRingCat.of R ⟶ Γ(Y, ⊤) :=
    CommRingCat.ofHom (e.symm.toRingHom.comp
      (φ.hom.codRestrict q.appTop.hom.range (fun r => hf ⟨_, rfl⟩)))
  have hψ : ψ ≫ q.appTop = φ := by
    ext r
    exact congrArg Subtype.val (e.apply_symm_apply
      (φ.hom.codRestrict q.appTop.hom.range (fun r => hf ⟨_, rfl⟩) r))
  let u : Y ⟶ Spec (CommRingCat.of R) :=
    (ΓSpec.adjunction.homEquiv Y (op (CommRingCat.of R))) ψ.op
  have hu : q ≫ u = f := by
    apply ext_to_Spec
    simp only [Scheme.Γ_map_op, Scheme.Hom.comp_appTop]
    exact (Category.assoc _ _ _).symm.trans
      ((congrArg (fun z => z ≫ q.appTop)
        (ΓSpecIso_inv_ΓSpec_adjunction_homEquiv ψ)).trans hψ)
  refine ⟨u, hu, ?_⟩
  intro v hv
  apply ext_to_Spec
  apply CommRingCat.hom_ext
  apply RingHom.ext
  intro r
  apply hq
  have H := congrArg (fun z => ((Scheme.ΓSpecIso (CommRingCat.of R)).inv ≫
    z.appTop).hom r) (hv.trans hu.symm)
  exact H

namespace StableGroupAction.StableAffineOpen

variable {k G : Type u} [CommRing k] [Group G] [Finite G]
  {X : Scheme.{u}} (act : G →* Aut X) [X.IsSeparated] [CompactSpace X]
  (p : X ⟶ Spec (CommRingCat.of k))
  (hact : ∀ g : G, (act g).hom ≫ p = p)
  (h : OrbitsInAffineOpen act)

/-- Every invariant morphism into an affine scheme factors uniquely through
the canonical glued finite-group quotient. -/
theorem finiteStableCanonicalQuotientProjection_existsUnique_factor_toSpec
    {R : Type u} [CommRing R] (f : X ⟶ Spec (CommRingCat.of R))
    (hf : ∀ g : G, (act g).hom ≫ f = f) :
    ∃! u : (finiteStableQuotientGlueData act p hact h).glued ⟶
        Spec (CommRingCat.of R),
      finiteStableCanonicalQuotientProjection act p hact h ≫ u = f := by
  apply existsUnique_factor_toSpec_of_appTop_injective_of_range
  · exact finiteStableCanonicalQuotientProjection_app_injective act p hact h ⊤
  · rintro _ ⟨s, rfl⟩
    apply (finiteStableCanonicalQuotientProjection_mem_range_app_iff_actApp
      act p hact h ⊤ (f.appTop.hom s)).mpr
    intro g
    exact congrArg (fun z => z.hom s) (app_actApp_of_invariant act f hf ⊤ g)

end StableGroupAction.StableAffineOpen

end MilneLib
