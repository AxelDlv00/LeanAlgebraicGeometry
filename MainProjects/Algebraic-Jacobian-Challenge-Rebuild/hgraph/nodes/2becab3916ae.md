---
author: sync
content_type: instance
created: '2026-07-30T20:44:27'
decl: AlgebraicGeometry.instIsProperBaseChangeBundle
docstring: Properness, keyed on the bundled base-changed curve.
file: AlgebraicJacobian/Picard/Pic0ChartFiniteExtension.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.instIsProperBaseChangeBundle
type: lean
updated: '2026-07-30T20:44:27'
---
instance instIsProperBaseChangeBundle : IsProper (baseChangeBundle C L).hom :=
  instIsProperSndLeft C L

variable (C) (L : Type u) [Field L] [Algebra k L] in