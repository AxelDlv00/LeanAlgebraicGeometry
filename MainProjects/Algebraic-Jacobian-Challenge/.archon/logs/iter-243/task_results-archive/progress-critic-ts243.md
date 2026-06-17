# Progress Critic Report

## Slug
ts243

## Iteration
243

## Routes audited

### Route A — `Picard/TensorObjSubstrate.lean`

- **Sorry trajectory**: 2→2→2→2 across iters 239–242 (net unchanged, expected: target is a NEW decl, not a sorry-pinned one)
- **Helper accumulation**: 9 helpers across 4 iters (iter-239: 1; iter-240: 2; iter-241: 4; iter-242: 2); sorry count net unchanged — 0 sorries closed by any of them
- **Prover dispatch pattern**: 1 file dispatched per iter (no other active ready files flagged in directive)
- **Recurring blockers**: `pullbackTensorIso` / `IsInvertible.pullback` (the actual target decl) has not landed in any of iters 239–242; recipe for closing it has been revised 3× (sectionwise-extendScalars → concrete-P → local-trivialization)
- **Avoidance patterns**: none (route active every iter, no off-critical-path reclassification)
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL→milestone, PARTIAL — 4 consecutive PARTIAL statuses
- **Throughput**: ON_SCHEDULE — strategy estimate is 7–11 iters left, 4 iters elapsed in phase (phase started iter-239)
- **Verdict**: **CHURNING**

**Primary corrective: Blueprint expansion**

The verdict rule "PARTIAL prover status ≥3 of last K iters" is satisfied by 4 consecutive PARTIALs. The cleaner diagnostic is the 3× recipe revision: iter-239 killed recipe #1, iter-242 killed recipe #2, and iter-243 proposes recipe #3 (local-trivialization). Each recipe revision consumes a full iter discovering the dead end rather than making progress. The root cause is an under-specified proof sketch: if the blueprint chapter for `IsInvertible.pullback` does not yet pin the 3-step recipe-#3 path (`δ_sheaf` transport → `IsInvertible⇒IsLocallyTrivial` bridge → assembly via `IsLocallyTrivial.pullback`), the prover will again discover the route's feasibility under fire rather than executing a written plan. Note that iter-241 was a genuine Phase-1 milestone (`pullbackUnitIso` landed); the churn is Phase-2-specific. **Action required before prover dispatch**: expand the blueprint chapter for `IsInvertible.pullback` to explicitly spell out recipe #3's 3-step path, including the sheaf-level δ transport step and the forward invertibility-to-local-triviality bridge. Only after that sketch is written should the prover be dispatched on iter-243 — this caps the recipe-revision burn at 3 and gives the prover a committed fallback boundary.

---

### Route B — `Cohomology/FlatBaseChange.lean`

- **Sorry trajectory**: 3→3→2→2 across iters 239–242; 1 sorry closed (iter-241), then stable
- **Helper accumulation**: steady — iter-239: 2 bricks; iter-240: carrier-wall resolution + sorry relocated; iter-241: milestone sorry closed; iter-242: `pullback_spec_tilde_iso` TARGET 1 landed + 1 brick
- **Prover dispatch pattern**: 1 file per iter (no other active ready files flagged)
- **Recurring blockers**: Two Mathlib-absent multi-hundred-LOC obligations surfaced in iter-242 (affine reduction / open-restriction naturality; adjoint-mate ↔ `cancelBaseChange`). These are FRESH — 1 iter of data only; not yet a recurring-blocker pattern.
- **Avoidance patterns**: none
- **Prover status pattern**: PARTIAL, PARTIAL, milestone, PARTIAL→milestone — milestone in iter-241 breaks any 3-PARTIAL chain
- **Throughput**: ESTIMATE_FREE in effect for this sub-lane (`A.2.c-engine` estimates 30–60 iters left; FlatBaseChange is a sub-lane within that phase)
- **Verdict**: **CONVERGING**

The pattern is healthy: iter-241 closed `pushforward_spec_tilde_iso` (sorry 3→2), iter-242 closed TARGET 1 `pullback_spec_tilde_iso` (new decl, no sorry change). The two Mathlib-absent obligations for TARGET 2 (`affineBaseChange_pushforward_iso`) are newly identified — 1 iter of data is insufficient to call STUCK. The proposed decompose-then-dispatch strategy is the right response: naming the two obligations as sub-lemmas before the next prover round avoids a repeat of the iter-240 carrier-wall pattern (where the blocker lived inside the body without a named handle). **Watch signal**: if iter-243 produces PARTIAL on both sub-lemmas with no reduction in the obligation list, escalate to Route pivot (Mathlib bump #37189) in iter-244 rather than waiting.

---

## PROGRESS.md dispatch sanity

- **File count**: 2 (cap: 10)
- **Ready but not dispatched**: none identified in directive
- **Over the cap**: no
- **Under-dispatch finding**: no — only 2 files under active consideration per directive; no additional ready files surfaced
- **Verdict**: OK — file count 2 within cap 10, no under-dispatch from available information. Note: 2 files is a light load; if any additional files with complete blueprint chapters and open sorries exist but were not included in the directive, the planner should surface them.

---

## Must-fix-this-iter

- **Route A (`TensorObjSubstrate.lean`): CHURNING** — primary corrective: **Blueprint expansion**. Why: 4 consecutive PARTIALs; recipe revised 3× across iters 239–242 without target landing; recipe #3 (local-trivialization) must be written explicitly into the blueprint chapter for `IsInvertible.pullback` before prover dispatch this iter, capping further recipe-discovery churn.

---

## Informational

- **Route B (CONVERGING)**: the proposed "decompose two obligations into named sub-lemmas before prover dispatch" is sound and should be treated as a hard prerequisite for the iter-243 prover round — not optional. If the prover is dispatched without named handles for the two Mathlib-absent obligations, it will reproduce the iter-242 wall inside the body rather than making measurable progress.

- **Route A throughput note**: the ON_SCHEDULE finding (4 elapsed vs 7–11 estimated) is a positive signal and should not be squandered. The Phase-1 milestone (`pullbackUnitIso`) was genuine work. Recipe #3 is structurally de-risked (sub-lemmas `IsLocallyTrivial.pullback` and `tensorObj_isLocallyTrivial` already proven). If the blueprint is expanded this iter, iter-244 has a realistic chance of landing the target — well within the estimate window.

---

## Overall verdict

One route healthy, one churning. Route B (FlatBaseChange) is converging steadily with genuine milestone closures every other iter; its two new Mathlib-absent obligations are fresh and not yet a stall. Route A (TensorObjSubstrate) is CHURNING: 4 consecutive PARTIAL statuses, recipe revised 3× without the target decl appearing once across iters 239–242. The corrective is **blueprint expansion before prover dispatch** — write recipe #3's 3-step local-trivialization path explicitly into the blueprint chapter for `IsInvertible.pullback` this plan phase, then dispatch the prover on that committed sketch. For Route B, name the two affine-close obligations as sub-lemmas in the blueprint before the prover round. Both routes should run in iter-243 (2-file load is appropriate), but Route A's blueprint expansion is a hard prerequisite that the plan phase must execute before the prover starts.
