---
author: sync
content_type: theorem
created: '2026-07-19T10:31:16'
decl: AlgebraicGeometry.deg_windowS
docstring: The degree of `S` is the `k`-ledger multiplier degree `s·δ`.
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivFibre.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.deg_windowS
type: lean
updated: '2026-07-29T15:26:35'
---
theorem deg_windowS (g : ℕ) :
    CurveDivisor.deg K (windowS C K hπ g)
      = (windowS_choice π hπ g : ℤ) * windowδ π :=
  deg_windowTransportDivisor C K π _

set_option linter.unusedSectionVars false in