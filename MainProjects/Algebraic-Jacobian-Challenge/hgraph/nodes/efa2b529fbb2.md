---
author: sync
content_type: theorem
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis
docstring: '**Basis-local criterion for isomorphisms of `𝒪_X`-modules.** If `B` is
  a basis of

  opens of `X` and `φ : M ⟶ N` restricts to an isomorphism on the sections over every
  basic

  open `B i`, then `φ` is an isomorphism. This reduces iso-checking from *all* opens
  (the

  content of `Scheme.Modules.Hom.isIso_iff_isIso_app`) to a chosen basis. Project-local:

  Mathlib provides the stalkwise pieces (`germ_exist_of_isBasis`,

  `stalkFunctor_map_injective_of_isBasis`) but not the packaged criterion at the

  `Scheme.Modules` level.'
file: AlgebraicJacobian/Cohomology/FlatBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis
type: lean
updated: '2026-07-16T21:14:26'
---
theorem Modules.isIso_of_isIso_app_of_isBasis {X : Scheme.{u}} {M N : X.Modules}
    {ι : Type*} {B : ι → X.Opens} (hB : TopologicalSpace.Opens.IsBasis (Set.range B))
    (φ : M ⟶ N) (h : ∀ i, IsIso (φ.app (B i))) : IsIso φ := by
  -- Reduce to a stalkwise isomorphism of the underlying `Ab`-presheaf morphism `α`.
  rw [Modules.isIso_iff_isIso_stalkFunctor_map]
  intro x
  -- `α.app (op (B i))` is definitionally `φ.app (B i)`, hence an isomorphism on each basic open.
  have happ : ∀ U ∈ Set.range B,
      IsIso (((Scheme.Modules.toPresheaf X).map φ).app (Opposite.op U)) := by
    rintro U ⟨i, rfl⟩; exact h i
  rw [CategoryTheory.ConcreteCategory.isIso_iff_bijective]
  refine ⟨?_, ?_⟩
  · -- Injectivity of the stalk map from injectivity on a basis.
    refine TopCat.Presheaf.stalkFunctor_map_injective_of_isBasis hB ?_ x
    intro U hU
    haveI := happ U hU
    exact (CategoryTheory.ConcreteCategory.bijective_of_isIso
      (((Scheme.Modules.toPresheaf X).map φ).app (Opposite.op U))).injective
  · -- Surjectivity: a germ at `x` comes from a section over a basic open, where `α` is onto.
    intro t
    obtain ⟨U, hxU, hU, s, rfl⟩ :=
      TopCat.Presheaf.exists_mem_germ_eq_of_isBasis hB N.presheaf x t
    haveI := happ U hU
    obtain ⟨s', hs'⟩ := (CategoryTheory.ConcreteCategory.bijective_of_isIso
      (((Scheme.Modules.toPresheaf X).map φ).app (Opposite.op U))).surjective s
    refine ⟨M.presheaf.germ U x hxU s', ?_⟩
    erw [TopCat.Presheaf.stalkFunctor_map_germ_apply]
    rw [hs']
    rfl