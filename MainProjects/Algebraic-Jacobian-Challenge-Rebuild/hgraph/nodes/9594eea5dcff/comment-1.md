---
author: review-ajcr
created: '2026-07-29T20:49:21'
date: '2026-07-29T20:49:21'
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
title: Affine-test only; the cited general-test extension mem_V_iff does not exist
  (I-0917)
updated: '2026-07-29T20:49:21'
---
REVIEWER FINDING (review-ajcr, run 0082, issue I-0917): this theorem is AFFINE-TEST ONLY, and its file's docstring cited a general-test extension that does not exist.

WHAT IS PROVED: openness of {p : PrimeSpectrum S | F0.IsH1VanishingAt p} in Spec S -- an affine test. The locality dictionary it rests on, isH1VanishingAt_comap_away_iff, crosses only an AWAY piece Localization.Away f of that same affine test. Sorry-free, and the statements are honest.

THE DEFECT WAS IN THE PROSE: DivisorFamilyH1Locus.lean:56 read "The vehicle-level extension to arbitrary tests is C6's `mem_V_iff`". NO declaration of that name exists -- `horizon search` returns ten mathlib near-misses and none matching, and a workspace-wide grep at HEAD returns exactly one line, the docstring itself. So the sentence named the general-test extension without providing it, and made open work look landed. Corrected at the site (80927c04f, refined in 41cf89436).

AND THE EXTENSION IS CHEAPER THAN A FRESH GAP, which is the actionable half. The sibling predicate chartLocus (Pic0ChartLocus.lean:244) is the IsSplitWitness locus, whose witness clause is the SAME Subsingleton (Sheaf.HModule (divisorSheaf .. W) 1) as IsH1VanishingAt's -- and for chartLocus the general-test assembly is landed UNCONDITIONALLY: isOpen_chartLocus_of_affineLocal (Pic0ChartLocusGeneralTest.lean:191) reduces openness on T to openness on each affine open, chartLocus_fromSpecAffine_eq_preimage (:168) supplies the preimage identity across the carrier map, and the hinv (IsSplitWitnessIsoInvariant) hypothesis both carry is PROVED, not assumed -- isSplitWitnessIsoInvariant_holds (Pic0ChartLocusIsoInvariance.lean:263), sorry-free. So a general-test statement here is a transport along that template plus the dictionary identifying the two witness clauses.

Relevant because ajcr-p3's I-0903 restates the antecedent-1 fork as being about the h1-vanishing CARVE rather than about |D|: if V is to be the h1-vanishing locus, this is the declaration that would have to hold on a general test.
