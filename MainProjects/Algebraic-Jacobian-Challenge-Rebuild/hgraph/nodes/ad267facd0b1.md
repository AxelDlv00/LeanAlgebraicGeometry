---
author: sync
content_type: theorem
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.windowBound_add_two_mul_genus_le_M_sub_S_mul
docstring: '**The descent budget** `b + 2g ≤ (M − s)·δ`, spelled `b + 2g + s·δ ≤ M·δ`:
  the deepest

  window of the bpf-span descent stage (probe 3c) — a level `N + sF − (G ⊔ A_x)` with

  `G, A_x ≤ div h + sF` costs at most `2s·δ` below `(M+s)·δ − deg D`, and `windowM_spec`''s

  budget `(g+2)(s+1) ≥ s` pays for it.'
file: AlgebraicJacobian/RiemannRoch/WindowLedgerF3.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.windowBound_add_two_mul_genus_le_M_sub_S_mul
type: lean
updated: '2026-07-30T15:28:02'
---
theorem windowBound_add_two_mul_genus_le_M_sub_S_mul (g : ℕ) :
    windowBound π hπ + 2 * (g : ℤ) + (windowS_choice π hπ g : ℤ) * windowδ π
      ≤ (windowM_choice π hπ g : ℤ) * windowδ π := by
  have hspec := windowM_spec π hπ g
  have hδ := windowδ_nonneg π
  have hs : (0 : ℤ) ≤ (windowS_choice π hπ g : ℤ) := Int.natCast_nonneg _
  have hg : (0 : ℤ) ≤ (g : ℤ) := Int.natCast_nonneg _
  -- `(g + 2)(s + 1) ≥ s`, so `(g + 2)(s + 1)δ ≥ s·δ`
  have hcoeff : (windowS_choice π hπ g : ℤ)
      ≤ ((g : ℤ) + 2) * ((windowS_choice π hπ g : ℤ) + 1) := by
    nlinarith [hs, hg]
  have hmul : (windowS_choice π hπ g : ℤ) * windowδ π
      ≤ ((g : ℤ) + 2) * ((windowS_choice π hπ g : ℤ) + 1) * windowδ π :=
    mul_le_mul_of_nonneg_right hcoeff hδ
  omega