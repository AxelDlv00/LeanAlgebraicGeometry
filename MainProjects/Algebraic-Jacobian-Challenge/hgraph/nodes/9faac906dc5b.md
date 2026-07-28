---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.comp4_solve_front
docstring: 'Generic 4-factor rearrangement: solve an iso-chain equation for its front
  pair.

  Project-local.'
file: AlgebraicJacobian/Picard/GlueDescent.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.Scheme.Modules.comp4_solve_front
type: lean
updated: '2026-07-28T13:22:16'
---
private lemma comp4_solve_front {𝒞 : Type*} [Category 𝒞] {a b c d e : 𝒞}
    {A : a ⟶ b} {B : b ⟶ c} (Cc : c ≅ d) (D : d ≅ e) {E : a ⟶ e}
    (hE : A ≫ B ≫ Cc.hom ≫ D.hom = E) :
    A ≫ B = E ≫ D.inv ≫ Cc.inv := by
  rw [← hE]; simp