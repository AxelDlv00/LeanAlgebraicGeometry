---
author: sync
content_type: theorem
created: '2026-07-31T02:29:40'
decl: AlgebraicGeometry.ProjectiveSpace.AffineChartAtRing.awayAlgEquiv_symm_X
file: AlgebraicJacobian/Picard/ProjectiveSpaceAffineChartAt.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjectiveSpace.AffineChartAtRing.awayAlgEquiv_symm_X
type: lean
updated: '2026-07-31T02:29:40'
---
theorem awayAlgEquiv_symm_X (i : J) (j : {j : J // j ≠ i}) :
    (awayAlgEquiv R J i).symm (X j) = chartCoord R J i j :=
  (awayAlgEquiv R J i).symm_apply_eq.mpr
    (awayAlgEquiv_chartCoord R J i j).symm

omit [Finite J] in