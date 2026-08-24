---
author: sync
content_type: theorem
created: '2026-08-03T16:37:45'
decl: AlgebraicGeometry.ProjectiveSpace.AffineChartAtRing.polyToAway_X
file: AlgebraicJacobian/Projective/ProjectiveSpaceAffineChartAt.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjectiveSpace.AffineChartAtRing.polyToAway_X
type: lean
updated: '2026-08-18T20:51:07'
---
theorem polyToAway_X (i : J) (j : {j : J // j ≠ i}) :
    polyToAway R J i (X j) = chartCoord R J i j :=
  MvPolynomial.aeval_X _ _