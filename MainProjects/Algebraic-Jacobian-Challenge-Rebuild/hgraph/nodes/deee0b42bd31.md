---
author: sync
content_type: theorem
created: '2026-07-28T13:48:47'
decl: DualNumber.isNilpotent_span_eps
docstring: '`(ε)` is nilpotent — the `span`-spelling of `isNilpotent_ker_fstHom`.'
file: AlgebraicJacobian/Tangent/DualNumberChartTriviality.lean
generated: lean
lean_status: lean_ok
stale: true
title: DualNumber.isNilpotent_span_eps
type: lean
updated: '2026-07-29T15:26:35'
---
theorem isNilpotent_span_eps : IsNilpotent (Ideal.span {(ε : DualNumber A)}) := by
  rw [← ker_fstHom_eq_span_eps]
  exact isNilpotent_ker_fstHom A