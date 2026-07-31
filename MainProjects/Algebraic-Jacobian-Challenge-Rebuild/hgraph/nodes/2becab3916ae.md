---
author: sync
content_type: instance
created: '2026-07-30T20:44:27'
decl: AlgebraicGeometry.instIsProperBaseChangeBundle
docstring: Properness, keyed on the bundled base-changed curve.
file: AlgebraicJacobian/Picard/Pic0FiniteSeparablePoint.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.instIsProperBaseChangeBundle
type: lean
updated: '2026-07-31T20:14:41'
---
instance instIsProperBaseChangeBundle : IsProper (baseChangeBundle C L).hom :=
  instIsProperSndLeft C L

variable (C : Over (Spec (.of k))) [GeometricallyIrreducible C.hom]
    (L : Type u) [Field L] [Algebra k L] in