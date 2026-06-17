# Iter-043 plan — Sub-lemma A landed; Sub-lemma B (the last tile ingredient) dispatched; falsely-ready P5a node corrected

## Entering state (verified)
iter-042's one lane landed **Sub-lemma A `tile_image_opens_identities`** axiom-clean (the two image-opens
identities of the affine identification `ι = specAwayToSpec g`) and **correctly did NOT paper
`tile_section_localization` with a sorry**: it confirmed on a clean `lake env lean` that Sub-lemma B
(`tile_section_comparison`) is genuinely non-definitional — the tile sections live in `ModuleCat R_g`, the
F-side in `ModuleCat R` (different base rings, not even the same type). Project inline-sorry = 2 (both
frozen/superseded). Build green (`QcohTildeSections.lean` EXIT 0).

Tile-lemma ingredient status: Sub-lemma A ✔ (iter-042), base-ring descent ✔ (iter-041), **Sub-lemma B —
NOT yet attempted** (iter-042 only confirmed it is needed). Sub-lemma B is the single remaining ingredient.

## What I did this phase
1. Processed iter-042 lane → task_done (+1 axiom-clean, Sub-lemma A); refreshed task_pending header to iter-043.
2. Dispatched the two HIGHLY-RECOMMENDED subagents: **progress-critic `routeb`** (keystone route convergence)
   + **blueprint-reviewer `iter043`** (full blueprint — gate re-confirm + P5a/P5b readiness for parallelism).
   - progress-critic `routeb` = **CONVERGING**, dispatch=OK (Sub-lemma B is a genuine NEW target, not churn).
   - blueprint-reviewer `iter043` = **HARD GATE CLEARS** — `lem:tile_section_comparison` sketch sound +
     detailed, NO MATH WALL ("bookkeeping of ring structures across a base-change"). 0 must-fix.
3. **Investigated blueprint-reviewer's "01I8-independent P5a parallel lane" claim** (Decision D2 below) and
   FALSIFIED it: 2 of the 3 named blocks already exist+proven; the 3rd (`cechAugmented_exact`) is actually
   gated on 01I8. Fixed the graph (`\uses{}` edge) accordingly.
4. Dispatched ONE prover lane: `QcohTildeSections.lean` → build Sub-lemma B `tile_section_comparison`, then
   assemble `tile_section_localization` (mathlib-build).

## Decision made

### D1 — ONE prover lane on Sub-lemma B; attempt the construction now, defer the analogist to a real wall.
Sub-lemma B is the last tile ingredient and the entire downstream chain (kernel comparison → keystone →
Route B assembly → 02KG tops → P5a → P5b) gates on it. It is a NEW target — the first genuine construction
attempt (iter-042 only *confirmed* it is non-definitional; it did not attempt to build it). The blueprint is
HARD-GATE-CLEARED with an explicit "no math wall" verdict, the recipe is concrete (5-step, plus the prover's
own deferred-note in the `.lean` file), and `StructureSheaf.globalSectionsIso` (the load-bearing Mathlib
piece) is confirmed to exist. The cheapest high-value signal is a real prover attempt, NOT a speculative
mathlib-analogist consult before any prover has struck a wall on the *construction* (iter-042's wall was on
the FALSE "it's rfl" route — a different thing). **Reversal signal:** if Sub-lemma B stalls on a concrete
term-mode wall, iter-044 dispatches the mathlib-analogist (api-alignment) on the
`modulesSpecToSheaf`/`globalSectionsIso` section-comparison with the prover's ACTUAL error state attached —
materially more useful than a consult now. mathlib-build mode guarantees no sorry: clean code or a finer
decomposition.

