---
author: sync
content_type: lemma
created: '2026-07-24T17:02:46'
decl: AlgebraicGeometry.BasicOpenCoverData.cover₁
docstring: The chart-1 pieces cover the pinned chart `V₁ᴮ`.
file: AlgebraicJacobian/Cohomology/GluedSheafDatum.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.BasicOpenCoverData.cover₁
type: lean
updated: '2026-07-29T15:31:34'
---
lemma cover₁ : (relCover C B (fiberTwoCover π)).V₁ ≤
    ⨆ j : D.J₁, (relCurve C B).basicOpen (D.h₁ j) :=
  le_iSup_basicOpen_of_sum_eq_one D.a₁ D.h₁ D.partition₁