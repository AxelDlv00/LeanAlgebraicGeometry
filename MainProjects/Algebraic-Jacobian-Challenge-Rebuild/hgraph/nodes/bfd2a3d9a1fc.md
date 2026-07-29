---
author: sync
content_type: theorem
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.Grassmannian.finite_submodule_of_projective_quotient
docstring: 'A submodule of a finite module with projective quotient is finite: the
  retraction

  `quotRetract` is a surjection from the ambient module.'
file: AlgebraicJacobian/Picard/DivCarveKit.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Grassmannian.finite_submodule_of_projective_quotient
type: lean
updated: '2026-07-29T15:26:33'
---
theorem finite_submodule_of_projective_quotient [Module.Finite R M] :
    Module.Finite R ↥N :=
  Module.Finite.of_surjective (quotRetract N) fun x =>
    ⟨x.1, by rw [quotRetract_apply_of_mem N x.2]⟩