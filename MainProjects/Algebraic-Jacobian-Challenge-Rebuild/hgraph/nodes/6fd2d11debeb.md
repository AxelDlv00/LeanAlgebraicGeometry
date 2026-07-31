---
author: sync
content_type: lemma
created: '2026-07-17T23:01:28'
decl: AlgebraicGeometry.DivFamZar.congr_apply
file: AlgebraicJacobian/Picard/DivisorFamilyZarVehicle.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.DivFamZar.congr_apply
type: lean
updated: '2026-07-31T20:14:45'
---
lemma congr_apply (e : A ≃ₐ[k] A') (F : DivFamZar C A π n) :
    congr e F = mapAlgHom e.toAlgHom F :=
  rfl

/-- The inverse transport along an isomorphism is `mapAlgHom` of the inverse map. -/
@[simp]