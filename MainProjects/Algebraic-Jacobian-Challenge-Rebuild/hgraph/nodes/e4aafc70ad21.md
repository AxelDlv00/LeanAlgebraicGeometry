---
author: sync
content_type: theorem
created: '2026-07-22T01:32:17'
decl: AlgebraicGeometry.divUniversalHighWindowChartRead_one_comp_oneEquiv_eq_sndWindowChartRead
file: AlgebraicJacobian/Picard/DivSchemeHighWindowRelationRead.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divUniversalHighWindowChartRead_one_comp_oneEquiv_eq_sndWindowChartRead
type: lean
updated: '2026-07-22T02:02:01'
---
theorem divUniversalHighWindowChartRead_one_comp_oneEquiv_eq_sndWindowChartRead
    (side : Bool) :
    ((divUniversalHighWindowChartRead (C := C) (pi := pi)
      hpi g r1 r2 b1 b2 i j 1 side).comp
      (LinearMap.baseChange RZ
        (divUniversalHighWindowOneEquiv (C := C) (pi := pi) hpi g).toLinearMap)).comp
        (divUniversalSndWindow C pi hpi g r1 r2 b1 b2 i j).toSubmodule.subtype =
      divUniversalSndWindowChartRead C hpi g r1 r2 b1 b2 i j side := by
  ext x
  change relThetaResSide
      (divUniversalHighWindowExponent (C := C) (pi := pi) hpi g 1)
      side le_rfl
      (relThetaWindowEquiv C RZ pi
        (divUniversalHighWindowExponent (C := C) (pi := pi) hpi g 1)
        (relThetaPairH1_windowM_add_mulS C pi hpi g 1)
        (LinearMap.baseChange RZ
          (divUniversalHighWindowOneEquiv (C := C) (pi := pi) hpi g).toLinearMap
          x)) =
    relThetaResSide
      (windowM_choice pi hpi g + windowS_choice pi hpi g) side le_rfl
      (relThetaWindowEquiv C RZ pi
        (windowM_choice pi hpi g + windowS_choice pi hpi g)
        (relThetaPairH1_windowMS C pi hpi g) x)
  have hone : windowM_choice pi hpi g + windowS_choice pi hpi g =
      divUniversalHighWindowExponent (C := C) (pi := pi) hpi g 1 := by
    simp [divUniversalHighWindowExponent]
  have hmap :
      (divUniversalHighWindowOneEquiv (C := C) (pi := pi) hpi g).toLinearMap =
        (divisorWindowExponentEquiv (C := C) (pi := pi) hone).toLinearMap := by
    apply LinearMap.ext
    intro y
    rfl
  rw [hmap]
  exact relThetaResSide_relThetaWindowEquiv_baseChange_ofEq_seed
    (C := C) (pi := pi) hone
    (relThetaPairH1_windowMS C pi hpi g)
    (relThetaPairH1_windowM_add_mulS C pi hpi g 1)
    RZ side x

set_option maxHeartbeats 2400000 in
-- The zero-stage ideal comparison repeats the mapped-submodule range reduction.
set_option synthInstance.maxHeartbeats 800000 in
-- The first-window seed equivalence carries the chart-ring dependent subtype.