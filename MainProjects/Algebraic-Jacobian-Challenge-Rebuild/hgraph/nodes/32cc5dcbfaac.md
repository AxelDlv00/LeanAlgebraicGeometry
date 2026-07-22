---
author: sync
content_type: lemma
created: '2026-07-18T19:01:11'
decl: AlgebraicGeometry.baseChange_thetaChartDatum_pieces
docstring: 'The pieces of the base-changed whole-chart theta datum are the whole pinned
  charts

  of `C_R`.'
file: AlgebraicJacobian/Picard/ThetaChartClassNaturality.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.baseChange_thetaChartDatum_pieces
type: lean
updated: '2026-07-18T19:31:12'
---
lemma baseChange_thetaChartDatum_pieces (j : ((thetaChartDatum C k π a).baseChange R).index) :
    ((thetaChartDatum C k π a).baseChange R).pieces j
      = (thetaChartCover C R π).pieces j := by
  rcases j with j | j
  · exact ((thetaChartDatum C k π a).toBasicOpenCoverData.pieces_baseChange R
        (Sum.inl j)).trans
      ((congrArg (relCurveMap C k R ⁻¹ᵁ ·) (thetaChartCover_pieces_inl C k π j)).trans
        ((relCurveMap_preimage_V₀ C R π).trans
          (thetaChartCover_pieces_inl C R π j).symm))
  · exact ((thetaChartDatum C k π a).toBasicOpenCoverData.pieces_baseChange R
        (Sum.inr j)).trans
      ((congrArg (relCurveMap C k R ⁻¹ᵁ ·) (thetaChartCover_pieces_inr C k π j)).trans
        ((relCurveMap_preimage_V₁ C R π).trans
          (thetaChartCover_pieces_inr C R π j).symm))