# Progress Critic Report

## Slug

iter139

## Iteration

139

## Routes audited

### Route: Piece (i.b) Step 2 — `Cotangent/GrpObj.lean` `relativeDifferentialsPresheaf_basechange_along_proj_two`

**Window**: iter-134 → iter-138 (K=5).

#### Signal extraction

- **Sorry trajectory (file-level GrpObj)**: 3 → 3 → 2 → 2 → 3.
  Net change over K window: **0**. Not strictly decreasing.
  Sub-route-specific trajectory (Step 2 only): 1 (hollow) → 1 (honest
  scaffold) → 1 (unchanged, no Step-2 work) → 1 (unchanged, no Step-2
  work) → 3 (decomposed into 3 sub-sorries; +2 net on this sub-route).
- **Helper accumulation**: helpers added in 3 of 5 iters (iter-134:
  4 helpers for Step 1; iter-136: 1 helper for Step 3; iter-138: 2
  helpers for Step 2). On Step 2 specifically, only 1 helper-adding
  iter (iter-138).
- **Recurring blockers**:
  - `PresheafOfModules.pullback` chart-opacity — appears in iter-137
    + iter-138 prover reports (2 iters). Iter-138 pivoted approach
    (Route (a) → Route (b)) to sidestep, but the same opacity class
    is plausibly reachable for the remaining `IsIso` sub-sorry.
  - `simp` does not beta-reduce inside `Derivation.mk` lambdas —
    iter-138 only, not recurring.
- **Prover status pattern**: COMPLETE, COMPLETE, COMPLETE, PARTIAL,
  PARTIAL. 2 consecutive PARTIAL at the trailing edge; 2-of-5 total
  PARTIAL (rule trigger is ≥3-of-5).

#### Strict rubric application

- **CONVERGING** — requires strict-decreasing sorry count. Sorry
  trajectory is 3→3→2→2→3, not strictly decreasing. **Fails.**
- **CHURNING (path A)** — requires helpers in ≥2 iters AND net
  sorry change ≤0.5/iter AND **no structural change in approach**.
  Helpers (3-of-5) ✓; sorry net 0/5 ✓; structural change **did
  occur** at iter-138 (Route (a) → Route (b) pivot). **Fails** on
  the third subclause.
- **CHURNING (path B)** — requires PARTIAL ≥3-of-5. Count is 2-of-5.
  **Fails.**
- **STUCK** — requires either (sorry count unchanged across K + an
  INCOMPLETE or 3+-iter recurring blocker) or (helpers without ANY
  sorry-elimination across K). Sorry count is not strictly unchanged
  (Step 1 closed iter-134, Step 3 closed iter-136). No INCOMPLETE.
  Recurring-blocker phrase count is 2 iters, below the 3-iter STUCK
  threshold. **Fails.**
- **UNCLEAR** — signals ambiguous. **Matches.**

**Verdict**: **UNCLEAR** — leaning toward CONVERGING-with-watch.

#### Why UNCLEAR, not CONVERGING

The K-window data is noisy because three different sub-routes
(Steps 1, 2, 3) were targeted across the window: iter-134 targeted
Step 1, iter-136 targeted Step 3, iter-138 targeted Step 2. Iters
135 and 137 did not produce code-level Step 2 advances. On Step 2
specifically the window contains **one** iter of substantive code
work (iter-138). That is below the K≥3 threshold needed to render a
non-ambiguous verdict on Step 2 alone.

The strict CONVERGING rule's "sorry count strictly decreasing"
clause fails because iter-138's decomposition added +2 sub-sorries
to the file count. The rebuttal "decomposition is mid-route
progress" is sound *if* the new sub-sorries are genuinely narrower
and independently dispatchable AND the d_add + d_mul closures are
real (not sorry-shuffling). The signals available to me — 92 LOC
body + 2 named helpers + 2 closed derivation fields out of 4 —
are consistent with genuine decomposition but cannot confirm it
from progress-signal data alone (that's the auditor's territory).

#### Why UNCLEAR, not CHURNING

