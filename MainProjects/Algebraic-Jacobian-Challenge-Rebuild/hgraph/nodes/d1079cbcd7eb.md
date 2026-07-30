---
author: sync
content_type: lemma
created: '2026-07-17T21:01:12'
decl: AlgebraicGeometry.thetaChartCover_pieces_le_inl
docstring: Every piece is contained in its pinned chart, chart-0 side.
file: AlgebraicJacobian/Cohomology/RelCurveCollapse.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.thetaChartCover_pieces_le_inl
type: lean
updated: '2026-07-30T15:46:00'
---
lemma thetaChartCover_pieces_le_inl (j : (thetaChartCover C B π).J₀) :
    (thetaChartCover C B π).pieces (Sum.inl j) ≤ (relCover C B (fiberTwoCover π)).V₀ :=
  (thetaChartCover_pieces_inl C B π j).le