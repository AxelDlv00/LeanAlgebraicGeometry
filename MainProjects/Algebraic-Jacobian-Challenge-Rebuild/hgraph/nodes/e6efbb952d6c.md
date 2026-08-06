---
author: sync
content_type: theorem
created: '2026-08-03T08:02:46'
decl: AlgebraicGeometry.divUniversalHighWindowKernelSyzygySpans_of_adjacent_fibreModels_at
docstring: 'Adjacent projective off-diagonal fibre models span every residue-field

  kernel of the successor presentation.'
file: AlgebraicJacobian/Picard/DivSchemeHighWindowRelationKoszulConjugacy.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divUniversalHighWindowKernelSyzygySpans_of_adjacent_fibreModels_at
type: lean
updated: '2026-08-07T05:01:48'
---
theorem divUniversalHighWindowKernelSyzygySpans_of_adjacent_fibreModels_at
    (n : Nat)
    [Module.Projective RZ (Amb[n] ⧸ Kr[n])]
    [Module.Projective RZ (Amb[n + 1] ⧸ Kr[n + 1])]
    (hmodel : DivUniversalHighWindowFibreModel_at
      C hpi g r1 r2 b1 b2 i j hgamma hchiGamma n)
    (hmodelNext : DivUniversalHighWindowFibreModel_at
      C hpi g r1 r2 b1 b2 i j hgamma hchiGamma (n + 1)) :
    DivUniversalHighWindowSyzygySpans (C := C) (pi := pi)
      hpi g r1 r2 b1 b2 i j (n + 1) Kr[n + 1]
      (divUniversalHighWindowKernelSyzygy (C := C) (pi := pi)
        hpi g r1 r2 b1 b2 i j (n + 1) Kr[n + 1]) := by
  apply (divUniversalHighWindowKernelSyzygySpans_iff
    (C := C) (pi := pi) hpi g r1 r2 b1 b2 i j (n + 1) Kr[n + 1]).2
  intro p
  exact
    divUniversalHighWindowRelationMul_liftQ_rTensor_injective_of_fibre_models_at
      (C := C) (pi := pi) hpi g r1 r2 b1 b2 i j p.asIdeal.ResidueField
        (divCarveIdeal_le_ker_of_tower k
          (windowS_choice pi hpi g • fiberWeilDivisor pi)
          (windowM_choice pi hpi g • fiberWeilDivisor pi)
          g r1 r2 b1 b2 i j p.asIdeal.ResidueField)
        hgamma hchiGamma n (hmodel p) (hmodelNext p)

set_option maxHeartbeats 3200000 in
-- The projectivity consumer unfolds the dependent successor relation quotient.
set_option synthInstance.maxHeartbeats 800000 in