---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: DualNumber.unitsFst_truncExpUnit
file: AlgebraicJacobian/Picard/Pic0DualNumberCocycle.lean
generated: lean
lean_status: lean_ok
title: DualNumber.unitsFst_truncExpUnit
type: lean
updated: '2026-07-16T21:14:27'
---
theorem unitsFst_truncExpUnit (b : R) : unitsFst (truncExpUnit b) = 1 :=
  Units.ext (by simp)

/-- The truncated exponential at `0` is the unit `1`. -/
@[simp]