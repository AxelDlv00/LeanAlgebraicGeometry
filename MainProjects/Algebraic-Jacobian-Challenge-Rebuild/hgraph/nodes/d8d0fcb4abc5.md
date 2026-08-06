---
author: sync
content_type: theorem
created: '2026-08-03T08:02:46'
decl: AlgebraicGeometry.PointwiseAchiever.isGenerator_univSeed_at
docstring: The generator clause of the off-diagonal universal seed.
file: AlgebraicJacobian/Picard/DivRepChartClassUniv.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PointwiseAchiever.isGenerator_univSeed_at
type: lean
updated: '2026-08-07T05:01:47'
---
theorem isGenerator_univSeed_at {gamma : Nat} (hgamma : gamma ≤ g)
    (hchiGamma : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (gamma : Int)) :
    (univSeed_at C hpi g r1 r2 b1 b2 i j hgamma hchiGamma).IsGenerator :=
  isGenerator_highWindowPointwiseGeneratorSeed_at
    C hpi g r1 r2 b1 b2 i j hgamma hchiGamma

set_option maxHeartbeats 2400000 in
-- The composite instantiates the ε-projection identity at the universal windows over the
-- heavy `DivCarveChartRing` / `relThetaSections` types; same profile as the two inputs.
set_option synthInstance.maxHeartbeats 800000 in