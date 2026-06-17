# Progress Critic Report

## Slug
route197

## Iteration
197

## Routes audited

---

### Route: `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean` (Lane H)

- **Sorry trajectory**: 4 → 4 → 4 → 3 → 3 across iter-192 → iter-196. Net: −1 in 5 iters = 0.2/iter, below the 0.5/iter threshold.
- **Helper accumulation**: 5 helpers added across 4 of 5 iters (iter-196: 0). 1 sorry closed (iter-195). Ratio: 5 helpers per 1 closure.
- **Prover dispatch pattern**: dispatched in all 5 iters.
- **Recurring blockers**: sheafification-unit-iso for irreducible spaces (Mathlib-absent) + `(constantSheaf ...).Full`/`.Faithful` instance not in Mathlib `b80f227`. These are distinct Mathlib gaps, not the same phrase, but the underlying theme — "constantSheaf category-theory instances missing from Mathlib" — recurs across at least iter-193 → iter-196.
- **Avoidance patterns**: none detected.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, done (1 closure), done (structural advance only — 0 closures in iter-196). A "done" status with 0 net sorry closures is convergence in name only; ground truth is the sorry count, which stalled at 3.
- **Throughput**: OVER_BUDGET — strategy upper bound ~10 iters total for phase RR.2.H¹ (entered iter-184); elapsed 13 iters as of iter-196. Directive explicitly confirms: "realistically OVER_BUDGET still even after iter-196 scope reduction."
- **Verdict**: **CHURNING**
  - PARTIAL ≥3 of last 5 iters: YES (exactly 3 PARTIAL).
  - Helpers added in ≥2 of last 5 iters AND sorry count down by <1 per 2 iters: YES (both conditions).
  - No structural change in approach until iter-197 blueprint writer.
- **Primary corrective**: Blueprint expansion — already in flight as `h1v-mustfix-iter197`. The corrective is correctly identified. The conditional-dispatch pattern (prover gated on writer + scoped review clearing) is the **right** response to this CHURNING signal; it is not avoidance. Gate failure must not silently become another structural-advance-only round — if the gate does not clear, escalate immediately rather than absorbing another iter of stall at sorry count 3.
- **Secondary note on OVER_BUDGET**: The strategy estimate has been exceeded by 30%. If iter-197 does not close at least 1 sorry in Lane H, the STRATEGY.md upper bound must be revised upward before iter-198. Do not carry OVER_BUDGET silently.

---

### Route: `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean` → ChartIso.lean (Lane BareScheme)

- **Sorry trajectory**: 2 → 2 → 2 → 2 → 2 across iter-192 → iter-196. Net: 0. Completely flat across 5 iters.
- **Helper accumulation**: helpers added in 1 of 5 iters (iter-196: 5 helpers; all other iters: 0). 0 sorry closures across the full 5-iter window.
- **Prover dispatch pattern**: dispatched in 4 of 5 iters (iter-195 was ERROR/no edits due to API 529).
- **Recurring blockers**: import cycle blocking `projectiveLineBar_smooth_chart_aux` (chart-ring iso lives in downstream ChartIso.lean); Stacks 0BLW substrate gap (~200–350 LOC) for `projectiveLineBar_geomIrred`. Both persist across the full window.
- **Avoidance patterns**: none — the iter-196 substrate additions and iter-197 refactor plan are substantive responses to the import-cycle blocker.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, ERROR (no edits), done (5 substrate decls, 0 closures). The iter-196 "done" is substrate-setup, not convergence.
- **Throughput**: ESTIMATE_FREE — strategy entry "none stated (rolled into Route C genus-0 arm)". With sorry count flat at 2 across 5 iters, the elapsed cost is not recoverable from the directive.
- **Verdict**: **STUCK**
  - Sorry count unchanged across K iters AND recurring blocker (import cycle) persists across ≥3 iters: YES.
  - Helpers added in iter-196 (5 total) with 0 sorry closures: satisfies "helpers added without any sorry-elimination" sub-clause.
