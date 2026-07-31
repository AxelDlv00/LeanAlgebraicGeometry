---
author: sync
content_type: theorem
created: '2026-07-30T17:14:50'
decl: AlgebraicGeometry.not_pointwiseCoverage_abelSigmaChartZero_of_ne_top
docstring: '**Coverage is refuted at every proper `V`, unconditionally at parameter
  `0`.**'
file: AlgebraicJacobian/Picard/Pic0ChartMonoUnconditional.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.not_pointwiseCoverage_abelSigmaChartZero_of_ne_top
type: lean
updated: '2026-07-31T20:15:27'
---
theorem not_pointwiseCoverage_abelSigmaChartZero_of_ne_top
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (0 : ℕ))
    (V : (Over.mk (𝟙 (Spec (CommRingCat.of k)))).left.Opens) (hV : V ≠ ⊤) :
    ¬ PointwiseCoverage C
      (fun _ : PUnit.{u+1} => restrictChart (abelSigmaChartZero (pi := pi) m Z hdeg) V) :=
  not_pointwiseCoverage_of_injective_of_ne_top C _ V hV
    (injective_abelSigmaChartZero m Z hdeg)