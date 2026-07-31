---
author: sync
content_type: theorem
created: '2026-07-31T08:04:21'
decl: AlgebraicGeometry.FiberCoordinateData.coordinateWeilDivisor_nonneg
docstring: The coordinate divisor is effective.
file: AlgebraicJacobian/RiemannRoch/Ledger/FiberCoordinateDivisor.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.FiberCoordinateData.coordinateWeilDivisor_nonneg
type: lean
updated: '2026-07-31T08:04:21'
---
theorem coordinateWeilDivisor_nonneg : 0 ≤ D.coordinateWeilDivisor (K := K) := by
  refine Finsupp.le_def.mpr (fun p => ?_)
  change (0 : ℤ) ≤ coeffAt p.2 (D.coordinateWeilDivisor (K := K))
  rw [D.coordinateWeilDivisor_coeffAt (K := K) p.2]
  exact le_max_right _ _