---
author: sync
content_type: theorem
created: '2026-07-29T00:16:06'
decl: AlgebraicGeometry.Scheme.AffineTwoCover.selector_mem
docstring: 'The selector selects a chart containing the point — the `hmem` clause
  every two-chart

  declaration takes. The `x ∉ V₀` branch is where `sup_eq_top` is spent.'
file: AlgebraicJacobian/Tangent/TwoChartSelector.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.AffineTwoCover.selector_mem
type: lean
updated: '2026-07-30T15:46:08'
---
theorem selector_mem (x : Y) : x ∈ D.boolFamily (D.selector x) := by
  classical
  rw [selector]
  split_ifs with h
  · exact h
  · have hx : x ∈ (⊤ : Y.Opens) := trivial
    rw [← D.sup_eq_top] at hx
    exact (TopologicalSpace.Opens.mem_sup.mp hx).resolve_left h

/-! ## The side condition, characterized -/