---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.overSpecMap_left_lmul'_inr
docstring: 'The `Spec`-side diagonal retracts the second coprojection: `∇ ≫ q₂ = 𝟙`.'
file: AlgebraicJacobian/Picard/ComparisonDiagonal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.overSpecMap_left_lmul'_inr
type: lean
updated: '2026-07-29T15:31:38'
---
lemma overSpecMap_left_lmul'_inr : Δs ≫ (q₂) = 𝟙 (SB) := by
  rw [← Over.comp_left, ← Over.overSpecMap_comp, tensorLmul'_comp_tensorInr,
    Over.overSpecMap_id]
  rfl