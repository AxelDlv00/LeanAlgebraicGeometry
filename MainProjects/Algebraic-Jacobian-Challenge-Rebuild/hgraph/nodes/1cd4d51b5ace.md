---
author: sync
content_type: instance
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.compactSpace_left_of_quasiCompact
docstring: A scheme quasi-compact over `Spec k` (e.g. proper) is a quasi-compact topological
  space.
file: AlgebraicJacobian/Curve/Basic.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.compactSpace_left_of_quasiCompact
type: lean
updated: '2026-07-30T15:46:00'
---
instance compactSpace_left_of_quasiCompact [QuasiCompact X.hom] : CompactSpace X.left :=
  QuasiCompact.compactSpace_of_compactSpace X.hom