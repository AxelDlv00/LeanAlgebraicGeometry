---
author: sync
content_type: theorem
created: '2026-07-22T01:02:01'
decl: AlgebraicGeometry.exists_divUniversalHighWindowMultiplierChartRead_mul_eq_one
docstring: The multiplier-window basis readings generate the unit ideal on either
  pinned chart.
file: AlgebraicJacobian/Picard/DivSchemeHighWindowRelationReadSuccessor.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.exists_divUniversalHighWindowMultiplierChartRead_mul_eq_one
type: lean
updated: '2026-07-31T20:14:46'
---
theorem exists_divUniversalHighWindowMultiplierChartRead_mul_eq_one (side : Bool) :
    ∃ c : Fin (Module.finrank k HS) →
        Γ(relCurve C RZ, relPinnedChart C RZ pi side),
      ∑ t, c t * divUniversalHighWindowMultiplierChartRead
        (C := C) (pi := pi) hpi g r1 r2 b1 b2 i j side
          ((Module.finBasis k HS) t) = 1 := by
  simpa only [divUniversalHighWindowMultiplierChartRead,
    relThetaWindowChartRead, LinearMap.comp_apply, LinearEquiv.coe_coe] using
      (exists_basis_relThetaWindowChartRead_mul_eq_one C RZ pi
        (windowS_choice pi hpi g) (Module.finBasis k HS)
        (relThetaPairH1_windowS C hpi g) side)

set_option maxHeartbeats 4800000 in
-- Successor reading compatibility unfolds two high-window theta dictionaries.
set_option synthInstance.maxHeartbeats 1200000 in
-- The carve-chart ring and both dependent tensor ambients make instance search expensive.