---
author: sync
content_type: lemma
created: '2026-07-31T08:04:21'
decl: AlgebraicGeometry.FiberCoordinateData.coordinateWeilDivisor_ofMap
docstring: The intrinsic positive divisor of map-derived coordinates is the existing
  fiber divisor.
file: AlgebraicJacobian/RiemannRoch/Ledger/FiberCoordinateDivisor.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.FiberCoordinateData.coordinateWeilDivisor_ofMap
type: lean
updated: '2026-07-31T08:04:21'
---
lemma coordinateWeilDivisor_ofMap :
    (ofMap π).coordinateWeilDivisor (K := K) = fiberWeilDivisor π := by
  unfold coordinateWeilDivisor fiberWeilDivisor
  rw [coordinateUnit_ofMap π]