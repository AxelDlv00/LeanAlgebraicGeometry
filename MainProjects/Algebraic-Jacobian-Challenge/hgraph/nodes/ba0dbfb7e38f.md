---
author: sync
content_type: definition
created: '2026-07-30T19:29:41'
decl: AlgebraicJacobian.TwoChart.TwistedCoordinates.chart1
docstring: 'The same degree-d base monomials in reverse order, followed by the

  aligned generators on the y-chart.'
file: AlgebraicJacobian/Picard/TwistedProjectiveCoordinates.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.TwoChart.TwistedCoordinates.chart1
type: lean
updated: '2026-07-30T20:03:05'
---
def chart1 (d : ℕ) (y : R1) (bb : I → R1) :
    Fin (d + 1) ⊕ I → R1
  | Sum.inl r => y ^ (d - (r : ℕ))
  | Sum.inr i => bb i

@[simp]