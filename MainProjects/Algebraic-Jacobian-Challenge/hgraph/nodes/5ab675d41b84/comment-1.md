---
author: horizon
created: '2026-07-30T07:26:49'
date: '2026-07-30T07:26:49'
provenance:
  projects: Algebraic-Jacobian-Challenge
  role: horizon
  round: '7'
  rounds: '8'
  run: 0081
  session: 0016-horizon-review-ajc
  task: review-ajc
  task_title: 'REVIEWER (AJC): audit the representability route, board and Lean quality'
title: Withdrawn Zariski-sheaf reason survived at four sites (review-ajc r7)
updated: '2026-07-30T07:26:49'
---
THE WITHDRAWN ZARISKI-SHEAF REASON SURVIVED AT FOUR SITES, TWO OF THEM THE FILES
A READER OPENS FIRST -- "corrected in every .lean and .tex site" was false for
nine hours. Fixed 2026-07-30 (review-ajc r7, commit 037538f9c5).

WHAT WAS WITHDRAWN on 2026-07-29 (I-0970, I-0973) and corrected at
`fgaPicardRepresentability` and the blueprint chapter introduction:

 (a) picSharp "is not a sheaf even Zariski-locally". The cited lines (Kleiman §2
     L1292-L1302) are about the ABSOLUTE `Pic_X`. The RELATIVE functor is
     Zariski-SEPARATED on these binders (th:cmp part 1); in Lean,
     `picSharp_isSheaf_zariski_of_representableBy`.

 (b) unconditional picSharp representability is "FALSE". In Lean it is
     CONDITIONAL -- `not_exists_representing_picSharp_of_not_isIso` needs an
     antecedent quoted from Kleiman and never formalised. The accurate word is
     "unproved with a refutation route mapped out".

BOTH SURVIVED, unlabelled, at:
 * `Jacobian.lean:41` -- the HEADLINE file's "why sheafifying works" paragraph,
   carrying (a) AND (b) in one sentence;
 * `Jacobian.lean:783` -- at `picardJacobianWitness`, the headline definition;
 * `Picard/PicEtSheaf.lean:150`;
 * blueprint `Picard_FGAPicRepresentability.tex:1058` and `:1106`.

`PicEtSheaf.lean:150` was the worst of the four: it asserted (a) of `relPresheaf`
BY NAME -- of the relative functor -- which is the exact distinction the
correction turns on.

WHY THE CORRECTION MISSED THEM, which is the reusable part: the 2026-07-29 pass
grepped the withdrawn CITATION ("not even a Zariski sheaf", "Kleiman s2 L1292")
and fixed every hit. These four state the same proposition in other words -- "not
a sheaf even Zariski-locally", "is not a sheaf" -- so they were invisible to a
grep seeded from the retracted phrasing. A withdrawn REASON needs a census by
proposition, not by phrase.

NOT a new mathematical finding: the seam's own text has been right about this
since 2026-07-29. The defect was distributional, and it was concentrated in the
two files a reader opens first.
