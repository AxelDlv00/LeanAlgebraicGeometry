# Progress Critic Report

## Slug
ts240

## Iteration
240

## Routes audited

### Route: `Picard/TensorObjSubstrate.lean` — A.1.c substrate `IsInvertible.pullback`

- **Sorry trajectory**: 2 → 2 → 2 → 2 across iter-236 to iter-239 (unchanged overall; file-level count confirmed at 2 real code-level sorries — `exists_tensorObj_inverse` L715 and `addCommGroup_via_tensorObj` L1005)
- **Helper accumulation**: 1 helper added in iter-239 (`sheafifyTensorUnitIso`), toward a target that was then declared structurally impossible under the dispatched recipe; 0 sorries closed
- **Prover dispatch pattern**: first dispatch on this specific sub-target (A.1.c `IsInvertible.pullback`) was iter-239; prior iters (237–238) were on the A.1.c.SubT group-law sub-target (now DONE)
- **Recurring blockers**: none — the "abstract left adjoint pullback has no sectionwise/stalkwise formula" blocker is a 1st-occurrence finding (iter-239); not yet recurring
- **Avoidance patterns**: none — the iter-240 plan-only pass is the first for this sub-target and is warranted by the dead-recipe discovery
- **Prover status pattern**: PARTIAL/BLOCKED (iter-239) — only 1 iter of data for this sub-target phase
- **Throughput**: UNCLEAR — only 1 iter elapsed against a ~4–7 iter estimate; far too early to judge budget
- **Verdict**: UNCLEAR — fresh phase with exactly 1 iter of prover data; the dead-recipe discovery is a legitimate design-pivot signal, not yet a churn pattern. Proceed with the planned mathlib-analogist + blueprint rewrite pass.

**One informational flag**: if iter-241 is also plan-only on this target (no prover dispatch after the chapter rewrite), that will be the second consecutive plan-only iter on this route. The CHURNING plan-phase-only rule fires at ≥3 consecutive zero-prover iters, but the pattern should be watched from iter-241 onward.

---

### Route: `Cohomology/FlatBaseChange.lean` — engine, affine flat base change (`i=0`, Stacks 02KH)

- **Sorry trajectory**: 2 → 2 → 2 → 3 across iter-236 to iter-239 — net **increase** of 1 over 4 iters; zero sorries closed, one additional sorry pinned
- **Helper accumulation**: 5 helpers added across 3 active-prover iters (3 in iter-237, 0 in iter-238, 2 in iter-239); net sorry movement: +1. Helper-to-closure ratio is undefined — no sorry has ever been closed on this route.
- **Prover dispatch pattern**: PARTIAL (iter-237) → no dispatch / blueprint expansion (iter-238) → PARTIAL (iter-239) → no dispatch / pivot pending (iter-240 proposal). Two out of four iters had zero prover dispatch.
- **Recurring blockers**: "smul / `Module` carrier wall" / "`Module.compHom` letI not consumed by `LinearMap.restrictScalars`" — appears in iter-234, iter-235, iter-236, iter-239. **Four consecutive recurrences** of the same carrier-wall blocker at 3 successive section locations (`⊤`→Γ→`D(a)`→`Module R`). This is the defining signal.
- **Avoidance patterns**: Persistent deferral language — "owed the affine close; hard commitment next iter" (iter-237 plan) → blueprint expansion corrective (iter-238, prover deferred) → "ONE post-corrective attempt justified; if sorry stays flat → ROUTE PIVOT" (iter-239 plan). Three consecutive iterations, three different framings of "not yet but next time." The iter-239 reversal signal correctly fired; the planner is now executing the route-pivot. No avoidance is ongoing — the pivot is the correct response and is being acted on this iter.
- **Prover status pattern**: PARTIAL → (no dispatch) → PARTIAL — never COMPLETE; zero sorries closed; sorry count worsened
- **Throughput**: the strategy's ~30–60 iter estimate is for the whole engine, not this specific affine close. The affine close has been the named target since iter-237 (3 iters elapsed, 0 sorry-eliminations). SLIPPING on this specific affine-close sub-phase; the engine-level estimate is not directly comparable, but 3 iters with net +1 sorry and a confirmed dead-recipe is a severity signal.
- **Verdict**: **STUCK**

  Verdict rules matched:
  - Sorry count net-worsened across 4-iter window (2→3, zero closed) ✓
  - Recurring blocker phrase across ≥3 iters (carrier wall: 234, 235, 236, 239) ✓
  - Helpers added (5 total) without any sorry-elimination across K iters ✓
  - Deferral language persisting across ≥2 consecutive iter sidecars ✓ (iter-237 → 238 → 239 all contain "next iter" / "deferred" framing)

