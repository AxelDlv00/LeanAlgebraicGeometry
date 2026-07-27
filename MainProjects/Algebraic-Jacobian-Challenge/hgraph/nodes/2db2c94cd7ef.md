---
author: sync
content_type: theorem
created: '2026-07-27T15:50:35'
decl: AlgebraicGeometry.Adelic.degK_nonneg_of_nonneg
docstring: '**An effective divisor has nonnegative weighted degree.**  Each summand

  `D(P)·[κ(P):k]` is a product of nonnegative integers.'
file: AlgebraicJacobian/RiemannRoch/Adelic/SectionBounds.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.degK_nonneg_of_nonneg
type: lean
updated: '2026-07-27T15:50:35'
---
theorem degK_nonneg_of_nonneg {D : X.WeilDivisor}
    (hD : ∀ P : X.PrimeDivisor, 0 ≤ (show X.PrimeDivisor →₀ ℤ from D) P) :
    0 ≤ degK k D := by
  rw [degK_eq_sum, Finsupp.sum]
  exact Finset.sum_nonneg fun P _ =>
    mul_nonneg (hD P) (Int.natCast_nonneg _)