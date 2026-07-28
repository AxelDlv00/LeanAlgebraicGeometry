---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Adelic.p1Eval_X0
file: AlgebraicJacobian/RiemannRoch/Adelic/NonconstantToP1.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.Adelic.p1Eval_X0
type: lean
updated: '2026-07-28T13:22:17'
---
private lemma p1Eval_X0 (b₀ b₁ : B) : p1Eval b₀ b₁ (X ⟨0⟩) = b₀ := by
  simp [p1Eval]

@[simp]