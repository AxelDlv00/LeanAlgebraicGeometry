---
author: sync
content_type: theorem
created: '2026-07-19T15:31:14'
decl: AlgebraicGeometry.Scheme.one_mem_divisorSections_top
docstring: '**The constant `1` is a global section of `𝒪(D)` for effective `D`.**'
file: AlgebraicJacobian/RiemannRoch/EffectiveUniqueness.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.one_mem_divisorSections_top
type: lean
updated: '2026-07-19T15:31:14'
---
theorem one_mem_divisorSections_top {D : X.CurveDivisor} (hD : 0 ≤ D) :
    (1 : X.functionField) ∈ divisorSections K D ⊤ := by
  rw [mem_divisorSections_top_iff K one_ne_zero]
  have hone : Units.mk0 (1 : X.functionField) one_ne_zero = 1 := Units.ext rfl
  rw [hone, Scheme.divOf_one, add_zero]
  exact hD

/-! ## Effective uniqueness -/