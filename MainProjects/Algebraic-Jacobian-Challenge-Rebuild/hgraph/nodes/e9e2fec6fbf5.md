---
author: sync
content_type: theorem
created: '2026-07-29T20:00:06'
decl: AlgebraicGeometry.injective_abelSigmaChart_of_isChartLocusFibre
docstring: '**Hence the Abel chart is injective on the points of every test**, unrestricted.


  The elementwise form, which is where the contradiction with `|D|` would be exhibited:
  two

  distinct effective divisors in one linear system give one class, and this says that
  cannot

  happen over any test whatsoever.'
file: AlgebraicJacobian/Picard/Pic0ChartLocusFibreGuard.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.injective_abelSigmaChart_of_isChartLocusFibre
type: lean
updated: '2026-07-31T20:15:27'
---
theorem injective_abelSigmaChart_of_isChartLocusFibre
    (h : IsChartLocusFibre C π n rep m Z hdeg) (T : Scheme.{u}ᵒᵖ) :
    Function.Injective ((abelSigmaChart C π n rep m Z hdeg).app T) :=
  injective_of_isOpenImmersion_presheaf
    (isOpenImmersion_presheaf_abelSigmaChart_of_isChartLocusFibre rep m Z hdeg h) T