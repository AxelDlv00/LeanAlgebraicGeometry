# Progress Critic Report

## Slug
ts244

## Iteration
244

## Routes audited

### Route: `Picard/TensorObjSubstrate.lean` (A.1.c substrate — `IsInvertible.pullback`)

- **Sorry trajectory**: 2 → 2 → 2 → 2 across iter-240 to 243. FLAT. (The 2 residual sorries are pre-existing dual-bridge deferrals, off the critical path and never expected to move. The critical-path deliverable `IsInvertible.pullback` has NOT landed in any of the last 5 iters, 239–243.)
- **Helper accumulation**: 10 helpers added across iter-240 to 243 (2 + 4 + 2 + 2); sorry count net unchanged; no structural change in the sense that each iter's helpers are framed as "setup for next iter's closure" — this has been said (implicitly or explicitly) for 4 consecutive iters.
- **Prover dispatch pattern**: 2 of 2 ready files dispatched each iter — full capacity, no under-dispatch.
- **Recurring blockers**:
  - "Mathlib-scale" appears in iter-242 (concrete inverse-image / `extendScalars`) and iter-243 (finite-presentation spread-out for `SheafOfModules`) — 2 iters. Not yet at the ≥3-iter STUCK threshold on this phrase alone, but the *underlying infrastructure gap* is structurally the same across both iters despite different surface names.
  - Route recipe revised EVERY iter: concrete-P (242) → local-trivialization (243) → presheaf δ iso upgrade (244 proposal). Three consecutive pivot-in-framing rounds while the named deliverable stays absent is a rotation-churn signal (see "possible rotation churn" note below).
- **Avoidance patterns**: No off-critical-path reclassifications; no consecutive plan-only iters; no deferral language. However: the repeated route-recipe pivots (concrete-P → local-trivialization → forward-bridge → presheaf δ iso) while encountering the same underlying Mathlib infrastructure gap each time qualifies as **possible rotation churn** — the planner is finding new surface routes that each bottom out at absent Mathlib infrastructure. Strategy-critic should confirm whether these surface routes share the same root infrastructure gap.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, PARTIAL — 4 consecutive PARTIAL verdicts across iter-240 to 243.
- **Throughput**: SLIPPING — STRATEGY.md estimates "~7–11" iters remaining; 5 iters have elapsed (239–243) without closing the critical-path deliverable. If "~7–11" was the estimate at the start of this sub-goal phase (iter-239), elapsed+remaining = 12–16 total projected iters; we are at 5 of 12 minimum, so nominally on-schedule in elapsed-vs-total terms. But the deliverable has not closed and the approach has pivoted 3 times, which is incompatible with the smooth-convergence shape "~7–11" implies. SLIPPING is the honest read.
- **Verdict**: **CHURNING**
  - Trigger: PARTIAL prover status for 4 of 4 audited iters; helpers added every iter; sorry count net unchanged; no structural change in approach (each pivot re-labels the same Mathlib infrastructure gap); possible rotation churn.
- **Primary corrective**: **Mathlib analogy consult** — the planner is already dispatching a mathlib-analogist this iter to confirm whether the presheaf-level δ is a cheaply-provable iso. This is the correct move. The must-fix action is: **block prover dispatch on that confirmation**. Do NOT fire another prover assuming the presheaf δ iso is trivial before the analogist returns a yes/no. If the analogist confirms the δ iso is Mathlib-scale too, the planner must escalate immediately to **Route pivot** rather than finding a fourth surface route that bottoms at the same gap.
- **Secondary corrective**: If mathlib-analogist returns "Mathlib-scale" for the presheaf δ iso, immediately invoke **Route pivot** (revise STRATEGY.md for A.1.c; pick a concrete-free approach or accept a sorry placeholder and unblock downstream lanes).

---

### Route: `Cohomology/FlatBaseChange.lean` (A.2.c engine, parallel side-lane — affine close)

- **Sorry trajectory**: 3 → 2 → 2 → 2 across iter-240 to 243. Flat for 3 consecutive iters (241–243); the single drop (3→2) occurred at iter-241 and nothing has moved since.
- **Helper accumulation**: 3 helpers across 4 iters (refactor in 240, 1 in 241, 2 in 242, 0 in 243); iter-243 added 0 (attempted declaration removed). Since iter-241: 3 helpers added, 0 sorries closed.
- **Prover dispatch pattern**: 1 lane dispatched every iter (parallel to Lane 1). No under-dispatch finding on this metric alone given the parallel-lane framing.
- **Recurring blockers**:
  - "SheafOfModules functor-`.map`-of-composite defeq wall" (`rw` silently fails, `erw` whnf-explodes) — appears iter-237 through 243 = **7 consecutive iters**. This far exceeds the ≥3-iter STUCK threshold.
  - "Mathlib-scale" appears iter-243 for both named affine-close obligations.
  - "#37189 bump" documented as the documented fallback since iter-242; watch-signal explicitly fired at iter-243.
- **Avoidance patterns**: Route is active every iter, so no off-critical-path reclassification. The HOLD proposed for this iter is deliberate and documented. **However**: a HOLD without a concrete re-engagement timeline is one iter away from becoming an avoidance finding. If FlatBaseChange is held again next iter (iter-245) without a named re-engagement condition (e.g., "resume after `IsInvertible.pullback` closes; targeted iter-N"), the avoidance clock has started.
- **Prover status pattern**: PARTIAL → COMPLETE-equiv → PARTIAL → INCOMPLETE. The iter-243 INCOMPLETE represents a regression: the prover attempted and then REMOVED a declaration (net zero progress). This is the worst status in the window.
- **Throughput**: SLIPPING — STRATEGY.md side-lane estimate is "~5/it"; elapsed is 8 iters (236–243) since re-engagement, with the sorry count moving from 3 to 2. 8 elapsed > 5 estimated = SLIPPING. At 1.6× the estimate it does not yet cross the 2× OVER_BUDGET threshold, but the iter-243 INCOMPLETE + 0 declarations is a downward turn.
- **Verdict**: **STUCK**
  - Trigger: sorry count flat for 3 consecutive iters (241–243); prover status includes INCOMPLETE (iter-243); recurring blocker phrase ("defeq wall") across ≥3 iters (in fact ≥7); helpers added without sorry-elimination since iter-241.
