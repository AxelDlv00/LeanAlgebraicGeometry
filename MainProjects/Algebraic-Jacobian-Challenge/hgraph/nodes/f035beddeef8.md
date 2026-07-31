---
author: sync
content_type: theorem
created: '2026-07-31T08:04:21'
decl: AlgebraicGeometry.FiberCoordinateData.coordinateWeilDivisor_coeffAt_of_mem_V1
docstring: The coordinate divisor vanishes on the inverse-coordinate chart.
file: AlgebraicJacobian/RiemannRoch/Ledger/FiberCoordinateDivisor.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.FiberCoordinateData.coordinateWeilDivisor_coeffAt_of_mem_V1
type: lean
updated: '2026-07-31T08:04:21'
---
theorem coordinateWeilDivisor_coeffAt_of_mem_V1 {x : Y} (hx : x ≠ genericPoint Y)
    (hxV1 : x ∈ D.V₁) : coeffAt hx (D.coordinateWeilDivisor (K := K)) = 0 := by
  rw [D.coordinateWeilDivisor_coeffAt (K := K) hx,
    max_eq_right (D.coordinateUnit_coeffAt_divOf_nonpos_of_mem_V1 hx hxV1)]