---
author: sync
content_type: instance
created: '2026-07-16T21:14:29'
decl: AlgebraicGeometry.below.
file: AlgebraicJacobian/RiemannRoch/WeilDivisor.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.below.
type: lean
updated: '2026-07-24T03:02:13'
---
  instance below.) -/
  out : ∀ Y : Scheme.PrimeDivisor X, IsDiscreteValuationRing (X.presheaf.stalk Y.point)