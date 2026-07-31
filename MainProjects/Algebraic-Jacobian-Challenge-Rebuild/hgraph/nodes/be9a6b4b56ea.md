---
author: sync
content_type: definition
created: '2026-07-20T16:31:23'
decl: AlgebraicGeometry.ThetaGeneratorSeed.chartIdealColengthModule
docstring: 'The image of the genuine chart-reading ideal in the colength ring

  `B ⧸ Ideal.span {read s}`.  Equivalently, this is `(chartReadIdeal K b + (read s))
  / (read s)`,

  viewed as a `B`-submodule of the quotient.'
file: AlgebraicJacobian/Picard/DivSchemeRedesignChartReadIdeal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ThetaGeneratorSeed.chartIdealColengthModule
type: lean
updated: '2026-07-31T20:15:22'
---
noncomputable def chartIdealColengthModule
    (K : Submodule R (relThetaSections C R π a)) (b : Bool)
    (s : relThetaSections C R π a) :
    Submodule Γ(relCurve C R, relPinnedChart C R π b)
      (Γ(relCurve C R, relPinnedChart C R π b) ⧸
        Ideal.span {relThetaResSide a b (le_rfl) s}) :=
  Submodule.map
    (Ideal.Quotient.mkₐ Γ(relCurve C R, relPinnedChart C R π b)
      (Ideal.span {relThetaResSide a b (le_rfl) s})).toLinearMap
    (chartReadIdeal K b)