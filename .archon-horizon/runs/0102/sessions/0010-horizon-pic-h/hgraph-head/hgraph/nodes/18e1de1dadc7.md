---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: CategoryTheory.Sheaf.h0_congr
docstring: '`h⁰` is invariant under sheaf isomorphism.'
file: AlgebraicJacobian/RiemannRoch/Chi.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.Sheaf.h0_congr
type: lean
updated: '2026-08-01T09:44:17'
---
theorem h0_congr (e : F ≅ G) : h0 F = h0 G :=
  (HModule.mapEquiv e 0).finrank_eq