### D2 — REBUTTED the "open a parallel P5a scaffold lane" affordance; no honest off-keystone lane exists.
blueprint-reviewer `iter043` flagged three P5a blocks as "01I8-independent, parallel scaffold feasible." I
checked each against the actual Lean before acting (the plan-rule: validate a frontier node's real target +
faithful dependency before dispatch):
- `homologyIsoSheafify` + `higherDirectImage_iso_sheafify_presheafHomology` — **ALREADY EXIST and are proven**
  (`HigherDirectImagePresheaf.lean`, 0 sorries). Not scaffold targets; done. (Their blueprint `\leanok` may
  just be unsynced.)
- `cechAugmented_exact` (`lem:cech_augmented_resolution`) — its blueprint **proof** reduces a general
  quasi-coherent `F` to `~M` on each affine, and the P3 input `sectionCech_affine_vanishing` is **TILDE-ONLY**
  (`M : ModuleCat R`, on `tilde M`). So the node is in fact **gated on 01I8** (`qcoh_iso_tilde_sections`). Its
  `\uses{def:cech_nerve, lem:cech_acyclic_affine}` OMITTED that edge — the exact "incomplete \uses makes a node
  look ready" trap the leandag guidance warns about. **Corrected this iter:** added
  `lem:qcoh_iso_tilde_sections` to the `\uses{}` (statement + proof blocks) and made the tilde reduction
  explicit in the prose. ⟹ the standing parallelism directive does not manufacture honest parallel work: the
  only "ready" off-keystone frontier node was falsely ready, and the keystone is the single live critical path.
  This matches iter-042's deferral reasoning, now confirmed by the dependency analysis rather than assumed.

## Prior critique status
- **progress-critic `routeb` (iter-043) — CONVERGING, dispatch=OK.** No live finding. The route has landed
  axiom-clean decls every prover iter (040:+4, 041:+3, 042:+1) on a shrinking leaf-set; Sub-lemma B is the
  last tile ingredient. No churn.
- **blueprint-reviewer `iter043` (iter-043) — HARD GATE CLEARS.** 0 must-fix. 1 "soon": the dormant/circular
  `lem:qcoh_localized_sections` cleanup (no DAG path to the goal; non-blocking, deferred to a writer pass —
  already tracked in STRATEGY Open-questions + PROGRESS Next-iter item 7). 3 informational (Sub-lemma B
  `\lean{}` pin to be assigned by the prover this iter; cosmetic `def:` label; expected unmatched count).
- **strategy-critic — not dispatched (see Subagent skips).**

## Subagent skips
- strategy-critic: STRATEGY.md is substantively unchanged from iter-042 (no route swap, no phase
  split/merge, no >30% estimate drift, no new fork). The keystone route (sheaf-axiom equalizer) was settled
  iter-041 and is now empirically validated by TWO landed leaves (equalizer iter-041, Sub-lemma A iter-042);
  iter-042's prior CHALLENGE was ADDRESSED + VALIDATED. A fresh strategy-critic read of the settled, twice-
  validated route would surface nothing new — the hollow-dispatch the affordance exists to avoid. (The one
  blueprint edit this iter is a `\uses{}` correctness fix to a P5a node, not a strategy change.)

## Coverage debt status (leandag unmatched)
- `tile_image_opens_identities` — CLEARED (review pinned `\lean{}` iter-042).
- `CechAcyclic.affine` — still deferred (dead/superseded; protected `CechHigherDirectImage.lean` design
  comments reference it; remove at the P5b assembly rework). Sole remaining genuinely-dead unmatched node.
- `lem:tile_section_comparison` / `lem:tile_section_localization` — to-build; the prover assigns the
  Sub-lemma B `\lean{}` pin this iter, review reconciles post-iter.

## Note for sync/review (not a planner action)
- lean-vs-blueprint-checker `qts` (iter-042) flagged 3 pre-existing decls (`isLocalizedModule_of_span_cover`,
  `qcoh_finite_presentation_cover`, `qcoh_section_equalizer`) lacking `\leanok` despite complete proofs — a
  stale-sync artifact (the file builds clean; the `QcohRestrictBasicOpen` import was added iter-042). The
  next `sync_leanok` run should re-mark them. `\leanok` is sync's domain; no planner action.
