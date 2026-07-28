---
author: sync
content_type: lemma
created: '2026-07-29T06:43:23'
decl: AlgebraicGeometry.Scheme.CurveDivisor.ext_coeffAt
docstring: Two Weil divisors with the same coefficient at every closed point are equal.
file: AlgebraicJacobian/RiemannRoch/Ledger/FiberDivisor.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.CurveDivisor.ext_coeffAt
type: lean
updated: '2026-07-29T06:43:23'
---
lemma ext_coeffAt {D D' : X.CurveDivisor}
    (h : ∀ (x : X) (hx : x ≠ genericPoint X), coeffAt hx D = coeffAt hx D') : D = D' :=
  Finsupp.ext fun p => h p.1 p.2

variable {x : X} (hx : x ≠ genericPoint X)

@[simp]