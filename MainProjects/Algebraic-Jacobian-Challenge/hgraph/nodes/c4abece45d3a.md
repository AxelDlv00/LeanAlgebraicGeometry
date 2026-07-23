---
author: sync
content_type: theorem
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Adelic.mem_orderGe_of_ne_zero
file: AlgebraicJacobian/RiemannRoch/Adelic/ChiLedger.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.mem_orderGe_of_ne_zero
type: lean
updated: '2026-07-24T03:02:13'
---
theorem mem_orderGe_of_ne_zero {P : X.PrimeDivisor} {m : ℤ} {f : X.functionField}
    (hf : f ≠ 0) : f ∈ orderGe P m ↔ m ≤ Scheme.RationalMap.order P f := by
  rw [mem_orderGe, or_iff_right hf]