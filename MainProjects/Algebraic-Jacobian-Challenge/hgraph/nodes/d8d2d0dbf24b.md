---
author: sync
content_type: theorem
created: '2026-07-28T15:48:28'
decl: AlgebraicGeometry.Scheme.WeilDivisor.degree_eq_zero_of_sum_nonGeneric_eq_zero
docstring: 'The transported form of the degree-zero conclusion: a divisor whose relabelled

  coefficient sum vanishes has degree zero. The shape in which the sibling''s `deg_divOf`
  will be

  consumed once its χ-machinery is ported.'
file: AlgebraicJacobian/RiemannRoch/CurveDivisorIndexBridge.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.WeilDivisor.degree_eq_zero_of_sum_nonGeneric_eq_zero
type: lean
updated: '2026-07-28T15:48:28'
---
theorem degree_eq_zero_of_sum_nonGeneric_eq_zero (hdim : ∀ z : X, Order.coheight z ≤ 1)
    {D : X.WeilDivisor}
    (h : (addEquivNonGeneric hdim D).sum (fun _ n => n) = 0) :
    degree D = 0 :=
  (degree_eq_sum_nonGeneric hdim D).trans h