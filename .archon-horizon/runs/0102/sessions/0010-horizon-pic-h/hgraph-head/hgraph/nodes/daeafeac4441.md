---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: CategoryTheory.PresheafOfGroups.OneCochain.mul_evInf
file: AlgebraicJacobian/Picard/UnitsCocycle.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.PresheafOfGroups.OneCochain.mul_evInf
type: lean
updated: '2026-08-01T09:44:17'
---
lemma OneCochain.mul_evInf (γ₁ γ₂ : OneCochain G U) (i j : I) :
    (γ₁ * γ₂).evInf i j = γ₁.evInf i j * γ₂.evInf i j :=
  rfl

@[simp]