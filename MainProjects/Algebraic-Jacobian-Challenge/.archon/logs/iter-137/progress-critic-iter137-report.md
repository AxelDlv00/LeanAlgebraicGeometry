# Progress Critic Report

## Slug
iter137

## Iteration
137

## Routes audited

### Route 1 — piece (i.a) in `AlgebraicJacobian/Cotangent/GrpObj.lean`

- **Sorry trajectory**: `-1 substantive at iter-132 (closed `cotangentSpaceAtIdentity_finrank_eq`), unchanged in iter-133, 134, 135, 136`. Net K-window: `closed → 0 → 0 → 0 → 0`. No regression.
- **Helper accumulation**: 0 helpers added across the K-window (last 4 iters touched nothing on this route).
- **Recurring blockers**: none.
- **Prover status pattern**: `COMPLETE (iter-132)`, then NO PROVER LANE × 4. META-PATTERN TRIPWIRE non-promise held in iter-134/135/136.
- **Verdict**: **CONVERGING**.
- **Primary corrective**: none required. Route is closed and stable for 4 iters of non-touch.

### Route 2 — `Jacobian.lean:197 genusZeroWitness` (M2.b genus-0 arm)

- **Sorry trajectory**: unchanged across all 5 iters (still 1 sorry in the iter-127 scaffold body).
- **Helper accumulation**: 0 across the K-window.
- **Recurring blockers**: gated-by-design (M2.a body close + terminal-object instances). Not a real blocker — strategic deferral.
- **Prover status pattern**: NO PROVER LANE × 5.
- **Verdict**: **UNCLEAR** (effectively dormant by design — no prover signal because the route is deliberately gated). Reclassifying as STUCK or CHURNING would be wrong: the absence of progress is by-design, not a missed convergence.
- **Primary corrective**: none. The gating is correct per strategy. Re-audit when M2.a + terminal-object instances land (iter-151+).

### Route 3 — `RigidityKbar.lean:87 rigidity_over_kbar` (M2.b body-pile / M2.a)

- **Sorry trajectory**: unchanged across all 5 iters.
- **Helper accumulation**: 0 across the K-window.
- **Recurring blockers**: gated-by-design on (i)+(ii)+(iii) closure.
- **Prover status pattern**: NO PROVER LANE × 5.
- **Verdict**: **UNCLEAR** (same shape as Route 2 — gated, not stuck).
- **Primary corrective**: none. Re-audit once shared cotangent-vanishing pile (i)+(ii)+(iii) closes.

### Route 4 — piece (i.b) in `AlgebraicJacobian/Cotangent/GrpObj.lean`

