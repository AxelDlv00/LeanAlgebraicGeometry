---
author: sync
content_type: theorem
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.windowBound_le_S_mul
docstring: '**The embedding bound at `s`**: `b ≤ s·δ`.'
file: AlgebraicJacobian/RiemannRoch/WindowLedger.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.windowBound_le_S_mul
type: lean
updated: '2026-08-01T09:44:18'
---
theorem windowBound_le_S_mul (g : ℕ) :
    windowBound π hπ ≤ (windowS_choice π hπ g : ℤ) * windowδ π := by
  have hspec := windowS_spec π hπ g
  have hδ : 0 ≤ windowδ π := windowδ_nonneg π
  have hg : (0 : ℤ) ≤ 2 * (g : ℤ) := by positivity
  -- `(s − 1)·δ ≥ b + 2g ≥ b`, and `s·δ = (s−1)·δ + δ ≥ (s−1)·δ`
  nlinarith [hspec, hδ, hg]