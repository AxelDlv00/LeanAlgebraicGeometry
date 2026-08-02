---
author: sync
content_type: theorem
created: '2026-08-03T02:07:56'
decl: AlgebraicGeometry.Scheme.Hom.IsHQuasiProjectiveWith.isSeparated
docstring: H-quasi-projective morphisms carrying a line bundle are separated.
file: AlgebraicJacobian/Picard/ProjectiveMorphism.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Hom.IsHQuasiProjectiveWith.isSeparated
type: lean
updated: '2026-08-03T02:07:56'
---
theorem isSeparated (h : π.IsHQuasiProjectiveWith L) : IsSeparated π :=
  h.isHQuasiProjective.isSeparated