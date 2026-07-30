---
author: sync
content_type: theorem
created: '2026-07-24T00:31:59'
decl: AlgebraicGeometry.divUniversalFibreHighWindowInAmbientEquiv_symm_coe
file: AlgebraicJacobian/Picard/DivSchemeHighWindowFibreModelInduction.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divUniversalFibreHighWindowInAmbientEquiv_symm_coe
type: lean
updated: '2026-07-30T15:46:02'
---
theorem divUniversalFibreHighWindowInAmbientEquiv_symm_coe (n : Nat)
    (x : ↥HF[n]) :
    (((((divUniversalFibreHighWindowInAmbientEquiv
        C hpi g r1 r2 b1 b2 i j K hO hchi hker n).symm x : ↥FA[n]) :
      ↥CA[n]) : (relCurve C K).functionField)) =
      (x : (relCurve C K).functionField) := by
  simpa only [LinearEquiv.apply_symm_apply] using
    (divUniversalFibreHighWindowInAmbientEquiv_coe
      C hpi g r1 r2 b1 b2 i j K hO hchi hker n
        ((divUniversalFibreHighWindowInAmbientEquiv
          C hpi g r1 r2 b1 b2 i j K hO hchi hker n).symm x)).symm

set_option maxHeartbeats 2400000 in
-- Reducing the two nested corestrictions retains the full canonical-window expression.
set_option synthInstance.maxHeartbeats 800000 in
/-- The closed-ambient fibre successor map reads as the ordinary finite
multiplication map in the function field. -/
@[simp]