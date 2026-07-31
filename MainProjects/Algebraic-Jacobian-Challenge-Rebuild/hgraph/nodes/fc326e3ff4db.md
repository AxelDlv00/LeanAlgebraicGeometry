---
author: sync
content_type: definition
created: '2026-07-27T10:33:33'
decl: AlgebraicGeometry.twistedFiberTwoCover
docstring: The affine two-chart cover of `Y` associated to the coordinate-twisted
  map.
file: AlgebraicJacobian/Cohomology/TwistedFiberTwoCover.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.twistedFiberTwoCover
type: lean
updated: '2026-07-31T20:15:18'
---
noncomputable def twistedFiberTwoCover {Y : Scheme.{u}} (π : Y ⟶ P1 k)
    [IsAffineHom π] (M : Matrix.GeneralLinearGroup (Fin 2) k) : Y.AffineTwoCover :=
  fiberTwoCover (twistedP1Map π M)

@[simp]