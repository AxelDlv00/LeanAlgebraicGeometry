---
author: sync
content_type: theorem
created: '2026-07-28T00:32:02'
decl: AlgebraicGeometry.Adelic.degK_principal_eq_zero_of_bump
docstring: '**Principal divisors have weighted degree zero, from the bump.**  `deg_k
  (div g) = 0`

  with the ledger eliminated; `degK_principal_eq_zero` is the form that takes it.'
file: AlgebraicJacobian/RiemannRoch/Adelic/LedgerClosure.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.degK_principal_eq_zero_of_bump
type: lean
updated: '2026-07-28T00:32:02'
---
theorem degK_principal_eq_zero_of_bump
    (hbump : ∀ (P : X.PrimeDivisor) (E : X.WeilDivisor),
      chi k U₀ U₁ (pointDivisor P + E) = chi k U₀ U₁ E + residueDeg k P)
    {g : X.functionField} (hg : g ≠ 0) :
    degK k (Scheme.WeilDivisor.principal g hg) = 0 :=
  degK_principal_eq_zero k U₀ U₁ (chi_eq_of_bump k U₀ U₁ hbump) hg