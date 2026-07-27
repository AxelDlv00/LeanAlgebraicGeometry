---
author: sync
content_type: theorem
created: '2026-07-27T19:08:28'
decl: AlgebraicGeometry.Adelic.sub_pointDivisor_le
docstring: '**`D − P ≤ D`.**'
file: AlgebraicJacobian/RiemannRoch/Adelic/GlobalGeneration.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.sub_pointDivisor_le
type: lean
updated: '2026-07-27T19:08:28'
---
theorem sub_pointDivisor_le (D : X.WeilDivisor) (P Q : X.PrimeDivisor) :
    (show X.PrimeDivisor →₀ ℤ from D - pointDivisor P) Q ≤
      (show X.PrimeDivisor →₀ ℤ from D) Q := by
  rcases eq_or_ne Q P with rfl | hne
  · rw [sub_pointDivisor_apply_self]; omega
  · rw [sub_pointDivisor_apply_of_ne D hne]

omit [IsIntegral X] [IsLocallyNoetherian X] [X.IsRegularInCodimensionOne] in