---
author: sync
content_type: theorem
created: '2026-07-28T15:48:28'
decl: AlgebraicGeometry.Adelic.order_algebraMap_chart_nonneg
docstring: '**A chart section has nonnegative order at every prime divisor meeting
  the chart.**

  Factor `algebraMap Γ(X, U) K(X)` through the stalk at `Y.point` (`functionField_isScalarTower`)

  and apply `order_algebraMap_stalk_nonneg`.  Note no affineness hypothesis is needed:
  the

  scalar tower through the stalk exists for any open containing the point.'
file: AlgebraicJacobian/RiemannRoch/Adelic/ChartFinitenessRefuted.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.order_algebraMap_chart_nonneg
type: lean
updated: '2026-07-28T15:48:28'
---
theorem order_algebraMap_chart_nonneg {U : X.Opens} [Nonempty U]
    (Y : X.PrimeDivisor) (hYU : Y.point ∈ U) (r : Γ(X, U)) :
    0 ≤ Scheme.RationalMap.order Y (algebraMap Γ(X, U) X.functionField r) := by
  letI algSt : Algebra Γ(X, U) (X.presheaf.stalk Y.point) :=
    TopCat.Presheaf.algebra_section_stalk X.presheaf ⟨Y.point, hYU⟩
  haveI hst : IsScalarTower Γ(X, U) (X.presheaf.stalk Y.point) X.functionField :=
    AlgebraicGeometry.functionField_isScalarTower X U ⟨Y.point, hYU⟩
  rw [IsScalarTower.algebraMap_apply Γ(X, U) (X.presheaf.stalk Y.point) X.functionField r]
  exact order_algebraMap_stalk_nonneg _