- **Primary corrective**: Refactor — already dispatched as `barescheme-smoothness-relocation`. This is the correct structural response: breaking the import cycle by relocating `projectiveLineBar_smoothOfRelDim` to ChartIso.lean or new Smooth.lean removes the primary blocker. The iter-197 prover re-dispatch to close the per-chart sorry (~10 LOC via `Algebra.IsStandardSmoothOfRelativeDimension.of_algEquiv`) is appropriate IFF the refactor lands in the same iter. If the refactor fails to complete, the prover dispatch must be held.
- **Secondary note**: `projectiveLineBar_geomIrred` (~200–350 LOC, Stacks 0BLW) has no stated resolution path in the current iter. This is a second open sorry that the per-chart dispatch does not touch. The route will remain at sorry count ≥1 after iter-197 regardless. That is fine as incremental progress, but should be explicitly acknowledged in the iter sidecar rather than implied by "done."

---

### Route: `AlgebraicJacobian/AbelianVarietyRigidity.lean` (Lane E)

- **Sorry trajectory**: 3 → 3 → 3 → 3 → 3 across the full window (iter-191 → iter-196 per directive). Net: 0. Completely flat.
- **Helper accumulation**: 11 helpers added across 4 of 5 iters (iter-195 = ERROR, 0 helpers). 0 sorry closures across the full window.
- **Prover dispatch pattern**: dispatched in all 5 iters (1 ERROR due to API).
- **Recurring blockers**: `Proj.appIso ⊤ .inv` evaluation chain has been the blocker since **iter-188** — 9 consecutive iters. The dependent-motive issue was named precisely only in iter-196; a concrete workaround (`Proj.basicOpenIsoSpec_inv_app_top`) was named for the first time this iter.
- **Avoidance patterns**: none — 11 helpers across 4 active iters is genuine work. The blocker is a real Lean/Mathlib API gap, not evasion.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, ERROR, done (2 substrate primitives; step (ii) blocked). 3 PARTIAL + 1 ERROR + 1 done (0 closures) = zero net convergence.
- **Throughput**: SLIPPING-to-OVER_BUDGET — strategy estimate ~2–4 iters remaining for "Genus-0 rigidity — chart-bridge (III.c separated)." Phase start is not given in the directive. If the phase entered around iter-192, elapsed = 5 iters vs 2–4 estimate = already OVER_BUDGET. The "post-pivot velocity ~30–50/iter" estimate has not materialized (0 sorries closed in all 5 iters).
- **Verdict**: **STUCK**
  - Sorry count unchanged (3→3→3→3→3) AND recurring blocker (`Proj.appIso ⊤ .inv` chain) across ≥3 iters: YES (9 iters).
  - Helpers added without any sorry-elimination across K iters: YES (11 helpers, 0 closures).
  - STUCK > CHURNING.
- **Primary corrective**: Blueprint expansion — already in flight as `avr-barescheme-mustfix-iter197` (adding `Proj.basicOpenIsoSpec_inv_app_top` as the named intermediate). This is the **correct and overdue** corrective; iter-196 is the first iter where the blocker was named precisely enough to act on it. The conditional-dispatch pattern (prover gated on writer + scoped review) is exactly right for a route that has been STUCK for 9 iters due to a missing structural intermediate. The gate is not bureaucratic overhead here — it is the minimum viable quality control after 9 fruitless iters.
- **Secondary note**: The "most prescribed and shortest closure path (~25–45 LOC)" characterization from the iter-196 review is credible given the precise blocker name. If the blueprint writer lands correctly and the scoped review clears, this dispatch has genuinely good odds of closing 2 sorries. But if the gate fails, do NOT proceed with the prover this iter — absorbing another PARTIAL at sorry count 3 after 9 iters of the same is a sunk-cost trap.

---

### Route: `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (Lane I)

- **Sorry trajectory**: 3 → 3 → 5 (sanctioned expand at iter-194) → 4 → 4 across iter-192 → iter-196. Net from pre-expand: 3→4 = +1 regress. Net from peak: 5→4→4 = −1 over 2 iters post-expand, flat for the last 2 iters.
- **Helper accumulation**: 12 helpers added across all 5 iters. 1 sorry closed (iter-195: 5→4). Ratio: 12 helpers per 1 closure.
- **Prover dispatch pattern**: dispatched in all 5 iters.
- **Recurring blockers**: `hy_ne_bot : y.asIdeal ≠ ⊥` is now the single named residual on `isRegularInCodimOneProjectiveLineBar` (newly isolated in iter-196). `degree_positivePart_principal_eq_finrank` blocked on Hartshorne I.6.12 function-field-determines-curve gap (Mathlib-absent, multi-iter). The iter-195 → iter-196 stall (4→4) is from these two distinct blockers.
- **Avoidance patterns**: none.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, PARTIAL, done (Route 2 PID transfer body; 1 named residual). 4 of 5 PARTIAL; the iter-196 "done" is genuine structural landing, but sorry count held at 4.
- **Throughput**: ON_SCHEDULE per the plan agent's assessment (~3–7 iters left). Phase start not given; post-expand progress is real but slow.
- **Verdict**: **CHURNING**
  - PARTIAL ≥3 of last 5 iters: YES (4 of 5).
  - Under the strict rule this is CHURNING. Noted: the iter-196 "done" is substantively different from prior PARTIAL statuses — the Route 2 body landed. The CHURNING verdict here reflects the historical pattern, not necessarily the current trajectory.
