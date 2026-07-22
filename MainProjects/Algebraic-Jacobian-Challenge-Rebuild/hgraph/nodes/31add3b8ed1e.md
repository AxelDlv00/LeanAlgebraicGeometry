---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.whiskerLeft_inl_comp_ofId
docstring: '`Spec` level, whiskered: `u₁ ≫ cg = cg₂`.'
file: AlgebraicJacobian/Picard/SectionsDescent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.whiskerLeft_inl_comp_ofId
type: lean
updated: '2026-07-16T21:33:28'
---
lemma whiskerLeft_inl_comp_ofId :
    (u₁) ≫ (cg) = (cg₂) := by
  rw [← Over.comp_left, ← MonoidalCategory.whiskerLeft_comp, ← Over.overSpecMap_comp,
    tensorInl_comp_ofId_eq_ofId]