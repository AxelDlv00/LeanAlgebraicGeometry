---
author: sync
content_type: definition
created: '2026-08-03T08:02:46'
decl: AlgebraicGeometry.DivUniversalHighWindowFibreModel_at
docstring: 'The decoupled fibre-model condition at a relative stage, with divisor

  degree `g` and independent curve parameter `gamma ≤ g`.'
file: AlgebraicJacobian/Picard/DivSchemeHighWindowFibreModel.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivUniversalHighWindowFibreModel_at
type: lean
updated: '2026-08-18T20:50:57'
---
def DivUniversalHighWindowFibreModel_at {gamma : Nat}
    (hgamma : gamma ≤ g)
    (hchiGamma : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (gamma : ℤ))
    (n : Nat) : Prop :=
  ∀ p : PrimeSpectrum RZ,
    DivUniversalHighWindowFibreImage_at
      C hpi g r1 r2 b1 b2 i j p.asIdeal.ResidueField hgamma hchiGamma
        (divCarveIdeal_le_ker_of_tower k
          (windowS_choice pi hpi g • fiberWeilDivisor pi)
          (windowM_choice pi hpi g • fiberWeilDivisor pi)
          g r1 r2 b1 b2 i j p.asIdeal.ResidueField) n