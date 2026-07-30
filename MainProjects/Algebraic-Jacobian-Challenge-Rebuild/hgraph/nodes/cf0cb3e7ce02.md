---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.pointCover_opens_self
file: AlgebraicJacobian/Picard/PointPresentation.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.pointCover_opens_self
type: lean
updated: '2026-07-30T15:46:06'
---
lemma pointCover_opens_self (d : PointUniformizerData K hx) :
    (pointCover K hx d).opens x = d.opens :=
  if_pos rfl