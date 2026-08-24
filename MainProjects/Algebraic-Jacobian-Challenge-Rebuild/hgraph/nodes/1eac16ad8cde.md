---
author: sync
content_type: theorem
created: '2026-08-17T13:21:30'
decl: AlgebraicGeometry.finiteType_pic0FiniteStageTensorPushoutRing
docstring: 'A tensor pushout of two finite-type algebras is finite type over the common
  ground

  ring.'
file: AlgebraicJacobian/Picard/Pic0FiniteStageTripleOverlapRings.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.finiteType_pic0FiniteStageTensorPushoutRing
type: lean
updated: '2026-08-18T20:51:05'
---
theorem finiteType_pic0FiniteStageTensorPushoutRing
    {R A B₁ B₂ : Type u} [CommRing R] [CommRing A]
    [CommRing B₁] [CommRing B₂] [Algebra R A] [Algebra R B₁] [Algebra R B₂]
    [Algebra.FiniteType R B₁] [Algebra.FiniteType R B₂]
    (f₁ : A →ₐ[R] B₁) (f₂ : A →ₐ[R] B₂) :
    Algebra.FiniteType R (Pic0FiniteStageTensorPushoutRing f₁ f₂) := by
  dsimp only [Pic0FiniteStageTensorPushoutRing]
  letI := pic0FiniteStageAlgebraOfMap f₁
  letI := pic0FiniteStageAlgebraOfMap f₂
  letI := pic0FiniteStageTowerOfMap f₁
  letI := pic0FiniteStageTowerOfMap f₂
  exact AlgebraicJacobian.finiteType_tensorProduct_over