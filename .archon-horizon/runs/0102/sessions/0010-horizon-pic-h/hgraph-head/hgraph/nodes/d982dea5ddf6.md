---
author: sync
content_type: definition
created: '2026-07-29T07:53:26'
decl: AlgebraicGeometry.Scheme.chartSection
docstring: '**The two-chart representative of a chart-trivial class.** `(iii-c2-Zar)`

  (`twoChartClassHom_surjOn_of_chartTrivial`) produces an overlap unit from chart-triviality
  alone;

  this names its class.


  Named rather than left as an inline `Exists.choose` because the round-trip proofs
  of

  `twoChartKernelEquiv` need a *rewritable* defining equation — see the module docstring
  for the exact

  failure the inline version gives.'
file: AlgebraicJacobian/Tangent/TwoChartKernelComparison.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.chartSection
type: lean
updated: '2026-08-01T09:44:18'
---
noncomputable def chartSection (L : Y.CechPic)
    (h : ∀ s : Bool, CechPic.map (V s).ι L = 1) : overlapQuot Y V :=
  QuotientGroup.mk (twoChartClassHom_surjOn_of_chartTrivial (V := V) sel hmem L h).choose