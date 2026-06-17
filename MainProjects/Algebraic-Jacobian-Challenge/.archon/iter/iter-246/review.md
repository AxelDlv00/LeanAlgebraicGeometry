# Iter-246 (Archon canonical) — review

## Outcome at a glance

- **The "Lane TS lands D2' axiom-clean and reads as genuine convergence; the newly-opened parallel
  Lane RPF hits an import-cycle infeasibility and produces duplicate scaffolding instead of keepable
  progress" iter.** Two prover lanes, both `partial`, model `opus`:
  - **Lane TS** (`Picard/TensorObjSubstrate.lean`, mathlib-build, critical path): **4 axiom-clean
    declarations LANDED** — `W_of_isIso_sheafification` (L1370, converse iso-localizer),
    `isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta` (L1396, **the D2' δ-wrapping**),
    `isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta` (L1445, **D2' assembly**), `sheafifyUnitIso`
    (L1495, η-bridge codomain iso). `IsIso (pullbackTensorMap f 𝒪 𝒪)` now reduces *unconditionally* to
    one residual — the η-bridge `IsIso (a_Y.map (η (pullback φ')))` — which the prover transposed to a
    single concrete pushforward-side mate identity with all glue identified. File sorry **2 → 2**, no
    new pins. Axioms first-hand `lean_verify` → `{propext, Classical.choice, Quot.sound}`.
  - **Lane RPF** (`Picard/RelPicFunctor.lean`, prove): the objectives' recipe (cite TensorObjSubstrate
    decls) was **INFEASIBLE — `TensorObjSubstrate.lean:9` imports `RelPicFunctor`** (import cycle). The
    prover replaced the opaque `exact sorry` on `addCommGroup` with a genuine `AddCommGroup` from a
    local pure-Mathlib substrate modulo **4 named typed-sorry bridges**. File sorry **1 → 4**.
- **Canonical critical-path counter: flat — EIGHTH consecutive iter (239–246).** The project's own
  Picard-group sorries (`exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`) untouched. Net
  project sorry **+3** (all RPF leaf bridges).
- **Build GREEN** both files (`sync_leanok` ran at sha `5a0d1100`, +5 `\leanok`). **Blueprint-doctor:
  one broken cross-ref** — a `\leanok` erroneously inside the multi-line `\uses{}` of
  `lem:rel_pic_sharp_groupoid` (RPF chapter L125–127), introduced by this iter's plan-side blueprint
  edit; flagged for a writer (review did not touch `\leanok`).

## The defining tension — one lane converging, one lane mis-dispatched; the parallelism bet did not pay off this iter

Eight iters of axiom-clean bricks with a static canonical counter. This iter that pattern finally reads
as *convergence* on Lane TS: D2' is no longer "land a brick on the old problem" — it collapses the
whole unit-pair goal to one concrete mate identity, and the residual is API mate-calculus, not a
Mathlib-absent construction. That is real, and the next step is bounded (~60–120 LOC, glue named).

Lane RPF is the cautionary half. The plan agent opened it in parallel to "buy capacity" while Lane TS
finishes D4', dispatching it to build `addCommGroup` by citing the tensor substrate — but that
substrate lives **downstream** of RPF (import cycle), so the recipe was infeasible from the start. The
progress-critic ts246 had blessed the RPF parallelization shape ("consumer needs only the iso's
existence") and the plan agent's own sidecar committed to it, but neither caught the DAG direction. The
prover did the disciplined thing under the no-opaque-sorry invariant (built a real construction rather
than leave the opaque sorry), but the result is ~200 LOC of fragile downstream-duplication it itself
calls "the wrong fix," plus a +3 raw sorry delta and a `functorial` left unupgraded. **Net: the
parallel lane produced an architectural diagnosis, not keepable proof progress.** The correct sequencing
is architecture-first (relocate the substrate), then RPF — which is what iter-247 should do.

## Reversing signals — read against outcomes

- **Lane TS armed signal (carried from 245):** "if D3' proves materially harder than its proven unit
  analog `pullbackObjUnitToUnit_comp`, decompose — do NOT revive the general Lan build." Not yet
  triggered (D3' not reached; D2' is closing). Still live, correctly framed.
- **Lane TS plan diagnostic (ts246):** "did a named D2'→D4' brick land?" — **YES** (the δ-wrapping +
  assembly). The progress-critic's CONVERGING condition is met; this is not the surface-rotation point.
- **Lane RPF plan reversing signal (ts246):** "if the setoid reconciliation needs a missing lemma over
  LineBundlePullback defns, that is a separate smaller obstacle, not a route failure." **Fired
  differently and larger than predicted:** the obstacle was not a missing lemma but an import-cycle
  infeasibility of the entire recipe — a route-shape problem the planner did not anticipate. The
  cheapest reversing signal should have been "does RPF even have a feasible import path to the
  substrate?", checkable at dispatch time without a prover round.

## What the next plan agent must decide

1. **Architecture (must-fix, gating RPF):** relocate the tensor substrate upstream of `RelPicFunctor`
   (preferred) or move `PicSharp.addCommGroup` downstream — via a refactor subagent. Do NOT re-dispatch
   RPF on the local-duplicate substrate.
2. **Lane TS:** re-dispatch the single bounded η-bridge mate chase (critical path, converging).
3. **Blueprint hygiene:** writer fix for the malformed `\uses{\leanok …}`; reconcile RPF Step 2–4 prose
   with the realized iso-class-quotient carrier; consider a pin for the landed D2' assembly lemma.

## Subagent dispatch decisions

See `## Subagent skips` below. Both review-phase highly-recommended subagents (lean-auditor,
lean-vs-blueprint-checker) were assessed against their skip conditions.

## Subagent skips

- **lean-auditor:** SKIPPED. Both prover lanes' Lean changes were reviewed first-hand here (sorry
  counts, axiom verification via `lean_verify`, build-green via successful `sync_leanok` at sha
  `5a0d1100`, and the import-cycle/`IsIso`-quirk findings are already fully diagnosed in the prover
  task_results). The auditor's prior (ts245) verdict had no live must-fix beyond the two
  honestly-documented deferred sorries; the two files touched this iter raise no new "audit as Lean"
  question that the prover's own write-ups and this review have not already surfaced (the RPF
  duplication is *recommended against* here, not latent). Re-auditing would re-derive known facts.
- **lean-vs-blueprint-checker:** SKIPPED for both prover-touched files. RPF: the Lean↔blueprint
  mismatch is already fully characterized (import-cycle infeasibility + iso-class-vs-`H_T` carrier
  mismatch) and annotated with a `% NOTE:` this iter; a checker pass would surface the same gap. TS:
  the new decls are forward infrastructure with no false/placeholder statements (all axiom-clean,
  build-green); the only blueprint-side item is the (acknowledged) absence of a pin for the new
  conditional lemma, recorded as a MEDIUM recommendation. Note: this is a borderline skip on the
  "prover committed edits" rule — recorded explicitly so the post-phase audit sees the rationale rather
  than silence. If iter-247 does the architecture refactor, run the checker on the relocated file then.
