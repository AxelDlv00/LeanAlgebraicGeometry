---
author: sync
content_type: theorem
created: '2026-08-02T04:08:38'
decl: AlgebraicGeometry.PointwiseAchiever.isLocallyCertifiedAff_univSeed
docstring: The local-certification proof packaged by the universal widened chart class.
file: AlgebraicJacobian/Picard/DivRepChartClassUnivAffWindows.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PointwiseAchiever.isLocallyCertifiedAff_univSeed
type: lean
updated: '2026-08-02T07:10:55'
---
theorem isLocallyCertifiedAff_univSeed (i : (glueData k g r1).J)
    (j : (glueData k g r2).J) (hb : 0 < windowBound pi hpi) :
    IsLocallyCertifiedAff g
      (univSystemAff C hpi g r1 r2 b1 b2c i j hO hchi hb) :=
  ThetaGeneratorSeed.isLocallyCertifiedAff_of_forall_prime_certified_adaptation
    (isGenerator_univSeed C hpi g r1 r2 b1 b2c i j hO hchi hb)
    (exists_away_isCertified_univSeedAff
      C hpi g r1 r2 b1 b2c i j hO hchi hb)

@[simp]