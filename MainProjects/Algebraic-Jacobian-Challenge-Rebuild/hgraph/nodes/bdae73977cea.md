---
author: sync
content_type: theorem
created: '2026-08-03T16:37:45'
decl: AlgebraicGeometry.ProjectiveSpace.AffineChartAtRing.awayAlgEquiv_chartCoord
file: AlgebraicJacobian/Projective/ProjectiveSpaceAffineChartAt.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjectiveSpace.AffineChartAtRing.awayAlgEquiv_chartCoord
type: lean
updated: '2026-08-18T20:51:07'
---
theorem awayAlgEquiv_chartCoord (i : J) (j : {j : J // j ≠ i}) :
    awayAlgEquiv R J i (chartCoord R J i j) = X j :=
  awayToPoly_chartCoord R J i j

@[simp]