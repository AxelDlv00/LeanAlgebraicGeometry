---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: CategoryTheory.PresheafOfGroups.OneCochain.mul_evInf
file: AlgebraicJacobian/Picard/UnitsCocycle.lean
generated: lean
lean_status: lean_ok
stale: true
title: CategoryTheory.PresheafOfGroups.OneCochain.mul_evInf
type: lean
updated: '2026-07-29T15:26:35'
---
lemma OneCochain.mul_evInf (γ₁ γ₂ : OneCochain G U) (i j : I) :
    (γ₁ * γ₂).evInf i j = γ₁.evInf i j * γ₂.evInf i j :=
  rfl

@[simp]