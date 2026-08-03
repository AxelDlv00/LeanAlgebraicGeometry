---
author: sync
content_type: theorem
created: '2026-08-03T08:02:47'
decl: AlgebraicGeometry.PointwiseAchiever.isGenerator_pointwiseGeneratorSeed_at
docstring: Decoupled pointwise RD-N produces a theta generator.
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivPointwiseGenerator.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PointwiseAchiever.isGenerator_pointwiseGeneratorSeed_at
type: lean
updated: '2026-08-03T08:02:47'
---
theorem isGenerator_pointwiseGeneratorSeed_at {gamma : Nat}
    (hgamma : gamma ≤ g)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (gamma : ℤ))
    (hrdn : PointwiseSeedRDNAt C hpi g r1 r2 b1 b2 i j hgamma hχ) :
    (pointwiseGeneratorSeed_at
      C hpi g r1 r2 b1 b2 i j hgamma hχ hrdn).IsGenerator := by
  apply ThetaGeneratorSeed.isGenerator_productCutter
    (pointwiseBaseSeed_at C hpi g r1 r2 b1 b2 i j hgamma hχ)
    (fun z => (exists_pointwiseAnnCutter_at
      C hpi g r1 r2 b1 b2 i j hgamma hχ hrdn z).choose)
    (fun z => (exists_pointwiseAnnCutter_at
      C hpi g r1 r2 b1 b2 i j hgamma hχ hrdn z).choose_spec.1)
  · intro z psi hpsi
    exact (exists_pointwiseAnnCutter_at
      C hpi g r1 r2 b1 b2 i j hgamma hχ hrdn z).choose_spec.2 hpsi
  · exact pointwiseBaseSeed_hfib_at C hpi g r1 r2 b1 b2 i j hgamma hχ