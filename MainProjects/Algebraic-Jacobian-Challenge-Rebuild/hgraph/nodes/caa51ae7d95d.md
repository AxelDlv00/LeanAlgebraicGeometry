---
author: sync
content_type: theorem
created: '2026-07-17T08:41:25'
decl: TruncExpCech.scaleRingHom_one
docstring: Scaling by `1` is the identity.
file: AlgebraicJacobian/Tangent/TruncExpUnits.lean
generated: lean
lean_status: lean_ok
stale: true
title: TruncExpCech.scaleRingHom_one
type: lean
updated: '2026-07-31T20:14:50'
---
theorem scaleRingHom_one : scaleRingHom (1 : R) = RingHom.id R[ε] :=
  RingHom.ext fun x => TrivSqZeroExt.ext (by simp) (by simp)