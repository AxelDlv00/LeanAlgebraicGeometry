---
author: sync
content_type: theorem
created: '2026-07-28T22:22:59'
decl: AlgebraicGeometry.PointwiseAchiever.divFamEps_highWindow_eq_universal_pair
docstring: "**The DDR9-U ε-identity at the universal point, from the certificate alone**\n\
  (`informal/w4-ddr9-worksheet.md` §3.1 U2, the ε half).\n\n`ε` of the certified family\
  \ of the high-window universal seed **is** the universal\ntautological pair `(divUniversalFstWindow,\
  \ divUniversalSndWindow)`.\n\nEvery input of `ThetaGeneratorSeed.divFamEps_certifiedFamily`\
  \ other than the certificate\nis discharged at the universal point:\n\n* the generator\
  \ clause by `isGenerator_highWindowPointwiseGeneratorSeed` — note this is\n  the\
  \ *high-window pointwise* seed, whose RD-N comes from `pointwiseSeedRDN_of_highWindow`\n\
  \  and therefore needs **no** germ-divisibility input, unlike `seedUniv'`;\n* the\
  \ two `thetaGluedEval` surjectivities by\n  `DivisorAdaptation.IsCertified.thetaGluedEval_surjective`,\
  \ from the certificate itself\n  (the second window `M + s` is `≥ M`);\n* the second-window\
  \ containment by\n  `divUniversalSndWindow_le_highWindow_divisorWindow`, for this\
  \ very seed.\n\n`divUniversalSeedK` is by construction the submodule parameter the\
  \ ε-projection identity\nasks for at `x₁ = divUniversalFstWindow` (`Picard/DivSchemeSeedUniv.lean`),\
  \ which is what\nmakes the instantiation type-correct with no transport."
file: AlgebraicJacobian/Picard/DivRepChartClassUniv.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.PointwiseAchiever.divFamEps_highWindow_eq_universal_pair
type: lean
updated: '2026-07-29T15:26:31'
---
theorem divFamEps_highWindow_eq_universal_pair (hb : 0 < windowBound pi hpi)
    (hc : ((univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb).divisorAdaptation
      (isGenerator_univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb)).IsCertified g) :
    divFamEps hpi g (DivFam.mk
        ((univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb).certifiedFamily g
          (isGenerator_univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb) hc))
      = ((divUniversalFstWindow C pi hpi g r1 r2 b1 b2 i j).toSubmodule,
         (divUniversalSndWindow C pi hpi g r1 r2 b1 b2 i j).toSubmodule) :=
  ThetaGeneratorSeed.divFamEps_certifiedFamily hpi
    (divUniversalFstWindow C pi hpi g r1 r2 b1 b2 i j)
    (divUniversalSndWindow C pi hpi g r1 r2 b1 b2 i j)
    (univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb)
    (isGenerator_univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb) hc
    -- NOTE the explicit `C pi hpi`: `thetaGluedEval_surjective`'s section variables
    -- `C`, `pi`, `hpi` are EXPLICIT and precede `hc`, so the dot-notation spelling
    -- `hc.thetaGluedEval_surjective hO hchi …` does not elaborate — it feeds `hO` to
    -- the `C` binder.  Measured, not guessed (this file's first kernel check).
    (DivisorAdaptation.IsCertified.thetaGluedEval_surjective C pi hpi hc hO hchi
      (relThetaPairH1_windowM C pi hpi g) le_rfl)
    (DivisorAdaptation.IsCertified.thetaGluedEval_surjective C pi hpi hc hO hchi
      (relThetaPairH1_windowMS C pi hpi g) (Nat.le_add_right _ _))
    (divUniversalSndWindow_le_highWindow_divisorWindow
      C hpi g r1 r2 b1 b2 i j hO hchi hb)