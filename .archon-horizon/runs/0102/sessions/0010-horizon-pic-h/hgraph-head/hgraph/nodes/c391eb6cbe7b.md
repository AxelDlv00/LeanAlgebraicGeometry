---
author: sync
content_type: definition
created: '2026-07-20T16:31:23'
decl: AlgebraicGeometry.ThetaGeneratorSeed.chartIdealColengthMap
docstring: 'The scalar-extension presentation of the chart-reading ideal after quotienting
  by the

  chosen section.'
file: AlgebraicJacobian/Picard/DivSchemeRedesignChartReadIdeal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ThetaGeneratorSeed.chartIdealColengthMap
type: lean
updated: '2026-08-01T09:44:12'
---
noncomputable def chartIdealColengthMap
    (K : Submodule R (relThetaSections C R π a)) (b : Bool)
    (s : relThetaSections C R π a) :
    Γ(relCurve C R, relPinnedChart C R π b) ⊗[R] ↥K →ₗ[Γ(relCurve C R,
      relPinnedChart C R π b)]
      (Γ(relCurve C R, relPinnedChart C R π b) ⧸
        Ideal.span {relThetaResSide a b (le_rfl) s}) :=
  LinearMap.liftBaseChange Γ(relCurve C R, relPinnedChart C R π b)
    ((Ideal.Quotient.mkₐ R (Ideal.span {relThetaResSide a b (le_rfl) s})).toLinearMap.comp
      (chartReadMap K b))

set_option maxHeartbeats 2400000 in
set_option synthInstance.maxHeartbeats 800000 in