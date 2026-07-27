---
author: sync
content_type: instance
created: '2026-07-27T17:35:58'
decl: AlgebraicGeometry.Adelic.instIsDomainULiftInt
docstring: '`ULift ℤ` is a domain (not available by unification from the instance
  for `ℤ`).'
file: AlgebraicJacobian/Picard/RigidPushforwardP1ChartRing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.instIsDomainULiftInt
type: lean
updated: '2026-07-27T17:35:58'
---
instance instIsDomainULiftInt : IsDomain (ULift.{u} ℤ) :=
  Function.Injective.isDomain (ULift.ringEquiv : ULift.{u} ℤ ≃+* ℤ).toRingHom
    ULift.ringEquiv.injective