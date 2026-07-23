---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.AffineCoverMVSquare.pairFamily
docstring: 'The two-element indexed family `{U₁, U₂}` of a 2-affine cover square,
  used

  to feed the Mathlib sheaf-condition API.'
file: AlgebraicJacobian/RiemannRoch/CohomologyKit.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.AffineCoverMVSquare.pairFamily
type: lean
updated: '2026-07-24T03:02:13'
---
noncomputable def AffineCoverMVSquare.pairFamily {X : Scheme.{u}}
    (S : X.AffineCoverMVSquare) : ULift.{u} Bool → X.Opens :=
  fun i => bif i.down then S.U₁ else S.U₂