- **Primary corrective**: Blueprint expansion — specifically, the `degree_positivePart_principal_eq_finrank` gap (Hartshorne I.6.12) needs an explicit blueprint sub-section that either (a) provides the mathematical content for a project-side proof, or (b) explicitly marks it as a named `axiom` and documents what it would take to remove it. Without this, the route will CHURN again after `hy_ne_bot` closes and the sorry count drops from 4 to 3 but stalls again at `degree_positivePart_principal_eq_finrank`.
- **Comment on iter-197 dispatch**: The `hy_ne_bot` target (~5–10 LOC, Stacks 02IZ bridge) is well-scoped and the right immediate action. This dispatch should proceed. It will close 1 sorry (4→3). The remaining 3 sorries will be dominated by `degree_positivePart_principal_eq_finrank` and at least 2 others. Blueprint expansion on the Hartshorne gap is a must-fix for iter-198 planning.

---

### Route: `AlgebraicJacobian/RiemannRoch/OCofP.lean` (Lane A)

- **Sorry trajectory**: 3 → 3 → 3 → 3 → 3 across iter-192 → iter-196. Net: 0. Completely flat.
- **Helper accumulation**: 3 helpers added across 2 of 5 iters. 0 sorry closures across the full 5-iter window.
- **Prover dispatch pattern**: dispatched in all 5 iters.
- **Recurring blockers**: algebraic Hartogs (Stacks 0BCK) and `Γ(C, 𝒪_C) = k̄` (Hartshorne I.3.4) — both Mathlib-absent. These are the only remaining blockers; the iter-196 "done" closed sub-claims (a)+(b) of `exists_nonconstant_rational_from_dim_eq_two` as axiom-clean, but the parent sorry count did not drop because (c) = `functionField_const_of_complete_curve_of_orderZero` absorbs the sorry. The blocker has been present implicitly across the window (substrate was named in iter-195 and carved in iter-196), meaning the Mathlib gap has been the effective blocker for ≥2 iters and likely longer.
- **Avoidance patterns**: none — the iter-196 carving is substantive.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, PARTIAL, done (0 closures; (a)+(b) axiom-clean, (c) extracted). 4 of 5 effectively non-converging statuses.
- **Throughput**: ESTIMATE_FREE — strategy lists "~5–12 iters remaining" with velocity "gated." No phase-start iter given; sorry count has been flat for 5 iters. The "gated" velocity designation honestly reflects that no progress is possible until the substrate exists. This is not a planning failure; it is an accurate description of the situation.
- **Verdict**: **STUCK**
  - Sorry count unchanged across K=5 iters AND recurring blocker (Hartogs + Γ=k̄ absent from Mathlib): YES.
  - Helpers added (3 total) without any sorry-elimination across K iters: YES.
- **Primary corrective**: Blueprint expansion — the blueprint chapter must explicitly document the Hartogs + Γ=k̄ sub-lemmas as named project-side build targets with estimated LOC and decomposition. Without blueprint anchors, each iter's prover will independently re-encounter the same wall and report "substrate needed" again. The substrate build itself (~80–150 LOC total, planned as 2 sub-helpers for iter-197) is the correct response; it is NOT a pivot situation because no alternative route to `functionField_const_of_complete_curve_of_orderZero` exists. **This is appropriate progress** — the first explicit substrate-build round after the gap was identified. The risk is that the 80–150 LOC estimate will consume 2–4 iters with 0 visible sorry closures before the parent sorry can close. That is expected; the plan agent must communicate this explicitly in the iter sidecar rather than allowing the STUCK signal to accumulate silently.
- **Milestone requirement**: Before iter-197 prover dispatch completes, the iter sidecar should name: "after building sub-helpers X and Y, `functionField_const_of_complete_curve_of_orderZero` sorry closes; expected by iter-NNN." Without this milestone, the substrate build becomes indistinguishable from helper churn in future critic assessments.

