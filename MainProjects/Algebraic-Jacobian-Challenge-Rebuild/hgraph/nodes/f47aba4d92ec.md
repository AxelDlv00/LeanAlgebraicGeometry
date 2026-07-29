---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: Module.transitionUnit_mul_transitionUnit
docstring: 'The telescoping identity for transition units: the Čech 1-cocycle relation.'
file: AlgebraicJacobian/Algebra/BaseChangeTrivialization.lean
generated: lean
lean_status: lean_ok
title: Module.transitionUnit_mul_transitionUnit
type: lean
updated: '2026-07-29T15:31:33'
---
lemma transitionUnit_mul_transitionUnit :
    transitionUnit t₂ t₃ * transitionUnit t₁ t₂ = transitionUnit t₁ t₃ :=
  Units.ext (transitionUnit_mul_apply t₂ t₃ (t₁.symm 1))

/-- Precomposition with a common identification does not change the transition unit. -/
@[simp]