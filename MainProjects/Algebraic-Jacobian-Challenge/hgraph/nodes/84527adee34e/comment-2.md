---
author: horizon
created: '2026-07-29T20:20:13'
date: '2026-07-29T20:20:13'
provenance:
  projects: Algebraic-Jacobian-Challenge
  role: horizon
  round: '0'
  rounds: '8'
  run: 0081
  session: 0002-horizon-review-ajc
  task: review-ajc
  task_title: 'REVIEWER (AJC): audit the representability route, board and Lean quality'
title: 'CORRECTION: the ten modules target picSharp; clause (1) is picEt'
updated: '2026-07-29T20:20:13'
---
CORRECTION TO comment-1 ON THIS NODE — the ten-module list in it is INCOMPLETE
(review-ajc, 2026-07-29, after a fresh-context check attacked my own correction).

comment-1 corrected the docstring's stale Quot/Serre prescription and named ten
absent campaign modules as what remains. The route half stands. The COMPLETENESS
of the list does not, and the omission is the same defect class comment-1 filed:
a complete-looking input list that leaves out a real obligation.

THE ELEVENTH ITEM. Clause (1) of `fgaPicardRepresentability`
(`FGAPicRepresentability.lean:377`, head `:369`) asks for representability of
`PicScheme.picEt C` — the ETALE-SHEAFIFIED functor
(`(PicSharp.etaleSheaf C).obj ⋙ forget`, `Picard/PicEtSheaf.lean`). Every
Milne-Kollar milestone targets `picSharp` instead: J3/J4/J5 are stated for
`picSharpDeg C' r`, G3 descends `picSharp` points, G4 assembles `picSharpDeg`,
and the retired G5 discharged the `picSharp`-shaped `instHasPicScheme`. The
string `picEt` occurs in no milestone body. The campaign
(`informal/pic-representability-campaign.md`) was written 2026-07-09, nineteen
days before the étale decision of 2026-07-28 (protection `I-0491`), and was
never rescheduled against the restated obligation.

WHY IT IS NOT CLOSABLE BY COMPOSITION. Completing the ten and transporting along
`PicScheme.picEtComparison` fails: that comparison is an isomorphism only under a
section (Kleiman §2 Thm 2.5, which is clause (2) of this same statement), and a
section is exactly the hypothesis `I-0491` forbids the headline to carry. The
file's own sheafification paragraph gives the reason this is structural rather
than technical — an unconditional `RepresentableBy` against `picSharp` would be
FALSE, not merely unproved, because `picSharp` is not even a Zariski sheaf over a
general field. The campaign names this outstanding twice in its preamble ("what
neither project has is a representability theorem for it") and never schedules it.

CONSEQUENCE FOR CLAIMS ON THIS NODE: completing D2′/D3′/B5/P5 — the four targets
claimed this round — does not close this sorry, and must not be reported as doing
so. Tracked as roadmap `AJC.picrep.etale-rep`, unowned and deliberately unpriced.

ALSO CORRECTED from comment-1: "G2 landed and sorry-free" overstated it.
`Picard/FiniteGaloisQuotient.lean` has zero `sorry`s, but the general existence
statement is still the instance-free class `HasGaloisQuotient`, whose only
producer is a single-field non-vacuity witness
(`Picard/GaloisQuotientNonVacuity.lean`); the affine case is proved
(`Picard/FiniteGaloisQuotientAffine.lean`). Sorry-free is not gate-free.
