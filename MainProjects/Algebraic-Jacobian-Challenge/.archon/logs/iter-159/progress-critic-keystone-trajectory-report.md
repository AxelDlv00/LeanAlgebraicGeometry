# Progress Critic Report

## Slug
keystone-trajectory

## Iteration
159

## Routes audited

### Route: genus-0 rigidity (route (c)) — `AlgebraicJacobian/AbelianVarietyRigidity.lean`

- **Sorry trajectory**: global 3 → 3 → 3 → 7 → 7 (iter-154→158). The 3→7 jump (iter-157) is
  *decomposition inflation*: one un-closed keystone (`rigidity_over_kbar`) was replaced by a
  4-link scaffold. Within the file the meaningful motion is qualitative, not count-based: iter-157
  left a **false/unsatisfiable** residual; iter-158 left **5 honest sorries** (2 internal to
  `rigidity_eqOn_dense_open` + 3 deferred scaffold links), and *eliminated* bridge 1
  (`snd_left_isClosedMap`) to a sorry-free, axiom-clean sub-lemma. Net count flat; residual
  quality strictly improved.
- **Helper accumulation**: 2 helpers across the 2 real prover iters (`rigidity_snd_lift` iter-157;
  `snd_left_isClosedMap` iter-158). This is NOT helper-churn — `snd_left_isClosedMap` is a closed,
  axiom-clean bridge that discharged a named sub-goal, not a wrapper stacked to defer work.
- **Recurring blockers**: none recurring across ≥3 iters. The iter-157 blocker ("false-as-stated /
  laundered `_hf`") was a one-iter defect, **closed** in iter-158 and verified by two independent
  review subagents — it did not recur. The two current gaps (`hfib`; relative proper-into-affine /
  Stein-factorization agreement equation) are *first-appearance* in iter-158, not recurring.
- **Prover status pattern**: route (c) has only **2** prover iters of data: iter-157 = over-claimed
  COMPLETE that review reclassified to UNSOUND (effectively INCOMPLETE), iter-158 = PARTIAL (honest).
  So the honest sequence is INCOMPLETE(false) → PARTIAL. Too short for a pattern; the PARTIAL≥3-of-K
  churn clause cannot fire (only 1 true PARTIAL exists).
- **Throughput**: ON_SCHEDULE — STRATEGY estimates "full arm ~10–18 (cumulative keystone ≈8 elapsed
  + this)"; elapsed ≈9 cumulative, ≈3 in the route-(c) file. Elapsed sits *inside* the stated band,
  and critically the estimate is **honest**: STRATEGY explicitly counts the burned df=0 iters and
  the cube as still-unbuilt. This is the opposite of the dishonest-estimate signature (no positive
  `Iters left` masking an over-budget reality).
- **Verdict**: UNCLEAR (leaning converging) — and iter-158 is **genuine forward motion, not churn**.

#### Why UNCLEAR rather than CONVERGING or CHURNING

The strict CONVERGING rule ("sorry count strictly decreasing") fails because count is flat — but
count is the *wrong metric this window*: the iter-157 scaffold inflated it by design, and iter-158's
real deliverables (laundered→sound; bridge 1 sorry→axiom-clean; false residual→2 honest gaps) are
all structural advances the count does not capture. Equally, CHURNING does **not** fire on any
verbatim clause: (a) the "helpers + flat count + *no structural change*" clause fails because every
iter 156–158 carried a structural change (pivot, scaffold, soundness refactor); (b) PARTIAL≥3 fails
(only 1 honest PARTIAL exists); (c) the ≥3-consecutive-zero-prover meta-pattern fails (157 and 158
both dispatched provers). The honest residual is simply that route (c) has **one** sound prover data
point (iter-158); that is < K, so the trajectory is not yet extrapolable. UNCLEAR = "proceed, this
is real, watch" — not a churn flag.

#### Route-level note the planner should hold (informational)

iter-158's progress is real but local to the *rigidity-lemma geometric heart*. The two gaps under
consult (`hfib`, the Stein-factorization agreement equation) plus the 3 deferred links are NOT the
heaviest piece: STRATEGY itself names the **theorem of the cube** as the cube-dominated keystone
("seesaw + flat/proper base-change + semicontinuity + line bundles on products, ALL absent from
Mathlib — comparable to a chunk of representability"), and it is entirely unstarted. Closing
`rigidity_eqOn_dense_open` does not retire the arm. Keep the cube's cost visible in the iters-left
accounting so this route does not silently slip from ON_SCHEDULE into OVER_BUDGET once the heart
closes and the cube begins.

## Assessment of the proposed plan (directive Q2 / Q3)

**The analogist-consult-then-maybe-prover plan is the correct corrective.** It is exactly the
binding fallback set last iter ("bridges must be BUILT not FOUND → scoped mathlib-analogist consult
BEFORE another prover round"). The planner is escalating to diagnosis rather than throwing a blind
prover at gaps that the prover itself flagged as not-FOUND-in-Mathlib. Credit it — this is the
opposite of the wall-throwing pattern this subagent exists to catch.

On the "are the bridges themselves multi-iter sub-builds?" concern: **likely yes for bridge 2.** The
agreement equation (relative proper-into-affine constancy / Stein factorization) is described by the
prover as the hardest residual input and is shared with Route A's Albanese UP — that profile reads
as a multi-iter own-decomposition, not a single sub-lemma. This is *precisely why* the consult is
the right move first: its job is to return either (i) a portable Mathlib technique (→ blueprint +
scoped prover, possibly same-iter as planned), or (ii) the verdict "this is its own sub-build" (→
the planner decomposes it as a named sub-target with its own iters-left line). Either outcome is
forward progress. Do not pre-empt the consult by guessing the decomposition.

**Dispatch sanity (Q3): the near-zero prover load this iter is fine and correct.** One consult-only
iter following two prover iters does NOT trip the ≥3-consecutive-zero-dispatch meta-pattern.

**Forward watch (set this now):** the zero-prover-dispatch CHURNING clause fires at *3 consecutive*
non-prover iters on this route. iter-159 consult-only = 1. If the consult does not yield a buildable
sub-lemma and iter-160 is also planning/consult-only, that is 2 — and a 3rd would be churn. So the
consult must terminate in one of two committal outcomes by iter-160: a prover-ready blueprinted
sub-lemma, OR an explicit decomposition decision (bridge 2 as its own sub-target). "Consult returned,
still thinking" is not an acceptable iter-160 state for this route.

## PROGRESS.md dispatch sanity

Verdict: OK — proposed file count 0–1 (consult-only, or at most `AbelianVarietyRigidity.lean` scoped
to one consult-made-buildable sub-lemma + the stale-docstring cleanup), far within cap; no
growth-while-churning.

## Overall verdict

One route audited, zero CHURNING/STUCK. The genus-0 rigidity route is **UNCLEAR-but-healthy**:
iter-158 was genuine forward motion (unsound→sound, bridge 1 built axiom-clean, residual narrowed
to honest gaps), the throughput estimate is honest and on-schedule, and there is simply too little
sound prover data (one iter) to upgrade to CONVERGING yet. The planner's consult-then-maybe-prover
plan and its near-zero prover load are both correct — proceed as proposed. Two things to hold: the
theorem-of-the-cube cost is still entirely ahead (don't let ON_SCHEDULE drift once the heart closes),
and the consult must reach a committal outcome (buildable sub-lemma or explicit decomposition) by
iter-160 to avoid the consecutive-non-prover-iter churn pattern.
