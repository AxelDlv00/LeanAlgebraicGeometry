---
author: sync
content_type: theorem
created: '2026-08-03T08:02:46'
decl: AlgebraicGeometry.divUniversalHighWindowFibreModel_succ_of_projective_at
docstring: 'A projective stage carrying the off-diagonal residue-prime model passes

  that model to its successor.'
file: AlgebraicJacobian/Picard/DivSchemeHighWindowFibreModelInduction.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divUniversalHighWindowFibreModel_succ_of_projective_at
type: lean
updated: '2026-08-18T20:50:57'
---
theorem divUniversalHighWindowFibreModel_succ_of_projective_at
    (n : Nat) [Module.Projective RZ (Amb[n] ⧸ Kr[n])]
    (hmodel : DivUniversalHighWindowFibreModel_at
      C hpi g r1 r2 b1 b2 i j hgamma hchiGamma n) :
    DivUniversalHighWindowFibreModel_at
      C hpi g r1 r2 b1 b2 i j hgamma hchiGamma (n + 1) := by
  intro p
  exact divUniversalHighWindowFibreImage_succ_of_projective_at
    (C := C) (pi := pi) hpi g r1 r2 b1 b2 i j p.asIdeal.ResidueField
      (divCarveIdeal_le_ker_of_tower k
        (windowS_choice pi hpi g • fiberWeilDivisor pi)
        (windowM_choice pi hpi g • fiberWeilDivisor pi)
        g r1 r2 b1 b2 i j p.asIdeal.ResidueField)
      hgamma hchiGamma n (hmodel p)

set_option maxHeartbeats 6400000 in
-- Strong induction elaborates the projectivity and fibre-model towers together.
set_option synthInstance.maxHeartbeats 1600000 in
set_option maxRecDepth 32000 in