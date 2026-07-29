---
author: sync
content_type: lemma
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.ThetaGeneratorSeed.piece_le
file: AlgebraicJacobian/Picard/DivSchemeFamily.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ThetaGeneratorSeed.piece_le
type: lean
updated: '2026-07-29T15:31:39'
---
lemma piece_le (z : relCurve C R) : D.piece z ≤ relPinnedChart C R π (D.side z) :=
  (relCurve C R).basicOpen_le (D.h z)