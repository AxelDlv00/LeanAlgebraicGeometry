---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.finsupp_induction_bump
docstring: 'Single-bump induction for finitely supported `ℤ`-valued functions: a predicate
  that

  holds at `0` and is invariant under adding a single generator holds everywhere.'
file: AlgebraicJacobian/RiemannRoch/ChiFiniteness.lean
generated: lean
lean_status: lean_ok
private: true
stale: true
title: AlgebraicGeometry.finsupp_induction_bump
type: lean
updated: '2026-07-29T15:26:39'
---
private theorem finsupp_induction_bump {α : Type u} {P : (α →₀ ℤ) → Prop} (zero : P 0)
    (bump : ∀ (a : α) (f : α →₀ ℤ), P (f + Finsupp.single a 1) ↔ P f) (f : α →₀ ℤ) :
    P f := by
  have hn : ∀ (n : ℤ), ∀ (a : α) (f : α →₀ ℤ), P (f + Finsupp.single a n) ↔ P f := by
    intro n
    induction n using Int.induction_on with
    | zero => intro a f; rw [Finsupp.single_zero, add_zero]
    | succ n ih =>
      intro a f
      have h1 : f + Finsupp.single a ((n : ℤ) + 1) =
          f + Finsupp.single a (n : ℤ) + Finsupp.single a 1 := by
        rw [Finsupp.single_add, add_assoc]
      rw [h1, bump a (f + Finsupp.single a (n : ℤ)), ih a f]
    | pred n ih =>
      intro a f
      have h1 : f + Finsupp.single a (-(n : ℤ) - 1) + Finsupp.single a 1 =
          f + Finsupp.single a (-(n : ℤ)) := by
        rw [add_assoc, ← Finsupp.single_add]
        norm_num
      rw [← ih a f, ← bump a (f + Finsupp.single a (-(n : ℤ) - 1)), h1]
  induction f using Finsupp.induction with
  | zero => exact zero
  | single_add a b f _ _ ih =>
    rw [show Finsupp.single a b + f = f + Finsupp.single a b from add_comm _ _]
    exact (hn b a f).mpr ih