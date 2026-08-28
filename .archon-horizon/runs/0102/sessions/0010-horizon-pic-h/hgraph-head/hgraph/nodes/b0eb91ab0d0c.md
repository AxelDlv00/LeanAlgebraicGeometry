---
author: sync
content_type: theorem
created: '2026-07-22T01:32:17'
decl: AlgebraicGeometry.divUniversalHighWindowRelationReadIdeal_one_eq_chartReadIdeal
docstring: Stage one generates exactly the genuine chart-reading ideal of the shifted
  seed.
file: AlgebraicJacobian/Picard/DivSchemeHighWindowRelationRead.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divUniversalHighWindowRelationReadIdeal_one_eq_chartReadIdeal
type: lean
updated: '2026-08-01T09:44:11'
---
theorem divUniversalHighWindowRelationReadIdeal_one_eq_chartReadIdeal
    (hO : Sheaf.h0 (C.left.moduleKSheaf k) = 1)
    (hchi : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : Int))
    (hb : 0 < windowBound pi hpi) (side : Bool) :
    divUniversalHighWindowRelationReadIdeal (C := C) (pi := pi)
        hpi g r1 r2 b1 b2 i j 1 side =
      ThetaGeneratorSeed.chartReadIdeal
        (divUniversalSeedK' C pi hpi g r1 r2 b1 b2 i j) side := by
  rw [divUniversalHighWindowRelationReadIdeal_one_eq_sndWindowChartReadIdeal
    (C := C) (pi := pi) hpi g r1 r2 b1 b2 i j hO hchi hb side]
  unfold divUniversalSndWindowChartRead ThetaGeneratorSeed.chartReadIdeal
  exact span_range_comp_surjective
    (f := ThetaGeneratorSeed.chartReadMap
      (divUniversalSeedK' C pi hpi g r1 r2 b1 b2 i j) side)
    (e := (divUniversalSeedK'Equiv C pi hpi g r1 r2 b1 b2 i j).toLinearMap)
    (divUniversalSeedK'Equiv C pi hpi g r1 r2 b1 b2 i j).surjective

set_option maxHeartbeats 2400000 in
-- The seed-anchor equality combines the two window ideal transports and persistence.
set_option synthInstance.maxHeartbeats 800000 in
-- The final comparison keeps both chart-ring seed ideals at the same dependent type.