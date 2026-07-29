---
author: sync
content_type: theorem
created: '2026-07-17T21:17:12'
decl: AlgebraicGeometry.baseDivisor_window_normalization
docstring: '**Recovery of the divisor from its window, assembled form** (the `baseDivisor`

  packaging of DDR-2''s `baseDivisorAt_window_normalization`, the DDR-8 hook): for
  an

  effective `D` of degree `g` under an embedding level `N` with exact normalization

  windows and budget `2g ≤ deg N`, any submodule `T` equal to the window section space

  `H⁰(𝒪(N − D))` has base divisor exactly `D` relative to `N`.'
file: AlgebraicJacobian/Picard/DivisorFamilyEpsMono.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.baseDivisor_window_normalization
type: lean
updated: '2026-07-29T15:31:44'
---
theorem baseDivisor_window_normalization (g : ℕ)
    (hO : Sheaf.h0 (Y.moduleKSheaf K) = 1)
    (hχ : Sheaf.chi (Y.moduleKSheaf K) = 1 - (g : ℤ))
    (N : Y.CurveDivisor)
    (hNnorm : ∀ D' : Y.CurveDivisor, CurveDivisor.deg K D' ≤ 2 * (g : ℤ) →
      Subsingleton (Sheaf.HModule (Y.divisorSheaf K (N - D')) 1))
    (hNdeg : 2 * (g : ℤ) ≤ CurveDivisor.deg K N)
    (D : Y.CurveDivisor) (hD0 : 0 ≤ D) (hdeg : CurveDivisor.deg K D = (g : ℤ))
    {T : Submodule K Y.functionField} (hT : T = divisorSections K (N - D) ⊤)
    (hne : ∃ f ∈ T, f ≠ 0) :
    Scheme.baseDivisor K T N hne = D := by
  refine CurveDivisor.ext_coeffAt (fun x hx => ?_)
  rw [Scheme.coeffAt_baseDivisor K hne hx, hT]
  exact baseDivisorAt_window_normalization g hO hχ N hNnorm hNdeg D hD0 hdeg hx

omit [LocallyOfFiniteType (Y ↘ Spec (CommRingCat.of K))] in