- **Primary corrective**: **Route pivot** — the planner is correctly executing this: the mathlib-analogist (api-alignment) has been dispatched this iter to find an affine-pushforward-preserves-quasi-coherence idiom that sidesteps the recurring `Module.compHom` carrier-wall transport. This is the appropriate corrective. The must-fix-this-iter flag below is informational — the planner has already acted.

  **Critical constraint for the pivot**: the new route must not produce a fourth blueprint-expansion cycle. If the analogist returns a viable Mathlib idiom, the prover dispatch in iter-241 must be scoped to the concrete idiom path (not another "set up helpers for next iter" round). The sorry count must go DOWN at iter-241, or the route-pivot itself must be declared and a second Mathlib-idiom search (potentially user escalation) is warranted.

---

## PROGRESS.md dispatch sanity

- **File count**: 0–1 (conditional fast-path)
- **Cap**: 10
- **Ready but not dispatched**: TensorObjSubstrate (HARD-GATE-blocked — chapter describes dead recipe, rewrite in progress this iter); FlatBaseChange (deliberately held — pivot pending analogist return). Both files are blocked by legitimate gating conditions, not avoidance.
- **Over the cap**: no
- **Under-dispatch finding**: no — neither file meets the "complete chapter + open sorries" definition of "ready" in the strict sense: TOS's chapter is HARD-GATE-blocked (dead recipe), FBC's pivot has not yet been determined. The planner has correctly classified both as not-yet-dispatchable.
- **Iter-over-iter trend**: 2 dispatched (iter-239) → 0–1 (iter-240 proposal). The single-iter drop to 0 is explained by the dual gating condition; this is not a persistent under-dispatch pattern.
- **Verdict**: OK — file count 0–1 within cap 10, gating conditions legitimate, no under-dispatch finding.

---

## Must-fix-this-iter

- **Route `FlatBaseChange.lean`**: STUCK — primary corrective: **Route pivot** (already in execution via mathlib-analogist dispatch). Why: recurring carrier-wall blocker at 4 iterations, sorry count net +1 across 4 iters, zero sorry-eliminations ever on this route, deferral language persisted across 3 iter sidecars. The pivot is correctly armed; iter-241 must produce a sorry-drop on a concrete new route or escalate further.

---

## Informational

**TensorObjSubstrate — watch from iter-241**: UNCLEAR verdict is appropriate for 1 iter of data, but the route is at risk of entering a plan-phase-only avoidance pattern if the blueprint rewrite is followed by another design-only iter rather than a prover dispatch. The CHURNING rule (≥3 consecutive zero-prover iters on a route) would fire at iter-242 if the chapter remains HARD-GATE-blocked. Track carefully.

**FlatBaseChange pivot quality gate**: the analogist's returned idiom (if any) needs to be scoped to a concrete sub-step the prover can execute in one iter. Vague idiom sketches that require another blueprint expansion round before the prover can proceed would re-enter the churn pattern immediately.

---

## Overall verdict

Two routes audited. `TensorObjSubstrate.lean` is UNCLEAR (fresh 1-iter phase, dead-recipe pivot is correct, design pass is warranted). `FlatBaseChange.lean` is STUCK (4-recurrence carrier-wall blocker, zero sorries ever closed, net +1 sorry over 4 iters, deferral language across 3 iter sidecars) — but the planner has already identified and is executing the correct corrective (route pivot via mathlib-analogist). Dispatch sanity is OK; the 0-dispatch conditional plan is justified by legitimate blueprint-gate and pivot-pending blockers. The planner's iter-240 design pass is the correct response to both signals; the key test comes at iter-241, where FlatBaseChange must either show a sorry drop on the new route or escalate to user consultation.
