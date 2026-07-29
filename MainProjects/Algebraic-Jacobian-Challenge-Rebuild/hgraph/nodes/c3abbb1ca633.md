---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.TrivializingFamily.cover_opens
file: AlgebraicJacobian/Picard/CechPicSurjective.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.TrivializingFamily.cover_opens
type: lean
updated: '2026-07-29T15:26:33'
---
lemma cover_opens (x : X) : F.cover.opens x = X.basicOpen (F.sec x) :=
  rfl

section transition

variable [IsAffine X]