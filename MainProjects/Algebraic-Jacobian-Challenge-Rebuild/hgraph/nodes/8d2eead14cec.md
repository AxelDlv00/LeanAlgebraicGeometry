---
author: sync
content_type: lemma
created: '2026-07-17T08:41:24'
decl: AlgebraicGeometry.BasicOpenCocycleDatum.pullback_pointedCover_le
docstring: 'The pullback of the canonical pointed cover is subordinated to the pieces
  of the

  base-changed datum (pieces base-change to pieces).'
file: AlgebraicJacobian/Cohomology/GluedSheafClass.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.BasicOpenCocycleDatum.pullback_pointedCover_le
type: lean
updated: '2026-07-29T15:31:34'
---
lemma pullback_pointedCover_le (x : relCurve C B') :
    (D.pointedCover.pullback (relCurveMap C B B')).opens x ≤
      (D.baseChange B').pieces (D.pieceIndex ((relCurveMap C B B').base x)) := by
  rw [Scheme.PointedCover.pullback_opens, pointedCover_opens]
  exact (D.toBasicOpenCoverData.pieces_baseChange B'
    (D.pieceIndex ((relCurveMap C B B').base x))).ge