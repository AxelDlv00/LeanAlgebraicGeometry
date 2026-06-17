# Progress Critic Report

## Slug
ts224

## Iteration
224

## Routes audited

### Route: A.1.c.SubT.dual (`AlgebraicJacobian/Picard/TensorObjSubstrate.lean`)

- **Sorry trajectory**: 80 → 80 → 80 → 81 → 81 across iters 219–223. Net: +1. Not strictly decreasing. The sorry count has been flat or rising for 5 consecutive iters; no target sorry has been eliminated in the 5-iter window.
- **Sub-step trajectory** (declared convergence metric): sub-steps 1 and 2 retired (iters 219, 220). Sub-step 3 in progress for iters 221, 222, 223 — 3 consecutive PARTIAL/BLOCKED iters with 0 sub-step retirements.
- **Helper accumulation**: ~33 decls added across 5 iters; 0 target sorries closed; sorry count net +1. Sub-step 3 has absorbed 3 iters of helper work with no closure. The iter-223 output is the worst-case signal: 0 new live decls, prover reverted its own edits.
- **Prover dispatch pattern**: 1 of 1 active route dispatched each iter, no under-dispatch.
- **Recurring blockers**: `whnf` heartbeat bomb / `(deterministic) timeout at whnf, 200000 heartbeats` appears in iter-222 AND iter-223 — two consecutive iters. Not yet ≥3 by the strict STUCK rule, but the iter-223 finding materially worsens the signal: the iter-222 "localized bomb + 3 whnf-free routes" diagnosis was refuted. The bomb is goal-wide and fires on the FIRST rewrite of ALL three proposed routes. `local irreducible` cannot shield. This is not a blocker narrowing toward closure — it is a diagnosis expanding toward "structural API gap."
- **Avoidance patterns**: none. Route continuously active; no off-critical-path reclassification, no consecutive plan-only iters, no deferral language.
- **Prover status pattern**: PARTIAL × 4 (iters 219–222), then PARTIAL/BLOCKED (iter-223) with zero new decls and reverted work. The iter-223 status is functionally INCOMPLETE on sub-step 3.
- **Throughput**: SLIPPING — strategy estimate ~6–12 iters entered at iter-219; elapsed 5. Lower bound (6) is at the next iter. Sub-step 3 has now consumed 3 of those 5 iters, leaving sub-steps 4 and 5 (sheaf condition, inverse object) untouched.
- **Verdict**: **CHURNING** — PARTIAL × ≥3 rule applies (5 of 5). The route is advancing on *understanding* the blocker (each iter the diagnosis gets more precise: iter-222 "localized bomb," iter-223 "goal-wide toxicity, `tensorUnit_map` is the required lemma") but is definitively STUCK on *closing* the naturality sorry. The decisive negative in iter-223 (all three proposed fixes refuted, prover reverted work) is a stronger CHURNING signal than the iter-222 partial assembly.

**Primary corrective**: Mathlib analogy consult (api-alignment). The CHURNING is driven by an elaboration-cost blocker that the prover cannot resolve by adding more helpers or retrying existing tactics. The iter-223 finding names the exact lemma required (`tensorUnit_map`) and confirms `local irreducible` cannot shield. An analogist consult targeted at "does `tensorUnit_map` or an equivalent Mathlib lemma provide a whnf-free naturality discharge for `internalHomEval`, and if so, what is the call shape?" is the minimum-scope action that can unblock the route. This is the corrective pre-committed by the iter-223 plan's escalation tripwire, and that tripwire was triggered.

**On the revert fallback**: holding the revert (`internalHomEval` to ABSENT, sorry 81→80) pending the analogist verdict is sound. The sorry at 81 is an active debt; it should not persist beyond one more prover round after the analogist returns. Pull it automatically under the tripwire defined below.

