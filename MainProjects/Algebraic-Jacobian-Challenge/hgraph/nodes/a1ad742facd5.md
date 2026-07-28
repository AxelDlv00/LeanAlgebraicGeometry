---
author: sync
content_type: definition
created: '2026-07-28T18:12:20'
decl: AlgebraicGeometry.uniformizer
docstring: 'A chosen uniformizer at `x`: `ord_x (uniformizer) = ofAdd (−1)`.'
file: AlgebraicJacobian/RiemannRoch/Ledger/JumpDimension.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.uniformizer
type: lean
updated: '2026-07-28T18:12:20'
---
noncomputable def uniformizer : X.functionField := (exists_ord_eq_neg_one K hx).choose