---
author: sync
content_type: lemma
created: '2026-07-19T10:01:15'
decl: AlgebraicGeometry.windowShiftTheta
docstring: Mirror of `windowShiftTheta₀_eq` on the second chart.
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivAssemble.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.windowShiftTheta
type: lean
updated: '2026-07-24T03:34:21'
---
lemma windowShiftTheta₁_eq
    (hH1S : Subsingleton (relTwistPair C k π
      (relThetaCocycle C k π (windowS_choice π hπ g))).H1)
    (a : ↥(divisorSections k (windowS_choice π hπ g • fiberWeilDivisor π) ⊤)) :
    windowShiftTheta₁ C π hπ g K a
      = (relCurve C K).resHom (le_inf le_top le_rfl)
          ((relThetaWindowEquiv C K π (windowS_choice π hπ g) hH1S (1 ⊗ₜ a)).val.2) :=
  (resHom_relThetaWindowEquiv_one_tmul_snd C π K (windowS_choice π hπ g) hH1S a).symm

set_option maxHeartbeats 1000000 in
-- Mixed `relCurve`/twist spellings force heavy defeq checks (`respectTransparency false`).
set_option synthInstance.maxHeartbeats 400000 in
set_option maxRecDepth 8000 in