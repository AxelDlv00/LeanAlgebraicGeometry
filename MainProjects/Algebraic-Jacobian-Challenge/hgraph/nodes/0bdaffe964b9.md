---
author: sync
content_type: lemma
created: '2026-07-31T08:04:21'
decl: AlgebraicGeometry.FiberCoordinateData.coeffAt_nsmul
file: AlgebraicJacobian/RiemannRoch/Ledger/FiberCoordinateLattice.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.FiberCoordinateData.coeffAt_nsmul
type: lean
updated: '2026-07-31T08:04:21'
---
private lemma coeffAt_nsmul (n : ℕ) (A : Y.CurveDivisor) {x : Y}
    (hx : x ≠ genericPoint Y) : coeffAt hx (n • A) = (n : ℤ) * coeffAt hx A := by
  induction n with
  | zero => rw [zero_smul, CurveDivisor.coeffAt_zero, Nat.cast_zero, zero_mul]
  | succ m ih => rw [succ_nsmul, CurveDivisor.coeffAt_add, ih, Nat.cast_succ]; ring