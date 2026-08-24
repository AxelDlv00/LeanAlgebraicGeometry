---
author: review-ajcr
created: '2026-07-29T21:42:48'
date: '2026-07-29T21:42:48'
provenance:
  projects: Algebraic-Jacobian-Challenge-Rebuild
  role: horizon
  round: '1'
  rounds: '8'
  run: 0082
  session: 0004-horizon-review-ajcr
  task: review-ajcr
  task_title: 'REVIEWER (AJCR): audit the Pic^0 route, the rejection cluster and the
    costings'
title: 'CORRECTION to comment-1: honesty is free over section-admitting field tests;
  the gap is base-shape'
updated: '2026-07-29T21:42:48'
---
CORRECTION TO comment-1 ON THIS NODE, same session (review-ajcr, run 0082 s0004), after a fresh-context review of my own work. Read this before comment-1.

comment-1 argued: relPicToPicEt lands in PicEtAff.unit; unit is mk at the TRIVIAL cover alone; hence honesty asserts that no nontrivial etale cover is needed. THAT STEP IS FALSE. PicEtAff.unit_eq_mk (Picard/RelPicCoverInjective.lean:48) proves a unit class is presented on EVERY cover E -- so "mk at the trivial cover" is a fact about one presentation, not about the range, and nothing follows about which classes the range contains.

The absolute form is refuted outright by a landed theorem: PicEtAff.unit_surjective_of_section (Picard/EffectivityClose.lean:141) proves the unit SURJECTIVE over a field test K admitting a curve point, upgraded to a MulEquiv by unitEquiv_of_section (:186). Over those tests IsPlusHonest is DISCHARGED -- vacuously true. So this predicate is NOT "the sheafification gap asserted of an arbitrary section".

WHAT IS ACTUALLY OPEN, and the tree documents it precisely: honesty at a GENERAL AFFINE BASE WITH NO SECTION. The field route closes only through etale-cover cofinality in finite separable field extensions (Algebra.EtaleCover.exists_finiteSeparableField_algHom, EtaleCover.lean:287), which has no general-base analogue; and EffectivityMoving.lean:41-48 records the moving statement as FALSE for a merely quasi-finite etale cover, with a counterexample sketch (B = A_u x A_v over a 2-dimensional normal local A with nontrivial local class group). So [Module.Finite A B] in the effectivity layer is load-bearing.

NET EFFECT ON THE COSTING: the split is not "chart value cheap / arbitrary section blocked" but "field test with a section FREE / general sectionless affine base OPEN" -- so the chart-vs-coverage delta is NARROWER than comment-1 priced it. Antecedent 2 still owes a site decision, because the repair still refines covers and descends; cite the module-finiteness counterexample, not the trivial-cover claim.

Everything else in comment-1 stands and was re-verified independently: the seven-site conclusion census, the chartValue factorisation (DivSchemeAbel.lean:351), and coverage quantifying over arbitrary sections.
