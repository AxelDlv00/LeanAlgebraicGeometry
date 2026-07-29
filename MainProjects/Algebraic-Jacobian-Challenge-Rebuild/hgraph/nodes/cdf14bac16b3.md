---
author: sync
content_type: theorem
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.mul_mem_divisorSections_top
docstring: '**The product rule for pole bounds**: `H⁰(𝒪(A)) · H⁰(𝒪(B)) ⊆ H⁰(𝒪(A +
  B))` — the

  valuation is multiplicative and `divisorBound` turns divisor addition into multiplication.'
file: AlgebraicJacobian/RiemannRoch/SectionSpaces.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.mul_mem_divisorSections_top
type: lean
updated: '2026-07-29T15:26:34'
---
theorem mul_mem_divisorSections_top {A B : X.CurveDivisor} {f h : X.functionField}
    (hfA : f ∈ divisorSections K A ⊤) (hhB : h ∈ divisorSections K B ⊤) :
    f * h ∈ divisorSections K (A + B) ⊤ := by
  rw [mem_divisorSections_of_nonempty K (top_opens_nonempty (X := X))] at hfA hhB ⊢
  intro x hx hxU
  rw [map_mul, Scheme.divisorBound_add]
  exact mul_le_mul' (hfA x hx hxU) (hhB x hx hxU)