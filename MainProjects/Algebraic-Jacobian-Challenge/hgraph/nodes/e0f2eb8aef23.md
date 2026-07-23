---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Adelic.awayLift_congr
docstring: '`awayLift` only depends on the evaluation.'
file: AlgebraicJacobian/RiemannRoch/Adelic/NonconstantToP1.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.awayLift_congr
type: lean
updated: '2026-07-16T21:14:28'
---
private lemma awayLift_congr {f : MvPolynomial (ULift.{u} (Fin 2)) (ULift.{u} ℤ)}
    {ψ₁ ψ₂ : MvPolynomial (ULift.{u} (Fin 2)) (ULift.{u} ℤ) →+* B} (h : ψ₁ = ψ₂)
    (hu : IsUnit (ψ₁ f)) :
    awayLift f ψ₁ hu = awayLift f ψ₂ (h ▸ hu) := by
  subst h; rfl