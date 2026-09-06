/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotientSections
import MilneLib.InvariantQuotientFiniteAtlasOrbit

/-!
# Epimorphisms for invariant quotient projections

The affine invariant quotient is surjective and injective on pullback of
structure-sheaf sections on every open. These two properties make it an
epimorphism in the category of schemes. Cancelling these affine projections
on the charts of the finite stable cover proves that the canonical glued
projection is also an epimorphism. This gives uniqueness of quotient
factorizations into arbitrary schemes; existence remains a separate theorem.
-/

set_option autoImplicit false

universe u

open CategoryTheory AlgebraicGeometry Opposite TopologicalSpace

namespace MilneLib

set_option backward.isDefEq.respectTransparency false in
/-- A surjective scheme morphism which is injective on pullback of sections
on every open is an epimorphism. -/
theorem epi_of_surjective_of_app_injective {X Y : Scheme.{u}} (f : X ⟶ Y)
    (hsurj : Function.Surjective f)
    (hinj : ∀ U : Y.Opens, Function.Injective (f.app U)) : Epi f := by
  apply Functor.epi_of_epi_map Scheme.forgetToLocallyRingedSpace
  apply Functor.epi_of_epi_map LocallyRingedSpace.forgetToSheafedSpace
  apply Functor.epi_of_epi_map SheafedSpace.forgetToPresheafedSpace
  let f' : X.toPresheafedSpace ⟶ Y.toPresheafedSpace := f.toLRSHom.toHom
  change Epi f'
  constructor
  intro Z ⟨g, gc⟩ ⟨h, hc⟩ e
  obtain rfl : g = h := ConcreteCategory.hom_ext _ _ fun y ↦ by
    obtain ⟨x, rfl⟩ := hsurj y
    exact congrArg (fun k => k.base x) e
  have hgc : gc = hc := by
    apply NatTrans.ext
    funext U
    haveI : Mono (f'.c.app ((Opens.map g).op.obj U)) :=
      ConcreteCategory.mono_of_injective _ (hinj _)
    rw [← cancel_mono (f'.c.app ((Opens.map g).op.obj U))]
    have H := PresheafedSpace.congr_app e U
    change gc.app U ≫ f'.c.app _ =
      (hc.app U ≫ f'.c.app _) ≫ X.presheaf.map (𝟙 _) at H
    rw [CategoryTheory.Functor.map_id] at H
    exact H.trans (Category.comp_id _)
  cases hgc
  rfl

/-- The affine finite-group invariant quotient is an epimorphism in the
category of schemes, including with arbitrary non-affine target schemes. -/
instance affineInvariantQuotientMap_epi
    {k A G : Type u} [CommRing k] [CommRing A] [Algebra k A]
    [Group G] [Finite G] [MulSemiringAction G A] [SMulCommClass G k A] :
    Epi (affineInvariantQuotientMap (k := k) (A := A) (G := G)) :=
  epi_of_surjective_of_app_injective _ affineInvariantQuotientMap_surjective
    InvariantLocalization.affineInvariantQuotientMap_app_injective

namespace StableGroupAction.StableAffineOpen

variable {k G : Type u} [CommRing k] [Group G] [Finite G]
  {X : Scheme.{u}} (act : G →* Aut X) [X.IsSeparated] [CompactSpace X]
  (p : X ⟶ Spec (CommRingCat.of k))
  (hact : ∀ g : G, (act g).hom ≫ p = p)
  (h : OrbitsInAffineOpen act)

set_option backward.isDefEq.respectTransparency false in
/-- The canonical projection from a compact scheme to its glued finite-group
quotient is an epimorphism. Thus any factorization through this projection is
unique for every target scheme. -/
instance finiteStableCanonicalQuotientProjection_epi :
    Epi (finiteStableCanonicalQuotientProjection act p hact h) := by
  constructor
  intro Y f g hfg
  let D := finiteStableQuotientCrossChartDatum act p hact h
  apply D.toGlueData.openCover.hom_ext
  intro i
  let C := finiteStableAffineChart act h i
  letI := sectionsAlgebra p C.U
  letI := sectionsMulSemiringAction act C.stable
  letI := sectionsSMulCommClass act p hact C.stable
  haveI : Epi (finiteStableQuotientChartMap act p hact h i) := by
    change Epi (C.affine.isoSpec.hom ≫
      affineInvariantQuotientMap (k := k) (A := Γ(X, C.U)) (G := G))
    infer_instance
  change D.toGlueData.ι i ≫ f = D.toGlueData.ι i ≫ g
  apply (cancel_epi (finiteStableQuotientChartMap act p hact h i)).mp
  have H := congrArg (fun z => (finiteStableAffineCover act h).f i ≫ z) hfg
  simpa only [← Category.assoc,
    finiteStableCover_f_finiteStableCanonicalQuotientProjection] using H

end StableGroupAction.StableAffineOpen

end MilneLib
