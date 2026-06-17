# Iter-047 plan — tile leaf SOLVED (iter-046); coverage debt cleared; advance to kernel comparison

## Entering state (verified)
iter-046's one `mathlib-build` lane **SOLVED `tile_section_localization`** — the LAST keystone-feeding tile
leaf — axiom-clean (`#print axioms` = {propext, Classical.choice, Quot.sound}), via the restrictScalars-carrier
recipe (`analogies/tile-descent-instance-shape.md`). The iter-045 W1/W2/W3 Lean-engineering walls dissolved.
+4 supporting decls (`tileReconcileEquiv`, `isScalarTower_restrictScalars_obj`, two apply lemmas, the `rfl`
map bridge). Prover also deleted the two stale sync-fooling comment blocks. File 0-sorry; project inline-sorry
= 2 (both frozen/superseded). This was the first clean SOLVE of a named target on the 01I8 route since the
tile-lemma decomposition began (041→046).

## What I did this phase
1. Processed iter-046 lane → task_done (+5 axiom-clean, tile leaf SOLVED); refreshed task_pending 01I8 section
   + top note to iter-047; cleared the processed prover result file.
2. **Cleared the coverage debt + stale `\uses` edges (the graph-state's 6 unmatched, lean-vs-blueprint `qts`
   findings).** blueprint-writer `coverage-debt`: added blocks for the 2 new PUBLIC decls
   (`lem:tileReconcileEquiv`, `lem:isScalarTower_restrictScalars_obj`), bundled the 3 private helpers into
   existing `\lean{...}` lists, and fixed the 2 stale edges on `lem:tile_section_localization` (removed
   `qcoh_finite_presentation_cover` from the statement `\uses`, removed `tile_scalar_compat` from the proof
   `\uses`, added `tileReconcileEquiv`/`isScalarTower_restrictScalars_obj`). `unmatched` 6→1 (only the
   pre-existing dead `CechAcyclic.affine` remains). blueprint-clean `cov` stripped 4 Lean-leakage spots from
   the two new blocks.
3. **Same-iter fast path:** blueprint-reviewer `iter047` (whole-blueprint) → **HARD GATE CLEARS** for the
   kernel-comparison lane: `Cohomology_CechHigherDirectImage.tex` complete + correct, 0 must-fix; explicitly
   confirmed `lem:qcoh_section_kernel_comparison`'s block is formalization-ready with all 4 `\uses` deps
   present/done and the two new scaffolding blocks introduce no wiring error.
4. **progress-critic `routeb` → CONVERGING (dispatch=OK).** The PARTIAL×4 mechanical rule fires but is a
   false positive (four distinct one-shot blocker phrases, each resolved next iter; iter-046 COMPLETE ended
   the streak; the proposed target is a DOWNSTREAM frontier-READY node, not a re-attempt). Only note:
   refresh the OVER_BUDGET iters-left estimate — done in STRATEGY 01I8 row.
5. Refreshed STRATEGY 01I8 row + the Mathlib-gaps 01I8 bullet: tile sub-phase CLOSED iter-046; remaining =
   build kernel comparison (frontier-READY) → keystone → Route-B assembly; Iters-left ~2 → ~2–3.
6. Dispatched ONE prover lane: `QcohTildeSections.lean` → build `qcoh_section_kernel_comparison` (mathlib-build,
   no-sorry; the Lean decl does not yet exist), with the keystone `qcoh_section_isLocalizedModule` as a same-lane
   stretch if it lands.

## Decision made

### D1 — ONE prover lane (`qcoh_section_kernel_comparison`, mathlib-build); the keystone path is linear.
The kernel comparison is the next frontier-READY node on the single critical path (all downstream — keystone →
Route B → 02KG tops → P5a → P5b — gates on it). All 4 `\uses` deps are DONE and axiom-clean; the blueprint
block carries the full equalizer→localize→match→kernels proof at formalization depth; the HARD GATE cleared.
The standing parallelism directive manufactures no honest second lane: the only other frontier node touching
this route (`cech_augmented_resolution`/`cechAugmented_exact`) is GATED on 01I8 via
`\uses{lem:qcoh_iso_tilde_sections}` (frontier-honesty fix iter-043, still live). The other frontier nodes
(`cech_free_eval_prepend_homotopy`, `tilde_restrict_basicOpen`) are P5a/Route-P assets off the live critical
path and not yet honest lanes. **Effort note:** kernel comparison is effort ~3119 (high) — likely a full iter;
the keystone stretch is a short assembly that may or may not fit. mathlib-build's go-as-far-as-possible +
precise-handoff contract fits this exactly. **Reversal signal:** if the build stalls on a genuinely-absent
product-localization Mathlib lemma, that becomes the explicit next mathlib-build target (gradient strategy),
not a route pivot.

### Mode choice — `mathlib-build` (not `prove`): the Lean decl `qcoh_section_kernel_comparison` does NOT exist;
this is a no-sorry build of a NEW declaration. The objective line carries the `does not yet exist` scaffold
token (plan-validate noop-trap regex).

## Subagent skips
- strategy-critic: route UNCHANGED (sheaf-axiom-equalizer 01I8, validated by `strategy-critic-keystone`
  iter-041, SOUND, no live challenge). This iter's STRATEGY edits are status-only (tile leaf → done; 01I8
  row + Mathlib-gaps bullet refreshed; Iters-left ~2→~2–3) — no route swap, phase split/merge, or new
  decomposition. progress-critic `routeb` iter-047 independently returned CONVERGING. Re-running a fresh-context
  strategy critic on an unchanged, converging route would be a hollow dispatch.

## Risks / watch
- Kernel comparison may need a "localization commutes with finite products" lemma not directly in Mathlib;
  the prover is instructed to build it project-side axiom-clean (gradient) and hand off precisely rather than
  paper a sorry.
- Non-circularity hinge is load-bearing: the only "sections-localise" inputs must be the per-tile
  `tile_section_localization`, never an algebraic span-cover descent on global `Γ(X,F)` — re-stated in the
  objective.
