---
author: sync
content_type: theorem
created: '2026-07-17T21:31:17'
decl: AlgebraicGeometry.subsingleton_h1_windowN_sub
docstring: '**`hNnorm`**: the transported normalization windows — for every `K`-divisor
  `D''` of

  degree `≤ 2g`, `H¹(𝒪(N − D'')) = 0`.  The π-free peeling at the transported multiplier

  window `s·F` (or at `N` itself in the degenerate `windowBound ≤ 0` branch, where

  `g = 0`), licensed by the ledger budgets.'
file: AlgebraicJacobian/RiemannRoch/WindowFieldTransport.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.subsingleton_h1_windowN_sub
type: lean
updated: '2026-07-31T20:15:29'
---
theorem subsingleton_h1_windowN_sub (g : ℕ)
    (hO : Sheaf.h0 (C.left.moduleKSheaf k) = 1)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
    (hχK : Sheaf.chi ((relCurve C K).moduleKSheaf K) = 1 - (g : ℤ))
    (D' : (relCurve C K).CurveDivisor)
    (hD' : CurveDivisor.deg K D' ≤ 2 * (g : ℤ)) :
    Subsingleton (Sheaf.HModule
      ((relCurve C K).divisorSheaf K (windowN C K hπ g - D')) 1) := by
  have hsub : CurveDivisor.deg K (windowN C K hπ g - D')
      = CurveDivisor.deg K (windowN C K hπ g) - CurveDivisor.deg K D' := by
    rw [sub_eq_add_neg, CurveDivisor.deg_add, CurveDivisor.deg_neg, sub_eq_add_neg]
  by_cases hb : windowBound π hπ ≤ 0
  · -- degenerate branch: `g = 0`, peel from `N` itself
    have hg0 : g = 0 := genus_eq_zero_of_windowBound_nonpos π hπ g hb hO hχ
    refine subsingleton_hModule_one_of_witness K (windowN C K hπ g) _
      (subsingleton_h1_windowN C K hπ g) ?_
    rw [hsub, hχK, hg0]
    simp only [Nat.cast_zero] at hD' ⊢
    linarith
  · -- main branch: peel from the transported multiplier window `s·F`
    refine subsingleton_hModule_one_of_witness K
      (windowTransportDivisor C K π (windowS_choice π hπ g)) _
      (subsingleton_h1_windowTransportDivisor C K π _ (relThetaPairH1_windowS C hπ g))
      ?_
    rw [hsub, hχK, deg_windowN, deg_windowTransportDivisor]
    have hb1 : 0 < windowBound π hπ := not_le.mp hb
    have hM := windowM_spec π hπ g
    have hδ := one_le_windowδ π
    have hs : (0 : ℤ) ≤ (windowS_choice π hπ g : ℤ) := Int.natCast_nonneg _
    have hg : (0 : ℤ) ≤ (g : ℤ) := Int.natCast_nonneg _
    have hkey : (windowS_choice π hπ g : ℤ) * windowδ π + ((g : ℤ) + 2)
        ≤ ((g : ℤ) + 2) * ((windowS_choice π hπ g : ℤ) + 1) * windowδ π := by
      nlinarith [hs, hg, hδ, mul_nonneg (mul_nonneg (by linarith : (0:ℤ) ≤ (g:ℤ) + 1) hs)
        (by linarith : (0:ℤ) ≤ windowδ π)]
    linarith [hM, hkey, hb1, hD']