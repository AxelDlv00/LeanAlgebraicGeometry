---
author: sync
content_type: lemma
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.FinCoverData.pieces_inr_le
docstring: The chart-1 pieces sit inside the pinned chart `V₁ᴿ`.
file: AlgebraicJacobian/Picard/DivisorFamilyTheta.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.FinCoverData.pieces_inr_le
type: lean
updated: '2026-07-30T15:28:05'
---
lemma pieces_inr_le (j : Fin D.m₁) :
    D.pieces (Sum.inr j) ≤ (relCover C R (fiberTwoCover π)).V₁ := by
  rw [pieces_inr]
  exact (relCurve C R).basicOpen_le (D.h₁ j)