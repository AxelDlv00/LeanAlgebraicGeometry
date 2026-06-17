# Progress Critic Report

## Slug
routec169

## Iteration
169

## Routes audited

### Route: Genus-0 base case (`AlgebraicJacobian/Genus0BaseObjects.lean` + AVR consumer chain)

- **Sorry trajectory**:
  - G0BO: 9 → 6 → 9 → 9 across iter-165 → iter-168. Net 0 over the K=4 window (one drop in iter-166 fully undone by helper-sorry additions in iter-167).
  - AVR (Lane B): 7 → 6 → 2 → 2. AVR side has substantively converged (downstream of Lane A exports).
  - Total Route-C-relevant: 15 → 15 → 14 → 14. Net −1 over 4 iters ≈ 0.25 sorry/iter — below the 0.5/iter threshold.
- **Helper accumulation**:
  - iter-165: scaffold landing — 4 base objects + 3 ℙ¹-points (skeleton opens 9 sorries).
  - iter-166: 3 ℙ¹-points axiom-clean + AVR consumer body (5 helper sorries propagated inside).
  - iter-167: 4 Lane A axiom-clean exports + 3 Lane A scaffold-sorry exports + AVR helper closure (`iotaGm_isDominant` hoisted).
  - iter-168: `projectiveLineBarAffineCover` (Step 1, axiom-clean, ~15 LOC) + 4 helper ring-homs + iso skeleton (`aux_right` axiom-clean, `aux_left` residual sorry) + `projectiveLineBar_isReduced` (Step 3, axiom-clean) — **~370 LOC of new infrastructure**.
  - Pattern: substantial helper accumulation **every** iter; the headline target `gmScalingP1` body has been **untouched for 4 consecutive iters** (the scaffold opened it iter-165; iters 166, 167, 168 did not attempt the body).
- **Prover dispatch pattern**: Directive lists 1 file for iter-169 (`Genus0BaseObjects.lean`). No "ready but not dispatched" field supplied; cannot strictly evaluate under-dispatch. Surrounding context (AVR closed, Step-1 chain closed, AV-rigidity chain closed) makes single-file dispatch on genus-0 plausible.
- **Recurring blockers**:
  - "`gmScalingP1` body NOT attempted" / "Steps 4-6 not attempted" — appears in iter-166, iter-167, iter-168 prover reports (≥3 iters).
  - "`gm_grpObj` deferred / escalation watch" — iter-166, iter-167, iter-168 (3-iter deferred per the auto-memory).
  - "time-budget decision: did not have budget to attempt Steps 4-6" — iter-168 explicit.
- **Avoidance patterns**:
  - **Persistent deferral language** across ≥2 consecutive iters: iter-167 ("(i)/(ii) DEFERRED to iter-168+, `gm_grpObj` 3-iter-deferred, escalation watch fires next iter") and iter-168 ("Time-budget decision … did not have budget to attempt Steps 4-6"). Same headline target deferred by the same kind of "budget" framing.
  - No "off-critical-path" reclassification — route has remained nominally active throughout.
  - No consecutive plan-only iters — prover did fire each iter (just not on the headline).
  - **Bounded-decomposition commitment was missed.** iter-167's commitment for iter-168 was "Steps 1+2 axiom-clean → body lands iter-168 OR iter-169." iter-168 delivered Step 1 ✓, Step 2 PARTIAL ✗ (`aux_left` residual), Step 3 ✓ (bonus). The Step 2 partial is the load-bearing miss: the iso it skeletonizes is the prerequisite for Steps 4-6. Substituting an extra axiom-clean Step 3 for a closed Step 2 does **not** satisfy the gate, because Step 3 sidesteps the iso entirely while Steps 4-6 (the body) still need it. This iter counts as another helper round, not a satisfaction of the bounded commitment.
- **Prover status pattern**: COMPLETE-skeleton (iter-165) → PARTIAL → PARTIAL → PARTIAL. **3 consecutive PARTIAL** on iter-166, iter-167, iter-168 — verdict rule (b) fires.
- **Throughput**: ON_SCHEDULE by raw count (4 elapsed iters vs STRATEGY estimate ~5–12 left for genus-0 phase, started iter-165). But the headline target has not been attempted in any of those 4 iters, so the raw count overstates real progress on the critical sub-problem.
- **Verdict**: **CHURNING**.
  - Rule (b) fires: PARTIAL prover status ≥3 of last K iters (iter-166, 167, 168).
  - Rule (a) fires: helpers added in ≥2 of last K iters (in fact: every iter) AND sorry-count net change of −1 in 4 iters = 0.25/iter, below the 0.5/iter threshold.
  - Pattern: each iter lands axiom-clean material on the *supports* (cover, reduced, ring objects, points, AVR consumer plumbing) without the headline body ever entering the active prover scope. Four iters in, the `gmScalingP1` body remains exactly where the scaffold left it.
