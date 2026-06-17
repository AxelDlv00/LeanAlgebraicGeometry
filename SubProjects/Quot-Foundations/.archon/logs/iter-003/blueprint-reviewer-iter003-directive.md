# Blueprint Reviewer directive — iter-003 gate re-confirm

Audit the WHOLE blueprint under `blueprint/src/chapters/`. Produce your standard
per-chapter completeness + correctness checklist and the HARD-GATE verdict
(`complete:` / `correct:` / must-fix-this-iter) for each chapter.

## What changed this iter (orientation only — still audit the whole blueprint)

- `Cohomology_FlatBaseChange.tex` — the monolithic mate lemma
  `lem:pushforward_base_change_mate_cancelBaseChange` was decomposed (effort-breaker)
  into a `\uses`-linked chain: 2 Mathlib anchors (`lem:pullbackSpecIso_mathlib`,
  `lem:cancelBaseChange_mathlib`) + L1 crux `lem:pullback_fst_snd_specMap_tensor` +
  L2/L3 dictionary reads + L4 generator trace. A coverage-debt node
  `lem:gammaPushforwardNatIso` was added.
- `Picard_FlatteningStratification.tex` — the dévissage residue of
  `thm:generic_flatness_algebraic` was decomposed (effort-breaker) into the chain in
  `sec:gf_devissage_chain` (`lem:gf_torsion_base`, `lem:noeth_prime_filtration` anchor,
  `lem:gf_splice_shortExact`, `lem:gf_noether_clear_denominators`,
  `lem:gf_polynomial_core` (the one genuine Mathlib-absent core), bottoming at the
  already-closed `lem:gf_finite_module`). The `thm:generic_flatness` geometric
  globalization proof was expanded with the affine-cover / coherence-to-finite-module /
  flat-from-free step structure (naming the Mathlib APIs the prover will use); the stale
  pre-resign `% NOTE` was corrected; coverage-debt helpers `lem:gf_flat_finite`,
  `lem:gf_free_moduleFinite` were added.
- `Picard_QuotScheme.tex` — a `% ENCODING PIVOT` note was added to
  `def:hilbert_polynomial`: the Hilbert polynomial will be formalized via the GRADED
  Hilbert function (Hartshorne I.7.5 / `Polynomial.existsUnique_hilbertPoly`), NOT the
  cohomological χ form whose prose/quotes are retained for reference. The χ→graded
  rewrite of this chapter is a queued task (QUOT is gated behind FBC/GF).

## Focus questions

1. Do `Cohomology_FlatBaseChange.tex` and `Picard_FlatteningStratification.tex` clear
   the HARD GATE (`complete: true` + `correct: true`, no must-fix) so provers may be
   dispatched at the decomposed FBC and GF chains this iter? Check that the new chains
   are mathematically sound (each sub-lemma's `\uses` covers its real dependencies; the
   chain actually proves the target; no gap relabelled away).
2. Is the expanded `thm:generic_flatness` globalization proof now adequate to guide a
   prover (does it name the steps + APIs concretely)?
3. For `Picard_QuotScheme.tex`: is the encoding-pivot note's deferral acceptable (the
   chapter is internally consistent under the χ prose pending its queued rewrite, and
   QUOT is not a prover objective this iter)? Flag it as needing a writer rewrite but do
   not treat the strategy/chapter divergence as a blocker for FBC/GF.

Also run your `## Unstarted-phase blueprint proposals` audit against the STRATEGY phases.
