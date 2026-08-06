---
author: sync
content_type: theorem
created: '2026-08-03T08:02:47'
decl: AlgebraicGeometry.chartReadIdeal_divUniversalSeedK'_eq_divUniversalSeedK_of_unitGeneration_at
docstring: 'Under explicit multiplier unit generation, the two genuine degree-`g`

  chart-reading ideals agree at independent Euler parameter `gamma ≤ g`.'
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivMulIdeal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.chartReadIdeal_divUniversalSeedK'_eq_divUniversalSeedK_of_unitGeneration_at
type: lean
updated: '2026-08-07T05:01:50'
---
theorem chartReadIdeal_divUniversalSeedK'_eq_divUniversalSeedK_of_unitGeneration_at
    {gamma : ℕ}
    (hgamma : gamma ≤ g)
    (hchi : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (gamma : ℤ))
    (b : Bool)
    (hunit : DivUniversalMultiplierChartUnitGeneration
      C hpi g r1 r2 b1 b2 i j b) :
    ThetaGeneratorSeed.chartReadIdeal
        (divUniversalSeedK' C pi hpi g r1 r2 b1 b2 i j) b =
      ThetaGeneratorSeed.chartReadIdeal
        (divUniversalSeedK C pi hpi g r1 r2 b1 b2 i j) b := by
  apply le_antisymm
  · exact chartReadIdeal_divUniversalSeedK'_le_divUniversalSeedK_at
      (C := C) (pi := pi) hpi g r1 r2 b1 b2 i j hgamma hchi b
  · rw [ThetaGeneratorSeed.chartReadIdeal, ThetaGeneratorSeed.chartReadIdeal]
    calc
      Ideal.span (Set.range (ThetaGeneratorSeed.chartReadMap
          (divUniversalSeedK C pi hpi g r1 r2 b1 b2 i j) b)) =
          Ideal.span (Set.range (divUniversalFstWindowChartRead
            C hpi g r1 r2 b1 b2 i j b)) := by
        simpa only [divUniversalFstWindowChartRead] using
          (span_range_comp_linearEquiv_eq
            (ThetaGeneratorSeed.chartReadMap
              (divUniversalSeedK C pi hpi g r1 r2 b1 b2 i j) b)
            (divUniversalSeedKEquiv C pi hpi g r1 r2 b1 b2 i j)).symm
      _ ≤ Ideal.span (Set.range (divUniversalSndWindowChartRead
          C hpi g r1 r2 b1 b2 i j b)) :=
        span_range_divUniversalFstWindowChartRead_le_snd_of_unitGeneration
          (C := C) (pi := pi) hpi g r1 r2 b1 b2 i j b hunit
      _ = Ideal.span (Set.range (ThetaGeneratorSeed.chartReadMap
          (divUniversalSeedK' C pi hpi g r1 r2 b1 b2 i j) b)) := by
        simpa only [divUniversalSndWindowChartRead] using
          span_range_comp_linearEquiv_eq
            (ThetaGeneratorSeed.chartReadMap
              (divUniversalSeedK' C pi hpi g r1 r2 b1 b2 i j) b)
            (divUniversalSeedK'Equiv C pi hpi g r1 r2 b1 b2 i j)

set_option maxHeartbeats 1600000 in
set_option synthInstance.maxHeartbeats 600000 in
set_option maxRecDepth 8000 in