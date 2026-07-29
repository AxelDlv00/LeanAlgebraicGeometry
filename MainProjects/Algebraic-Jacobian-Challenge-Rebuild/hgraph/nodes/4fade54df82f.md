---
author: sync
content_type: lemma
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.FinCoverData.isAffineOpen_pieces
docstring: The pieces are affine opens (basic opens of the affine pinned charts).
file: AlgebraicJacobian/Picard/DivisorFamilyPullbackMap.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.FinCoverData.isAffineOpen_pieces
type: lean
updated: '2026-07-29T15:31:45'
---
lemma isAffineOpen_pieces (j : D.index) : IsAffineOpen (D.pieces j) := by
  cases j
  · exact (relCover_isAffineOpen₀ C R (fiberTwoCover π)).basicOpen _
  · exact (relCover_isAffineOpen₁ C R (fiberTwoCover π)).basicOpen _