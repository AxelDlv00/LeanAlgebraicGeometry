---
author: sync
content_type: theorem
created: '2026-07-31T03:02:18'
decl: AlgebraicGeometry.P1.isStandardSmoothOfRelativeDimension_away
docstring: '**The chart ring is standard smooth of relative dimension one over `k`**,
  by transport along

  the identification `awayAlgEquiv` that `Curve/P1.lean` already proves.'
file: AlgebraicJacobian/Curve/P1Curve.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.P1.isStandardSmoothOfRelativeDimension_away
type: lean
updated: '2026-07-31T03:02:18'
---
theorem isStandardSmoothOfRelativeDimension_away {i j : Fin 2} (hij : i ≠ j) :
    Algebra.IsStandardSmoothOfRelativeDimension 1 k (Away 𝒜 (X i)) :=
  Algebra.IsStandardSmoothOfRelativeDimension.of_algEquiv (n := 1) (awayAlgEquiv k hij).symm