- **Primary corrective**: **Address deferred infrastructure** — the #37189 Mathlib bump is the documented fallback and has been documented as such since iter-242 without being executed. The defeq wall is not something the prover can work around (it has tried for 7 iters); the infrastructure must move. The must-fix action this iter is: the HOLD must be accompanied by a written re-engagement condition in `iter/iter-244/plan.md`, e.g., "FlatBaseChange re-engages after `IsInvertible.pullback` is closed OR after #37189 is merged, whichever comes first; targeted no later than iter-N." Without this, the next HOLD becomes an avoidance finding automatically.
- **Secondary corrective**: If the #37189 bump timeline is indefinite, consider **Route pivot** or explicit de-scoping of the affine-close sub-goal (accept a sorry placeholder for the defeq-sensitive obligations, land what's provable, and close the sorry count via a `sorry`-bridge that the mathematician can replace when #37189 lands).

---

## PROGRESS.md dispatch sanity

- **File count**: 1 (cap: 10)
- **Ready but not dispatched**: FlatBaseChange.lean — held by deliberate decision with documented strategic rationale (both obligations Mathlib-scale, defeq wall 7 iters, watch-signal fired). One file fewer than ready. Per the rules, one fewer is acceptable given explicit strategic reasons.
- **Over the cap**: No (1 of 10)
- **Under-dispatch finding**: No — with FlatBaseChange on a documented strategic hold and no other files out of scope for actionable reasons (Route-C pause, RPF/FGA held pending `IsInvertible.pullback`, A.3+ user-blocked), the 1-file proposal reflects genuinely constrained availability, not planner throttling.
- **Iter-over-iter trend**: Not assessed (dispatch-sanity across iters is not provided in the directive for this metric).
- **Verdict**: **OK** — file count 1 within cap 10; FlatBaseChange hold is deliberate and documented; no other ready lanes are silently bypassed. **One iter away from an avoidance finding**: if FlatBaseChange is HELD again at iter-245 without a re-engagement plan in iter-244's plan sidecar, it must be flagged as avoidance at that audit.

---

## Must-fix-this-iter

- **Route TensorObjSubstrate**: CHURNING — primary corrective: **Mathlib analogy consult** (gate the prover dispatch on the mathlib-analogist's confirmation that presheaf-level δ is a cheaply-provable iso; if the analogist returns "Mathlib-scale," immediately escalate to Route pivot rather than finding a fifth surface route). Why: 4 consecutive PARTIAL statuses + possible rotation churn signal; unchecked, another prover dispatch risks landing a fifth "Mathlib-scale" result and burning another iter.
- **Route FlatBaseChange**: STUCK — primary corrective: **Address deferred infrastructure** — the HOLD must be documented with a concrete re-engagement condition in `iter/iter-244/plan.md` (a named iter target or a named upstream event). A HOLD without a re-engagement condition is indistinguishable from indefinite deferral. Why: "defeq wall" recurring 7 consecutive iters (237–243); iter-243 INCOMPLETE; both affine-close obligations Mathlib-scale; the documented fallback (#37189 bump) has been known since iter-242 without action.

---

## Informational

- **TensorObjSubstrate rotation-churn flag**: The iter-242, 243, and 244 pivots share a structural pattern: each discovers a new surface approach that bottoms at absent Mathlib infrastructure. The three surface routes named so far (concrete-P / `extendScalars`, local-trivialization / `isLocallyTrivial`, presheaf δ iso upgrade) may share the same root gap. Strategy-critic is the right agent to confirm this — the progress-critic cannot assess this without reading the strategy and blueprint.
- **FlatBaseChange OVER_BUDGET watch**: At 8 elapsed vs. ~5 estimated (SLIPPING), the route has not crossed the 2× OVER_BUDGET line yet. But if FlatBaseChange re-engages after the hold and does not close a sorry in the first 2 iters of re-engagement, the throughput bucket shifts to OVER_BUDGET and the must-fix classification escalates.

---

## Overall verdict

Two active routes, both in failure modes. TensorObjSubstrate is CHURNING: 4 consecutive PARTIAL statuses, 10 helpers added, critical-path deliverable `IsInvertible.pullback` absent for 5 iters, and a possible rotation-churn pattern where each iter finds a new surface route that bottoms at the same Mathlib infrastructure gap. The planner's current iter-244 proposal (gate on mathlib-analogist confirmation before dispatching) is the correct corrective — but it must actually block; a prover dispatched without that confirmation risks a fifth wasted iter. FlatBaseChange is STUCK: the SheafOfModules defeq wall has recurred for 7 consecutive iters and both remaining obligations are Mathlib-scale. The proposed HOLD is strategically sound but must be paired with a written re-engagement condition this iter or the hold silently converts to indefinite deferral. Dispatch is otherwise OK (1 of 10 cap, FlatBaseChange hold is intentional and documented). The planner's iter-244 must-fixes: (1) block TensorObjSubstrate prover on the mathlib-analogist return, and (2) write a concrete FlatBaseChange re-engagement condition into `iter/iter-244/plan.md`.
