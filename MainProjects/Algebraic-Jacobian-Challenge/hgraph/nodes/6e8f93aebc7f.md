---
author: sync
content_type: theorem
created: '2026-07-31T02:29:39'
decl: AlgebraicGeometry.Adelic.LaurentChartData.FiniteMapGenerators.lifted_compatible
docstring: The lifted generator families retain the aligned overlap equation.
file: AlgebraicJacobian/Picard/FiniteMapProjectiveCoordinates.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.LaurentChartData.FiniteMapGenerators.lifted_compatible
type: lean
updated: '2026-07-31T02:29:39'
---
theorem lifted_compatible (i : G.LiftedIndex) :
    D.sourceRestriction0 pi (G.liftedAA i) =
      D.sourceRestriction0 pi (D.pullbackX pi) ^ G.d *
        D.sourceRestriction1 pi (G.liftedBB i) := by
  exact G.compatible i.down