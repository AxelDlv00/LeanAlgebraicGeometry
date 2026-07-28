---
author: sync
content_type: lemma
created: '2026-07-24T17:02:57'
decl: AlgebraicGeometry.Adelic.chartHom₀_mk
file: AlgebraicJacobian/RiemannRoch/Adelic/NonconstantToP1.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.Adelic.chartHom₀_mk
type: lean
updated: '2026-07-28T13:22:17'
---
private lemma chartHom₀_mk (b : B) {i : ℕ}
    (hf : (X ⟨0⟩ : MvPolynomial (ULift.{u} (Fin 2)) (ULift.{u} ℤ))
      ∈ homogeneousSubmodule (ULift.{u} (Fin 2)) (ULift.{u} ℤ) i) (n : ℕ)
    (a : MvPolynomial (ULift.{u} (Fin 2)) (ULift.{u} ℤ))
    (ha : a ∈ homogeneousSubmodule (ULift.{u} (Fin 2)) (ULift.{u} ℤ) (n • i)) :
    chartHom₀ b (Away.mk (homogeneousSubmodule (ULift.{u} (Fin 2)) (ULift.{u} ℤ)) hf n a ha)
      = p1Eval 1 b a := by
  have h : chartHom₀ b
        (Away.mk (homogeneousSubmodule (ULift.{u} (Fin 2)) (ULift.{u} ℤ)) hf n a ha)
      * p1Eval 1 b (X ⟨0⟩) ^ n = p1Eval 1 b a :=
    awayLift_mul_eq hf (p1Eval 1 b) (by rw [p1Eval_X0]; exact isUnit_one) n a ha
  simpa using h