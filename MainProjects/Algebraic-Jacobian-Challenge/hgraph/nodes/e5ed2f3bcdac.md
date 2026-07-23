---
author: sync
content_type: definition
created: '2026-07-16T21:14:25'
decl: CategoryTheory.Functor.gHomologyZeroIso
docstring: '**Degree-zero cohomology of the applied resolution** (degree-`0` case
  of blueprint

  `lem:cohomology_of_applied_resolution`). For a finite-limit-preserving `G`, the
  zeroth cohomology

  of the applied complex `G(K•)` is `G` of the zeroth cosyzygy `Z⁰ = K.cycles 0`:

  `H⁰(G(K•)) ≅ G(Z⁰)`. Since the complex starts in degree `0` there is no incoming
  differential, so

  `H⁰` coincides with the cocycle object `ker(G(K⁰) → G(K¹))`, which `Functor.gCosyzygyIsoCocycles`

  identifies with `G(Z⁰)`. Composed with an augmentation iso `A ≅ Z⁰` this gives the
  blueprint''s

  `H⁰(G(J•)) ≅ G(A)`.'
file: AlgebraicJacobian/Cohomology/AcyclicResolution.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.Functor.gHomologyZeroIso
type: lean
updated: '2026-07-24T03:02:09'
---
noncomputable def Functor.gHomologyZeroIso (G : 𝒜 ⥤ ℬ) [G.Additive]
    [Limits.PreservesFiniteLimits G] (K : CochainComplex 𝒜 ℕ) :
    G.obj (K.cycles 0) ≅ ((G.mapHomologicalComplex (ComplexShape.up ℕ)).obj K).homology 0 :=
  G.gCosyzygyIsoCocycles K 0 ≪≫
    CochainComplex.isoHomologyπ₀ ((G.mapHomologicalComplex (ComplexShape.up ℕ)).obj K)

end Cosyzygy

/-! ## Project-local Mathlib supplement — the acyclic-resolution comparison theorem -/