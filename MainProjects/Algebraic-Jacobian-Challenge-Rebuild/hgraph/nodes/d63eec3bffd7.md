---
author: sync
content_type: definition
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.Grassmannian.quotSection
docstring: A chosen splitting of the quotient map of a projective-quotient submodule.
file: AlgebraicJacobian/Picard/DivCarveKit.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Grassmannian.quotSection
type: lean
updated: '2026-07-30T15:28:04'
---
noncomputable def quotSection : (M ⧸ N) →ₗ[R] M :=
  (Module.projective_lifting_property N.mkQ LinearMap.id N.mkQ_surjective).choose