---
author: sync
content_type: definition
created: '2026-08-03T08:02:47'
decl: AlgebraicGeometry.PointwiseAchiever.pointwiseBaseSeed_at
docstring: The decoupled pointwise section equipped with its base-locus cutter.
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivPointwiseGenerator.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PointwiseAchiever.pointwiseBaseSeed_at
type: lean
updated: '2026-08-18T20:50:59'
---
noncomputable def pointwiseBaseSeed_at {gamma : Nat}
    (hgamma : gamma ≤ g)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (gamma : ℤ)) :
    ThetaGeneratorSeed C RZ pi (windowM_choice pi hpi g)
      (divUniversalSeedK C pi hpi g r1 r2 b1 b2 i j) where
  side := pointwiseSide C hpi g r1 r2 b1 b2 i j
  h := fun z => algebraMap RZ
    Γ(relCurve C RZ,
      relPinnedChart C RZ pi (pointwiseSide C hpi g r1 r2 b1 b2 i j z))
    (exists_pointwiseBaseCutter_at
      C hpi g r1 r2 b1 b2 i j hgamma hχ z).choose
  mem_basicOpen := fun z =>
    (exists_pointwiseBaseCutter_at
      C hpi g r1 r2 b1 b2 i j hgamma hχ z).choose_spec.1
  sec := pointwiseSection_at C hpi g r1 r2 b1 b2 i j hgamma hχ
  sec_mem := pointwiseSection_mem_at C hpi g r1 r2 b1 b2 i j hgamma hχ

set_option maxHeartbeats 2400000 in
set_option synthInstance.maxHeartbeats 800000 in
set_option maxRecDepth 8000 in