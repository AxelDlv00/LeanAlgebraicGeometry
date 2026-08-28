---
author: sync
content_type: theorem
created: '2026-07-21T15:02:24'
decl: AlgebraicGeometry.divUniversalSeedK'Equiv_val
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivMulIdeal.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.divUniversalSeedK'Equiv_val
type: lean
updated: '2026-07-21T15:32:03'
---
private theorem divUniversalSeedK'Equiv_val (x : N2) :
    (divUniversalSeedK'Equiv C pi hpi g r1 r2 b1 b2 i j x).val =
      relThetaWindowEquiv C RZ pi
        (windowM_choice pi hpi g + windowS_choice pi hpi g)
        (relThetaPairH1_windowMS C pi hpi g) x.1 := by
  rfl

-- This identity is valid over the chart ring itself; the field-only assembly
-- wrapper is intentionally not used here.
set_option maxHeartbeats 1000000 in
set_option synthInstance.maxHeartbeats 400000 in
set_option maxRecDepth 8000 in