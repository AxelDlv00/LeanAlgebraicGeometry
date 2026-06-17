# Progress Critic Report

## Slug
pc256

## Iteration
256

## Routes audited

### Route 1 — Lane TS-cmp `Picard/TensorObjSubstrate.lean` (pullback-monoidality arc)

- **Sorry trajectory**: 3 → 3 → 3 → 2 → 1 across iter-251 to iter-255. Strictly decreasing in the last 2 iters; the remaining file sorry (`exists_tensorObj_inverse`) is cross-file gated and explicitly not this lane's obligation.
- **Helper accumulation**: +6 (iter-251), +1 (iter-252), +2 (iter-253), ~1 STEP-A helper (iter-254), 0 (iter-255 fix was a one-line proof-side ascription). Net: early helper churn transitioned cleanly to zero-helper close in iter-255.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, COMPLETE (STEP A), COMPLETE (D1′ canonical target). Last two iters are COMPLETE — the PARTIAL streak broke.
- **Recurring blockers**: "δ_natural MonoidalCategory carrier-spelling synthesis" — recurred across iter-251 to iter-254; explicitly dissolved in iter-255 via the `show…from` ascription device. No active recurring blocker for iter-256.
- **Avoidance patterns**: None.
- **Throughput**: OVER_BUDGET — STRATEGY.md estimates 4–7 iters left (was 6–11 original); 22 elapsed vs 6–11. However, the sorry trajectory is now actively closing 1 per iter in the last 2 iters, so the over-budget flag reflects elapsed time, not current stall.
- **Verdict**: **CONVERGING**

Route 1 is cleanly converging. The D3′ `pullbackTensorMap_restrict` target has all blueprint dependencies closed (D1′ iter-255, D2′ iter-250, `pullbackObjUnitToUnit_comp` prior) and a concrete recipe (mirror the D1′ `show…from` device). No must-fix action required.

---

### Route 2 — Lane TS-inv `Picard/TensorObjSubstrate/DualInverse.lean` (dual-inverse / group inverse)

- **Sorry trajectory**: 2 → 2 → 2 → 2 → 2 across iter-251 to iter-255. **Zero net change across all K=5 iters.** The file-level sorry count has not moved in five consecutive iterations.
- **Helper accumulation**: Several (iter-251); `homLocalSection` CLOSED (iter-252); `topSectionToHom` CLOSED (iter-253); sub-step (a) CLOSED, (c) ~90% (iter-254); M-leg of (c) CLOSED (iter-255). Substantial internal sub-step work, but it has not translated to any file-level sorry elimination.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, PARTIAL, PARTIAL — 5 consecutive PARTIAL on the same `homOfLocalCompat` target.
- **Recurring blockers**: "carrier-duality / restrictScalars smul instance bridge" — present in iter-252, iter-253, iter-254, iter-255 (4 of 5 iters). The directive characterizes it as "provably SMALLER each iter" which is accurate (scope narrows: whole-decl → sub-step → M-leg → single f-leg). But at the file-sorry level the wall has not fallen.
- **Avoidance patterns**: None of the planner-laziness type. The planner has been actively dispatching this lane and iterating on approach.
- **Throughput**: OVER_BUDGET (same A.1.c.sub row as Route 1).

**Verdict: CHURNING**

Applying the rules verbatim:
- Sorry count net unchanged across K iters (2 → 2, zero net): qualifies.
- Helpers added in ≥2 of last K iters AND sorry count net unchanged: qualifies (helpers/sub-steps in iter-251, 252, 253, 254, 255).
- PARTIAL status ≥3 of last K iters (PARTIAL all 5): qualifies.

All three CHURNING triggers are met simultaneously. The internal-progress narrative (obstacle shrinking each iter) is directionally correct but is not the metric. The CHURNING verdict is rule-driven, not a claim that the math approach is wrong.

**Primary corrective**: **Execute inline close — no new helpers.** The planner has correctly diagnosed this in iter-255 ("extra scaffolding IS the churn to break") and prescribed exactly the right action for iter-256: inline execution with `ModuleCat.restrictScalars.smul_def`/`restrictScalarsId'App`, no new helper declarations. This corrective is already encoded in PROGRESS.md. The CHURNING verdict exists here to create explicit accountability: if iter-256 returns another PARTIAL on `homOfLocalCompat`, it cannot be ratified silently — the planner must escalate to a mathlib-analogist consult or a structural consult on the f-leg bridge, not another "we narrowed the obstacle" helper round.

