---
author: sync
content_type: theorem
created: '2026-07-17T16:57:14'
decl: AlgebraicGeometry.deg_eq_genus_of_window_corank
docstring: '**The certified-degree pinch, abstract window form** (spec-dd-r §1(ii)):
  a divisor

  `D` whose normalization window `H⁰(𝒪(N − D))` has corank exactly `g` inside an exact

  embedding window `H⁰(𝒪(N))` of budget `2g ≤ deg N` has `deg D = g`.  First the DD-0

  section bound caps `deg D ≤ 2g` (`h⁰(𝒪(N − D)) = deg N + 1 − 2g ≥ 1`, F1''s move),
  then

  the exact normalization window reads the degree off the corank.  No carve, no

  Mayer–Vietoris, no adaptation independence.'
file: AlgebraicJacobian/RiemannRoch/CarveDegreePinch.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.deg_eq_genus_of_window_corank
type: lean
updated: '2026-07-30T15:46:07'
---
theorem deg_eq_genus_of_window_corank (g : ℕ)
    (hO : Sheaf.h0 (Y.moduleKSheaf K) = 1)
    (hχ : Sheaf.chi (Y.moduleKSheaf K) = 1 - (g : ℤ))
    (N : Y.CurveDivisor)
    (hNwin : Subsingleton (Sheaf.HModule (Y.divisorSheaf K N) 1))
    (hNnorm : ∀ D' : Y.CurveDivisor, CurveDivisor.deg K D' ≤ 2 * (g : ℤ) →
      Subsingleton (Sheaf.HModule (Y.divisorSheaf K (N - D')) 1))
    (hNdeg : 2 * (g : ℤ) ≤ CurveDivisor.deg K N)
    (D : Y.CurveDivisor)
    (hcorank : Module.finrank K ↥(divisorSections K (N - D) ⊤) + g
      = Sheaf.h0 (Y.divisorSheaf K N)) :
    CurveDivisor.deg K D = (g : ℤ) := by
  have hrN : (Sheaf.h0 (Y.divisorSheaf K N) : ℤ)
      = CurveDivisor.deg K N + Sheaf.chi (Y.moduleKSheaf K) :=
    h0_eq_deg_add_chi_of_subsingleton_hModule_one _ hNwin
  rw [hχ] at hrN
  have hfr : Module.finrank K ↥(divisorSections K (N - D) ⊤)
      = Sheaf.h0 (Y.divisorSheaf K (N - D)) := finrank_divisorSections_top K _
  rw [hfr] at hcorank
  have hdegND : CurveDivisor.deg K (N - D)
      = CurveDivisor.deg K N - CurveDivisor.deg K D :=
    Scheme.CurveDivisor.deg_sub' K N D
  -- F1: the section bound caps `deg D ≤ 2g`
  have hsec := h0_divisorSheaf_le_max_of_h0_one K hO (N - D)
  rw [hdegND] at hsec
  have hD2g : CurveDivisor.deg K D ≤ 2 * (g : ℤ) := by
    rcases le_max_iff.mp hsec with h0le | hvle
    · omega
    · omega
  -- the exact normalization window reads off the degree
  have hnorm : (Sheaf.h0 (Y.divisorSheaf K (N - D)) : ℤ)
      = CurveDivisor.deg K N - CurveDivisor.deg K D
        + Sheaf.chi (Y.moduleKSheaf K) := by
    rw [h0_eq_deg_add_chi_of_subsingleton_hModule_one _ (hNnorm D hD2g), hdegND]
  rw [hχ] at hnorm
  omega

/-! ## §2 The ledger form -/

variable (π : Y ⟶ P1 K) [IsFinite π] [IsDominant π]
  (hπ : π ≫ P1.structureMap K = Y ↘ Spec (CommRingCat.of K))