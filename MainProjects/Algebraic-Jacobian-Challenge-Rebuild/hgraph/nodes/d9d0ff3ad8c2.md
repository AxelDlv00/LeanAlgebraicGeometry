---
author: sync
content_type: definition
created: '2026-07-24T03:02:02'
decl: AlgebraicGeometry.PointwiseAchiever.pointwiseGeneratorSeed
docstring: Multiply the pointwise base-locus seed by the RD-N annihilator cutter.
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivPointwiseGenerator.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.PointwiseAchiever.pointwiseGeneratorSeed
type: lean
updated: '2026-07-30T15:28:04'
---
noncomputable def pointwiseGeneratorSeed
    (hrdn : PointwiseSeedRDN C hpi g r1 r2 b1 b2 i j hO hchi) :
    ThetaGeneratorSeed C RZ pi (windowM_choice pi hpi g)
      (divUniversalSeedK C pi hpi g r1 r2 b1 b2 i j) :=
  ThetaGeneratorSeed.productCutter
    (pointwiseBaseSeed C hpi g r1 r2 b1 b2 i j hO hchi)
    (fun z => (exists_pointwiseAnnCutter
      C hpi g r1 r2 b1 b2 i j hO hchi hrdn z).choose)
    (fun z => (exists_pointwiseAnnCutter
      C hpi g r1 r2 b1 b2 i j hO hchi hrdn z).choose_spec.1)

set_option maxHeartbeats 2400000 in
-- The generator theorem aligns the ann-cutter containment with base-seed nonvanishing.
set_option synthInstance.maxHeartbeats 800000 in
set_option maxRecDepth 8000 in