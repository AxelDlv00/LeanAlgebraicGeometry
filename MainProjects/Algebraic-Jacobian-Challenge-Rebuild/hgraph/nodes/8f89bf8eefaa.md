---
author: sync
content_type: theorem
created: '2026-07-19T15:01:16'
decl: AlgebraicGeometry.thetaChartUnit_zero
docstring: The whole-chart theta transition units are trivial at exponent `0`.
file: AlgebraicJacobian/Picard/DivisorDatumInverse.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.thetaChartUnit_zero
type: lean
updated: '2026-07-29T15:31:43'
---
theorem thetaChartUnit_zero (i j : (thetaChartCover C B π).index) :
    thetaChartUnit C B π 0 i j = 1 := by
  rcases i with i | i <;> rcases j with j | j
  · rfl
  · change (relCurve C B).unitsRestrict _ (relThetaCocycle C B π 0) = 1
    rw [relThetaCocycle_zero, map_one]
  · change (relCurve C B).unitsRestrict _ (relThetaCocycle C B π 0)⁻¹ = 1
    rw [relThetaCocycle_zero, inv_one, map_one]
  · rfl