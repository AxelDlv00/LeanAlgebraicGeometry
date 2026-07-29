---
author: sync
content_type: lemma
created: '2026-07-18T19:01:11'
decl: AlgebraicGeometry.DivisorAdaptation.theta_chart_inl_inr
docstring: 'The cross-chart theta twisting unit agrees with the whole-chart theta
  unit,

  restrictionwise: both restrict the relative theta cocycle.'
file: AlgebraicJacobian/Picard/DivSchemeFibreH1.lean
generated: lean
lean_status: lean_ok
private: true
stale: true
title: AlgebraicGeometry.DivisorAdaptation.theta_chart_inl_inr
type: lean
updated: '2026-07-29T15:26:35'
---
private lemma theta_chart_inl_inr (a : ℕ) (i : Fin A.m₀) (j : Fin A.m₁)
    {O : (relCurve C R).Opens}
    (hOc : O ≤ (thetaChartCover C R π).pieces (Sum.inl PUnit.unit)
      ⊓ (thetaChartCover C R π).pieces (Sum.inr PUnit.unit))
    (hOp : O ≤ A.pieces (Sum.inl i) ⊓ A.pieces (Sum.inr j)) :
    (relCurve C R).unitsRestrict hOc
        (thetaChartUnit C R π a (Sum.inl PUnit.unit) (Sum.inr PUnit.unit))
      = (relCurve C R).unitsRestrict hOp (A.thetaOvlUnit a (Sum.inl i) (Sum.inr j)) := by
  rw [A.toFinCoverData.thetaOvlUnit_inl_inr,
    show thetaChartUnit C R π a (Sum.inl PUnit.unit) (Sum.inr PUnit.unit)
        = (relCurve C R).unitsRestrict
            (inf_le_inf (thetaChartCover_pieces_le_inl C R π PUnit.unit)
              (thetaChartCover_pieces_le_inr C R π PUnit.unit))
            (relThetaCocycle C R π a) from rfl,
    unitsRestrict_unitsRestrict, unitsRestrict_unitsRestrict]