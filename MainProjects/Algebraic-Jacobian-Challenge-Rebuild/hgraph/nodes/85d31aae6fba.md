---
author: sync
content_type: theorem
created: '2026-07-29T04:13:39'
decl: AlgebraicGeometry.isOpenImmersion_presheaf_mixedParamChart
docstring: '**Heterogeneity costs nothing in the certificate**: the `hf` clause of
  a mixed-parameter

  family is exactly a per-index `IsChartUniv`, by definition of both.


  So a lane that can discharge CHART-U(c) *at one parameter* can discharge it index-by-index
  at

  different parameters, with no additional compatibility between them — there is no
  coherence

  condition across indices, because `pic0RepresentableByOfCharts` imposes none.'
file: AlgebraicJacobian/Picard/Pic0ChartAtlasParamFree.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.isOpenImmersion_presheaf_mixedParamChart
type: lean
updated: '2026-07-31T20:14:47'
---
theorem isOpenImmersion_presheaf_mixedParamChart {ι : Type u} (nn : ι → ℕ)
    (D : ι → Over (Spec (.of k)))
    (rep : ∀ i, (divFunctor C π (nn i)).RepresentableBy (D i))
    (m : ι → ℕ) (Z : ι → (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : ∀ i, Scheme.CurveDivisor.deg k (Z i)
      = (m i : ℤ) * classDeg k (thetaCechClass C) - (nn i : ℤ))
    (V : ∀ i, (D i).left.Opens)
    (huniv : ∀ i, IsChartUniv C π (nn i) (rep i) (m i) (Z i) (hdeg i) (V i)) (i : ι) :
    IsOpenImmersion.presheaf (mixedParamChart C π nn D rep m Z hdeg V i) :=
  huniv i

variable (C π) in