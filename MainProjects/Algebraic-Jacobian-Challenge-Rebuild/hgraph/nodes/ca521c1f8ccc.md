---
author: sync
content_type: theorem
created: '2026-07-17T21:31:17'
decl: AlgebraicGeometry.deg_windowN
docstring: The degree of `N` is the `k`-ledger embedding degree `M·δ`.
file: AlgebraicJacobian/RiemannRoch/WindowFieldTransport.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.deg_windowN
type: lean
updated: '2026-07-17T21:31:17'
---
theorem deg_windowN (g : ℕ) :
    CurveDivisor.deg K (windowN C K hπ g)
      = (windowM_choice π hπ g : ℤ) * windowδ π :=
  deg_windowTransportDivisor C K π _