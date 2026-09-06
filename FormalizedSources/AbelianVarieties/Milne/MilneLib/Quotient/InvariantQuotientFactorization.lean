/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.Quotient.InvariantQuotientFiniteAtlasSections
import MilneLib.Quotient.InvariantQuotientEpimorphism
import MilneLib.Sheaf.SchemeMorphismDescent

/-!
# Factorization through the finite quotient

Orbit fibres descend the underlying continuous map. Invariant sections then
descend its pullback on every open of the target.
-/

set_option autoImplicit false

universe u

open CategoryTheory AlgebraicGeometry Opposite TopologicalSpace

namespace MilneLib.StableGroupAction.StableAffineOpen

variable {k G : Type u} [CommRing k] [Group G] [Finite G]
  {X : Scheme.{u}} (act : G →* Aut X) [X.IsSeparated] [CompactSpace X]
  (p : X ⟶ Spec (CommRingCat.of k))
  (hact : ∀ g : G, (act g).hom ≫ p = p)
  (h : OrbitsInAffineOpen act)
  {Z : Scheme.{u}} (f : X ⟶ Z) (hf : ∀ g : G, (act g).hom ≫ f = f)

noncomputable def finiteQuotientFactorBase :
    (finiteStableQuotientGlueData act p hact h).glued.toTopCat ⟶ Z.toTopCat :=
  TopCat.ofHom ((finiteStableCanonicalQuotientProjection_isQuotientMap act p hact h).lift
    f.base.hom (by
      intro x y hxy
      obtain ⟨g, rfl⟩ :=
        (finiteStableCanonicalQuotientProjection_eq_iff_exists_act act p hact h x y).mp hxy
      exact (congrArg (fun t : X ⟶ Z => t x) (hf g)).symm))

theorem finiteQuotientFactorBase_comp :
    (finiteStableCanonicalQuotientProjection act p hact h).base ≫
        finiteQuotientFactorBase act p hact h f hf = f.base := by
  apply TopCat.hom_ext
  exact Topology.IsQuotientMap.lift_comp
      (finiteStableCanonicalQuotientProjection_isQuotientMap act p hact h)
      f.base.hom _

theorem finiteQuotientFactorBase_preimage (U : Z.Opens) :
    finiteStableCanonicalQuotientProjection act p hact h ⁻¹ᵁ
        (Opens.map (finiteQuotientFactorBase act p hact h f hf)).obj U = f ⁻¹ᵁ U := by
  change (Opens.map ((finiteStableCanonicalQuotientProjection act p hact h).base ≫
    finiteQuotientFactorBase act p hact h f hf)).obj U = _
  rw [finiteQuotientFactorBase_comp]
  rfl

noncomputable def finiteQuotientFactorPullback (U : Z.Opens) :
    Γ(Z, U) ⟶ Γ(X, finiteStableCanonicalQuotientProjection act p hact h ⁻¹ᵁ
      (Opens.map (finiteQuotientFactorBase act p hact h f hf)).obj U) :=
  f.appLE U _ (finiteQuotientFactorBase_preimage act p hact h f hf U).le

theorem finiteQuotientFactorPullback_invariant (U : Z.Opens) (g : G) :
    finiteQuotientFactorPullback act p hact h f hf U ≫ actApp act
      (finiteStableCanonicalQuotientProjection_preimage_isStableOpen act p hact h _)
      g = finiteQuotientFactorPullback act p hact h f hf U := by
  rw [finiteQuotientFactorPullback, actApp, Scheme.Hom.appLE_comp_appLE,
    appLE_congr_hom (hf g)]

/-- The pullback of a target section has a unique lift to the quotient. -/
theorem finiteQuotientFactorPullback_mem_range (U : Z.Opens) (s : Γ(Z, U)) :
    (finiteQuotientFactorPullback act p hact h f hf U).hom s ∈ Set.range
      ((finiteStableCanonicalQuotientProjection act p hact h).app
        ((Opens.map (finiteQuotientFactorBase act p hact h f hf)).obj U)).hom := by
  apply (finiteStableCanonicalQuotientProjection_mem_range_app_iff_actApp
    act p hact h _ _).mpr
  intro g
  exact congrArg (fun t => t.hom s)
    (finiteQuotientFactorPullback_invariant act p hact h f hf U g)

/-- The descended pullback on one target open. -/
noncomputable def finiteQuotientFactorApp (U : Z.Opens) :
    Γ(Z, U) ⟶ Γ((finiteStableQuotientGlueData act p hact h).glued,
      (Opens.map (finiteQuotientFactorBase act p hact h f hf)).obj U) := by
  let r := ((finiteStableCanonicalQuotientProjection act p hact h).app
    ((Opens.map (finiteQuotientFactorBase act p hact h f hf)).obj U)).hom
  let e := RingEquiv.ofBijective r.rangeRestrict
    ⟨fun a b hab => finiteStableCanonicalQuotientProjection_app_injective
      act p hact h _ (congrArg Subtype.val hab), r.rangeRestrict_surjective⟩
  exact CommRingCat.ofHom (e.symm.toRingHom.comp
    ((finiteQuotientFactorPullback act p hact h f hf U).hom.codRestrict r.range
      (finiteQuotientFactorPullback_mem_range act p hact h f hf U)))

