---
author: sync
content_type: definition
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.pairTautSnd
docstring: '**The second tautological window** over the pair chart: the pullback of
  the

  chart-`J` tautological point along the right inclusion `R^J → R^I ⊗ R^J`.

  The `K_taut^J` of the carve.'
file: AlgebraicJacobian/Picard/DivCarveLocus.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pairTautSnd
type: lean
updated: '2026-07-31T20:15:20'
---
noncomputable def pairTautSnd (i : (glueData k g r₁).J) (j : (glueData k g r₂).J) :
    grFunctorAff k (Fin r₂ → k) g (PairChartRing k g r₁ g r₂ i j) :=
  Module.Grassmannian.map (Algebra.TensorProduct.includeRight
    (R := k) (A := ChartRing k g r₁ i.down.1))
    (chartTautologicalPoint k g r₂ j.down.1 j.down.2)