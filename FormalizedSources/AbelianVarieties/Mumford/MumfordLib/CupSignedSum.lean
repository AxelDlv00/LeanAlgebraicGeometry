/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Tactic.Ring

/-!
# Signed finite sums in the cup-product differential

The front and back face sums have one extra endpoint each. Their signs are
opposite, yielding the signed Leibniz formula after cancellation.
-/

set_option autoImplicit false

namespace Mumford.Analytic

/-- Splitting an alternating face sum at degree `p`, with cancellation of
the duplicated interface term, gives the signed Leibniz expression. -/
theorem singularCup_signed_sum {p q n : ℕ} (h : p + q = n)
    (a : Fin (p + 2) → ℤ) (b : Fin (q + 2) → ℤ)
    (c : Fin (n + 2) → ℤ) (A B : ℤ)
    (hleft : ∀ (i : Fin (n + 2)) (hi : i.val ≤ p),
      c i = a ⟨i.val, by omega⟩ * B)
    (hright : ∀ (i : Fin (n + 2)) (hi : p < i.val),
      c i = A * b ⟨i.val - p, by omega⟩)
    (ha : a (Fin.last (p + 1)) = A) (hb : b 0 = B) :
    (∑ i : Fin (n + 2), (-1 : ℤ) ^ i.val * c i) =
      (∑ i : Fin (p + 2), (-1 : ℤ) ^ i.val * a i) * B +
        (-1 : ℤ) ^ p * A *
          (∑ i : Fin (q + 2), (-1 : ℤ) ^ i.val * b i) := by
  have hs : (p + 1) + (q + 1) = n + 2 := by omega
  have splitSum :
      (∑ i : Fin (n + 2), (-1 : ℤ) ^ i.val * c i) =
        (∑ i : Fin (p + 1), (-1 : ℤ) ^ i.val * a i.castSucc) * B +
          (-1 : ℤ) ^ (p + 1) * A *
            (∑ i : Fin (q + 1), (-1 : ℤ) ^ i.val * b i.succ) := by
    rw [← Fin.sum_congr' (fun i : Fin (n + 2) => (-1 : ℤ) ^ i.val * c i) hs]
    rw [Fin.sum_univ_add]
    simp only [Finset.sum_mul, Finset.mul_sum]
    congr 1
    · apply Finset.sum_congr rfl
      intro i _
      rw [hleft _ (by simpa using Nat.le_of_lt_succ i.isLt)]
      simp only [Fin.val_cast, Fin.val_castAdd]
      change (-1 : ℤ) ^ i.val * (a i.castSucc * B) =
        ((-1 : ℤ) ^ i.val * a i.castSucc) * B
      ring
    · apply Finset.sum_congr rfl
      intro i _
      rw [hright _ (by simp; omega)]
      simp only [Fin.val_cast, Fin.val_natAdd]
      have hi : p + 1 + i.val - p = i.val + 1 := by omega
      simp only [hi]
      change (-1 : ℤ) ^ (p + 1 + i.val) * (A * b i.succ) =
        (-1 : ℤ) ^ (p + 1) * A * ((-1 : ℤ) ^ i.val * b i.succ)
      rw [pow_add]
      ring
  rw [splitSum,
    Fin.sum_univ_castSucc (fun i : Fin (p + 2) => (-1 : ℤ) ^ i.val * a i),
    Fin.sum_univ_succ (fun i : Fin (q + 2) => (-1 : ℤ) ^ i.val * b i)]
  simp only [Fin.val_castSucc, Fin.val_last, Fin.val_zero, Fin.val_succ,
    pow_zero, one_mul, ha, hb, pow_succ, mul_neg_one, neg_mul,
    Finset.sum_neg_distrib]
  ring

end Mumford.Analytic
