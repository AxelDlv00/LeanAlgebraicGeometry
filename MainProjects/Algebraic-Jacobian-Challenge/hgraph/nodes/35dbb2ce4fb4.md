---
author: sync
content_type: theorem
created: '2026-07-31T02:29:40'
decl: AlgebraicGeometry.ProjectiveSpace.AffineChartAtRing.polyToAway_X
file: AlgebraicJacobian/Picard/ProjectiveSpaceAffineChartAt.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjectiveSpace.AffineChartAtRing.polyToAway_X
type: lean
updated: '2026-07-31T02:29:40'
---
theorem polyToAway_X (i : J) (j : {j : J // j ≠ i}) :
    polyToAway R J i (X j) = chartCoord R J i j :=
  MvPolynomial.aeval_X _ _