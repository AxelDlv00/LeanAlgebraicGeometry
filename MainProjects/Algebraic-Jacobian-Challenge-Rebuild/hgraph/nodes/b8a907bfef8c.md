---
author: sync
content_type: theorem
created: '2026-07-30T08:49:43'
decl: AlgebraicGeometry.exists_isIso_of_mem_zariskiTopology
docstring: '**A Zariski covering sieve of a scheme with at most one point contains
  an isomorphism.**


  Take a cover refining the sieve; its component over the point `x` is an open immersion
  whose

  base map is surjective *because the target is a subsingleton*, hence an isomorphism.


  The `Subsingleton` hypothesis is on the space, and `x` witnesses that it is also
  nonempty —

  both are needed: on the empty scheme the bottom sieve covers

  (`Scheme.bot_mem_grothendieckTopology`) and contains no isomorphism at all.'
file: AlgebraicJacobian/Picard/Pic0ChartFieldTestSurjective.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.exists_isIso_of_mem_zariskiTopology
type: lean
updated: '2026-07-30T15:28:03'
---
theorem exists_isIso_of_mem_zariskiTopology {X : Scheme.{u}} [Subsingleton (X : Type u)]
    (x : X) (S : Sieve X) (hS : S ∈ Scheme.zariskiTopology X) :
    ∃ (Y : Scheme.{u}) (g : Y ⟶ X), S.arrows g ∧ IsIso g := by
  obtain ⟨𝒰, hle⟩ := Scheme.exists_cover_of_mem_grothendieckTopology hS
  obtain ⟨i, y, hy⟩ := 𝒰.exists_eq x
  haveI : IsOpenImmersion (𝒰.f i) := 𝒰.map_prop i
  haveI : Epi (𝒰.f i).base := by
    rw [TopCat.epi_iff_surjective]
    exact fun z => ⟨y, Subsingleton.elim _ _⟩
  exact ⟨𝒰.X i, 𝒰.f i, hle _ _ (Presieve.ofArrows.mk i), IsOpenImmersion.isIso (𝒰.f i)⟩