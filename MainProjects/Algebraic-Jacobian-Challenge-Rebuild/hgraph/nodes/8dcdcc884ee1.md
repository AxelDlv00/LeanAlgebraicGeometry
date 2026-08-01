---
author: sync
content_type: lemma
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.FinCoverData.ovlMap_resHom_right
docstring: The overlap comparison restricted from the right piece.
file: AlgebraicJacobian/Picard/DivisorFamilyPullbackOverlap.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.FinCoverData.ovlMap_resHom_right
type: lean
updated: '2026-08-01T09:44:14'
---
lemma ovlMap_resHom_right (i j : D.index) (s : Γ(relCurve C R, D.pieces j)) :
    D.ovlMap R' i j ((relCurve C R).resHom inf_le_right s) =
      (relCurve C R').resHom inf_le_right (D.piecesMap R' j s) :=
  ((relCurveMap C R R').appLE_resHom inf_le_right
    (D.baseChange_pieces_le_preimage R' j) (D.baseChange_inf_le_preimage R' i j)
    inf_le_right s).symm