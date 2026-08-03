---
author: sync
content_type: definition
created: '2026-08-02T04:08:38'
decl: AlgebraicGeometry.PointwiseAchiever.divFamZarAffUniv
docstring: The high-window universal seed defines a widened locally certified class
  on its chart ring.
file: AlgebraicJacobian/Picard/DivRepChartClassUnivAffCertified.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PointwiseAchiever.divFamZarAffUniv
type: lean
updated: '2026-08-03T08:02:46'
---
noncomputable def divFamZarAffUniv (hb : 0 < windowBound pi hpi) :
    DivFamZarAff C RZ g :=
  (univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb)
    |>.divFamZarAff_of_forall_prime_certified_adaptation
      (isGenerator_univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb)
      (exists_away_isCertified_univSeedAff
        C hpi g r1 r2 b1 b2 i j hO hchi hb)

set_option maxHeartbeats 8000000 in
-- The local certificate assembles the widened rank and projectivity data.
set_option synthInstance.maxHeartbeats 800000 in