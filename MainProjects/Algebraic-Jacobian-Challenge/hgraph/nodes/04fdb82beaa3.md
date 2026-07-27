---
author: sync
content_type: theorem
created: '2026-07-27T17:35:58'
decl: AlgebraicGeometry.Adelic.p1AwayAlgEquiv_p1CoordAway
file: AlgebraicJacobian/Picard/RigidPushforwardP1ChartRing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.p1AwayAlgEquiv_p1CoordAway
type: lean
updated: '2026-07-27T17:35:58'
---
theorem p1AwayAlgEquiv_p1CoordAway {i j : ULift.{u} (Fin 2)} (hij : i ≠ j) :
    p1AwayAlgEquiv (ULift.{u} ℤ) hij (p1CoordAway (ULift.{u} (Fin 2)) i j) = Polynomial.X := by
  rw [← p1ChartCoord_eq_p1CoordAway]
  exact p1AwayAlgEquiv_p1ChartCoord _ hij

/-- The chart ring of the integral model of `ℙ¹` is a domain. -/
example (i : ULift.{u} (Fin 2)) :
    IsDomain (Away (homogeneousSubmodule (ULift.{u} (Fin 2)) (ULift.{u} ℤ)) (X i)) :=
  inferInstance