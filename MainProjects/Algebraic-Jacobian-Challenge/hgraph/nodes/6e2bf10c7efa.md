---
author: sync
content_type: theorem
created: '2026-07-27T15:50:35'
decl: AlgebraicGeometry.Adelic.degK_principal_eq_zero
docstring: '**Principal divisors have residue-weighted degree zero** — the adelic

  counterpart of the geometric statement `Scheme.WeilDivisor.principal_degree_zero`.


  Given the closed ledger, this is a two-line consequence of the class-invariance
  of

  `χ` proved in `ClassInvariance.lean`: `0 − div g` is in the class of `0`, so

  `χ(0 − div g) = χ(0)`, and the ledger reads off

  `deg_k (0 − div g) = 0`, i.e. `deg_k (div g) = 0`.


  This is the *weighted* statement.  It does **not** close the open geometric leaf

  `principal_degree_zero`, which asserts the same for the unweighted degree

  `Σ_P ord_P g`; see §4.'
file: AlgebraicJacobian/RiemannRoch/Adelic/SectionBounds.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.degK_principal_eq_zero
type: lean
updated: '2026-07-27T15:50:35'
---
theorem degK_principal_eq_zero
    (hledger : ∀ D : X.WeilDivisor, chi k U₀ U₁ D = chi k U₀ U₁ 0 + degK k D)
    {g : X.functionField} (hg : g ≠ 0) :
    degK k (Scheme.WeilDivisor.principal g hg) = 0 := by
  have hchi := chi_eq_of_principal_shift k U₀ U₁ (0 : X.WeilDivisor) hg
  rw [hledger ((0 : X.WeilDivisor) - Scheme.WeilDivisor.principal g hg),
    hledger (0 : X.WeilDivisor), degK_sub, degK_zero] at hchi
  omega