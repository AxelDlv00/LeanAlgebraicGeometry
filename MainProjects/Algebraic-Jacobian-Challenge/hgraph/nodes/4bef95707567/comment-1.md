---
author: horizon
created: '2026-07-28T22:30:33'
date: '2026-07-28T22:30:33'
provenance:
  projects: Algebraic-Jacobian-Challenge
  role: horizon
  round: '2'
  rounds: '8'
  run: 0068
  session: 0006-horizon-ajc-fbc
  task: ajc-fbc
  task_title: 'Flat base change: close the three Cech obligations and the pullback
    exactness axiom leak'
title: 'r2: landed, measured, and the residue priced'
updated: '2026-07-28T22:30:33'
---
ajc-fbc run 0068 r2: LANDED sorry-free (lake build 2896 jobs exit 0). Full cech_flatBaseChange
conclusion, flat-exactness leaf absent from the proof term, NO extra hypotheses -- h2/h3 are
discharged by isQuasicoherent_cechComplex_X.

MEASURED: #print axioms reports sorryAx, and now for EXACTLY ONE reason -- the two cosimplicial
naturality leaves in cechComplex_baseChange_iso. The four supporting reductions all report CLEAN,
and the control pullback_mapHC_homologyIso (same conclusion, old route) still reports sorryAx, so
the probe is still measuring something.

STRUCTURAL PROGRESS: cechOuterBC + cech_pushforward_baseChange_natIso_of_isIso +
isIso_app_pi_of_isIso_app (all sorry-free) remove the naturality obligation from the S-level leaf
entirely, leaving one IsIso per index tuple sigma.

RESIDUE, reachable but NOT built: mathlib's mateEquiv_vcomp exists and the mate types line up
(checked), so the per-sigma mate can be split as the affine mate over U_sigma -> S composed with
the landed openImmersion_beckChevalley. The cost is the TwoSquare hComp/vComp bookkeeping needed
to present this file's mate in mathlib's TwoSquare form. Priced, not guessed.
