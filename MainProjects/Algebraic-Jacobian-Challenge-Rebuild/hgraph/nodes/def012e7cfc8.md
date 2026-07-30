---
author: sync
content_type: lemma
created: '2026-07-17T10:31:28'
decl: AlgebraicGeometry.FinCoverData.baseChange_pieces_le_preimage
docstring: 'The base-changed pieces are below the preimages of the pieces (the `≤`-form
  of

  `pieces_baseChange` consumed by `appLE`).'
file: AlgebraicJacobian/Picard/DivisorFamilyPullback.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.FinCoverData.baseChange_pieces_le_preimage
type: lean
updated: '2026-07-30T15:46:04'
---
lemma baseChange_pieces_le_preimage (j : D.index) :
    (D.baseChange R').pieces j ≤ relCurveMap C R R' ⁻¹ᵁ D.pieces j :=
  (D.pieces_baseChange R' j).le