---

### Route: `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean` (Lane RCI)

- **Sorry trajectory**: 1 → 3 (sanctioned carve at iter-192) → 3 → 3 → 3 across iter-192 → iter-196. Post-carve: flat at 3 for 3 consecutive iters.
- **Helper accumulation**: 6 helpers added across 4 of 5 iters. 0 sorry closures post-carve. The iter-196 "done" is a reformulation, not a closure.
- **Prover dispatch pattern**: dispatched in all 5 iters.
- **Recurring blockers**: "per-fibre LQF Mathlib gap" (helper (a), closed-point branch) persists from iter-193 → iter-196 = 4 consecutive iters. `IsNormalScheme` gap (helper (d)) is unchanged. These are TWO distinct Mathlib-absent blockers with no stated resolution path.
- **Avoidance patterns**: The strategy explicitly marks this route OVER_BUDGET ("~20–26 paused"). The plan agent is dispatching to a route the strategy has flagged as paused, without a STRATEGY.md revision. This is the inverse of avoidance — it is persistence on an OVER_BUDGET route — and is still a planning problem.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, PARTIAL, done (reformulation, 0 closures). 4 of 5 effectively non-converging.
- **Throughput**: OVER_BUDGET — strategy explicitly states "OVER_BUDGET — n/a (paused) | ~20–26 paused."
- **Verdict**: **STUCK**
  - Sorry count unchanged post-carve (3→3→3) AND recurring blocker ≥3 iters: YES.
  - Helpers (6 total) without any sorry-elimination post-carve: YES.
  - OVER_BUDGET per strategy: YES.
- **Primary corrective**: User escalation — not because no automated corrective exists, but because the route's OVER_BUDGET status requires a STRATEGY.md decision the plan agent cannot make unilaterally: (1) Is helper (d)'s `IsNormalScheme` gap in-scope? If not, it must be replaced by a named `axiom` and the proof strategy updated. (2) Is the LQF closed-point branch in-scope? If not, same. Only after these scope decisions can the generic-point branch dispatch be properly evaluated. **The narrow re-dispatch (generic-point branch, ~30 LOC) is NOT appropriate without a prior STRATEGY.md revision.** The dispatch should be HELD this iter. Route RCI should be removed from the iter-197 prover objectives; it may be re-dispatched in iter-198 after STRATEGY.md explicitly re-opens it with a revised scope.
- **Secondary corrective**: Blueprint expansion — when STRATEGY.md re-scopes this route, the chapter must reflect the reduced scope (generic-point branch only, `IsNormalScheme` as named axiom if out-of-scope) before the prover runs.

---

### Route: `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` (Lane G)

Lane G is off-critical-path with no iter-197 dispatch. Sorry count: 1. Strategy: ON_SCHEDULE (~6–12 iters left, velocity ~50/iter). The 4-piece decomposition for n=k+1 is documented. No avoidance pattern detected for this iter — 1 open sorry on an on-schedule route is a reasonable deferral. **Watch point**: if Lane G is off-critical-path in iter-198 as well without a re-engagement date, this will trigger the avoidance pattern (≥2 consecutive iters off-critical-path without re-engagement plan).

---

## PROGRESS.md dispatch sanity

- **File count**: 6 (cap: 10)
- **Ready but not dispatched**: Lane G (AuslanderBuchsbaum, 1 sorry, on schedule) — explicitly held off-critical-path. No other ready-but-unassigned lanes identified from the directive.
- **Over the cap**: no
- **Under-dispatch finding**: no — Lane G's deferral is justified by on-schedule status and low residual.
- **Iter-over-iter trend**: stable at 6 dispatched routes.
- **Verdict**: **OK** — file count 6 within cap 10, no under-dispatch. Caveat: 4 of 6 dispatched routes carry STUCK verdicts and 2 carry CHURNING. If the structural interventions (blueprint writers, refactor) do not land in iter-197, the iter-198 dispatch will face the same 6 stalled routes — at which point continued dispatch without structural change would qualify as BLOAT_WITHOUT_PROGRESS.

---

## Must-fix-this-iter

