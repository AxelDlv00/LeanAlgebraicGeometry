---
author: sync
content_type: theorem
created: '2026-08-03T08:02:47'
decl: AlgebraicGeometry.exists_mem_ne_zero_of_window_normalization_at
docstring: '**The decoupled window section space is nonzero.**  Its exact rank is

  `deg N - n + 1 - gamma`, which is positive under `deg N ≥ 2n` and `gamma ≤ n`.'
file: AlgebraicJacobian/Picard/DivisorFamilyEpsMono.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.exists_mem_ne_zero_of_window_normalization_at
type: lean
updated: '2026-08-07T05:01:52'
---
theorem exists_mem_ne_zero_of_window_normalization_at (n : ℕ) {gamma : ℕ}
    (hgamma : gamma ≤ n)
    (hχ : Sheaf.chi (Y.moduleKSheaf K) = 1 - (gamma : ℤ))
    (N : Y.CurveDivisor)
    (hNnorm : ∀ D' : Y.CurveDivisor, CurveDivisor.deg K D' ≤ 2 * (n : ℤ) →
      Subsingleton (Sheaf.HModule (Y.divisorSheaf K (N - D')) 1))
    (hNdeg : 2 * (n : ℤ) ≤ CurveDivisor.deg K N)
    (D : Y.CurveDivisor) (hdeg : CurveDivisor.deg K D = (n : ℤ))
    {T : Submodule K Y.functionField} (hT : T = divisorSections K (N - D) ⊤) :
    ∃ f ∈ T, f ≠ 0 := by
  have hn2 : CurveDivisor.deg K D ≤ 2 * (n : ℤ) := by omega
  have hrank : (Sheaf.h0 (Y.divisorSheaf K (N - D)) : ℤ)
      = CurveDivisor.deg K N - CurveDivisor.deg K D
        + Sheaf.chi (Y.moduleKSheaf K) := by
    rw [h0_eq_deg_add_chi_of_subsingleton_hModule_one _ (hNnorm D hn2),
      Scheme.CurveDivisor.deg_sub' K]
  rw [hχ, hdeg] at hrank
  have hfr : Module.finrank K ↥T = Sheaf.h0 (Y.divisorSheaf K (N - D)) := by
    rw [hT]
    exact finrank_divisorSections_top K _
  refine Submodule.exists_mem_ne_zero_of_ne_bot (fun hbot => ?_)
  rw [hbot, finrank_bot] at hfr
  have hcast : (gamma : ℤ) ≤ (n : ℤ) := by exact_mod_cast hgamma
  omega