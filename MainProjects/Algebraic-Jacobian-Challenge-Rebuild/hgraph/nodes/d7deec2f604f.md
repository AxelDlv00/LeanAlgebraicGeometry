---
author: sync
content_type: theorem
created: '2026-08-11T11:10:29'
decl: AlgebraicGeometry.BasicOpenCocycleDatum.resHom_piecesMap_eq_relAffSectionsMap
docstring: 'Restricting the datum-piece comparison to the actual preimage piece gives
  the

  arbitrary-affine section comparison.  This is the pointwise equation bridge between
  the

  base-changed glued section and `LocalEquations.pullbackEqn`.'
file: AlgebraicJacobian/Picard/Pic0RankOneFibrePresentedProducerSectionDivEq.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.BasicOpenCocycleDatum.resHom_piecesMap_eq_relAffSectionsMap
type: lean
updated: '2026-08-18T20:51:05'
---
theorem resHom_piecesMap_eq_relAffSectionsMap
    [IsAffineHom pi]
    (D : BasicOpenCocycleDatum C B pi)
    (B' : Type u) [CommRing B'] [Algebra k B'] [Algebra B B']
    [IsScalarTower k B B'] (j : D.index)
    (t : Γ(relCurve C B, D.pieces j)) :
    (relCurve C B').resHom
        (D.toBasicOpenCoverData.pieces_baseChange B' j).ge
        (D.toBasicOpenCoverData.piecesMap B' j t) =
      relAffSectionsMap C B' (D.pieces j) t := by
  cases j with
  | inl j =>
      simpa only [BasicOpenCoverData.piecesMap, pieceSectionsMap,
        BasicOpenCoverData.pieces, BasicOpenCoverData.baseChange, Sum.elim_inl,
        relAffSectionsMap, Scheme.resHom_refl] using
        ((relCurveMap C B B').appLE_resHom
          (le_rfl : D.pieces (Sum.inl j) ≤ D.pieces (Sum.inl j))
          (D.toBasicOpenCoverData.baseChange_pieces_le_preimage B' (Sum.inl j))
          (le_rfl : relCurveMap C B B' ⁻¹ᵁ D.pieces (Sum.inl j) ≤
            relCurveMap C B B' ⁻¹ᵁ D.pieces (Sum.inl j))
          (D.toBasicOpenCoverData.pieces_baseChange B' (Sum.inl j)).ge t)
  | inr j =>
      simpa only [BasicOpenCoverData.piecesMap, pieceSectionsMap,
        BasicOpenCoverData.pieces, BasicOpenCoverData.baseChange, Sum.elim_inr,
        relAffSectionsMap, Scheme.resHom_refl] using
        ((relCurveMap C B B').appLE_resHom
          (le_rfl : D.pieces (Sum.inr j) ≤ D.pieces (Sum.inr j))
          (D.toBasicOpenCoverData.baseChange_pieces_le_preimage B' (Sum.inr j))
          (le_rfl : relCurveMap C B B' ⁻¹ᵁ D.pieces (Sum.inr j) ≤
            relCurveMap C B B' ⁻¹ᵁ D.pieces (Sum.inr j))
          (D.toBasicOpenCoverData.pieces_baseChange B' (Sum.inr j)).ge t)