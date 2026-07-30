---
author: sync
content_type: theorem
created: '2026-07-22T01:02:01'
decl: AlgebraicGeometry.divUniversalHighWindowTensorMultiplierTransition_tmul
file: AlgebraicJacobian/Picard/DivSchemeHighWindowTransitionRelation.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divUniversalHighWindowTensorMultiplierTransition_tmul
type: lean
updated: '2026-07-30T15:46:02'
---
theorem divUniversalHighWindowTensorMultiplierTransition_tmul
    (n : Nat) (r : RZ) (a : HS) :
    divUniversalHighWindowTensorMultiplierTransition (C := C) (pi := pi)
        hpi g r1 r2 b1 b2 i j n (r ⊗ₜ a) =
      r • divUniversalHighWindowBaseMultiplierTransition (C := C) (pi := pi)
        hpi g r1 r2 b1 b2 i j n a := by
  rw [divUniversalHighWindowTensorMultiplierTransition,
    LinearMap.liftBaseChange_tmul, LinearMap.comp_apply,
    LinearMap.baseChangeHom_apply,
    divUniversalHighWindowBaseMultiplierTransition]

set_option maxHeartbeats 4800000 in
-- The finite dependent source and high-window ambient require extended reduction.
set_option synthInstance.maxHeartbeats 1200000 in
-- Basis coordinates require dependent module and zero-map instances.