**Regarding `dual_restrict_iso` Step-4 (Q3):** Keep gated behind `homOfLocalCompat` closing. The existing gating condition ("ONLY if homOfLocalCompat closes") is correct. But given 5 PARTIAL iters on the prerequisite and Step-4 being a "known hard slice-site base-change build," the prover should treat Step-4 as aspirational-only this iter and invest all capacity in the `homOfLocalCompat` closure first. Additionally: if `homOfLocalCompat` DOES close and the prover reaches Step-4, this is exactly the target for which a mathlib-analogist pre-consult (prior to the next iter's prover dispatch) would be warranted — Step-4 has been deferred as a structural hard wall repeatedly, and it should not enter a prover round without a concrete recipe. **Recommendation: do NOT attempt Step-4 in iter-256's prover round even if `homOfLocalCompat` closes; instead, report the milestone and leave Step-4 for a next-iter dispatch with a recipe (analogist or blueprint-expansion first).**

---

### Route 3 — Lane engine `Picard/LineBundleCoherence.lean` (A.2.c coherence entry)

- **Sorry trajectory**: No prior data (0 iters of prover signal).
- **Prover status pattern**: No data.
- **Recurring blockers**: None identified (fresh route).
- **Avoidance patterns**: None — this lane is opening now per the strategy, not being deferred.
- **Throughput**: ESTIMATE_FREE for this specific file; A.2.c-engine is 0 iters elapsed vs. 85–140 estimated.
- **Verdict**: **UNCLEAR** — fresh route, insufficient data. Proceed with scaffold + de-risk; watch for site-instance gaps.

The proposed scope (skeleton scaffold + de-risk investigation of `J.over X`/`X.ringCatSheaf` site instances, no proofs) is appropriately conservative for a first iter. If the de-risk reveals that `HasWeakSheafify`/`WEqualsLocallyBijective`/`HasSheafCompose` for `J.over X` are absent from Mathlib, that is a blocking infrastructure gap warranting a mathlib-analogist consult before any subsequent prover dispatch on this file.

---

## PROGRESS.md dispatch sanity

- **File count**: 3 (cap: 10)
- **Ready but not dispatched**: None identified. All held lanes (RPF, FGA, Albanese, RR) have explicit gating rationales (cross-file dependencies, Route C PAUSE, A.2.c serialization). No files with complete blueprint chapters and open sorries are being omitted without stated reason.
- **Over the cap**: No.
- **Under-dispatch finding**: No. The 3-file dispatch covers all unlocked lanes. The held lanes are legitimately gated, not avoidance.
- **Independence check**: The 3 files are genuinely independent at the import level (`TensorObjSubstrate.lean` and `DualInverse.lean` are separate files post iter-247 split; `LineBundleCoherence.lean` is a new file). No write conflicts.
- **Right-sizing check**: TS-cmp (D3′ with concrete recipe) — appropriate scope. TS-inv (`homOfLocalCompat` inline close) — appropriate scope, single residual. LineBundleCoherence (scaffold + de-risk, no proofs) — appropriate first-iter scope.
- **Verdict**: **OK** — 3 files within cap 10, no under-dispatch against available ready files, no bloat.

---

## Must-fix-this-iter

- **Route 2 (TS-inv)**: CHURNING — primary corrective: **execute inline close, no new helpers**. Iter-256 prover must treat `homOfLocalCompat` as the sole obligation and not add any wrapper helper declarations; the inline `ModuleCat.restrictScalars.smul_def`/`restrictScalarsId'App` recipe must be attempted directly. If another PARTIAL with `homOfLocalCompat` still open is returned, the planner must escalate to a mathlib-analogist consult on the f-leg ring-bridge in iter-257 — silent ratification of a 6th PARTIAL is not acceptable.
- **Route 2 secondary (`dual_restrict_iso` Step-4)**: Do NOT enter in iter-256 prover round even if `homOfLocalCompat` closes. Step-4 is a known structural hard wall; it needs a recipe (blueprint-expansion or analogist consult) before prover dispatch. Gate it to iter-257 with a pre-consult.
- **A.1.c.sub (both TS-cmp + TS-inv)**: OVER_BUDGET — 22 elapsed vs. 6–11 original. The STRATEGY.md estimate must be revised to reflect reality (~4–7 remaining at current closing rate) or the route escalated. This does not block iter-256 work but must appear in the planner's iter-256 sidecar.

---

## Informational

- **Route 1 (TS-cmp)**: The OVER_BUDGET throughput flag is noted but NOT a must-fix for iter-256 — the sorry trajectory (2→1 in last iter, 0 recurring blockers) is actively closing. The strategy estimate revision is the appropriate response, not a change to the prover dispatch.
- **Route 3 (LineBundleCoherence)**: The "do NOT attempt proofs" constraint in the objective is important — a prover assigned to this file that over-reaches into actual proof attempts (rather than scaffold + de-risk) would be burning capacity on an underspecified target. The scaffold output should clearly enumerate which site instances are present vs. absent, so the iter-257 plan can make a data-driven decision about whether to open a full prover lane or dispatch a mathlib-analogist first.

---

## Overall verdict

Two routes are healthy: Route 1 (TS-cmp) is CONVERGING with a clear next target (D3′) and no active blockers, and Route 3 (engine) is UNCLEAR but appropriately scoped. Route 2 (TS-inv) is CHURNING by all three applicable rules (zero sorry movement across K=5 iters, PARTIAL×5, recurring blocker×4) and must be treated as a must-fix: the iter-256 prover on `DualInverse.lean` must execute the inline close without helper additions, and if another PARTIAL is returned, the planner must escalate rather than dispatch a 7th round. The proposed `dual_restrict_iso` Step-4 secondary target is mis-sized for a single iter after a 5-PARTIAL prerequisite; it should not enter the iter-256 prover round at all and should be deferred to a next-iter dispatch with a pre-consult. The 3-file dispatch is within cap and each lane is independent — dispatch sanity is OK.
