---
author: sync
content_type: theorem
created: '2026-08-03T08:02:46'
decl: AlgebraicGeometry.divUniversalHighWindowFibreModel_zero_at
docstring: Every residue field sees the off-diagonal canonical stage-zero image.
file: AlgebraicJacobian/Picard/DivSchemeHighWindowFibreModelBase.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divUniversalHighWindowFibreModel_zero_at
type: lean
updated: '2026-08-18T20:50:57'
---
theorem divUniversalHighWindowFibreModel_zero_at {gamma : Nat}
    (hgamma : gamma ≤ g)
    (hchiGamma : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (gamma : ℤ)) :
    DivUniversalHighWindowFibreModel_at
      C hpi g r1 r2 b1 b2 i j hgamma hchiGamma 0 := by
  intro p
  exact divUniversalHighWindowFibreImage_zero_at
    C hpi g r1 r2 b1 b2 i j p.asIdeal.ResidueField
      (divCarveIdeal_le_ker_of_tower k
        (windowS_choice pi hpi g • fiberWeilDivisor pi)
        (windowM_choice pi hpi g • fiberWeilDivisor pi)
        g r1 r2 b1 b2 i j p.asIdeal.ResidueField)
      hgamma hchiGamma

set_option maxHeartbeats 4000000 in
-- Residue-field specialization reconstructs the complete carve-chart scalar tower.
set_option synthInstance.maxHeartbeats 1000000 in