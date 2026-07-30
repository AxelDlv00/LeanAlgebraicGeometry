---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: Module.actionMap_baseChange_mk
docstring: The action map of `B ⊗[A] X` retracts the base change of `x ↦ 1 ⊗ₜ x`.
file: AlgebraicJacobian/Descent/ModuleDescent.lean
generated: lean
lean_status: lean_ok
stale: true
title: Module.actionMap_baseChange_mk
type: lean
updated: '2026-07-30T15:28:03'
---
theorem actionMap_baseChange_mk (x : B ⊗[A] X) :
    actionMap A B (B ⊗[A] X) ((TensorProduct.mk A B X 1).baseChange B x) = x := by
  induction x with
  | zero => simp
  | tmul b m => simp [TensorProduct.smul_tmul']
  | add x y hx hy => simp [hx, hy]

end actionMap

variable (A B M) in