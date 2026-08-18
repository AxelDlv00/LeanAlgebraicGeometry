---
author: sync
content_type: theorem
created: '2026-08-03T18:38:51'
decl: AlgebraicGeometry.P1FiniteMap.FiniteMapGenerators.isClosedImmersion_restrict_targetOpen0
docstring: The restriction to the first target chart is a closed immersion.
file: AlgebraicJacobian/Projective/FiniteMapToP1.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.P1FiniteMap.FiniteMapGenerators.isClosedImmersion_restrict_targetOpen0
type: lean
updated: '2026-08-18T20:51:07'
---
theorem isClosedImmersion_restrict_targetOpen0
    (hpi : pi ≫ P1.structureMap k = C.hom) [IsFinite pi] :
    IsClosedImmersion (G.toProjectiveSpace ∣_ G.targetOpen0) := by
  rw [MorphismProperty.arrow_mk_iso_iff (P := @IsClosedImmersion)
    (restrictionIsoChart G.toProjectiveSpace G.targetOpen0
      (pi ⁻¹ᵁ P1.chartOpen k 0) G.preimage_targetOpen0
        G.targetOpen0IsoAffineChartAt G.chartFactor0
          G.resLE_targetOpen0_iso_eq_chartFactor0)]
  exact G.isClosedImmersion_chartFactor0 hpi