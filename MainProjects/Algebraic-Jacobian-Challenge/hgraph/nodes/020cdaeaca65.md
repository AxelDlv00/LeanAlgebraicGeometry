---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.Modules.chartFiberRank_congr_chart
file: AlgebraicJacobian/Picard/EntryIdealStratum.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.chartFiberRank_congr_chart
type: lean
updated: '2026-07-16T21:14:26'
---
lemma chartFiberRank_congr_chart {V W : X.affineOpens} (h : V = W) (x : X)
    (hxV : x ∈ V.1) (hxW : x ∈ W.1) :
    chartFiberRank G x hxV = chartFiberRank G x hxW := by
  subst h; rfl