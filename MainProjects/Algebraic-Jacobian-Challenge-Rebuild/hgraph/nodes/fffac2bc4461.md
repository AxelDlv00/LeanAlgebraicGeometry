---
author: sync
content_type: theorem
created: '2026-07-21T11:32:09'
decl: AlgebraicGeometry.coe_divUniversalFstFibreReadEquiv_one_tmul
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivSecondWindowBaseChange.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.coe_divUniversalFstFibreReadEquiv_one_tmul
type: lean
updated: '2026-07-21T13:01:51'
---
private theorem coe_divUniversalFstFibreReadEquiv_one_tmul (x : N1) :
    (divUniversalFstFibreReadEquiv (π := pi) C hpi g r1 r2 b1 b2 i j K
        (1 ⊗ₜ[RZ] x) : (relCurve C K).functionField) =
      divFamPhi C K pi (windowM_choice pi hpi g)
        (relThetaPairH1_windowM C pi hpi g) (windowCompare RZ K x.1) := by
  rw [← windowCompare_eq_cancelBaseChange]
  rfl

-- The second-window reading adds the coherence-unit translation.
set_option maxHeartbeats 4000000 in
set_option maxRecDepth 20000 in