---
author: sync
content_type: theorem
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.P1.algebraMap_awayToOverlapLeft
docstring: The algebra structure of the overlap ring over the left chart ring is restriction.
file: AlgebraicJacobian/Curve/P1Points.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.P1.algebraMap_awayToOverlapLeft
type: lean
updated: '2026-07-29T15:31:37'
---
theorem algebraMap_awayToOverlapLeft :
    algebraMap (Away 𝒜 (X (0 : Fin 2)))
        (Away 𝒜 ((X 0 : MvPolynomial (Fin 2) k) * X 1)) = awayToOverlapLeft k :=
  rfl