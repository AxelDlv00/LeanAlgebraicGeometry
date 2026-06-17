# Iter-170 (Archon canonical) — review

## Outcome at a glance

- **The "lane lost to upstream API-500, the body-first test never ran" iter.** The iter-170 plan committed an armed-trigger escalation answer: option (c) inline chart-glue committed across iter-170 → iter-172, body-first attack on `gmScalingP1` per progress-critic `routec170` CHURNING corrective. The prover lane was dispatched per plan, set up its 5-task TODO board matching the iter-170 `objectives.md` decomposition, and ran two `lean_run_code` probes verifying the `Algebra.compHom` recipe — then the session terminated with `API Error: 500 Internal server error` at `2026-05-22T03:57:14Z`, **251s / 22 turns in, with zero file edits**.
- **No .lean edits this iter** (`git diff HEAD --stat` confirms zero working-tree changes; `attempts_raw.jsonl` summary `edits: 0`; `meta.json` provers status `error`). **Global bare-sorry 13 → 13 (NET 0).** Per-file inventory (verified via `grep -nE '^\s*sorry\s*$|:=\s*sorry'`):
  - `AbelianVarietyRigidity.lean` — **2** at L934, L1141 (unchanged).
  - `Genus0BaseObjects.lean` — **8** at L177, L184, L364, L593, L687, L713, L791, L823 (unchanged; matches iter-170 plan inventory modulo a 2-line shift).
  - `Jacobian.lean` — **2** (unchanged).
  - `RigidityKbar.lean` — **1** (unchanged).
  No new `axiom`; `sync_leanok` ran clean (iter 170, added 0, removed 0); blueprint-doctor reported no structural findings.
- **Dispatch MATCHED the plan — 13th consecutive iter** with no plan/dispatch contradiction. The plan specified ONE Lane A on `Genus0BaseObjects.lean`; one lane fired; the lane scoped exactly to the planned PRIMARY (body-first `gmScalingP1` skeleton + `Algebra.compHom` + Step A ring maps + SECONDARY `aux_left`). The lane simply did not survive to the editing phase.
- **iter-170 plan's reversal trigger DOES NOT FIRE.** The trigger predicate is "the prover cannot WRITE the body shape" — a falsifying test that requires the prover to actually attempt and fail to produce the shape. An external API outage tests nothing. The route remains un-falsified; iter-171 must **re-attempt** the same test before the reversal is in play.

## What the iter-170 prover did before the API error

Verified by reading `.archon/logs/iter-170/provers/AlgebraicJacobian_Genus0BaseObjects.jsonl`:

1. Read `.archon/CLAUDE.md`, `.archon/prompts/prover-prover.md`, `PROGRESS.md`, then `AlgebraicJacobian/Genus0BaseObjects.lean` (the assigned file).
2. Ran `grep -n "USER:"` on the assigned file (no hits — no `/- USER: ... -/` hints exist on G0BO).
3. Ran `grep -n "sorry"` — confirmed the 8 in-file sorries at the expected positions.
4. Loaded the deferred tool schemas (`ToolSearch` for `TaskCreate`/`TaskUpdate`/`lean_*` MCP tools).
5. Created a 5-task TODO board:
   1. Add `Algebra.compHom` instance.
   2. Define `gmScalingP1_chart{0,1}_ringMap`.
   3. Assemble `gmScalingP1` body skeleton via `Scheme.Cover.glueMorphisms`.
   4. SECONDARY: attempt `aux_left` via cancel-surjective.
   5. Verify build green.

   The TODO decomposition matches the iter-170 `objectives.md` PRIMARY/SECONDARY structure verbatim.
6. Marked task 1 in-progress.
7. Ran `lean_diagnostic_messages` on the in-tree file (returned the expected 8 sorry warnings at L175, L182, L360, L593, L685, L709, L789, L819 — confirming a clean build with sorries only).
8. Ran `lean_run_code` probe 1 verifying the `Algebra.compHom` instance recipe in a standalone snippet.

   **Probe 1 result**: failed with `failed to compile definition, consider marking it as 'noncomputable' because it depends on 'MvPolynomial.gradedAlgebra', which is 'noncomputable'`. The error fired on the `abbrev projectiveLineBarGrading'` at L14 of the snippet (and propagated to the `GradedRing` instance + the two `inferInstance` example uses).
9. Ran `lean_run_code` probe 2 with `noncomputable abbrev projectiveLineBarGrading'`.

   **Probe 2 result**: still failed — same error, now firing on the `GradedRing` instance at L14 of the snippet (also not annotated `noncomputable`).
10. **API Error: 500 Internal server error** at the next text-generation turn. Session ended.

The two probes' `noncomputable` errors are **snippet-only artifacts**. The actual file's `projectiveLineBarGrading` (L78) and `projectiveLineBarGrading_gradedRing` (L82) compile cleanly inside the `noncomputable section` opened at L65. The `Algebra.compHom` recipe is sound for the in-file landing; the prover would have landed it directly in iter-170 if the API had stayed up.

## The advance, independently verified this review

There is no Lean-side advance this iter — that's the headline. Independent verification:

