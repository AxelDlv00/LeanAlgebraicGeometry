---
author: sync
content_type: definition
created: '2026-08-03T18:38:50'
decl: AlgebraicGeometry.BasicOpenCoverData.pinnedGenerator
docstring: The pinned-chart section cutting out a basic-open piece.
file: AlgebraicJacobian/Picard/Pic0AdmissibleAbelEtaleSurjectiveDivisor.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.BasicOpenCoverData.pinnedGenerator
type: lean
updated: '2026-08-03T18:38:50'
---
noncomputable def pinnedGenerator (D : BasicOpenCoverData C B pi) :
    (j : D.index) → Γ(relCurve C B, relPinnedChart C B pi (D.pinnedSide j))
  | Sum.inl j => D.h₀ j
  | Sum.inr j => D.h₁ j