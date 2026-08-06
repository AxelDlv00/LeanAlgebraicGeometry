---
author: sync
content_type: definition
created: '2026-08-03T16:37:45'
decl: AlgebraicGeometry.ProjectiveSpace.Coordinates.chartHom
docstring: 'A coordinate family with its `i`-th coordinate equal to one defines a

  ring map from the `i`-th standard projective chart.'
file: AlgebraicJacobian/Projective/ProjectiveCoordinateChart.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjectiveSpace.Coordinates.chartHom
type: lean
updated: '2026-08-07T05:01:59'
---
def chartHom (i : J) (c : J → B) (hi : c i = 1) :
    Away (homogeneousSubmodule J (ULift.{u} ℤ)) (X i) →+* B :=
  awayLift (X i) (eval c) (by rw [eval_X, hi]; exact isUnit_one)