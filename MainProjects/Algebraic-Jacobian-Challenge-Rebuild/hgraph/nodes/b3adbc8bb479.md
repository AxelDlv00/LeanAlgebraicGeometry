---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: AlgebraicJacobian.RigidEngine.pow_apply_of_smul
docstring: (Implementation) Powers of an endomorphism acting as `a₀ • ·` act as `a₀
  ^ n • ·`.
file: AlgebraicJacobian/Cohomology/GluedAlgebra.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.RigidEngine.pow_apply_of_smul
type: lean
updated: '2026-07-16T21:33:27'
---
private lemma pow_apply_of_smul (a₀ : A) (e : Module.End R M)
    (he : ∀ m : M, e m = a₀ • m) (n : ℕ) (m : M) : (e ^ n) m = a₀ ^ n • m := by
  induction n generalizing m with
  | zero => rw [pow_zero, Module.End.one_apply, pow_zero, one_smul]
  | succ n ih => rw [pow_succ', Module.End.mul_apply, ih, he, pow_succ', mul_smul]