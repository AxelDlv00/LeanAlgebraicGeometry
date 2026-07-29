---
author: sync
content_type: theorem
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.exists_subsingleton_hModule_one_of_one_le_classDeg_of_isFinite_toP1
docstring: '**FLV-class (conditional on a finite dominant map)** — the worksheet''s
  outer statement

  (`informal/w4-flv-worksheet.md` §§1.2, 2.5). For a finite dominant `π : Y ⟶ ℙ¹`
  compatible with

  the structure morphisms, and Čech Picard classes `l`, `θ` with `1 ≤ classDeg θ`:
  the degree-one

  cohomology of `𝒪(D)` vanishes for **every** Weil divisor `D` of class `l · θⁿ`,
  for all

  sufficiently large `n`. The bound `n₀` is per-class and non-effective.


  The reduction (§2.5, in the simplified `m = m₀` form): FLV-fiber

  (`subsingleton_hModule_divisorSheaf_one_of_isFinite_toP1`) vanishes `H¹(𝒪(D₀ + m₀·F))`
  for `D₀`

  realizing `l` and `F` the fiber divisor (`0 < deg F` by the surjectivity witness);
  for `n` large

  the residual class `θⁿ·(𝒪(F))⁻ᵐ⁰` has degree `≥ 1 − χ(𝒪)`, giving an **effective**
  witness `E`

  of that class (`exists_effective_of_picClass`); `D₀ + m₀·F + E` is in class `l·θⁿ`,
  and peeling

  `E` (`peel_effective`) transports the vanishing; witness-independence (W6-lite

  `subsingleton_hModule_one_of_picClass_eq`) upgrades it to every `D` of the class.'
file: AlgebraicJacobian/RiemannRoch/FLVClass.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.exists_subsingleton_hModule_one_of_one_le_classDeg_of_isFinite_toP1
type: lean
updated: '2026-07-29T15:31:49'
---
theorem exists_subsingleton_hModule_one_of_one_le_classDeg_of_isFinite_toP1
    [Module.Finite K (Sheaf.HModule (Y.moduleKSheaf K) 0)]
    [Module.Finite K (Sheaf.HModule (Y.moduleKSheaf K) 1)]
    (π : Y ⟶ P1 K) [IsFinite π] [IsDominant π]
    (hπ : π ≫ P1.structureMap K = Y ↘ Spec (CommRingCat.of K))
    (l θ : Y.CechPic) (hθ : 1 ≤ classDeg K θ) :
    ∃ n₀ : ℕ, ∀ n ≥ n₀, ∀ D : Y.CurveDivisor,
      CurveDivisor.picClass K D = l * θ ^ n →
      Subsingleton (Sheaf.HModule (Y.divisorSheaf K D) 1) := by
  obtain ⟨D₀, hD₀⟩ := CurveDivisor.exists_picClass_eq K l
  obtain ⟨m₀, hm₀⟩ := subsingleton_hModule_divisorSheaf_one_of_isFinite_toP1 π hπ D₀
  set F : Y.CurveDivisor := fiberWeilDivisor π with hF
  set d' : ℤ := CurveDivisor.deg K F with hd'
  have hd'pos : 0 < d' := by rw [hd', hF]; exact zero_lt_deg_fiberWeilDivisor π
  set φ : Y.CechPic := CurveDivisor.picClass K F with hφ
  have hφdeg : classDeg K φ = d' := by rw [hφ, hd', classDeg_picClass]
  set gtld : ℤ := 1 - Sheaf.chi (Y.moduleKSheaf K) with hgtld
  refine ⟨(m₀ * d' + gtld).toNat, fun n hn D hD => ?_⟩
  -- the residual class and its degree
  set c : Y.CechPic := θ ^ n * (φ ^ m₀)⁻¹ with hc
  have hcdeg : classDeg K c = n * classDeg K θ - m₀ * d' := by
    rw [hc, classDeg_mul, classDeg_inv, classDeg_pow, classDeg_pow, hφdeg]; ring
  have hlarge : gtld ≤ classDeg K c := by
    rw [hcdeg]
    have h1 : (m₀ * d' + gtld : ℤ) ≤ (n : ℤ) :=
      le_trans (Int.self_le_toNat _) (by exact_mod_cast hn)
    have h2 : (n : ℤ) ≤ (n : ℤ) * classDeg K θ :=
      le_mul_of_one_le_right (Int.natCast_nonneg n) hθ
    linarith
  -- an effective witness of the residual class
  obtain ⟨W, hWc⟩ := CurveDivisor.exists_picClass_eq K c
  have hWdeg : 1 ≤ CurveDivisor.deg K W + Sheaf.chi (Y.moduleKSheaf K) := by
    have hWc' : classDeg K c = CurveDivisor.deg K W := by rw [← hWc, classDeg_picClass]
    rw [hWc', hgtld] at hlarge; linarith
  obtain ⟨E, hEnonneg, hEc⟩ := exists_effective_of_picClass W hWdeg
  -- the class of the witness divisor `D₀ + m₀·F + E`
  have hD'class : CurveDivisor.picClass K (D₀ + m₀ • F + E) = l * θ ^ n := by
    rw [CurveDivisor.picClass_add, CurveDivisor.picClass_add, hD₀, picClass_nsmul, ← hφ,
      hEc, hWc, hc]
    rw [mul_comm (θ ^ n) ((φ ^ m₀)⁻¹), ← mul_assoc, mul_assoc l, mul_inv_cancel, mul_one]
  -- vanishing at the base, then peel `E`, then transport by witness-independence
  have hbase : Subsingleton (Sheaf.HModule (Y.divisorSheaf K (D₀ + m₀ • F)) 1) := by
    rw [hF]; exact hm₀ m₀ le_rfl
  have hpeel : Subsingleton (Sheaf.HModule (Y.divisorSheaf K (D₀ + m₀ • F + E)) 1) :=
    peel_effective (D₀ + m₀ • F) E hEnonneg hbase
  exact subsingleton_hModule_one_of_picClass_eq K (hD'class.trans hD.symm) hpeel

omit [LocallyOfFiniteType (Y ↘ Spec (CommRingCat.of K))] in