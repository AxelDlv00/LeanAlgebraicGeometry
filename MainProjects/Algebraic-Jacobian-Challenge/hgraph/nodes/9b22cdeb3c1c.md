---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Adelic.p1Eval_monomial
docstring: Two-variable monomial evaluation.
file: AlgebraicJacobian/RiemannRoch/Adelic/NonconstantToP1.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.Adelic.p1Eval_monomial
type: lean
updated: '2026-07-28T13:22:17'
---
private lemma p1Eval_monomial (b₀ b₁ : B) (d : ULift.{u} (Fin 2) →₀ ℕ) (c : ULift.{u} ℤ) :
    p1Eval b₀ b₁ (monomial d c) = (c.down : B) * (b₀ ^ d ⟨0⟩ * b₁ ^ d ⟨1⟩) := by
  simp only [p1Eval, coe_eval₂Hom]
  rw [MvPolynomial.eval₂_monomial, Finsupp.prod_fintype _ _ (fun i => pow_zero _)]
  congr 1
  rw [← Equiv.prod_comp (Equiv.ulift.symm : Fin 2 ≃ ULift.{u} (Fin 2))
    (fun i => (![b₀, b₁] i.down) ^ d i), Fin.prod_univ_two]
  rfl