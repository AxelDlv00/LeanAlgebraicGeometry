---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.mul_unitsEvInf
file: AlgebraicJacobian/Picard/UnitsCocycle.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.mul_unitsEvInf
type: lean
updated: '2026-08-01T09:44:17'
---
lemma mul_unitsEvInf {𝒰 : X.PointedCover} (γ₁ γ₂ : X.unitsCocycle 𝒰) (i j : X) :
    unitsEvInf (γ₁ * γ₂) i j = unitsEvInf γ₁ i j * unitsEvInf γ₂ i j :=
  rfl