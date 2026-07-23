---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.ProjectiveSpace.isProjectiveWith_over
docstring: '**The structural morphism of relative projective space is itself

  projective**, carrying the Serre twist `O(1)`: the canonical inhabitant of

  `IsProjectiveWith`, with the identity closed immersion.  This exhibits

  `ℙ(Fin (d+1); S) ↘ S` as the universal projective morphism and shows the

  predicate is non-vacuous.'
file: AlgebraicJacobian/Picard/ProjectiveMorphism.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjectiveSpace.isProjectiveWith_over
type: lean
updated: '2026-07-16T21:14:27'
---
theorem isProjectiveWith_over (d : ℕ) (S : Scheme.{0}) :
    (ℙ(Fin (d + 1); S) ↘ S).IsProjectiveWith (twistingSheaf (Fin (d + 1)) S 1) :=
  ⟨d, 𝟙 _, inferInstance, Category.id_comp _,
    ⟨((Scheme.Modules.pullbackId _).app _).symm⟩⟩