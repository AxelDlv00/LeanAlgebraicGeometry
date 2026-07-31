---
author: sync
content_type: definition
created: '2026-07-17T21:31:16'
decl: AlgebraicGeometry.windowN
docstring: '**The abstract fibre window divisor `N`** of DDR-2''s pinch: the transported
  window

  divisor at the `k`-ledger embedding exponent `M = windowM_choice π hπ g`.'
file: AlgebraicJacobian/RiemannRoch/WindowFieldTransport.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.windowN
type: lean
updated: '2026-07-31T20:14:52'
---
noncomputable def windowN (g : ℕ) : (relCurve C K).CurveDivisor :=
  windowTransportDivisor C K π (windowM_choice π hπ g)

set_option linter.unusedSectionVars false in