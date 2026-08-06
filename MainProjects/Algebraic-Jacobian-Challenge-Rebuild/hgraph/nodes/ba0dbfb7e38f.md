---
author: sync
content_type: definition
created: '2026-08-03T16:37:46'
decl: AlgebraicJacobian.TwoChart.TwistedCoordinates.chart1
file: AlgebraicJacobian/Projective/TwoChartCoordinates.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.TwoChart.TwistedCoordinates.chart1
type: lean
updated: '2026-08-07T05:01:59'
---
def chart1 (d : ℕ) (y : R1) (bb : I → R1) :
    Fin (d + 1) ⊕ I → R1
  | Sum.inl r => y ^ (d - (r : ℕ))
  | Sum.inr i => bb i