- **Sorry trajectory** (route opened effectively at iter-133): `n/a → n/a → 4 → 6 → 5` across iter-132 to iter-136. Not strictly decreasing across the K-window, but the iter-135 `+2` is documented structural-honesty intervention (placeholder→scaffold refactor + `by_cases` split), not stall-shaped. Post-intervention trend (iter-135→iter-136): `6 → 5`, down 1 with COMPLETE + kernel-only.
- **Helper accumulation**: iter-134 = 3 helpers (`shearMulRight` + 2 `@[simps]` companions + `schemeHomRingCompatibility`, ~50 LOC); iter-135 = 0 (refactor only); iter-136 = 1 small private helper (`section_snd_eq_identity_struct`, substantively consumed by the closure, not churn-shaped). 4 helpers across 3 prover-active iters, with 1 substantive sorry-elimination (Step 3) and 1 substantive structural step (Step 1).
- **Recurring blockers**: none recurring. The iter-134 hollow-tautology pattern (`Nonempty (X ≅ X) := ⟨Iso.refl _⟩`) was a single-iter must-fix, addressed at iter-135 by `refactor-grpobj-and-jacobian-iter135`. It has NOT reappeared. The iter-133 `mathlib-analogist` flagged 2 NEEDS_MATHLIB_GAP_FILL sub-pieces; one (Step 3's relativeDifferentialsPresheaf restriction) has now closed, the other (Step 2's tensor-equiv/presheaf-pullback bridge) is the iter-137 target.
- **Prover status pattern**: `n/a, n/a, PARTIAL-with-must-fix (iter-134), n/a (refactor), COMPLETE (iter-136)`. One PARTIAL, one COMPLETE — does NOT meet CHURNING's "PARTIAL ≥3 of last K iters" threshold.
- **Verdict**: **UNCLEAR, trending CONVERGING**.
  - Strict-rule reading: NOT CONVERGING (sorry count not strictly decreasing in K-window — the iter-135 `+2` breaks monotonicity). NOT CHURNING (the iter-135 honest-scaffold refactor is exactly the "structural change in approach" CHURNING's third conjunct excludes; sorry count net +1 across the prover-active window but with one substantive close and one substantive structural step). NOT STUCK (Step 3 closed iter-136, sorry count moved).
  - Per dispatcher_notes' direct question — "does the iter-136 closure of Step 3 + the iter-135 honest-scaffold refactor's success constitute enough signal that Route 4 is CONVERGING": 1 of 3 substantive closures landed COMPLETE with no recurring blocker and minimal helper churn IS positive evidence, but it is one data point post-intervention. UNCLEAR with positive trend is the honest call. The iter-137 Step 2 lane is the confirmatory test: a COMPLETE there flips to CONVERGING; a PARTIAL with new hollow patterns flips to CHURNING.
- **Primary corrective (proactive, not corrective-yet)**:
  - **LOC-trigger pre-emption.** Iter-134→iter-136 added ~600 LOC cumulative on the (i.b) side per the directive. Step 2's iter-133 envelope is 150–300 LOC. That puts cumulative (i.b)-side build at ~466–616 LOC, brushing or crossing the strategy's trigger (a')/(c) 600 LOC cap. **The iter-137 plan must (a) name an explicit LOC budget for the Step 2 lane and (b) bind the prover to that budget in its directive, with an explicit "if exceeded, ship PARTIAL with diagnosis rather than padding closure"** instruction. If the lane crosses 600 LOC cumulative without closing, the iter-137 plan must commit (in iter-138 plan.md) to either (i) opening a refactor pass to extract a load-bearing helper file before Step 2 grows further, or (ii) escalating Step 2 to a `mathlib-analogist` + `blueprint-writer` re-decomposition rather than a second prover lane.
- **Secondary corrective**:
  - **Confirm the pre-dispatched `mathlib-analogist-kaehler-tensorequiv-presheafpullback-iter137` Wave-1 dispatch returns BEFORE the prover lane fires in Wave 2** (the iter-135→iter-136 Step 3 pattern depended on this ordering). If Wave 1 returns NEEDS_MATHLIB_GAP_FILL again rather than PROCEED, the iter-137 plan should hold the prover lane and dispatch `blueprint-writer` to expand the Step 2 sketch first, rather than fire prover blind.

## Must-fix-this-iter

No CHURNING or STUCK verdicts this iter, so no automatic must-fix entries. Two proactive items raised on Route 4 worth treating as soft must-fix for the iter-137 plan agent:

- **Route 4 LOC budgeting**: the iter-137 plan must name an explicit LOC budget for the Step 2 prover lane (recommendation: cap at 200 LOC delta; degrade to PARTIAL-with-diagnosis at 250 LOC) and reference the strategy's trigger (a')/(c) cumulative-600-LOC cap explicitly in the prover directive. Why: cumulative (i.b)-side build is at ~440 LOC entering iter-137; Step 2's upper envelope (300 LOC) would cross the trigger.
- **Route 4 Wave-ordering discipline**: the iter-137 plan must gate the Step 2 prover-lane Wave 2 dispatch on the Wave 1 `mathlib-analogist` returning PROCEED. If the analogist returns NEEDS_MATHLIB_GAP_FILL, the plan must hold the prover and re-dispatch blueprint-writer for Step 2's sketch first. Why: the iter-134 PARTIAL was a wave-ordering miss (no analogist consulted upfront on the load-bearing bridge), and iter-136's COMPLETE came directly from doing the analogist-first ordering at iter-135→iter-136 for Step 3.

## Informational

- **Route 1** (CONVERGING): closed at iter-132, stable across 4 subsequent iters. No iter-137 action.
- **Routes 2 and 3** (UNCLEAR — by-design gated): no iter-137 action. These are not stalled routes; they are correctly deferred. Re-audit cadence: re-include in directive when their gating pieces close.
- **Route 4** (UNCLEAR, trending CONVERGING): iter-137 Step 2 lane is the confirmatory data point. Watch for hollow-placeholder re-emergence and LOC overrun as the two specific risks; both can be pre-empted in the iter-137 prover directive.

## Overall verdict

Of 4 routes audited: 1 CONVERGING (Route 1, closed/stable), 2 UNCLEAR-by-design (Routes 2 & 3, correctly gated), 1 UNCLEAR-trending-CONVERGING (Route 4, the iter-137 target). Zero CHURNING, zero STUCK. The iter-137 plan should proceed with the Route 4 Step 2 prover lane as proposed, but must bind two proactive constraints into the prover directive: an explicit Step-2 LOC budget cross-referencing the strategy's 600 LOC trigger, and an explicit Wave-1-analogist-must-return-PROCEED gate before the Wave-2 prover lane fires. If both constraints are honored and Step 2 ships COMPLETE in iter-137, Route 4 flips to CONVERGING in iter-138's audit. If Step 2 ships PARTIAL with fresh hollow patterns or crosses 600 LOC cumulative without closure, Route 4 flips to CHURNING and the iter-138 plan must escalate to refactor or route-decomposition rather than a third prover round.
