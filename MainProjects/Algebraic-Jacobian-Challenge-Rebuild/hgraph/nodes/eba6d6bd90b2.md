---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: TwoLatticePair.Hom.comm_tN_pow
file: AlgebraicJacobian/Cohomology/RigidEngineLattice.lean
generated: lean
lean_status: lean_ok
title: TwoLatticePair.Hom.comm_tN_pow
type: lean
updated: '2026-07-16T21:33:27'
---
lemma comm_tN_pow (f : P.Hom P') (m : ℕ) (n : N) :
    f.homN ((P.tN.val ^ m) n) = (P'.tN.val ^ m) (f.homN n) := by
  induction m with
  | zero => simp
  | succ m ih =>
    rw [pow_succ', pow_succ']
    simp only [Module.End.mul_apply]
    rw [f.comm_tN, ih]