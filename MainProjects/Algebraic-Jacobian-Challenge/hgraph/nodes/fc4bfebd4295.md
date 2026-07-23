---
author: sync
content_type: theorem
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Adelic.chi_le_ell
docstring: '**N16 — nonnegativity of the index of speciality: `χ(D) ≤ ℓ(D)`.** Immediate

  from `χ(D) = ℓ(D) − h¹(D)` and `h¹(D) = i(D) ≥ 0`.  This is the `i(D) ≥ 0` half
  of

  the Riemann inequality.'
file: AlgebraicJacobian/RiemannRoch/Adelic/ChiLedger.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.chi_le_ell
type: lean
updated: '2026-07-16T21:14:28'
---
theorem chi_le_ell (D : X.WeilDivisor) : chi k U₀ U₁ D ≤ (ell k D : ℤ) := by
  have : (0 : ℤ) ≤ (h1dim k U₀ U₁ D : ℤ) := Int.natCast_nonneg _
  simp only [chi]; linarith