---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.triple_elt_eq
docstring: The tensor-element identity finishing `ΓSpecIso_hom_tripleSection` (pure
  algebra).
file: AlgebraicJacobian/Picard/WitnessAway.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.Over.triple_elt_eq
type: lean
updated: '2026-07-31T20:15:28'
---
private lemma triple_elt_eq (x y z : B) :
    (x ⊗ₜ[A] ((1 : B) ⊗ₜ[A] (1 : B)))
        * (((1 : B) ⊗ₜ[A] (y ⊗ₜ[A] (1 : B))) * ((1 : B) ⊗ₜ[A] ((1 : B) ⊗ₜ[A] z)))
      = (x ⊗ₜ[A] (1 : B ⊗[A] B))
        * ((1 : B) ⊗ₜ[A] ((y ⊗ₜ[A] (1 : B)) * ((1 : B) ⊗ₜ[A] z))) := by
  simp only [Algebra.TensorProduct.tmul_mul_tmul, Algebra.TensorProduct.one_def,
    one_mul, mul_one]