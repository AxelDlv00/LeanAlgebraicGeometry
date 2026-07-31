---
author: sync
content_type: definition
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.picEt.overlapTest
docstring: 'The mediating test of the cross-member gluing: the open subscheme of the
  target at

  an affine open `W`, over the base through the inclusion.'
file: AlgebraicJacobian/Picard/PicEtCoverBridge.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.picEt.overlapTest
type: lean
updated: '2026-07-31T20:14:49'
---
noncomputable def overlapTest (W : T.left.affineOpens) : Over (Spec (.of k)) :=
  Over.mk (W.1.ι ≫ T.hom)

variable (T) in