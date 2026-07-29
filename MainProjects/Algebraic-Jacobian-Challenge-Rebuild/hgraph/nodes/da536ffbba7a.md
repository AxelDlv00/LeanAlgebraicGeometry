---
author: sync
content_type: theorem
created: '2026-07-29T06:04:35'
decl: AlgebraicGeometry.Scheme.AffineTwoCover.isAffine_of_V₀_eq_top
docstring: '**If the first chart is everything, the scheme is affine.** `IsAffineOpen
  ⊤` means the open

  subscheme `↑⊤` is affine, and `Scheme.topIso : ↑⊤ ≅ Y` transports that to `Y` along

  `IsAffine.of_isIso`.'
file: AlgebraicJacobian/Tangent/TwoChartHonest.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.AffineTwoCover.isAffine_of_V₀_eq_top
type: lean
updated: '2026-07-29T15:31:50'
---
theorem isAffine_of_V₀_eq_top (h : D.V₀ = ⊤) : IsAffine Y := by
  have h2 := D.isAffineOpen₀
  rw [h] at h2
  haveI : IsAffine (↑(⊤ : Y.Opens)) := h2
  exact IsAffine.of_isIso Y.topIso.inv