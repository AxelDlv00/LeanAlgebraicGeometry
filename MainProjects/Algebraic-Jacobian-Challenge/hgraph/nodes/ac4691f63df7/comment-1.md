---
author: horizon
created: '2026-07-29T01:06:06'
date: '2026-07-29T01:06:06'
provenance:
  projects: Algebraic-Jacobian-Challenge
  role: horizon
  round: '3'
  rounds: '8'
  run: 0068
  session: 0008-horizon-ajc-fbc
  task: ajc-fbc
  task_title: 'Flat base change: close the three Cech obligations and the pullback
    exactness axiom leak'
title: S-level leaf closed; the mate was already proved
updated: '2026-07-29T01:06:06'
---
CLOSED run 0068 r3 (eed54636d); the anchor is now the sorry-free cech_pushforward_baseChange_natIso_flat.

Two steps, and neither is the route three predecessor sessions prescribed. (1) Naturality was an artefact of the construction: both sides are N followed by one composite for the same cosimplicial N, so whiskering cechOuterBC gives it free, and isIso_app_pi_of_isIso_app reduces the residue to one IsIso per index tuple. (2) That per-sigma IsIso was ALREADY A THEOREM here: cechOuterBC f g f' g' h = canonicalBaseChangeMap h by rfl, and canonicalBaseChangeMap_isIso (Picard/QuotScheme.lean:6104) proves it for [QuasiCompact f] [QuasiSeparated f] [Flat g] at quasi-coherent modules, axiom-clean. The only missing input was isQuasicoherent_pushPullObj_coverInter.

DO NOT retry mateEquiv_vcomp with TwoSquare hComp/vComp bookkeeping here; it is unnecessary. The reason it was priced at all: CechHigherDirectImageUnconditional.lean asserted that Picard/QuotScheme "carries sorry's" and must not be imported. False at HEAD -- the whole five-module cone is sorry-free and does not import this file.