theorem finiteQuotientFactorApp_comp (U : Z.Opens) :
    finiteQuotientFactorApp act p hact h f hf U ≫
      (finiteStableCanonicalQuotientProjection act p hact h).app
        ((Opens.map (finiteQuotientFactorBase act p hact h f hf)).obj U) =
      finiteQuotientFactorPullback act p hact h f hf U := by
  let r := ((finiteStableCanonicalQuotientProjection act p hact h).app
    ((Opens.map (finiteQuotientFactorBase act p hact h f hf)).obj U)).hom
  let e := RingEquiv.ofBijective r.rangeRestrict
    ⟨fun a b hab => finiteStableCanonicalQuotientProjection_app_injective
      act p hact h _ (congrArg Subtype.val hab), r.rangeRestrict_surjective⟩
  ext s
  exact congrArg Subtype.val (e.apply_symm_apply
    ⟨_, finiteQuotientFactorPullback_mem_range act p hact h f hf U s⟩)

set_option backward.isDefEq.respectTransparency false in
theorem finiteQuotientFactorApp_naturality {U V : Z.Opens} (i : U ⟶ V) :
    Z.presheaf.map i.op ≫ finiteQuotientFactorApp act p hact h f hf U =
      finiteQuotientFactorApp act p hact h f hf V ≫
        (finiteStableQuotientGlueData act p hact h).glued.presheaf.map
          ((Opens.map (finiteQuotientFactorBase act p hact h f hf)).map i).op := by
  let q := finiteStableCanonicalQuotientProjection act p hact h
  let b := finiteQuotientFactorBase act p hact h f hf
  haveI : Mono (q.app ((Opens.map b).obj U)) := ConcreteCategory.mono_of_injective _
    (finiteStableCanonicalQuotientProjection_app_injective act p hact h _)
  apply (cancel_mono (q.app ((Opens.map b).obj U))).mp
  rw [Category.assoc, finiteQuotientFactorApp_comp]
  rw [Category.assoc, q.naturality (((Opens.map b).map i).op),
    ← Category.assoc, finiteQuotientFactorApp_comp]
  dsimp [finiteQuotientFactorPullback]
  rw [Scheme.Hom.map_appLE, Scheme.Hom.appLE_map]

/-- The descended continuous map and section pullbacks form a morphism of
presheafed spaces. -/
noncomputable def finiteQuotientFactorPresheafedSpace :
    (finiteStableQuotientGlueData act p hact h).glued.toPresheafedSpace ⟶
      Z.toPresheafedSpace where
  base := finiteQuotientFactorBase act p hact h f hf
  c :=
    { app := fun U => finiteQuotientFactorApp act p hact h f hf U.unop
      naturality := fun _ _ i =>
        finiteQuotientFactorApp_naturality act p hact h f hf i.unop }

set_option backward.isDefEq.respectTransparency false in
theorem finiteQuotientFactorPresheafedSpace_comp :
    (finiteStableCanonicalQuotientProjection act p hact h).toLRSHom.toHom ≫
      finiteQuotientFactorPresheafedSpace act p hact h f hf = f.toLRSHom.toHom := by
  apply PresheafedSpace.ext _ _ (finiteQuotientFactorBase_comp act p hact h f hf)
  apply NatTrans.ext
  funext U
  change (finiteQuotientFactorApp act p hact h f hf U.unop ≫
      (finiteStableCanonicalQuotientProjection act p hact h).app
        ((Opens.map (finiteQuotientFactorBase act p hact h f hf)).obj U.unop)) ≫ _ =
      f.app U.unop
  rw [finiteQuotientFactorApp_comp]
  dsimp [finiteQuotientFactorPullback]
  change f.appLE _ _ _ ≫ X.presheaf.map _ = _
  rw [Scheme.Hom.appLE_map]
  exact Scheme.Hom.appLE_eq_app f

include hf in
/-- Every invariant morphism into an arbitrary scheme factors uniquely through
the canonical finite quotient. -/
theorem finiteStableCanonicalQuotientProjection_existsUnique_factor :
    ∃! u : (finiteStableQuotientGlueData act p hact h).glued ⟶ Z,
      finiteStableCanonicalQuotientProjection act p hact h ≫ u = f := by
  let u := schemeMorphismOfPresheafedSpaceFactor
    (finiteStableCanonicalQuotientProjection act p hact h)
    (finiteStableCanonicalQuotientProjection_surjective act p hact h) f
    (finiteQuotientFactorPresheafedSpace act p hact h f hf)
    (finiteQuotientFactorPresheafedSpace_comp act p hact h f hf)
  have hu : finiteStableCanonicalQuotientProjection act p hact h ≫ u = f :=
    comp_schemeMorphismOfPresheafedSpaceFactor _ _ _ _ _
  refine ⟨u, hu, ?_⟩
  intro v hv
  exact (cancel_epi (finiteStableCanonicalQuotientProjection act p hact h)).mp
    (hv.trans hu.symm)

end MilneLib.StableGroupAction.StableAffineOpen
