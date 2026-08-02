---
author: sync
content_type: theorem
created: '2026-08-02T21:35:45'
decl: AlgebraicGeometry.two_mul_degree_le_S_mul_windowδ
docstring: "**The tower budget** `b + δ ≤ s·δ − 2g`: the levels `sF − E + j·x` with\n\
  `deg E ≤ 2g` of the bpf-span tower stage (probe 3e) stay in-window — a rearrangement\
  \ of\n`windowS_spec`. -/\ntheorem windowBound_add_windowδ_le_S_mul_sub (g : ℕ) :\n\
  \    windowBound π hπ + windowδ π\n      ≤ (windowS_choice π hπ g : ℤ) * windowδ\
  \ π - 2 * (g : ℤ) := by\n  have hspec := windowS_spec π hπ g\n  have hδ := windowδ_nonneg\
  \ π\n  nlinarith [hspec, hδ]\n\n/-! ## The decoupled budget\n\nThe universal divisor\
  \ family is budgeted by its degree `n`, while the Riemann--Roch\nnormalization carries\
  \ an independent curve parameter `gamma`.  The coverage path uses\n`gamma ≤ n`;\
  \ keeping this relation explicit here lets the diagonal API above remain\nsource-compatible\
  \ and gives the widened tower the exact arithmetic it needs.\n-/\n\ntheorem two_mul_genus_le_S_mul_windowδ_at\
  \ (gamma n : ℕ) (hgamma : gamma ≤ n)\n    (hO : Sheaf.h0 (Y.moduleKSheaf K) = 1)\n\
  \    (hχ : Sheaf.chi (Y.moduleKSheaf K) = 1 - (gamma : ℤ)) :\n    2 * (gamma : ℤ)\
  \ ≤ (windowS_choice π hπ n : ℤ) * windowδ π := by\n  by_cases hb : windowBound π\
  \ hπ ≤ 0\n  · have hgamma0 := genus_eq_zero_of_windowBound_nonpos π hπ gamma hb\
  \ hO hχ\n    subst hgamma0\n    simpa using mul_nonneg (Int.natCast_nonneg (windowS_choice\
  \ π hπ n)) (windowδ_nonneg π)\n  · have hb1 : 0 < windowBound π hπ := not_le.mp\
  \ hb\n    have hspec := windowS_spec π hπ n\n    have hδ := one_le_windowδ π\n \
  \   have hcast : (gamma : ℤ) ≤ (n : ℤ) := by exact_mod_cast hgamma\n    nlinarith\
  \ [hspec, hδ, hb1]\n\ntheorem two_mul_genus_le_M_mul_windowδ_at (gamma n : ℕ) (hgamma\
  \ : gamma ≤ n)\n    (hO : Sheaf.h0 (Y.moduleKSheaf K) = 1)\n    (hχ : Sheaf.chi\
  \ (Y.moduleKSheaf K) = 1 - (gamma : ℤ)) :\n    2 * (gamma : ℤ) ≤ (windowM_choice\
  \ π hπ n : ℤ) * windowδ π := by\n  by_cases hb : windowBound π hπ ≤ 0\n  · have\
  \ hgamma0 := genus_eq_zero_of_windowBound_nonpos π hπ gamma hb hO hχ\n    subst\
  \ hgamma0\n    simpa using mul_nonneg (Int.natCast_nonneg (windowM_choice π hπ n))\
  \ (windowδ_nonneg π)\n  · have hb1 : 0 < windowBound π hπ := not_le.mp hb\n    have\
  \ hnorm := windowBound_le_M_norm π hπ n\n    have hcast : (gamma : ℤ) ≤ (n : ℤ)\
  \ := by exact_mod_cast hgamma\n    omega\n\ntheorem three_mul_genus_le_M_mul_windowδ_at\
  \ (gamma n : ℕ) (hgamma : gamma ≤ n)\n    (hO : Sheaf.h0 (Y.moduleKSheaf K) = 1)\n\
  \    (hχ : Sheaf.chi (Y.moduleKSheaf K) = 1 - (gamma : ℤ)) :\n    3 * (gamma : ℤ)\
  \ ≤ (windowM_choice π hπ n : ℤ) * windowδ π := by\n  by_cases hb : windowBound π\
  \ hπ ≤ 0\n  · have hgamma0 := genus_eq_zero_of_windowBound_nonpos π hπ gamma hb\
  \ hO hχ\n    subst hgamma0\n    simpa using mul_nonneg (Int.natCast_nonneg (windowM_choice\
  \ π hπ n)) (windowδ_nonneg π)\n  · have hb1 : 0 < windowBound π hπ := not_le.mp\
  \ hb\n    have hspec := windowM_spec π hπ n\n    have hδ := one_le_windowδ π\n \
  \   have hs : (0 : ℤ) ≤ (windowS_choice π hπ n : ℤ) := Int.natCast_nonneg _\n  \
  \  have hgamma' : (0 : ℤ) ≤ (gamma : ℤ) := Int.natCast_nonneg _\n    have hcast\
  \ : (gamma : ℤ) ≤ (n : ℤ) := by exact_mod_cast hgamma\n    have hone : (1 : ℤ) ≤\
  \ ((windowS_choice π hπ n : ℤ) + 1) * windowδ π := by\n      nlinarith [hs, hδ]\n\
  \    have hcube : ((n : ℤ) + 2)\n        ≤ ((n : ℤ) + 2) * (((windowS_choice π hπ\
  \ n : ℤ) + 1) * windowδ π) :=\n      le_mul_of_one_le_right (by positivity) hone\n\
  \    rw [← mul_assoc] at hcube\n    linarith [hspec, hcube, hb1, hgamma']\n\n/-!\
  \ The degree-keyed forms used by the decoupled P-fib spine.  They do not mention\
  \ an\nEuler-characteristic parameter: after the positive normalization of `windowBound`,\
  \ the\nledger itself supplies the full `2*n`/`3*n` slack needed by a degree-`n`\
  \ family."
file: AlgebraicJacobian/RiemannRoch/WindowLedgerF3.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.two_mul_degree_le_S_mul_windowδ
type: lean
updated: '2026-08-02T21:35:45'
---
theorem two_mul_degree_le_S_mul_windowδ (n : ℕ) :
    2 * (n : ℤ) ≤ (windowS_choice π hπ n : ℤ) * windowδ π := by
  have hspec := windowS_spec π hπ n
  have hδ := one_le_windowδ π
  have hb := windowBound_pos π hπ
  nlinarith