---
author: sync
content_type: theorem
created: '2026-08-03T08:02:46'
decl: AlgebraicGeometry.PointwiseAchiever.exists_certifiedFamily_divFamEps_eq_universal_pair_at
docstring: The existential universal family at independent Euler parameter `gamma
  ≤ g`.
file: AlgebraicJacobian/Picard/DivRepChartClassUniv.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PointwiseAchiever.exists_certifiedFamily_divFamEps_eq_universal_pair_at
type: lean
updated: '2026-08-18T20:50:56'
---
theorem exists_certifiedFamily_divFamEps_eq_universal_pair_at {gamma : Nat}
    (hgamma : gamma ≤ g)
    (hchiGamma : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (gamma : Int))
    (hc : ((univSeed_at C hpi g r1 r2 b1 b2 i j hgamma hchiGamma).divisorAdaptation
      (isGenerator_univSeed_at C hpi g r1 r2 b1 b2 i j hgamma hchiGamma)).IsCertified g) :
    ∃ G : CertifiedDivisorFamily C RZ pi g,
      divFamEps hpi g (DivFam.mk G)
        = ((divUniversalFstWindow C pi hpi g r1 r2 b1 b2 i j).toSubmodule,
           (divUniversalSndWindow C pi hpi g r1 r2 b1 b2 i j).toSubmodule) :=
  ⟨_, divFamEps_highWindow_eq_universal_pair_at
    C hpi g r1 r2 b1 b2 i j hgamma hchiGamma hc⟩