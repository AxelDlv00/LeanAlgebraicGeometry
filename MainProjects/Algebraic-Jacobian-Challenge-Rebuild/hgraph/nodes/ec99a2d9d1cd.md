---
author: sync
content_type: lemma
created: '2026-07-29T09:42:53'
decl: AlgebraicGeometry.AffAdaptation.pieces_inf_le_relPinnedChart_inf
docstring: An overlap of two widened pieces sits below both assigned pinned charts.
file: AlgebraicJacobian/Picard/DivisorFamilyAffTheta.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.pieces_inf_le_relPinnedChart_inf
type: lean
updated: '2026-07-29T15:31:44'
---
lemma pieces_inf_le_relPinnedChart_inf (i j : D.index) :
    D.pieces i ⊓ D.pieces j
      ≤ relPinnedChart C R π (τ.side i) ⊓ relPinnedChart C R π (τ.side j) :=
  inf_le_inf (piece_le_relPinnedChart τ i) (piece_le_relPinnedChart τ j)