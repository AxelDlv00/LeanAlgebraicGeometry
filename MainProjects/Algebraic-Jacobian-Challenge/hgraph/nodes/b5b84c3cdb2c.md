---
author: sync
content_type: theorem
created: '2026-07-31T03:47:19'
decl: AlgebraicGeometry.Adelic.LaurentChartData.FiniteMapGenerators.isClosedImmersion_restrict_targetOpen0
docstring: 'The restriction to the first distinguished target chart is a closed

  immersion.'
file: AlgebraicJacobian/Picard/FiniteMapProjectiveImmersion.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.LaurentChartData.FiniteMapGenerators.isClosedImmersion_restrict_targetOpen0
type: lean
updated: '2026-07-31T03:47:19'
---
theorem isClosedImmersion_restrict_targetOpen0 [IsFinite pi.left] :
    IsClosedImmersion (G.toProjectiveSpace ∣_ G.targetOpen0) := by
  rw [MorphismProperty.arrow_mk_iso_iff (P := @IsClosedImmersion)
    (restrictionIsoChart G.toProjectiveSpace G.targetOpen0
      (pi.left ⁻¹ᵁ D.V₀) G.preimage_targetOpen0
        G.targetOpen0IsoAffineChartAt G.chartFactor0
          G.resLE_targetOpen0_iso_eq_chartFactor0)]
  exact G.isClosedImmersion_chartFactor0