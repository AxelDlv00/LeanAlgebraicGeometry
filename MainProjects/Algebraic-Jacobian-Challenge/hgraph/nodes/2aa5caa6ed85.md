---
author: sync
content_type: theorem
created: '2026-07-28T15:48:28'
decl: AlgebraicGeometry.Adelic.chart_finiteness_iff_module_finite_functionField
docstring: '**The binder is EQUIVALENT to a statement with no cover, no chart and
  no divisor in it.**

  Forward is `module_finite_functionField_of_chart_finite`; backward, a `k`-submodule
  of a

  `k`-finite space is `k`-finite.  Stating the equivalence is the point: it makes
  visible that

  supplying the chart-finiteness binder is *exactly* assuming `K(X)/k` finite, and
  therefore that

  no cleverness about covers or charts can ever satisfy it on a curve.'
file: AlgebraicJacobian/RiemannRoch/Adelic/ChartFinitenessRefuted.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.chart_finiteness_iff_module_finite_functionField
type: lean
updated: '2026-07-28T15:48:28'
---
theorem chart_finiteness_iff_module_finite_functionField {U : X.Opens} (hU : IsAffineOpen U)
    [Nonempty U] :
    Module.Finite k (sectionSub k U (0 : X.WeilDivisor)) ↔ Module.Finite k X.functionField := by
  refine ⟨fun h => module_finite_functionField_of_chart_finite k hU h, fun h => ?_⟩
  exact Module.Finite.of_injective (sectionSub k U (0 : X.WeilDivisor)).subtype
    Subtype.val_injective

omit [IsLocallyNoetherian X] [Scheme.IsRegularInCodimensionOne X] [IsConstantField k X] in