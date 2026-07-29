---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.pointEqn_of_ne
file: AlgebraicJacobian/Picard/PointPresentation.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.pointEqn_of_ne
type: lean
updated: '2026-07-29T15:31:48'
---
lemma pointEqn_of_ne (d : PointUniformizerData K hx) {z : X} (hz : z ≠ x) :
    pointEqn K hx d z = 1 :=
  dif_neg hz