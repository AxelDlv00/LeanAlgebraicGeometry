---
author: sync
content_type: theorem
created: '2026-08-03T08:02:46'
decl: AlgebraicGeometry.divUniversalHighWindowMulMap_fibre_conjugacy_closedAmbient_at
docstring: 'The relative successor map becomes the off-diagonal closed-ambient

  canonical multiplication map after scalar extension.'
file: AlgebraicJacobian/Picard/DivSchemeHighWindowFibreModelInduction.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divUniversalHighWindowMulMap_fibre_conjugacy_closedAmbient_at
type: lean
updated: '2026-08-18T20:50:57'
---
theorem divUniversalHighWindowMulMap_fibre_conjugacy_closedAmbient_at
    (n : Nat) [Module.Projective RZ (Amb[n] ⧸ Kr[n])]
    (himage : DivUniversalHighWindowFibreImage_at
      C hpi g r1 r2 b1 b2 i j K hgamma hchiGamma hker n)
    (x : K ⊗[RZ] DivUniversalHighWindowMulSource (C := C) (pi := pi)
      hpi g r1 r2 b1 b2 i j n Kr[n]) :
    divUniversalHighWindowClosedAmbientFibreEquiv
        (C := C) (pi := pi) hpi g r1 r2 b1 b2 i j K (n + 1)
        (LinearMap.baseChange K
          (divUniversalHighWindowMulMap (C := C) (pi := pi)
            hpi g r1 r2 b1 b2 i j n Kr[n]) x) =
      divUniversalFibreHighWindowMulMapToClosedAmbient_at
        C hpi g r1 r2 b1 b2 i j K hker hgamma hchiGamma n
        (divUniversalHighWindowMulSourceFibreEquiv_at
          C hpi g r1 r2 b1 b2 i j K hgamma hchiGamma hker n himage x) := by
  apply Subtype.ext
  simpa only [divUniversalHighWindowClosedAmbientFibreRead_apply,
    divUniversalFibreHighWindowMulMapToClosedAmbient_coe_at] using
    (divUniversalHighWindowMulMap_fibre_conjugacy_at
      (C := C) (pi := pi) hpi g r1 r2 b1 b2 i j K hgamma hchiGamma hker
        n himage x)

set_option maxHeartbeats 4000000 in
-- Rewriting the recursive range and transporting its scalar extension is reduction-heavy.
set_option synthInstance.maxHeartbeats 1000000 in
set_option maxRecDepth 20000 in