**Secondary corrective (contingent, only if analogist returns "no path without upstream Mathlib PR")**: Route pivot within sub-step 3 — restructure `internalHomEval` as a morphism assembly that avoids the `𝟙_`-unit naturality check entirely (e.g., define the evaluation map at a universe-polymorphic or functorially-abstracted level where the unit isomorphism is definitionally trivial). This is the "structural refactor" corrective and should only be triggered if the analogist finds the gap is in Mathlib, not in the project's tactic selection.

---

## Tripwire for iter-225 (Question 3)

Execute the revert-to-absent fallback (sorry 81→80) and move the lane's frontier to sub-step 4 (sheaf condition, building on the axiom-clean presheaf) if ANY of the following hold after the iter-224 analogist returns:

1. **Analogist verdict is "no path"**: the analogist finds no Mathlib lemma that avoids the `𝟙_`-whnf reduction in the naturality goal, or finds that the required lemma (`tensorUnit_map` or equivalent) does not exist in current Mathlib and would require an upstream PR.
2. **Analogist finds a path, but prover cannot close in one round**: if iter-225 dispatches with the analogist's path and the naturality sorry remains at 81 after that round, the route has spent 5 iters on sub-step 3 with the lower bound of the strategy estimate already elapsed. Pull the revert and advance to sub-step 4 — the sheaf condition does not depend on the eval morphism being closed.
3. **Analogist path requires structural refactor of `internalHomEval`'s definition**: if closing the naturality requires changing the type signature or the assembly shape of the morphism (not just the proof tactic), treat this as a sub-step 3 branch failure and revert. A definition-level change at this stage would require re-verifying sub-step 2's compatibility, which is not within the 1–2 iter budget.

Do NOT pull the revert preemptively before the analogist returns. The iter-223 finding ("`tensorUnit_map` is the exact lemma needed") is specific enough that the analogist may return a direct path, and the revert would be a false pessimism.

---

## PROGRESS.md dispatch sanity

- **File count**: 0 prover files (1 analogist consult subagent)
- **Cap**: not exceeded
- **Over the cap**: no
- **Under-dispatch finding**: no — this is a justified 0-prover iter. The route's sole blocker is an elaboration-cost API gap that another prover round cannot resolve. The pre-committed escalation tripwire was triggered (iter-223 did not close the naturality sorry). This is the first plan-only iter since route entry; it is not a consecutive plan-only pattern (iter-223 dispatched a prover).
- **Iter-over-iter trend**: 1 prover × 4 iters → 0 provers × 1 iter. The drop to 0 is correct given the escalation.
- **Verdict**: OK — file count 0 within cap, no under-dispatch given the justified escalation, not a bloat-without-progress pattern.

---

## Must-fix-this-iter

- Route A.1.c.SubT.dual: **CHURNING** — primary corrective: Mathlib analogy consult (api-alignment) targeted at `tensorUnit_map` / whnf-free naturality discharge for `internalHomEval`. Why: PARTIAL × 5 rule triggered; sub-step 3 has stalled 3 consecutive iters; iter-223 decisive negative refuted all three proposed whnf-free routes; prover reverted its own edits. The pre-committed escalation tripwire is satisfied — dispatch the analogist, do not schedule another prover round before the verdict returns.

---

## Overall verdict

One route audited. CHURNING verdict triggered by PARTIAL × 5 and confirmed by the iter-223 decisive negative (all whnf-free routes refuted, prover reverted work, zero new decls). The route is advancing on *understanding* the blocker — each iter the diagnosis sharpens — but is definitively stalled on *closing* the naturality sorry. The sub-step frontier has not moved in 3 iters. The proposed iter-224 action (0 provers, 1 Mathlib analogy consult) is the correct corrective type and honors the pre-committed escalation tripwire from the iter-223 plan. The planner should dispatch the analogist, hold the revert fallback pending the verdict, and apply the iter-225 tripwire mechanically: if the analogist finds no path, or if one more prover round does not close the sorry, execute the revert (81→80) and advance the lane's frontier to sub-step 4 (sheaf condition). The route's on-schedule budget is being consumed; sub-steps 4 and 5 must not be delayed indefinitely by a blocked sub-step 3.
