---
author: sync
content_type: theorem
created: '2026-08-03T16:37:45'
decl: AlgebraicGeometry.ProjectiveSpace.AffineChartAtRing.awayAlgEquiv_symm_X
file: AlgebraicJacobian/Projective/ProjectiveSpaceAffineChartAt.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjectiveSpace.AffineChartAtRing.awayAlgEquiv_symm_X
type: lean
updated: '2026-08-18T20:51:07'
---
theorem awayAlgEquiv_symm_X (i : J) (j : {j : J // j ≠ i}) :
    (awayAlgEquiv R J i).symm (X j) = chartCoord R J i j :=
  (awayAlgEquiv R J i).symm_apply_eq.mpr
    (awayAlgEquiv_chartCoord R J i j).symm

omit [Finite J] in