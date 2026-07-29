---
author: sync
content_type: definition
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.toFinsupp
docstring: 'The underlying finitely supported function of a Weil divisor (`CurveDivisor`
  is definitionally

  a `Finsupp`, but the wrapper blocks `FunLike`/`Sub`; this genuine coercion re-exposes
  them).'
file: AlgebraicJacobian/RiemannRoch/Devissage.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.toFinsupp
type: lean
updated: '2026-07-29T15:26:31'
---
def toFinsupp (D : X.CurveDivisor) : {p : X // p ≠ genericPoint X} →₀ ℤ := D