---
author: sync
content_type: theorem
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.window_normalization_shift
docstring: '**The shifted normalization window**: `H¹(𝒪((M+s)·F − D)) = 0` for `deg
  D ≤ 2g`.'
file: AlgebraicJacobian/RiemannRoch/WindowLedger.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.window_normalization_shift
type: lean
updated: '2026-07-29T15:26:31'
---
theorem window_normalization_shift (g : ℕ) (D : Y.CurveDivisor)
    (hD : CurveDivisor.deg K D ≤ 2 * (g : ℤ)) :
    Subsingleton (Sheaf.HModule (Y.divisorSheaf K
      ((windowM_choice π hπ g + windowS_choice π hπ g) • fiberWeilDivisor π - D)) 1) := by
  refine windowBound_spec π hπ _ ?_
  rw [deg_sub, deg_nsmul, deg_fiberWeilDivisor_windowδ]
  have hM := windowBound_le_M_norm π hπ g
  have hs := windowS_mul_windowδ_nonneg π hπ g
  push_cast
  linarith