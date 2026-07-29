---
author: sync
content_type: definition
created: '2026-07-22T11:03:23'
decl: AlgebraicGeometry.divUniversalHighWindowAmbientCancelEquiv
docstring: 'Cancel the two-step extension `K ⊗[RZ] (RZ ⊗[k] H_n)` at an

  arbitrary high-window stage.'
file: AlgebraicJacobian/Picard/DivSchemeHighWindowFibreNormalization.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divUniversalHighWindowAmbientCancelEquiv
type: lean
updated: '2026-07-29T15:31:40'
---
noncomputable def divUniversalHighWindowAmbientCancelEquiv (n : Nat) :
    K ⊗[RZ] (RZ ⊗[k] HW[n]) ≃ₗ[K] K ⊗[k] HW[n] :=
  TensorProduct.AlgebraTensorModule.cancelBaseChange k RZ K K HW[n]

set_option maxHeartbeats 1200000 in