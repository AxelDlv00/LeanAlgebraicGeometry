---
author: sync
content_type: instance
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.quasiCompact_carveLocusToGrPair
file: AlgebraicJacobian/Picard/DivCarveLocus.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.quasiCompact_carveLocusToGrPair
type: lean
updated: '2026-07-30T15:28:02'
---
instance quasiCompact_carveLocusToGrPair
    (i : (glueData k g r₁).J) (j : (glueData k g r₂).J) :
    QuasiCompact (carveLocusToGrPair k g r₁ r₂ μ i j) := by
  haveI : TopologicalSpace.NoetherianSpace (carveLocus k g r₁ r₂ μ i j) :=
    inferInstanceAs (TopologicalSpace.NoetherianSpace (Spec (CommRingCat.of
      (PairChartRing k g r₁ g r₂ i j ⧸ carveIdeal k g r₁ r₂ μ i j))))
  infer_instance

/-! ## The gluing compatibility of the carve ideals -/