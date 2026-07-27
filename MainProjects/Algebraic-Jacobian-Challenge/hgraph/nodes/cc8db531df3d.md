---
author: sync
content_type: theorem
created: '2026-07-27T15:50:35'
decl: AlgebraicGeometry.Adelic.h1dim_eq_of_shift
docstring: '**`h¹` is invariant under the class shift `D ↦ D − div g`.**'
file: AlgebraicJacobian/RiemannRoch/Adelic/ClassInvariance.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.h1dim_eq_of_shift
type: lean
updated: '2026-07-27T15:50:35'
---
theorem h1dim_eq_of_shift {D D' : X.WeilDivisor} {g : X.functionField}
    (hg : g ≠ 0)
    (hD' : ∀ P : X.PrimeDivisor, (show X.PrimeDivisor →₀ ℤ from D') P =
      (show X.PrimeDivisor →₀ ℤ from D) P - Scheme.RationalMap.order P g) :
    h1dim k U₀ U₁ D' = h1dim k U₀ U₁ D :=
  ((h1ModMulEquiv k U₀ U₁ hg hD').symm).finrank_eq