Both CHURNING paths fail strict checks. Path A fails because
iter-138 *did* pivot approach (Route (a) → Route (b)) — this is the
structural change the rule requires for non-CHURNING. Path B fails
because PARTIAL count is 2, not 3. The planner has also adopted
the iter-138 progress-critic's recommended corrective (mathlib-
analogist consult on Route (a) vs Route (b'2) for IsIso) as
parallel Wave 2, which is an explicit escalation rather than a
silent helper round.

The case for CHURNING anyway: (a) 2-PARTIAL-in-a-row is
trending-toward-3-of-5 — one more PARTIAL iter triggers Path B
hard; (b) the same `pullback` chart-opacity class is plausibly
recurring even though Route (b) sidestepped it once, so the
blocker may resurface for the IsIso sub-sorry; (c) the auditor's
"fully sorry-supported" finding on the iso indicates the
substantive math content of iter-138 is concentrated in d_add +
d_mul, and the iso glue may still face the original blocker. These
are watch criteria, not verdict triggers yet.

#### Re-evaluation of the iter-138 progress-critic's flagged points

1. **Did structural decomposition advance the route?** Signal-level
   yes: d_add + d_mul are claimed-closed substantively; the
   residual is now 3 narrowly-scoped sub-sorries whose names and
   internal positions (L581, L585, L624) suggest independent
   dispatch is feasible. But the auditor's "1 hollow → 3 narrow
   sorries with no math verified" framing has weight — verification
   that the d_add/d_mul closures are real (not sorry-replacement)
   sits with the auditor, not me.
2. **2 PARTIAL in a row vs 3-of-5 trigger.** 2-in-a-row is not the
   strict trigger but is a "one-iter-away-from-CHURNING" warning.
   Iter-140 progress-critic should treat a third PARTIAL as
   hard-CHURNING.
3. **Sorry trajectory +2 on Step 2 alone.** The decomposition
   rebuttal is sound *iff* the new sub-sorries are independently
   dispatchable — which the names + helper structure suggest, but
   only iter-139 prover lane will demonstrate. If iter-139 closes
   ≥2 of the 3 sub-sorries, the rebuttal is confirmed.
4. **Helper accumulation on Step 2: 1 iter only.** Correct — Step 2
   has had a single helper-construction iter (iter-138). This is
   not a "helpers-without-payoff" churn pattern; it's the first
   substantive attempt iter. The rule against repeated helper
   rounds without convergence does not yet apply.
5. **Mathlib-analogist consult adoption.** The iter-138 progress-
   critic recommended this corrective; the iter-139 plan dispatches
   it as Wave 2. This satisfies the recommendation. **No further
   corrective is required this iter beyond what the planner has
   already proposed**, contingent on the prover lane delivering ≥2
   of 3 sub-sorries closed.

#### Watch criteria for iter-140

The iter-140 progress-critic should apply these gates strictly:

- **CONVERGING-confirmed (proceed to Main)**: iter-139 closes ≥2
  of 3 sub-sorries (d_app + d_map at minimum); mathlib-analogist
  report names a concrete Route (a) or Route (b'2) IsIso strategy.
- **CHURNING-triggered**: iter-139 closes 0 or 1 sub-sorries (third
  consecutive PARTIAL → Path B trigger fires at 3-of-5). Primary
  corrective: refactor or blueprint expansion on the derivation-
  level approach; pause Wave 2 mathlib-analogist consult until the
  derivation closes.
- **STUCK-triggered**: iter-139 closes 0 sub-sorries AND the
  `pullback` chart-opacity blocker resurfaces in the d_app or d_map
  attempt (3rd iter of same blocker phrase). Primary corrective:
  route pivot — reconsider Route (b) viability vs alternative
  presentations of `relativeDifferentialsPresheaf_basechange_along_proj_two`.

## Must-fix-this-iter

(none — UNCLEAR is not gating)

## Informational

- Route "Piece (i.b) Step 2" — **UNCLEAR**, leaning CONVERGING-with-
  watch. The planner's iter-139 proposal (close 2-of-3 sub-sorries
  in prover lane; mathlib-analogist Wave 2 for IsIso) is responsive
  and addresses the iter-138 progress-critic's recommended
  corrective. Proceed as planned. Iter-140 progress-critic should
  apply strict gates per the watch criteria above.

## Overall verdict

One route audited; verdict is UNCLEAR. The K-window data mixes
three sub-routes (Steps 1, 2, 3) of a single piece, and Step 2
itself has only one iter of substantive code work (iter-138). The
strict rubric does not cleanly satisfy CONVERGING (sorry count not
decreasing), CHURNING (structural change occurred + PARTIAL count
below threshold), or STUCK (sorries did close during the K window
on other steps). The planner's proposal already incorporates the
iter-138 progress-critic's recommended mathlib-analogist consult,
so no new corrective is needed this iter. Iter-139's prover-lane
outcome is the disambiguating signal — if ≥2 of 3 sub-sorries
close honestly, CONVERGING is confirmed; if 0 or 1 close, iter-140
hard-triggers CHURNING and the planner must escalate beyond the
current Wave-2 consult. The iter's shape should be: proceed with
the prover lane on Step 2 sub-sorries, run the mathlib-analogist
consult in parallel, and the iter-140 progress-critic will resolve
the verdict.
