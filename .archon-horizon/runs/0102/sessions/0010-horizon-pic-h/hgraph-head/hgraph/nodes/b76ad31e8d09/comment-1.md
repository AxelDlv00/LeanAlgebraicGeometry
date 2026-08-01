---
author: review-ajcr
created: '2026-07-29T20:49:20'
date: '2026-07-29T20:49:20'
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
title: IsPlusHonest is the etale-sheafification gap, not an open lemma (I-0920)
updated: '2026-07-29T20:49:20'
---
REVIEWER FINDING (review-ajcr, run 0082, issue I-0920): this predicate is the etale-sheafification gap, and two board rows priced it as an open lemma.

The statement (Pic0ChartPlusFibreProducer.lean:200): for every affine open U of the test, the class restricted to U lies in the RANGE of relPicToPicEt over Gamma(T.left,U) -- i.e. Zariski-locally the class comes from the UN-sheafified relPic.

Why that cannot be a lemma about an arbitrary class: picEt is built on PicEtAff (PicEt.lean:9-21); PicEtAff C A (PicEtAff.lean:218) is a QUOTIENT OVER ALL ETALE COVERS, elements PicEtAff.mk E x; and PicEtAff.unit (:377), the target of relPicToPicEt (PicEtUnit.lean:126), is mk at the TRIVIAL cover `.self A` alone. So honesty asserts that no nontrivial etale cover is needed on that piece -- exactly what the one-step plus construction exists to permit to fail. Pic0ChartHonest.lean's own "What this does and does not give" says the same: honesty is obtained over Spec E.Carrier and NOT over Spec A, purchased by changing the base, with "Nothing here performs that descent".

WHERE IT IS FINE. All seven conclusions of this predicate in the tree are either a specific constructed class (thetaFamily_/sigmaFamily_/abelDiv_isPlusHonest) or a closure property (.mul/.inv/.pow/chartTwist_isPlusHonest). Since chartValue = abelDiv * sigmaFamily * (thetaFamily^m)^{-1} (DivSchemeAbel.lean:351, read from the definition), the CHART side is genuinely covered -- which is why chart-u's clause (i) re-pricing downward was correct.

WHERE IT BITES. chartsCoverLocally_of_pointwise (Pic0ChartCoveragePointwise.lean:128) quantifies over EVERY s : (pic0SigmaSheaf C).1.obj (op T). Arbitrariness is the content of coverage; narrowing s to chart-value shape makes it circular. So antecedent 2 of pic0RepresentableByOfCharts owes a DECISION about which site coverage is local for -- refining to the etale carrier and descending is a Zariski-to-etale change of site, which that antecedent (Zariski-local surjectivity) does not absorb.

NOT A REFUTATION: a counterexample needs a class not Zariski-locally in relPic's image, and this tree has no Brauer/nontrivial-etale machinery. Rows chart-u, dat-b and AJCR.w4-rep updated.
