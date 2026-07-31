---
author: sync
content_type: lemma
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.graphTensorEval_graphElift
docstring: 'The pushed idempotent lift evaluates to zero: the graph chart contains
  the graph

  point.'
file: AlgebraicJacobian/RiemannRoch/GraphChart.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.graphTensorEval_graphElift
type: lean
updated: '2026-07-31T20:15:29'
---
lemma graphTensorEval_graphElift : graphTensorEval C t (graphElift C t) = 0 := by
  rw [graphElift, graphTensorEval_map,
    (Over.diagonalChartData C).lmul'_elift (t.left.base default), map_zero]