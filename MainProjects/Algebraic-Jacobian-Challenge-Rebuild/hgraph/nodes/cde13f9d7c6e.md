---
author: sync
content_type: theorem
created: '2026-07-31T00:30:37'
decl: CategoryTheory.Sheaf.HModule.surjective_map_g_zero
docstring: '**Right exactness on degree-zero cohomology**: `H⁰(X₂) → H⁰(X₃)` is

  surjective when `H¹(X₁)` vanishes.'
file: AlgebraicJacobian/RiemannRoch/ChiSlice.lean
generated: lean
lean_status: lean_ok
stale: true
title: CategoryTheory.Sheaf.HModule.surjective_map_g_zero
type: lean
updated: '2026-07-31T20:14:50'
---
theorem surjective_map_g_zero (hS : S.ShortExact) [Subsingleton (HModule S.X₁ 1)] :
    Function.Surjective (map S.g 0) := fun y =>
  (exact_map_g_delta hS rfl y).mp (Subsingleton.elim _ 0)