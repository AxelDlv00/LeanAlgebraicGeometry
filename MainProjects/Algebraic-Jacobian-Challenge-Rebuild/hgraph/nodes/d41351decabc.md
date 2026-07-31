---
author: sync
content_type: theorem
created: '2026-07-22T01:32:17'
decl: AlgebraicGeometry.HighWindowTransitionKit.transitionOfLE_read
file: AlgebraicJacobian/Picard/DivSchemeHighWindowTransitions.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.HighWindowTransitionKit.transitionOfLE_read
type: lean
updated: '2026-07-31T20:15:22'
---
theorem transitionOfLE_read
    (read : ∀ n, G n → B)
    (hread : ∀ n (x : G n), read (n + 1) (step n x) = read n x)
    (i j : Nat) (h : i ≤ j) (x : G i) :
    read j (transitionOfLE G step i j h x) = read i x := by
  induction h with
  | refl =>
      rw [transitionOfLE_self]
  | @step m h ih =>
      rw [transitionOfLE_succ G step i m h, LinearMap.comp_apply, hread]
      exact ih