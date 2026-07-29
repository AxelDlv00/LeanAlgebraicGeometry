---
author: ajc-p2
created: '2026-07-29T22:42:06'
date: '2026-07-29T22:42:06'
provenance:
  projects: Algebraic-Jacobian-Challenge
  role: horizon
  round: '1'
  rounds: '8'
  run: 0084
  session: 0004-horizon-ajc-p2
  task: ajc-p2
  task_title: 'AJC prover p2: claim and close the 2nd-most important representability
    item'
title: The chain restates at Pic0SchemeEt; the residue's carrier is the sheafification
updated: '2026-07-29T22:42:06'
---
MEASURED by ajc-p2 (run 0084). This node's development is stated for Pic0Scheme (picSharp side, [HasPicScheme C], no instance). Jacobian.lean:418-421 priced carrying it to the ETALE Pic0SchemeEt as needing 'the comparison of the two Picard schemes, available only under a section' — what protection I-0491 forbids the headline to carry.

FALSE. Every engine of the dual-number leg is generic in (functor, RepresentableBy): pointedDualNumberPointsEquivAddKernel (Pic0DualNumberCocycle.lean:430), pointedDualNumberPointsEquivOfOpenImmersion (Pic0TangentSpace.lean:160), overDualNumberSectionEquivCotangentSpaceDual (TangentSpaceIdentitySection.lean:123), nonempty_cotangentSpaceAddEquiv_of_finrank_eq (:93). picSharp entered only at Pic0AbelianVariety.lean:538-539. Applying them at (PicSharp.etaleSheaf C).obj with representableEt gives the whole chain: Picard/Pic0EtTangentSpace.lean (952c13f09, 4ed49a1c8, 8267a5be2), 11 declarations, no new sorry, lake build EXIT=0 (8699 jobs), including the etale counterpart of THIS node (Pic0Et.tangentSpaceIso).

THE PART THAT IS NOT FREE, and a later reader should not lose it. The etale dimension identity is an implication from one named antecedent, SemilinearCotangentComparisonEt, which is clause-for-clause this node's own open residue (semilinearComparison_cotangentSpaceDual_h1Cok, Pic0AbelianVariety.lean:838) but at a DIFFERENT CARRIER: the etale kernel is a kernel of the SHEAFIFICATION, this one's is a quotient of LineBundle.OnProduct. No lemma in the project bridges them without a section. So one hypothesis rather than two, and strictly harder than its namesake (I-0989, from a fresh-context audit that refuted my own 'same statement' claim).

Also: everything on both sides binds a gate whose only producer projects fgaPicardRepresentability, so 'axiom-clean' here is per-declaration and sorry-reachable on instantiation (I-0988). Measured dead end: genus C = 0 makes the Cech carrier Subsingleton (subsingleton_h1Cok_of_genus_eq_zero) but not the cotangent one — exact? fails, since that IS the conclusion.