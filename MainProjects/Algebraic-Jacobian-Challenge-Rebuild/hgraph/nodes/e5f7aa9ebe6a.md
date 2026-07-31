---
author: sync
content_type: theorem
created: '2026-07-22T03:31:53'
decl: AlgebraicGeometry.relThetaResSide_relThetaSideUnit_false_true
file: AlgebraicJacobian/Picard/DivSchemeThetaKernelKill.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.relThetaResSide_relThetaSideUnit_false_true
type: lean
updated: '2026-07-31T20:15:23'
---
theorem relThetaResSide_relThetaSideUnit_false_true (a : Nat) :
    relThetaResSide a true le_rfl
        (relThetaSideUnitSection C R pi false a) =
      relFiberCoord₁ C R pi ^ a := by
  change (relCurve C R).resHom (le_inf le_top le_rfl)
      ((relThetaSectionSnd C R pi a).val.2) = relFiberCoord₁ C R pi ^ a
  rw [relThetaSectionSnd_val_snd, Scheme.resHom_resHom, Scheme.resHom_self,
    relFiberCoordOnePow_eq_pow]

/-- On the chart opposite side `true`, the true-side unit section reads as
the chart-0 coordinate power. -/
@[simp]