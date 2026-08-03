---
author: sync
content_type: theorem
created: '2026-08-03T08:02:46'
decl: AlgebraicGeometry.divUniversalHighWindowFibreModel_all_at
docstring: 'Every finite relation stage has the canonical off-diagonal divisor-window

  model on all residue fields.'
file: AlgebraicJacobian/Picard/DivSchemeHighWindowFibreModelInduction.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divUniversalHighWindowFibreModel_all_at
type: lean
updated: '2026-08-03T08:02:46'
---
theorem divUniversalHighWindowFibreModel_all_at (n : Nat) :
    DivUniversalHighWindowFibreModel_at
      C hpi g r1 r2 b1 b2 i j hgamma hchiGamma n :=
  (projective_and_divUniversalHighWindowFibreModel_all_at
    (C := C) (pi := pi) hpi g r1 r2 b1 b2 i j hgamma hchiGamma n).2

set_option maxHeartbeats 1600000 in
-- Synthesizing flatness unfolds the complete dependent relation quotient.
set_option synthInstance.maxHeartbeats 400000 in
include hgamma hchiGamma in