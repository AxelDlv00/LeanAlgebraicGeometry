---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: Algebra.TensorProduct.piRightAlgEquiv
docstring: 'Tensoring distributes over finite products of algebras, on the right:
  the `A`-algebra

  equivalence `N ⊗[A] (∀ i, S i) ≃ₐ[A] ∀ i, N ⊗[A] S i`.  This is

  `TensorProduct.piRight` upgraded to algebras.'
file: AlgebraicJacobian/Algebra/PiLocalization.lean
generated: lean
lean_status: lean_ok
stale: true
title: Algebra.TensorProduct.piRightAlgEquiv
type: lean
updated: '2026-07-29T15:26:32'
---
noncomputable def piRightAlgEquiv : (N ⊗[A] ∀ i, S i) ≃ₐ[A] ∀ i, N ⊗[A] S i :=
  -- `map_mul` is checked by two rounds of `TensorProduct.induction_on` (both sides are
  -- bilinear); on pure tensors it is componentwise `tmul_mul_tmul`.
  AlgEquiv.ofLinearEquiv (_root_.TensorProduct.piRight A A N S)
    (by
      funext i
      simp [Algebra.TensorProduct.one_def])
    (fun x y => by
      induction x using TensorProduct.induction_on with
      | zero => simp
      | add x₁ x₂ h₁ h₂ => simp only [add_mul, map_add, h₁, h₂]
      | tmul a s =>
        induction y using TensorProduct.induction_on with
        | zero => simp
        | add y₁ y₂ h₁ h₂ => simp only [mul_add, map_add, h₁, h₂]
        | tmul b t =>
          funext i
          simp [Algebra.TensorProduct.tmul_mul_tmul])

@[simp]