---
author: sync
content_type: lemma
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.FinCoverData.pieces_inl_le
docstring: The chart-0 pieces sit inside the pinned chart `V₀ᴿ`.
file: AlgebraicJacobian/Picard/DivisorFamilyTheta.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.FinCoverData.pieces_inl_le
type: lean
updated: '2026-07-31T20:14:43'
---
lemma pieces_inl_le (j : Fin D.m₀) :
    D.pieces (Sum.inl j) ≤ (relCover C R (fiberTwoCover π)).V₀ := by
  rw [pieces_inl]
  exact (relCurve C R).basicOpen_le (D.h₀ j)