---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: AlgebraicJacobian.Diagonal.aeval_sub_dvd
docstring: Difference of evaluations at two points is divisible by the difference
  of the points.
file: AlgebraicJacobian/Algebra/DiagonalIdeal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.Diagonal.aeval_sub_dvd
type: lean
updated: '2026-07-16T21:33:27'
---
lemma aeval_sub_dvd (a b : B ⊗[k] B) (p : Polynomial k) :
    a - b ∣ aeval a p - aeval b p := by
  rw [aeval_def, aeval_def, eval₂_eq_eval_map, eval₂_eq_eval_map]
  exact sub_dvd_eval_sub a b _