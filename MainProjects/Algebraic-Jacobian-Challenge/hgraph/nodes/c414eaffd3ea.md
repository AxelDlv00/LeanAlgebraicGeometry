---
author: sync
content_type: theorem
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Adelic.mem_orderGe
file: AlgebraicJacobian/RiemannRoch/Adelic/ChiLedger.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.mem_orderGe
type: lean
updated: '2026-07-16T21:14:28'
---
theorem mem_orderGe {P : X.PrimeDivisor} {m : ℤ} {f : X.functionField} :
    f ∈ orderGe P m ↔ f = 0 ∨ m ≤ Scheme.RationalMap.order P f :=
  Iff.rfl