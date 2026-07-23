---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: DualNumber.mapRingHom_inl
docstring: '`mapRingHom` intertwines the constant inclusions: `mapRingHom ρ (inl a)
  =

  inl (ρ a)`.'
file: AlgebraicJacobian/Picard/Pic0DualNumberCocycle.lean
generated: lean
lean_status: lean_ok
title: DualNumber.mapRingHom_inl
type: lean
updated: '2026-07-16T21:14:27'
---
theorem mapRingHom_inl {A : Type u} {B : Type v} [CommRing A] [CommRing B]
    (ρ : A →+* B) (a : A) :
    mapRingHom ρ (inl a : A[ε]) = (inl (ρ a) : B[ε]) :=
  TrivSqZeroExt.ext (by simp) (by simp)