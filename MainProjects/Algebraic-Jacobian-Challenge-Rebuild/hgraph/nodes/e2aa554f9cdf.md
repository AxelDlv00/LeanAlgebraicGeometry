---
author: sync
content_type: theorem
created: '2026-07-16T21:33:27'
decl: Algebra.IsStandardSmooth.isReduced_of_isDomain
docstring: A standard smooth algebra over a domain is reduced.
file: AlgebraicJacobian/Curve/GeometricallyReduced.lean
generated: lean
lean_status: lean_ok
stale: true
title: Algebra.IsStandardSmooth.isReduced_of_isDomain
type: lean
updated: '2026-07-30T15:28:05'
---
theorem Algebra.IsStandardSmooth.isReduced_of_isDomain (B S : Type*) [CommRing B] [CommRing S]
    [IsDomain B] [Algebra B S] [Algebra.IsStandardSmooth B S] : IsReduced S :=
  (RingHom.isStandardSmooth_algebraMap.mpr ‹_›).isReduced_of_isDomain

end RingTheory

namespace AlgebraicGeometry

open CategoryTheory Limits

variable {X Y : Scheme.{u}}