---
author: sync
content_type: theorem
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.fiberLattice_mono
docstring: '**The lattice ladder is increasing.** `Aₙ ≤ Aₙ₊₁`: over `V₀` the twist
  bound relaxes (`F` is

  effective, so `D + n·F ≤ D + (n+1)·F`), and over `V₁` the lattice is constant.'
file: AlgebraicJacobian/RiemannRoch/FLVLattice.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.fiberLattice_mono
type: lean
updated: '2026-07-29T15:31:49'
---
theorem fiberLattice_mono (D : Y.CurveDivisor) (n : ℕ) :
    fiberLattice π D n ≤ fiberLattice π D (n + 1) := by
  have hle : D + n • fiberWeilDivisor π ≤ D + (n + 1) • fiberWeilDivisor π := by
    refine Finsupp.le_def.mpr (fun p => ?_)
    change coeffAt p.2 (D + n • fiberWeilDivisor π)
      ≤ coeffAt p.2 (D + (n + 1) • fiberWeilDivisor π)
    rw [CurveDivisor.coeffAt_add, CurveDivisor.coeffAt_add, coeffAt_nsmul, coeffAt_nsmul]
    have hF : 0 ≤ coeffAt p.2 (fiberWeilDivisor π) := by
      rw [fiberWeilDivisor_coeffAt π p.2]; exact le_max_right _ _
    have hmul : (n : ℤ) * coeffAt p.2 (fiberWeilDivisor π)
        ≤ ((n : ℤ) + 1) * coeffAt p.2 (fiberWeilDivisor π) :=
      mul_le_mul_of_nonneg_right (by linarith) hF
    push_cast
    linarith
  refine sup_le_sup ?_ ?_
  · exact divisorSections_mono K hle (fiberChart₀ π)
  · exact divisorSections_mono K hle (fiberChart₁ π)

/-! ## Exhaustion of `N` by the ladder -/