- **Route H (H1Vanishing)**: CHURNING + OVER_BUDGET — primary corrective: Blueprint expansion (in-flight `h1v-mustfix-iter197`). Gate failure = no prover dispatch; do not silently absorb another structural-advance-only round. Revise STRATEGY.md upper bound estimate if iter-197 yields 0 closures.
- **Route BareScheme (ChartIso)**: STUCK — primary corrective: Refactor (in-flight `barescheme-smoothness-relocation`). Prover dispatch for per-chart sorry is contingent on refactor completing in the same iter. Geom-irred sorry (~200–350 LOC gap) must not be silently carried as "done."
- **Route E (AbelianVarietyRigidity)**: STUCK — primary corrective: Blueprint expansion (in-flight `avr-barescheme-mustfix-iter197`). Gate failure = hold prover. After 9 iters of `Proj.appIso` blocker, another PARTIAL with 0 closures is not acceptable. This is the pivot iter for Lane E.
- **Route I (WeilDivisor)**: CHURNING — primary corrective: Blueprint expansion for `degree_positivePart_principal_eq_finrank` (Hartshorne I.6.12). The `hy_ne_bot` dispatch is correct; the blueprint must be expanded to name the multi-iter path for the Hartshorne gap before iter-198 dispatch, or that sorry will stall indefinitely.
- **Route A (OCofP)**: STUCK — primary corrective: Blueprint expansion. Document Hartogs + Γ=k̄ sub-lemmas as named build targets in the blueprint chapter. Add an explicit milestone (iter-NNN by which parent sorry closes after sub-helpers land) to the iter sidecar.
- **Route RCI (RationalCurveIso)**: STUCK + OVER_BUDGET — **HOLD this iter**; primary corrective: User escalation. STRATEGY.md must be revised to decide the scope of helper (d) (`IsNormalScheme`) and the LQF closed-point branch before any prover dispatch resumes. Remove RCI from iter-197 prover objectives; re-open in iter-198 after revision.

---

## Informational

**On the conditional-dispatch pattern (Lanes H and E)**: The pattern of gating prover dispatch on a blueprint-writer + scoped-review clearing is **appropriate and correct** for both routes, given their trajectories. This is not bureaucratic overhead — it is the minimum viable safeguard after 5+ iters of structural-advance-only prover results. The key discipline is: if a gate does not clear this iter, the route must be treated as unresolved (not absorbed silently) and either escalated or held. The gates must be enforced, not rubber-stamped.

**On Lane A's substrate build**: The multi-iter substrate build for `functionField_const_of_complete_curve_of_orderZero` is **appropriate progress** for a route whose blockers (Hartogs + Γ=k̄) have no Mathlib alternative. The first explicit substrate-build round is the correct response to a STUCK signal when the blocker is a documented Mathlib-absent theorem. The risk is that 2–4 iters of helper additions with 0 sorry closures will continue to look like churn to future critics. Mitigation: add a named milestone to the iter sidecar (see Must-fix above) so the build has a measurable end condition.

**On Lane RCI's narrow dispatch**: The generic-point branch of helper (a) is a real, closeable target (~30 LOC). The objection is not that the work is ill-scoped — it is that dispatching to a OVER_BUDGET-paused route without first revising STRATEGY.md sets a precedent of treating the strategy as advisory rather than binding. One narrow dispatch now, one narrow dispatch next iter, and the route accumulates iters without a forcing function for the IsNormalScheme and LQF decisions. The discipline of HOLD → revise → re-open is what makes the OVER_BUDGET flag meaningful.

---

## Overall verdict

Six routes audited: **0 CONVERGING, 2 CHURNING (H, I), 4 STUCK (BareScheme, E, A, RCI)**. This is the most stressed state seen in the audited window. No route is cleanly closing sorries at pace; the closest is Lane I, whose `hy_ne_bot` dispatch has a realistic closure. The iter-197 plan is structurally sound in its interventions (blueprint writers for H and E, refactor for BareScheme, substrate build for A), but three of those interventions are CONDITIONAL — if they do not land, the prover dispatches must be held and the iter absorbs zero sorry closures on those routes again.

The planner must enforce the gates this iter, not wave them through. Lane RCI should be removed from iter-197 prover objectives and held pending STRATEGY.md revision; deploying a prover to a route the strategy explicitly marks as paused and OVER_BUDGET, without first revising the strategy, undermines the OVER_BUDGET mechanism. The single well-scoped target (generic-point branch, ~30 LOC) does not justify bypassing the strategic checkpoint. Revise STRATEGY.md for RCI in iter-197 plan-phase, then dispatch in iter-198.
