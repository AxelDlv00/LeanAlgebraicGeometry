---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.whiskerLeft_lmul'_inr
docstring: 'The curve-product diagonal retracts the second coprojection: `Δ ≫ u₂ =
  𝟙`.'
file: AlgebraicJacobian/Picard/ComparisonDiagonal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.whiskerLeft_lmul'_inr
type: lean
updated: '2026-07-29T15:31:38'
---
lemma whiskerLeft_lmul'_inr : Δx ≫ (u₂) = 𝟙 (XB) := by
  rw [← Over.comp_left, ← MonoidalCategory.whiskerLeft_comp, ← Over.overSpecMap_comp,
    tensorLmul'_comp_tensorInr, Over.overSpecMap_id, MonoidalCategory.whiskerLeft_id]
  rfl