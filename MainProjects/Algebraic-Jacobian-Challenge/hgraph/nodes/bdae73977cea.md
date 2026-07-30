---
author: sync
content_type: theorem
created: '2026-07-31T02:29:40'
decl: AlgebraicGeometry.ProjectiveSpace.AffineChartAtRing.awayAlgEquiv_chartCoord
file: AlgebraicJacobian/Picard/ProjectiveSpaceAffineChartAt.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjectiveSpace.AffineChartAtRing.awayAlgEquiv_chartCoord
type: lean
updated: '2026-07-31T02:29:40'
---
theorem awayAlgEquiv_chartCoord (i : J) (j : {j : J // j ≠ i}) :
    awayAlgEquiv R J i (chartCoord R J i j) = X j :=
  awayToPoly_chartCoord R J i j

@[simp]