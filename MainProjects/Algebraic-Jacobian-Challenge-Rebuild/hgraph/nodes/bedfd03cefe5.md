---
author: sync
content_type: theorem
created: '2026-07-21T22:01:54'
decl: AlgebraicGeometry.divUniversalHighWindowRelation_zero
file: AlgebraicJacobian/Picard/DivSchemeHighWindowRelations.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.divUniversalHighWindowRelation_zero
type: lean
updated: '2026-07-31T20:14:50'
---
theorem divUniversalHighWindowRelation_zero :
    divUniversalHighWindowRelation (C := C) (pi := pi)
      hpi g r1 r2 b1 b2 i j 0 =
      (divUniversalHighWindowStageZero (C := C) (pi := pi)
        hpi g r1 r2 b1 b2 i j).toSubmodule :=
  rfl

set_option maxHeartbeats 1600000 in
-- Reducing the transported stage-one ambient exceeds the default definitional-equality budget.
@[simp]