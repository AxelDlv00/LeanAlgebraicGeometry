---
author: sync
content_type: theorem
created: '2026-07-31T19:55:23'
decl: AlgebraicGeometry.FiberCoordinateData.uniformVanishing_fixedCoordinate
docstring: 'Large-degree `H^1` vanishing is uniform over every field extension of
  the ground field.

  This is the unconditional endpoint of the fixed-coordinate degree construction.'
file: AlgebraicJacobian/RiemannRoch/Ledger/FixedFiberDegree.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.FiberCoordinateData.uniformVanishing_fixedCoordinate
type: lean
updated: '2026-07-31T19:55:23'
---
theorem uniformVanishing_fixedCoordinate : UniformVanishing C :=
  uniformVanishing_of_uniformBaseDivisor_curve C (uniformBaseDivisor_fixedCoordinate C)