---
author: sync
content_type: definition
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.uniformizer
docstring: 'A chosen uniformizer at `x`: `ord_x (uniformizer) = ofAdd (−1)`.'
file: AlgebraicJacobian/RiemannRoch/JumpDimension.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.uniformizer
type: lean
updated: '2026-07-29T15:26:30'
---
noncomputable def uniformizer : X.functionField := (exists_ord_eq_neg_one K hx).choose