---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.rationalHilbert_antidiff
docstring: '**Antidifference step for rational Hilbert series.** If the first difference

  `H (n+1) - H n` is, for `n ≫ 0`, the `n`-th coefficient of the rational series

  `q · (1-X)^{-e}`, then `H` itself is, for `n ≫ 0`, the `n`-th coefficient of

  `p · (1-X)^{-(e+1)}` for an explicit polynomial `p`. This is the power-series

  heart of the inductive step in graded Hilbert–Serre (Stacks 00K1). Project-local:

  Mathlib supplies only the converse extraction `Polynomial.existsUnique_hilbertPoly`.'
file: AlgebraicJacobian/Picard/GradedHilbertSerre.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.rationalHilbert_antidiff
type: lean
updated: '2026-07-16T21:14:27'
---
lemma rationalHilbert_antidiff
    (H δ : ℕ → ℚ) (q : Polynomial ℚ) (e N : ℕ)
    (hδ : ∀ n, N < n → δ n = ((q : ℚ⟦X⟧) * (PowerSeries.invOneSubPow ℚ e).val).coeff n)
    (hH : ∀ n, N < n → H (n + 1) - H n = δ (n + 1)) :
    ∃ (p : Polynomial ℚ), ∀ n, N < n →
      H n = ((p : ℚ⟦X⟧) * (PowerSeries.invOneSubPow ℚ (e + 1)).val).coeff n := by
  set F : ℚ⟦X⟧ := (q : ℚ⟦X⟧) * (PowerSeries.invOneSubPow ℚ e).val with hF
  -- Partial-sum identity: the order-`(e+1)` series accumulates the order-`e` coefficients.
  have hsum : ∀ m, ((q : ℚ⟦X⟧) * (PowerSeries.invOneSubPow ℚ (e + 1)).val).coeff m
      = ∑ k ∈ Finset.range (m + 1), F.coeff k := by
    intro m
    have hmul : (q : ℚ⟦X⟧) * (PowerSeries.invOneSubPow ℚ (e + 1)).val
        = (PowerSeries.invOneSubPow ℚ 1).val * F := by
      rw [hF, show (e + 1) = 1 + e from by omega, PowerSeries.invOneSubPow_add, Units.val_mul]
      ring
    rw [hmul, coeff_invOneSubPow_one_mul]
  -- Telescoping `H` from its first differences, expressed via `F`.
  have hstep : ∀ n, N < n → H (n + 1) - H n = F.coeff (n + 1) := by
    intro n hn
    rw [hH n hn, hδ (n + 1) (by omega)]
  have htel : ∀ j, H (N + 1 + j)
      = H (N + 1) + ∑ i ∈ Finset.range j, F.coeff (N + 2 + i) := by
    intro j
    induction j with
    | zero => simp
    | succ j ih =>
        rw [Finset.sum_range_succ, show N + 2 + j = N + 1 + (j + 1) from by omega]
        have hs := hstep (N + 1 + j) (by omega)
        rw [show (N + 1 + j) + 1 = N + 1 + (j + 1) from by omega] at hs
        linarith [hs, ih]
  -- Constant-absorption: a constant function is the order-`(e+1)` coefficient of `C·(1-X)^e`.
  have hCconst : ∀ (c : ℚ),
      c • (PowerSeries.invOneSubPow ℚ 1).val
        = ((Polynomial.C c * (1 - Polynomial.X) ^ e : Polynomial ℚ) : ℚ⟦X⟧)
            * (PowerSeries.invOneSubPow ℚ (e + 1)).val := by
    intro c
    have hkey : (1 - PowerSeries.X : ℚ⟦X⟧) ^ e * (PowerSeries.invOneSubPow ℚ (e + 1)).val
        = (PowerSeries.invOneSubPow ℚ 1).val := by
      rw [Nat.add_comm e 1]
      exact PowerSeries.one_sub_pow_mul_invOneSubPow_val_add_eq_invOneSubPow_val ℚ 1 e
    rw [Polynomial.coe_mul, Polynomial.coe_C, Polynomial.coe_pow, Polynomial.coe_sub,
      Polynomial.coe_one, Polynomial.coe_X, mul_assoc, hkey, PowerSeries.smul_eq_C_mul]
  have hcoeff1 : ∀ m, (PowerSeries.invOneSubPow ℚ 1).val.coeff m = 1 := by
    intro m
    have h1 : (PowerSeries.invOneSubPow ℚ 1).val = PowerSeries.mk (fun _ => (1 : ℚ)) := by
      have := PowerSeries.invOneSubPow_val_succ_eq_mk_add_choose (S := ℚ) (d := 0)
      simpa using this
    rw [h1, PowerSeries.coeff_mk]
  -- Assemble the polynomial numerator.
  set B : ℚ := ∑ k ∈ Finset.range (N + 2), F.coeff k with hB
  set C0 : ℚ := H (N + 1) - B with hC0
  refine ⟨Polynomial.C C0 * (1 - Polynomial.X) ^ e + q, ?_⟩
  intro n hn
  -- Rewrite `H n` via the telescoping identity at `j = n - (N+1)`.
  obtain ⟨j, rfl⟩ : ∃ j, n = N + 1 + j := ⟨n - (N + 1), by omega⟩
  rw [htel j]
  -- The tail sum is an `Ico`-window of `F`.
  have htail : ∑ i ∈ Finset.range j, F.coeff (N + 2 + i)
      = ∑ k ∈ Finset.Ico (N + 2) (N + 2 + j), F.coeff k := by
    rw [Finset.sum_Ico_eq_sum_range]
    simp
  rw [htail]
  -- Split `range (n+1) = range (N+2) ∪ Ico (N+2) (n+1)` in the partial-sum identity.
  have hsplit : ∑ k ∈ Finset.range (N + 1 + j + 1), F.coeff k
      = B + ∑ k ∈ Finset.Ico (N + 2) (N + 2 + j), F.coeff k := by
    rw [hB, Finset.range_eq_Ico, Finset.range_eq_Ico,
      show N + 1 + j + 1 = N + 2 + j from by omega,
      ← Finset.sum_Ico_consecutive _ (Nat.zero_le (N + 2)) (by omega : N + 2 ≤ N + 2 + j)]
  -- Now compute the target coefficient and match.
  rw [show ((Polynomial.C C0 * (1 - Polynomial.X) ^ e + q : Polynomial ℚ) : ℚ⟦X⟧)
        = ((Polynomial.C C0 * (1 - Polynomial.X) ^ e : Polynomial ℚ) : ℚ⟦X⟧) + (q : ℚ⟦X⟧)
      from by push_cast; ring,
    add_mul, map_add, ← hCconst C0]
  rw [show (C0 • (PowerSeries.invOneSubPow ℚ 1).val).coeff (N + 1 + j)
        = C0 * (PowerSeries.invOneSubPow ℚ 1).val.coeff (N + 1 + j)
      from by rw [map_smul]; rfl, hcoeff1, mul_one,
    hsum (N + 1 + j), hsplit, hC0]
  ring

open PowerSeries Polynomial in