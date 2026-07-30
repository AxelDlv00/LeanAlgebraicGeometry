---
author: sync
content_type: theorem
created: '2026-07-30T11:48:44'
decl: AlgebraicGeometry.Scheme.Hom.IsProjective.isSeparated
docstring: Projective morphisms are separated.
file: AlgebraicJacobian/Picard/ProjectiveMorphismBasic.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Hom.IsProjective.isSeparated
type: lean
updated: '2026-07-30T11:48:44'
---
theorem isSeparated (h : pi.IsProjective) : IsSeparated pi :=
  haveI := h.isProper
  inferInstance