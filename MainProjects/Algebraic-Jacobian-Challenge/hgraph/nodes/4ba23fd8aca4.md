---
author: sync
content_type: theorem
created: '2026-07-16T21:14:28'
decl: PresheafOfModules.isLocallyInjective_of_injective_stalk
docstring: '**Injective on stalks ⇒ locally injective (topological site).** For a
  morphism `T` of

  presheaves valued in a concrete category over a topological space `Z`, stalkwise
  injectivity

  implies local injectivity for `Opens.grothendieckTopology Z`. Project-local: Mathlib
  provides

  this only at the sheaf level (`app_injective_iff_stalkFunctor_map_injective`); here
  it is the

  presheaf-level statement, proved directly through `germ_eq` (the equalizer sieve
  covers each

  point because agreeing germs agree on a neighbourhood).'
file: AlgebraicJacobian/Picard/TensorObjSubstrate/Vestigial.lean
generated: lean
lean_status: lean_ok
title: PresheafOfModules.isLocallyInjective_of_injective_stalk
type: lean
updated: '2026-07-16T21:14:28'
---
theorem isLocallyInjective_of_injective_stalk
    {F G : TopCat.Presheaf A Z} (T : F ⟶ G)
    (h : ∀ z : Z, Function.Injective ⇑(ConcreteCategory.hom ((stalkFunctor A z).map T))) :
    CategoryTheory.Presheaf.IsLocallyInjective (Opens.grothendieckTopology Z) T := by
  refine ⟨fun {U'} s t hst z hz => ?_⟩
  have hgerm : (ConcreteCategory.hom (F.germ (unop U') z hz)) s
      = (ConcreteCategory.hom (F.germ (unop U') z hz)) t := by
    apply h z
    rw [stalkFunctor_map_germ_apply, stalkFunctor_map_germ_apply, hst]
  obtain ⟨W, hzW, iU, iV, heq⟩ := F.germ_eq z hz hz s t hgerm
  refine ⟨W, iU, ?_, hzW⟩
  rw [Subsingleton.elim iV iU] at heq
  rw [Presheaf.equalizerSieve_apply]
  exact heq