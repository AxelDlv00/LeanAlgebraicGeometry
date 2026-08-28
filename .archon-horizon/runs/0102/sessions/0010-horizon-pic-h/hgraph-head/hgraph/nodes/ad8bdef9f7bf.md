---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.whiskerLeft_lmul'_inl
docstring: 'The curve-product diagonal retracts the first coprojection: `Δ ≫ u₁ =
  𝟙`.'
file: AlgebraicJacobian/Picard/ComparisonDiagonal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.whiskerLeft_lmul'_inl
type: lean
updated: '2026-08-01T09:44:11'
---
lemma whiskerLeft_lmul'_inl : Δx ≫ (u₁) = 𝟙 (XB) := by
  rw [← Over.comp_left, ← MonoidalCategory.whiskerLeft_comp, ← Over.overSpecMap_comp,
    tensorLmul'_comp_tensorInl, Over.overSpecMap_id, MonoidalCategory.whiskerLeft_id]
  rfl