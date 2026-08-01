---
author: sync
content_type: lemma
created: '2026-07-24T17:02:47'
decl: AlgebraicGeometry.FinCoverData.cover₁
docstring: The chart-1 pieces cover the pinned chart `V₁ᴿ`.
file: AlgebraicJacobian/Picard/DivisorFamily.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.FinCoverData.cover₁
type: lean
updated: '2026-08-01T09:44:12'
---
lemma cover₁ : (relCover C R (fiberTwoCover π)).V₁ ≤
    ⨆ j : Fin D.m₁, (relCurve C R).basicOpen (D.h₁ j) :=
  le_iSup_basicOpen_of_sum_eq_one D.a₁ D.h₁ D.partition₁