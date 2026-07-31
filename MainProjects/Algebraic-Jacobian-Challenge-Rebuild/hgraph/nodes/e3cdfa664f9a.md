---
author: sync
content_type: definition
created: '2026-07-17T08:41:24'
decl: AlgebraicGeometry.datumH1Equiv
docstring: '**(b) The `H¹` carrier of the datum''s glued sheaf**: degree-one cohomology
  of the

  glued sheaf of the pinned cocycle datum is `H¹` of the datum pair — the landed

  `Scheme.TwoCoverPairData.h1Equiv` fired on `D.pairData`. Instantiated at a field

  `B := κ(p)` (the fibre datum of DAT-1 stage (1d-ii)), this is step (b) of the W6-full

  discharge chain: `H¹(pair over κ(p)) ≃ Sheaf.HModule (fibre glued sheaf) 1`.'
file: AlgebraicJacobian/Cohomology/GluedSheafFibre.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.datumH1Equiv
type: lean
updated: '2026-07-31T20:15:17'
---
noncomputable def datumH1Equiv :
    Sheaf.HModule D.sheaf 1 ≃ₗ[B] (datumPair D).H1 :=
  D.pairData.h1Equiv (relCover_isAffineOpen₀ C B (fiberTwoCover π))
    (relCover_isAffineOpen₁ C B (fiberTwoCover π)) (relCover_sup C B (fiberTwoCover π))