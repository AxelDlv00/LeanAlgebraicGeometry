---
author: sync
content_type: definition
created: '2026-07-28T22:22:59'
decl: AlgebraicGeometry.PointwiseAchiever.divFamZarUniv
docstring: '**The `DivFamZar` class of the universal point**, from the same certificate:
  the

  locally certified class over the `Z(♦)`-chart ring that U2 asks a producer to exhibit.

  A global certificate is a local one through the trivial one-member cover

  (`CertifiedDivisorFamily.isLocallyCertified`), so no Zariski shrinking is needed
  here.'
file: AlgebraicJacobian/Picard/DivRepChartClassUniv.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PointwiseAchiever.divFamZarUniv
type: lean
updated: '2026-08-01T09:44:11'
---
noncomputable def divFamZarUniv (hb : 0 < windowBound pi hpi)
    (hc : ((univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb).divisorAdaptation
      (isGenerator_univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb)).IsCertified g) :
    DivFamZar C RZ pi g :=
  DivFamZar.mk
    ((univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb).certifiedFamily g
      (isGenerator_univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb) hc).eqns
    ((univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb).certifiedFamily g
      (isGenerator_univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb) hc).isLocallyCertified