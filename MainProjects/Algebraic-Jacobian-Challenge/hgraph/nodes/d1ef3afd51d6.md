---
author: sync
content_type: theorem
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Adelic.riemann_inequality
docstring: '**N16 — the Riemann inequality `deg D + χ(0) ≤ ℓ(D)`.** Given the telescoped

  Euler characteristic `χ(D) = χ(0) + deg D` (node N15 `chi_add` iterated along the

  divisor: `deg D = Σᵢ deg Pᵢ` the sum of the one-point local residue degrees, an

  honest hypothesis packaging the induction on the effective parts), the Riemann

  inequality is the elementary `χ(D) ≤ ℓ(D)` (`i(D) ≥ 0`):

  `deg D + χ(0) ≤ ℓ(D)`.'
file: AlgebraicJacobian/RiemannRoch/Adelic/ChiLedger.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.riemann_inequality
type: lean
updated: '2026-07-24T03:02:13'
---
theorem riemann_inequality {D : X.WeilDivisor} {degD : ℤ}
    (htel : chi k U₀ U₁ D = chi k U₀ U₁ 0 + degD) :
    degD + chi k U₀ U₁ 0 ≤ (ell k D : ℤ) := by
  have h := chi_le_ell k U₀ U₁ D
  rw [htel] at h; linarith

/-! ### N16 — telescoping the one-step equality over an effective divisor

The one-step equality `χ(E + P) = χ(E) + deg P` (`chi_add_eq_residueDeg`) telescopes:
writing an effective divisor `D ≥ 0` as a sum of one-point divisors `D = Σ P∈L 1·P`
(with multiplicity given by repetition in the list `L`), iteration gives the Riemann
shape `χ(D) = χ(0) + Σ P∈L deg P`, the **adelic degree** `deg_k D = Σ nᵢ·[κ(Pᵢ):k]`
weighted by residue degrees (the field-of-constants refinement of the geometric
`degree`, which is this sum with every `[κ(Pᵢ):k] = 1` over `k̄`).  The per-step
equality is supplied as the hypothesis `hbump` — each instance is exactly one
application of `chi_add_eq_residueDeg` (the one-point twist `E ↦ 1·P + E` satisfies
`hstep`/`hle`/`hoff` by `Finsupp.single`), so this is the honest reduction of N16 to
the strong-approximation one-point count. -/