---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.Over.diagonal_left_fst_left
docstring: 'Scheme-level retraction: `(δ C).left ≫ (fst C C).left = 𝟙`.'
file: AlgebraicJacobian/Curve/DiagonalClosed.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.diagonal_left_fst_left
type: lean
updated: '2026-08-01T09:44:10'
---
lemma diagonal_left_fst_left : (diagonal C).left ≫ (fst C C).left = 𝟙 C.left := by
  rw [← Over.comp_left, diagonal_fst, Over.id_left]