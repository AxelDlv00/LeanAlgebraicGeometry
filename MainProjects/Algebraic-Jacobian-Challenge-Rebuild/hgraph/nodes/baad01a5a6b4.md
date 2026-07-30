---
author: sync
content_type: theorem
created: '2026-07-24T03:02:02'
decl: AlgebraicGeometry.PointwiseAchiever.isGenerator_pointwiseGeneratorSeed
docstring: Pointwise RD-N produces an unconditional theta generator.
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivPointwiseGenerator.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.PointwiseAchiever.isGenerator_pointwiseGeneratorSeed
type: lean
updated: '2026-07-30T15:28:03'
---
theorem isGenerator_pointwiseGeneratorSeed
    (hrdn : PointwiseSeedRDN C hpi g r1 r2 b1 b2 i j hO hchi) :
    (pointwiseGeneratorSeed C hpi g r1 r2 b1 b2 i j hO hchi hrdn).IsGenerator := by
  apply ThetaGeneratorSeed.isGenerator_productCutter
    (pointwiseBaseSeed C hpi g r1 r2 b1 b2 i j hO hchi)
    (fun z => (exists_pointwiseAnnCutter
      C hpi g r1 r2 b1 b2 i j hO hchi hrdn z).choose)
    (fun z => (exists_pointwiseAnnCutter
      C hpi g r1 r2 b1 b2 i j hO hchi hrdn z).choose_spec.1)
  · intro z psi hpsi
    exact (exists_pointwiseAnnCutter
      C hpi g r1 r2 b1 b2 i j hO hchi hrdn z).choose_spec.2 hpsi
  · exact pointwiseBaseSeed_hfib C hpi g r1 r2 b1 b2 i j hO hchi