1. **Zero working-tree changes.** `git diff HEAD --stat` returns empty. The iter started uncommitted on a single base commit (`6282fc4 first commit`); no new commits and no working-tree edits to .lean files were produced.
2. **No new axioms.** Blueprint-doctor reports zero axiom declarations.
3. **Sorry footprint identical to iter-170 entry.** `grep -nE '^\s*sorry\s*$|:=\s*sorry' AlgebraicJacobian/*.lean | wc -l` = 13. Per-file matches iter-170 plan's pre-iter inventory.
4. **`sync_leanok` confirms no `\leanok` flips were warranted.** `.archon/sync_leanok-state.json`: `added: 0, removed: 0, chapters_touched: []`.
5. **Blueprint-side advances DID land** in the plan phase (file-disjoint, before the prover lane fired):
   - `blueprint-writer avr-orphan170`: orphan `def:ga_grpObj` block deleted from `AbelianVarietyRigidity.tex`; `blueprint/lean_decls` L134 removed in sync; iter-170 NOTE refreshes on `def:gaTranslationP1` (L1144) + `lem:gmScaling_fixes_zero` (L1205) recording the option-(c) commitment.
   - `blueprint-writer jacobian-routeA170`: 3 new paragraphs on `Jacobian.tex` (L347–L432) — Route A per-sub-phase LOC/iter budget, Mathlib-prerequisite cascade, per-bullet budget tags on the existing `Mathlib status for Route A` itemize, refreshed LOC figure in the `def:positiveGenusWitness` proof body.
   These edits are NOT review-phase work; they're plan-phase outputs, surfaced here for completeness of the iter narrative.

## Why the reversal trigger DOES NOT fire

The iter-170 plan's reversal commitment (verbatim):

> If iter-170's body-first attempt **fails to produce** a `Scheme.Cover.glueMorphisms` skeleton (i.e. the prover **cannot even WRITE** the body shape with internal sorries — not just fails to close them axiom-clean), the route reverses to escalation option (a) Mathlib upstream PR in iter-171.

The predicate has the form "the prover cannot write the body shape." Reading this carefully:

- **"Cannot write"** = the prover attempted the write, produced a shape, and the shape was rejected by the type-checker (or the prover gave up before achieving a shape that compiles).
- **"Cannot write"** ≠ the prover was killed by an external API outage before the editing phase began.

The iter-170 prover never edited the file. It never invoked `Edit` / `Write`. It probed the `Algebra.compHom` recipe and then died. The body-first test was **untested**, not **failed**. iter-171 must re-run the test before the reversal is in play.

(This matters because option (a) is a 5-iter detour through Mathlib upstream PRs; the cost of falsely firing the reversal is multiple iters wasted on a Mathlib detour while the in-project option (c) was never honestly tested.)

## Plan/dispatch alignment (sanity check)

13th consecutive iter where the planner's lane count + scope matched the dispatcher's reality:

| iter | planned lanes | dispatched lanes | alignment |
|------|---------------|------------------|-----------|
| 170 | 1 (Lane A on G0BO; no Lane B because both AVR sorries gated) | 1 (Lane A on G0BO; same scope) | ✓ |

The two plan-phase blueprint-writer dispatches (`avr-orphan170`, `jacobian-routeA170`) are file-disjoint from the prover lane (`.tex` vs `.lean`) and not counted as prover lanes.

## Knowledge Base updates landing this iter

See PROJECT_STATUS.md `## Knowledge Base` for the cumulative anti-patterns. One new entry from iter-170:

- **`lean_run_code` snippet + `noncomputable section` propagation**: standalone snippets that mirror declarations from a file inside `noncomputable section` must explicitly annotate `noncomputable abbrev` / `noncomputable instance` per-decl. The section blanket does NOT translate to the snippet. iter-170's prover lost 2 of 22 turns to this when verifying the `tensoraway` recipe. Recommendation captured: prefer in-file landing (where the section blanket carries it) + `lake build` + `lean_diagnostic_messages` over standalone snippet pre-verification.

## Sorry landscape (leaving iter-170)

Per-file (verified via grep):

- `AbelianVarietyRigidity.lean` — **2 sorries**: L934 `iotaGm_isDominant` (gated on `gmScalingP1` body landing); L1141 `genusZero_curve_iso_P1` (RR bridge, upstream Mathlib deferral).
- `Genus0BaseObjects.lean` — **8 sorries**: L177 `projectiveLineBar_geomIrred` (Mathlib gap); L184 `projectiveLineBar_smoothOfRelDim` (Mathlib gap); L364 `homogeneousLocalizationAwayIso_aux_left` (SECONDARY iter-171); L593 `gm_grpObj` (iter-173 target via `GrpObj.ofRepresentableBy`); L687 `gmScalingP1` (PRIMARY iter-171); L713 `gmScalingP1_collapse_at_zero` (gated downstream); L791 `gm_geomIrred` (Mathlib gap); L823 `projGm_isReduced` (gated on `aux_left`).
- `Jacobian.lean` — **2 sorries**: `genusZeroWitness` (gated); `positiveGenusWitness` (Route A).
- `RigidityKbar.lean` — **1 sorry**: `rigidity_over_kbar` (fallback (a) artifact).

Project total: **13** (unchanged from iter-170 entry).

## Subagent skips

- **lean-auditor**: no `.lean` file under the project tree was modified this iter (`attempts_raw.jsonl` summary `edits: 0`; `git diff HEAD --stat` zero working-tree changes). Per dispatcher_notes skip condition.
- **lean-vs-blueprint-checker**: NO `.lean` file received prover work this iter (the prover lane died with `status: error` before any edit). Per dispatcher_notes skip condition.

## Recommendation for iter-171 plan

Re-dispatch the iter-170 Lane A verbatim. The plan, objectives, analogies, and prover TODO scaffold are all on disk and unchanged-applicable. Shift the iter-170 → iter-172 3-iter horizon by one iter to iter-171 → iter-173. Do **not** fire the option-(a) escalation. Do **not** re-dispatch the iter-170 critics (verdicts unchanged-applicable; STRATEGY.md SHA unchanged; no new prover signal).

See `proof-journal/sessions/session_170/recommendations.md` for full detail.
