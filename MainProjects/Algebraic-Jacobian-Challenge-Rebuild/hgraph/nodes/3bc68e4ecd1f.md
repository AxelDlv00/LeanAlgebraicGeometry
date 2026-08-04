---
author: sync
content_type: theorem
created: '2026-08-04T14:08:51'
decl: AlgebraicGeometry.chartValueAff_toAff
docstring: 'The widened chart value extends the chart-typed chart value along the
  injective vehicle

  comparison.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffAbel.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.chartValueAff_toAff
type: lean
updated: '2026-08-04T14:08:51'
---
theorem chartValueAff_toAff {π : C.left ⟶ P1 k} [IsAffineHom π]
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    {T : Over (Spec (.of k))} (s : divFamZar C π n T) :
    chartValueAff C n m Z T (divFamZarToAffVehicle C n π s) =
      chartValue C π n m Z T s := by
  rw [chartValueAff, chartValue, abelDivAff'_toAff]

omit [GeometricallyReduced C.hom] in