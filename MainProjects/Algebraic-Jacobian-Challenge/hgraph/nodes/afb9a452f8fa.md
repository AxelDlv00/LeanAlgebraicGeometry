---
author: sync
content_type: definition
created: '2026-07-28T18:12:20'
decl: AlgebraicGeometry.toFinsupp
docstring: 'The underlying finitely supported function of a Weil divisor (`CurveDivisor`
  is definitionally

  a `Finsupp`, but the wrapper blocks `FunLike`/`Sub`; this genuine coercion re-exposes
  them).'
file: AlgebraicJacobian/RiemannRoch/Ledger/Devissage.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.toFinsupp
type: lean
updated: '2026-07-28T18:12:20'
---
def toFinsupp (D : X.CurveDivisor) : {p : X // p ≠ genericPoint X} →₀ ℤ := D