---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: CategoryTheory.Sheaf.h0_congr
docstring: '`h⁰` is invariant under sheaf isomorphism.'
file: AlgebraicJacobian/RiemannRoch/Chi.lean
generated: lean
lean_status: lean_ok
stale: true
title: CategoryTheory.Sheaf.h0_congr
type: lean
updated: '2026-07-29T15:26:10'
---
theorem h0_congr (e : F ≅ G) : h0 F = h0 G :=
  (HModule.mapEquiv e 0).finrank_eq