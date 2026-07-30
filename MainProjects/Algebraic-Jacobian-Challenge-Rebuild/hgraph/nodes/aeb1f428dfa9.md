---
author: sync
content_type: theorem
created: '2026-07-24T17:02:48'
decl: AlgebraicGeometry.fiberCoordUnit_coeffAt_divOf_nonneg_of_mem_chart₀
docstring: '**Order table, chart 0.** The fiber unit `u` is regular on `V₀ = π⁻¹ D₊(X₀)`:
  its classical

  order `div u` is nonnegative at every point of `V₀` (`u = germ_η t₀`, and `t₀` is
  a regular section

  on `V₀`).'
file: AlgebraicJacobian/RiemannRoch/FLVFiberToolkit.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.fiberCoordUnit_coeffAt_divOf_nonneg_of_mem_chart₀
type: lean
updated: '2026-07-30T15:28:02'
---
theorem fiberCoordUnit_coeffAt_divOf_nonneg_of_mem_chart₀ {x : Y} (hx : x ≠ genericPoint Y)
    (hxV₀ : x ∈ fiberChart₀ π) :
    (0 : ℤ) ≤ coeffAt hx
      (Scheme.divOf (Y ↘ Spec (CommRingCat.of K)) (fiberCoordUnit π)) :=
  zero_le_coeffAt_divOf_of_val_eq_germ (genericPoint_mem_preimage_inf π).1 hx hxV₀ (fiberCoord π)
    (fiberCoordUnit_val π)