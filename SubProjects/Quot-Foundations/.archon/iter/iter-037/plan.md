# Iter 037 — Plan (Quot-Foundations)

## TL;DR

Three lanes advanced cleanly in iter-036 (FBC step (b), QUOT `gammaPullbackTopIso`, GR E1/E2/E3-core); each
now has a single precisely-named residual, so iter-037 dispatches **3 parallel import-independent provers**:

1. **FBC-A1** [fine-grained] — close `base_change_mate_gstar_transpose` (@2167) by ASSEMBLING the now
   all-PROVED atoms: inline step-(a) reindex (from the proved `inner_eCancel_*` atoms + Seam-1, extracted as
   a NAMED standalone lemma = the tripwire deliverable) + step (b) `gstar_generator_close` + step (c) `huce`
   + dictionary cancellation. Prune the dead `_legs`/conj-2a sorry cluster once step-(a) inline lands.
2. **QUOT-Hfr** [mathlib-build] — build the two Mathlib-absent bridges (I) ring-iso-semilinear
   `IsLocalizedModule` transport + (II) base-change-of-localization `R→R_r`, assemble `Hfr`, close the named
   `isLocalizedModule_basicOpen_descent` + gap1.
3. **GR-E3full** [mathlib-build] — build the cofactor-expansion helper (det of a column-substituted identity),
   close E3-full `existence_factor_through_valuationRing`.

## Decision — FBC: one clean ASSEMBLY pass (not a pivot, not a new helper round)

The progress-critic `iter037` returned **STUCK** (mechanical: 4 flat-sorry iters + recurring step-(a)
blocker) but explicitly endorsed this exact action: "the iter-037 assembly pass is the right action and must
be given one clean try, as all atoms are now proved." This is NOT the same as the 5-iter stall: at iter-036
ALL three sub-ingredients became PROVED standalone (step (a) atoms `inner_eCancel_*`, step (b)
`gstar_generator_close`, step (c) master `huce`), so the route moved from "build helpers" to "glue proved
atoms" — the endgame. The fine-grained mode extracts the inline step-(a) reindex as a named lemma so a
compiling deliverable lands even if the final glue is hard.

**Tripwire (ENFORCED — progress-critic must-fix):** if iter-037 closes neither `gstar_transpose` NOR lands a
compiling inline step-(a) lemma, iter-038 MUST dispatch a **mathlib-analogist** (cross-domain-inspiration) on
the `X.Modules`-diamond leg-reindex / dictionary cancellation — NOT another assembly round, NOT user
escalation. If the inline step-(a) lemma lands (even without final close), the route stays on the prover.

## strategy-critic `iter037` must-fixes — ALL ADDRESSED (no silent override)

1. **Affine lemma's second sorry (A2).** `affineBaseChange_pushforward_iso` carries a SECOND un-scoped sorry
   at `FlatBaseChange.lean:2348` (the affine/locality reduction, source-acknowledged "multi-hundred-LOC,
   Mathlib-absent"). My prior phase row conflated it with `gstar_transpose`. → STRATEGY.md now splits FBC-A
   into **A1** (`gstar_transpose`, 1–2 iters, ~80–150 LOC) and **A2** (affine reduction, 3–6 iters,
   ~200–500 LOC, Mathlib-absent, NO scaffold, gated behind A1) with honest estimates; route prose + Mathlib-
   gaps list updated; A2 added to the iter-038 ramp as needing a blueprint section + decomposition BEFORE a
   prover. Verified line numbers (actual sorries: 1700/2167/2348/2370).
2. **Dead `_legs`/conj-2a cluster carrying a live sorry.** → FBC directive orders the prover to PRUNE the
   `_legs`/`fstar_reindex`/`inner_value_eq` cluster (sorry @1700) once the inline step-(a) reproof makes it
   unreferenced (verify no live consumer first).
3. **Phantom anchor `Matrix.det_updateColumn`** (does not exist). → corrected to `Matrix.cramer_apply` +
   `Matrix.det_succ_column` in the GR phase row, GR directive, and the GR do-not-retry standing note.
4. **Format DRIFT (~15KB > ~12KB).** Non-blocking; this iter's additions were the required A1/A2 honesty
   fixes, so a dedicated Routes-prose trim pass is owed and logged under task_pending Open hygiene (deferred,
   not ignored).

The FBC `gstar_transpose` node itself was confirmed by the strategy-critic as an honest assembly-of-proved-
atoms (its question 1 affirmative for the node), so no rebuttal is needed on that point — only the A2 scope
honesty, now fixed.

## Coverage debt (cleared this iter)

Plan-agent-written ADDITIVE blueprint blocks for the 3 public unmatched decls:
- `lem:gamma_pullback_image_iso` + `lem:gamma_pullback_image_iso_hom_naturality` (Picard_QuotScheme.tex).
- `lem:gr_existence_lift_transitionPreMap_minorDet_mul` (Picard_GrassmannianCells.tex).
All `\uses{}` labels verified to resolve. All other unmatched decls are already `private` (verified in
source) → clear on the iter-037 sync; FBC `extendScalars_inner_value_counit` dedup'd at the prover.

## Subagent skips

- blueprint-reviewer: iter-036 reviewer PASSED all 3 active chapters (complete+correct, no must-fix); the
  prover-TARGET blocks (`lem:base_change_mate_gstar_transpose`, `lem:gr_existence_factor_through_valuation_ring`,
  the QUOT Hfr NOTE under `lem:pullback_gamma_top_iso`) are textually UNCHANGED this iter; the only blueprint
  edits are ADDITIVE coverage blocks for already-PROVED helpers, which cannot regress target
  completeness/correctness. (strategy-critic + progress-critic both dispatched — STRATEGY changed and FBC was
  STUCK, so neither was skippable.)
