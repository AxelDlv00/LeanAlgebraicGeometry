---
author: sync
content_type: theorem
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.exists_bound_subsingleton_hModule_one_of_isFinite_toP1
docstring: '**DAT-0a — the P5-uniform `H¹`-vanishing bound.** For a **finite** dominant
  `π : Y ⟶ ℙ¹`

  compatible with the structure morphisms, there is a single threshold `b : ℤ`, depending
  only on

  `(Y, π)`, past which the degree-one cohomology of `𝒪(D)` vanishes for **every**
  Weil divisor `D` of

  degree `≥ b`:


  `∃ b, ∀ D, b ≤ deg D → Subsingleton H¹(𝒪(D))`.


  The bound is `b = n₁·deg F + 1 − χ(𝒪_Y)`, with `F = fiberWeilDivisor π` and `n₁`
  the FLV-fiber

  threshold at `D₀ = 0`; see the module docstring for the collapsed route

  (`informal/w4-datum-worksheet.md` §4 DAT-0a). Consumed by DAT-D''s uniform Grassmannian
  twist.'
file: AlgebraicJacobian/RiemannRoch/UniformVanishing.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.exists_bound_subsingleton_hModule_one_of_isFinite_toP1
type: lean
updated: '2026-07-31T20:14:50'
---
theorem exists_bound_subsingleton_hModule_one_of_isFinite_toP1
    [Module.Finite K (Sheaf.HModule (Y.moduleKSheaf K) 0)]
    [Module.Finite K (Sheaf.HModule (Y.moduleKSheaf K) 1)]
    (π : Y ⟶ P1 K) [IsFinite π] [IsDominant π]
    (hπ : π ≫ P1.structureMap K = Y ↘ Spec (CommRingCat.of K)) :
    ∃ b : ℤ, ∀ D : Y.CurveDivisor, b ≤ CurveDivisor.deg K D →
      Subsingleton (Sheaf.HModule (Y.divisorSheaf K D) 1) := by
  obtain ⟨n₁, hn₁⟩ :=
    subsingleton_hModule_divisorSheaf_one_of_isFinite_toP1 π hπ (0 : Y.CurveDivisor)
  have hd'pos : 0 < CurveDivisor.deg K (fiberWeilDivisor π) :=
    zero_lt_deg_fiberWeilDivisor π
  refine ⟨(n₁ : ℤ) * CurveDivisor.deg K (fiberWeilDivisor π) + 1
      - Sheaf.chi (Y.moduleKSheaf K), fun D hD => ?_⟩
  -- the residual class `[D] · [F]^{-n₁}`
  set c : Y.CechPic := CurveDivisor.picClass K D
    * (CurveDivisor.picClass K (fiberWeilDivisor π) ^ n₁)⁻¹ with hc
  have hcdeg : classDeg K c
      = CurveDivisor.deg K D - (n₁ : ℤ) * CurveDivisor.deg K (fiberWeilDivisor π) := by
    rw [hc, classDeg_mul, classDeg_inv, classDeg_pow, classDeg_picClass, classDeg_picClass]
    ring
  -- an effective witness of the residual class
  obtain ⟨W, hWc⟩ := CurveDivisor.exists_picClass_eq K c
  have hWdeg : 1 ≤ CurveDivisor.deg K W + Sheaf.chi (Y.moduleKSheaf K) := by
    have hWeq : CurveDivisor.deg K W
        = CurveDivisor.deg K D - (n₁ : ℤ) * CurveDivisor.deg K (fiberWeilDivisor π) := by
      rw [← hcdeg, ← hWc, classDeg_picClass]
    linarith
  obtain ⟨E, hEnonneg, hEc⟩ := exists_effective_of_picClass W hWdeg
  -- the witness divisor `n₁ • F + E` is in the class of `D`
  have hclass : CurveDivisor.picClass K (n₁ • fiberWeilDivisor π + E)
      = CurveDivisor.picClass K D := by
    rw [CurveDivisor.picClass_add, picClass_nsmul, hEc, hWc, hc,
      mul_comm (CurveDivisor.picClass K D), ← mul_assoc, mul_inv_cancel, one_mul]
  -- base vanishing at `n₁ • F`, peel `E`, transport along the class
  have hbase : Subsingleton
      (Sheaf.HModule (Y.divisorSheaf K (n₁ • fiberWeilDivisor π)) 1) := by
    have h := hn₁ n₁ le_rfl
    rwa [zero_add] at h
  have hpeel : Subsingleton
      (Sheaf.HModule (Y.divisorSheaf K (n₁ • fiberWeilDivisor π + E)) 1) :=
    peel_effective (n₁ • fiberWeilDivisor π) E hEnonneg hbase
  exact subsingleton_hModule_one_of_picClass_eq K hclass hpeel