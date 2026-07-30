---
author: sync
content_type: theorem
created: '2026-07-18T20:01:11'
decl: AlgebraicGeometry.picClass_thetaFieldDivisor
docstring: The theta divisor lies in the class of the `K`-level whole-chart theta
  datum.
file: AlgebraicJacobian/Picard/DivisorFamilyFieldDictionaryCore.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.picClass_thetaFieldDivisor
type: lean
updated: '2026-07-30T15:46:04'
---
theorem picClass_thetaFieldDivisor :
    Scheme.CurveDivisor.picClass K (thetaFieldDivisor C K π a)
      = (thetaChartDatum C K π a).cechPicClass := by
  rw [thetaFieldDivisor, Scheme.CurveDivisor.picClass_presentationDivisor]
  exact (thetaChartDatum C K π a).cechPicClass_eq_mk (thetaFieldPointedCover C K π)
    (thetaFieldChartIndex C K π) (fun _ => le_rfl)