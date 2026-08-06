---
author: sync
content_type: theorem
created: '2026-08-03T16:37:45'
decl: AlgebraicGeometry.Scheme.Hom.IsProjective.isSeparated
docstring: Projective morphisms are separated.
file: AlgebraicJacobian/Projective/ProjectiveMorphism.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Hom.IsProjective.isSeparated
type: lean
updated: '2026-08-07T05:01:59'
---
theorem isSeparated (h : pi.IsProjective) : IsSeparated pi :=
  haveI := h.isProper
  inferInstance