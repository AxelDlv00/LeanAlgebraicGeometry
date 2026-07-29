---
author: sync
content_type: definition
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.graphChart
docstring: '**The graph chart**: the basic open `D(1 − eliftF)` of the product chart
  `𝔚(U, ⊤)` of

  the fibre curve, on which the graph ideal is principal on the point generator.  An

  `abbrev`, so that the ambient `basicOpen` localization instances fire on it.'
file: AlgebraicJacobian/RiemannRoch/GraphChart.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.graphChart
type: lean
updated: '2026-07-29T15:26:22'
---
noncomputable abbrev graphChart : (C ⊗ overSpec k K).left.Opens :=
  (C ⊗ overSpec k K).left.basicOpen
    (Over.productChartSections C (overSpec k K) (isAffineOpen_graphBaseChart C t)
      (isAffineOpen_top_overSpec k K) (1 - graphElift C t))