- **Primary corrective**: **Refactor** — adopt the iter-168 prover's Option B (direct `Proj.fromOfGlobalSections` from the chart-side ring maps `MvPoly (Fin 2) kbar → Away 𝒜 (X i) ⊗ GmRing`) and **drop the iso-skeleton sub-build** (or demote it to off-path). iter-169 PRIMARY must be "land `gmScalingP1` body via Option B," not "close `aux_left` then iso then body." Why: Option A has accumulated 4 iters of helper-building without the body being attempted; the prover surfaced Option B mid-iter as the cleaner construction (it does not require `aux_left` to be axiom-clean), so the iso route is a 4-iter sunk cost whose marginal value is now ≤ Option B's. Continuing to chase the iso would be ratifying the same churn pattern.
- **Secondary corrective**: **User escalation if iter-169 Option B also produces PARTIAL/INCOMPLETE on the body.** The planner's own iter-168 commitment was "4th consecutive deferral triggers user-escalation iter-169" — that trigger is currently ARMED. Honor it: iter-169 attempts the body via Option B; if the body does not land, the next phase invokes user escalation rather than opening a 5th iter of supports.

## PROGRESS.md dispatch sanity

The directive does not provide a `## PROGRESS.md proposal (this iter)` block in the prescribed format — no file count, no cap, no "ready but not dispatched" list. The only file named is `AlgebraicJacobian/Genus0BaseObjects.lean`. With the rest of the project's hot chains (KDM, AV-rigidity chain, Step-1, AVR Lane B) closed or substantively converged per the auto-memory, a single-file dispatch on the open headline is plausible and consistent with "filling the one truly-ready lane." However, the absence of the prescribed dispatch block means under-dispatch cannot be rigorously evaluated.

- **Verdict**: OK — single-file dispatch consistent with surrounding context, but **dispatch-sanity data was not supplied in the prescribed format**; the planner should include the `## PROGRESS.md proposal` block in future progress-critic directives so this check can be made strictly.

## Must-fix-this-iter

- Route Genus-0 base case: **CHURNING** — primary corrective: **Refactor** (adopt Option B; drop iso-skeleton sub-build; iter-169 PRIMARY = land `gmScalingP1` body via direct `Proj.fromOfGlobalSections`). Why: 3 consecutive PARTIAL + 4 iters of helpers without the headline ever being attempted + bounded-decomposition commitment missed.
- Route Genus-0 base case: **deferral-trigger ARMED** — iter-168 plan committed "4th consecutive deferral triggers user-escalation iter-169." iter-168 did not land Steps 1+2 axiom-clean (only Step 1 + Step 3; Step 2 PARTIAL), and Steps 4-7 were not attempted. The trigger condition is met by the planner's own framing. iter-169 must either land the body (via Option B) or escalate to the user — not open another helper round.
- Route Genus-0 base case: **`gm_grpObj` 3-iter-deferred** with "escalation watch fires next iter" recorded iter-167. iter-168 did not engage it. iter-169 must either bring `gm_grpObj` into scope (which Option B may make optional, since direct `Proj.fromOfGlobalSections` may not need the grp-object structure on `𝔾_m` for the *map* `σ_×` — only for downstream collapse via Cor 1.5) or explicitly justify continued deferral in the plan sidecar.

## Informational

- **Bounded-decomposition question (re-evaluation requested by directive)**: iter-168's "Step 1 axiom-clean + Step 3 axiom-clean + Step 2 partial" does **not** satisfy the iter-167 bounded commitment, because the gate was "Steps 1+2 axiom-clean" and Step 3 cannot substitute for Step 2 — Step 3 sidesteps the iso, while Steps 4-6 require the iso. The substitution looks like progress on the file (two axiom-clean exports landed), but it doesn't unblock the headline. This is the canonical "we closed the easy sub-pieces and called it progress" helper-round pattern. Counts as another helper round, not satisfaction.
- **AVR side has converged** (7 → 6 → 2 → 2; 2 named residual bridges gated on Lane A). The churn is concentrated on the G0BO side, specifically the iso sub-build.
- **Throughput is technically ON_SCHEDULE** (4 of 5–12 elapsed) but the headline-untouched pattern means the raw count is not a faithful proxy for sub-problem progress. If iter-169's Option B also doesn't close the body, the strategy row's `Iters left` estimate should be revised upward (or the genus-0 base-case route revisited at the strategy critic).

## Overall verdict

One route audited; **CHURNING** with 1 must-fix-this-iter corrective (refactor to Option B), 1 armed escalation trigger (per the planner's own iter-168 commitment), and 1 deferred-helper watch (`gm_grpObj`, now 3-iter-deferred). The planner has built ~370 LOC of supporting infrastructure in iter-168 alone — and ~600+ LOC across iter-165 through iter-168 — without the headline target `gmScalingP1` body ever entering the active prover scope. Each iter has produced axiom-clean sub-pieces while the body stays exactly where the iter-165 scaffold left it; this is helper-round-by-the-textbook. iter-169 must commit to landing the body (via the prover's Option B / direct `Proj.fromOfGlobalSections` route), drop the iso-skeleton sub-build, and honor the armed escalation trigger if the body does not close. A 5th iter of "build more supports for the body" is the failure mode this subagent exists to catch.
