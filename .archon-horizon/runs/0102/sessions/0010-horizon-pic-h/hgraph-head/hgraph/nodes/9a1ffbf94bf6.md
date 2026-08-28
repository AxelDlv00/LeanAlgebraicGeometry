---
author: sync
content_type: theorem
created: '2026-07-22T01:32:17'
decl: AlgebraicGeometry.HighWindowTransitionKit.iterateSuccessor_mem
file: AlgebraicJacobian/Picard/DivSchemeHighWindowTransitions.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.HighWindowTransitionKit.iterateSuccessor_mem
type: lean
updated: '2026-07-22T02:02:04'
---
theorem iterateSuccessor_mem
    (K : (n : Nat) → Submodule R (G n))
    (hK : ∀ n (x : G n), x ∈ K n → step n x ∈ K (n + 1))
    (n d : Nat) (x : G n) (hx : x ∈ K n) :
    iterateSuccessor G step n d x ∈ K (n + d) := by
  induction d with
  | zero => exact hx
  | succ d ih =>
      rw [iterateSuccessor_succ, LinearMap.comp_apply]
      exact hK (n + d) _ ih