# Recommendations — after iter-010 (no prover; strategy-correction / blueprint-repair iter)

## Top priority — the gate-then-build sequence (already in PROGRESS.md; do not skip a step)
The iter-010 plan agent wrote the correct iter-011 sequence into PROGRESS.md. It MUST be honoured in
order, because the consolidated chapter `Cohomology_CechHigherDirectImage.tex` was substantially
restructured this iter and has **not been re-reviewed since the repair**:

1. **HARD-GATE blueprint-review FIRST.** Re-run the whole-blueprint reviewer (or the same-iter
   fast-path scoped to `Cohomology_CechHigherDirectImage.tex` only). No prover may touch the file
   until that chapter returns `complete: true AND correct: true` with no must-fix. The iter-010
   repair is DAG-clean (doctor confirms, `gaps`=0), but a fresh correctness pass on the rewritten
   `lem:cech_to_cohomology_on_basis` + the two new bridge lemmas is the gate's whole purpose.
2. **Effort-break the two new bridge lemmas.** `lem:injective_cech_acyclic` (effort 1455) and
   `lem:ses_cech_h1` (effort 1323) are freshly written and have NOT been decomposed. Both are
   from-scratch presheaf-Čech homological algebra for `O_X`-modules (new phase P3b). Send the
   effort-breaker at each before a prover, or the prover will work an under-decomposed sketch.
   `lem:cech_to_cohomology_on_basis` (effort 3466) is the largest frontier node and almost
   certainly needs breaking too.
3. **File-split / signature scaffold for P3.** Plan D3 locked the P3 design to Mathlib idioms
   (`affineOpenCoverOfSpanRangeEqTop` bundle `(s, hs)`; `exact_of_isLocalized_span`). Narrow ONLY
   the non-protected `CechAcyclic.affine`; keep the protected goal + `CechComplex` general. See
   `analogies/p3-localisation.md`.
4. **Only then dispatch provers** on the Čech side.

## Frontier (ready to prove once the gate clears) — `archon dag-query frontier`
All 5 are in `Cohomology_CechHigherDirectImage.tex` → `CechHigherDirectImage.lean`:
- `lem:injective_cech_acyclic` (effort 1455) — injectives are Čech-acyclic. P3b bridge.
- `lem:ses_cech_h1` (effort 1323) — the Čech H¹ short exact sequence. P3b bridge.
- `lem:cech_to_cohomology_on_basis` (effort 3466, used-by 1) — the 01EO dimension shift; LARGEST.
- `lem:cech_augmented_resolution` (effort 865) — smallest; possible warm-up lane.
- `lem:higher_direct_image_presheaf` (effort 1315, used-by 2) — presheaf-cohomology comparison.

## Do NOT retry
- **Do NOT re-dispatch any lane on `AcyclicResolution.lean`.** P4 closed iter-009, sorry-free,
  axiom-clean. Nothing remains to build there; it is now an off-the-shelf engine for the Čech side.
- **Do NOT reinstate the iter-009 reduced-scope route for `lem:cech_to_cohomology_on_basis`.** That
  route WAS the circular one (affine vanishing from the contracting homotopy alone). The repaired
  01EO dimension-shift route is the correct one; the torsor sub-theory remains genuinely avoidable.

## Standing coverage debt — 28 unmatched `lean_aux` nodes (`archon dag-query unmatched`)
All 28 are **pre-existing P4 helpers** (no prover ran this iter, so nothing new was added). They are
prover-created Lean declarations with no blueprint entry — invisible to the dependency graph. The
review agent does not author informal prose, so the planner should add thin blueprint entries
(statement + `\lean{}` + `\uses{}`) for these next time a P4-area writer is dispatched. The clusters,
by source area:
- **Cosyzygy / applied-cohomology (iter-007/009)**: `Functor.cosyzygyShortComplex`,
  `Functor.gCosyzygyIsoCocycles_hom_iCycles`, `Functor.gCosyzygyIsoCocycles_toCycles`,
  `Functor.isZero_homology_mapHomologicalComplex_of_isRightAcyclic`, `cosyzygyKernelFork`,
  `cosyzygy_iCycles_comp_toCycles`, `epi_toCycles_of_exactAt`.
- **Horseshoe / twisted-biproduct (iter-005/006)**: `twistedBiprod`, `twistedBiprodD`,
  `twistedBiprodD_fst`, `twistedBiprodD_snd`, `twistedBiprodInl_comp_Snd`, `twistedBiprodInl_f`,
  `twistedBiprodSnd_f`, `twistedBiprod_X`, `twistedBiprod_d`,
  `shortExact_map_mapHomologicalComplex_of_degreewise_splitting`,
  `shortExact_of_degreewise_splitting`.
- **Push-pull functoriality (iter-002)**: `coverCechNerveOver`, `coverCechNerveOverAug`,
  `pushPullMap_eq_raw`, `pushPull_pentagon`, `pushPull_unit_comp`, `pushforwardComp_hom_app_id`,
  `rawPushPullMap`, `rawPushPullMap_comp`, `rawPushPullMap_self`, `rawPushPullMap_self_gen`.

These are LOW priority (P4 is closed and consumed via one top-level lemma; these helpers are
internal), but the "where there is Lean there must be tex" doctrine wants them blueprinted
eventually. Not blocking.

## Reusable proof patterns
No new patterns this iter (no prover). The cumulative Knowledge Base in `PROJECT_STATUS.md` is
unchanged and remains the reference for the Čech-side build (notably the acyclic-resolution engine
entry — `rightDerivedIsoOfAcyclicResolution` is the off-the-shelf comparison lemma the Čech side
now consumes).
