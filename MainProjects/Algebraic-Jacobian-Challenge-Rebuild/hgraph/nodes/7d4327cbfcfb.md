---
author: sync
content_type: theorem
created: '2026-08-03T08:02:47'
decl: AlgebraicGeometry.universalMulMapToSnd_rTensor_residueField_surjective_at
docstring: Residue-field surjectivity at independent Euler parameter `gamma ≤ g`.
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivSecondWindowBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.universalMulMapToSnd_rTensor_residueField_surjective_at
type: lean
updated: '2026-08-18T20:50:59'
---
theorem universalMulMapToSnd_rTensor_residueField_surjective_at {gamma : ℕ}
    (hgamma : gamma ≤ g)
    (hchi : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (gamma : ℤ))
    (p : PrimeSpectrum RZ) :
    Function.Surjective
      ((universalMulMapToSnd (C := C) (π := pi)
        hpi g r1 r2 b1 b2 i j).rTensor p.asIdeal.ResidueField) := by
  rw [universalMulMapToSnd_rTensor_surjective_iff_baseChange
    (C := C) (π := pi) hpi g r1 r2 b1 b2 i j p.asIdeal.ResidueField]
  exact universalMulMapToSnd_baseChange_surjective_at
    (C := C) (pi := pi) hpi g r1 r2 b1 b2 i j
    p.asIdeal.ResidueField hgamma hchi
    (divCarveIdeal_le_ker_of_tower k
      (windowS_choice pi hpi g • fiberWeilDivisor pi)
      (windowM_choice pi hpi g • fiberWeilDivisor pi)
      g r1 r2 b1 b2 i j p.asIdeal.ResidueField)

set_option maxHeartbeats 800000 in
set_option synthInstance.maxHeartbeats 400000 in
set_option maxSynthPendingDepth 8 in