---
author: sync
content_type: instance
created: '2026-07-16T21:14:29'
decl: AlgebraicGeometry.below.
file: AlgebraicJacobian/RiemannRoch/WeilDivisor.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.below.
type: lean
updated: '2026-07-28T12:23:48'
---
  instance below.) -/
  out : ∀ Y : Scheme.PrimeDivisor X, IsDiscreteValuationRing (X.presheaf.stalk Y.point)