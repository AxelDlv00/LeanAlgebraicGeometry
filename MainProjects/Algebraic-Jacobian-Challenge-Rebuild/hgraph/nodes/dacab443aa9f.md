---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: Module.actionMap_baseChange
docstring: Naturality of the action map in `B`-linear maps.
file: AlgebraicJacobian/Descent/ModuleDescent.lean
generated: lean
lean_status: lean_ok
title: Module.actionMap_baseChange
type: lean
updated: '2026-07-30T15:46:01'
---
theorem actionMap_baseChange [Module B X] [IsScalarTower A B X]
    [AddCommGroup Y] [Module A Y] [Module B Y] [IsScalarTower A B Y]
    (g : X →ₗ[B] Y) (x : B ⊗[A] X) :
    actionMap A B Y ((g.restrictScalars A).baseChange B x) = g (actionMap A B X x) := by
  induction x with
  | zero => simp
  | tmul b m => simp
  | add x y hx hy => simp [hx, hy]