---
author: sync
content_type: theorem
created: '2026-08-03T18:38:51'
decl: AlgebraicGeometry.P1FiniteMap.basicOpen_coord1
docstring: The second coordinate cuts out the overlap inside `P1`.
file: AlgebraicJacobian/Projective/FiniteMapProjectiveCoordinates.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.P1FiniteMap.basicOpen_coord1
type: lean
updated: '2026-08-07T05:01:59'
---
theorem basicOpen_coord1 :
    (P1 k).basicOpen (coord1 (k := k)) =
      P1.chartOpen k 0 ⊓ P1.chartOpen k 1 := by
  rw [coord1_eq_awayToSection, P1.basicOpen_awayToSection_chartCoord, inf_comm]