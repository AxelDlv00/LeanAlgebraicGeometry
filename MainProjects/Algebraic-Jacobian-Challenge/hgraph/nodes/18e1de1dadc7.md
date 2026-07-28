---
author: sync
content_type: theorem
created: '2026-07-28T18:12:20'
decl: CategoryTheory.Sheaf.h0_congr
docstring: '`h⁰` is invariant under sheaf isomorphism.'
file: AlgebraicJacobian/RiemannRoch/Ledger/Chi.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.Sheaf.h0_congr
type: lean
updated: '2026-07-28T18:12:20'
---
theorem h0_congr (e : F ≅ G) : h0 F = h0 G :=
  (HModule.mapEquiv e 0).finrank_eq