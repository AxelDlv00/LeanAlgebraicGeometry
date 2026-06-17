# Blueprint Writer Report: grquot-nitsure
**Status:** COMPLETE

## Changes (all in Picard_GrassmannianQuot.tex, sec:grquot_universal, before represents thm)
- Add `lem:tautologicalQuotient_epi` (`Grassmannian.tautologicalQuotient_epi`): u epi, chart-local via split-epi u^I. \uses{lem:gr_chartQuotientMap_epi, def:tautological_quotient}.
- Add `def:isoLocus` (`Grassmannian.isoLocus`): largest open where φ pulls back to iso.
- Add `lem:isIso_of_stalkFunctor_map_iso_mathlib` (`TopCat.Presheaf.isIso_of_stalkFunctor_map_iso`) — `\mathlibok` anchor (verified via hover).
- Add `lem:isIso_pullback_isoLocus_map` (`Grassmannian.isIso_pullback_isoLocus_map`): stalk-local + Mathlib criterion. \uses{def:isoLocus, anchor}.
- Add `def:chartLocus` (`Grassmannian.chartLocus`): T_I = isoLocus(s_I∘q). \uses{def:isoLocus, def:gr_chart_quotient, def:gr_rankQuotient}.
- Add `lem:chartLocus_isOpenCover` (`Grassmannian.chartLocus_isOpenCover`): cover via fibre-surjectivity + Nakayama. SOURCE quote = Nitsure §1 minor/invertibility-locus passage (src L823–828, verbatim).
- Add `def:grPointOfRankQuotient` (`Grassmannian.grPointOfRankQuotient`): glued inverse morphism. \uses{lem:chartLocus_isOpenCover, lem:isIso_pullback_isoLocus_map, def:gr_affine_chart, def:gr_chart_quotient, def:gr_transition, lem:gr_cocycle, def:gr_glued_scheme}.
- Edit `represents` PROOF \uses only (statement untouched): +5 new labels so DAG connects them.

## Verify
- leandag: 0 unknown_uses, 0 isolated in chapter; 5 project pins matched; anchor in unmatched_lean (expected `\mathlibok` pattern). No conflicts.

## Notes / Strategy
- Nitsure §1 states the inverse construction only as Exercise (2); the verbatim quote backs the minor-invertibility-locus mechanism, the Nakayama covering step is Nitsure's unstated exercise content (no verbatim proof in source) — flagged honestly, not fabricated.

## References consulted
- references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex (L546–566 exercise, L796–910 construction; quote L823–828)
- references/summary.md
