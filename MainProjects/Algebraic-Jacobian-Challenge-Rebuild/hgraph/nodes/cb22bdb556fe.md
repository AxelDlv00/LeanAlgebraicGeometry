---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.relCurveMap
docstring: '**The comparison morphism between relative curves** over the test-ring
  change

  `R → R''`: the underlying scheme morphism of the whiskering `C ◁ overSpecMap R R''`,

  `relCurve C R'' ⟶ relCurve C R`.'
file: AlgebraicJacobian/Cohomology/RelativeSectionsLinear.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.relCurveMap
type: lean
updated: '2026-07-29T15:26:34'
---
noncomputable def relCurveMap : relCurve C R' ⟶ relCurve C R :=
  (C ◁ overSpecMap (k := k) R R').left