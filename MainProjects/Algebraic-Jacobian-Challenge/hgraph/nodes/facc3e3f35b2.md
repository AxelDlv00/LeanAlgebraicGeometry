---
author: sync
content_type: theorem
created: '2026-07-28T18:12:20'
decl: AlgebraicGeometry.Scheme.CurveDivisor.deg_single
docstring: 'The degree of a single-point divisor `n · x` is `n · [κ(x) : K]`.'
file: AlgebraicJacobian/RiemannRoch/Ledger/Divisor.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.CurveDivisor.deg_single
type: lean
updated: '2026-07-28T18:12:20'
---
theorem deg_single (x : {x : X // x ≠ genericPoint X}) (n : ℤ) :
    deg K (Finsupp.single x n : X.CurveDivisor) = n * (X.residueDeg K x.1 : ℤ) := by
  simp only [deg]
  refine Finsupp.sum_single_index ?_
  simp