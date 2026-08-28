---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: TwoLatticePair.tN_val_inv_apply
file: AlgebraicJacobian/Cohomology/RigidEngineLattice.lean
generated: lean
lean_status: lean_ok
title: TwoLatticePair.tN_val_inv_apply
type: lean
updated: '2026-08-01T09:44:10'
---
lemma tN_val_inv_apply (n : N) : P.tN.val (P.tN.inv n) = n := by
  have h := congrArg (fun e : Module.End R N => e n) P.tN.val_inv
  simpa only [Module.End.mul_apply, Module.End.one_apply] using h