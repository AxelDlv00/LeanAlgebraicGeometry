# Progress Critic Report

## Slug
routec167

## Iteration
167

## Routes audited

### Route: `AlgebraicJacobian/Genus0BaseObjects.lean` (Lane A)

- **Sorry trajectory**: file did not exist iter-163/164; 0 → 9 (iter-165, scaffold land) → 6 (iter-166). Net -3 sorries in the one iter the file has been a live prover lane.
- **Helper accumulation**: iter-165 = 4 main objects + 5 axiom-clean bridge instances + `projectiveLineBar_isProper`; iter-166 = 2 helpers (`pointOfVec`, `irrelevant_map_eq_top`). Helpers added are proportionate to sorries closed (2 helpers ↔ 3 ℙ¹-points discharged axiom-clean).
- **Prover dispatch pattern**: 1 of 1 ready (the file itself); not an under-dispatch case.
- **Recurring blockers**:
  - `GrpObj.ofRepresentableBy` — appears in iter-165 and iter-166 deferral language. 2 iters, NOT yet 3 → does not yet trip the recurring-blocker rule, but watch in iter-168.
  - `Scheme.Cover.glueMorphisms` over 2-chart cover — first appearance iter-166 only.
- **Avoidance patterns**: none. Route is on critical path; no off-critical-path reclassification; no plan-only iters since iter-164 strategy decision. Deferral of CRITICAL items from iter-165 → iter-166 → iter-167 is borderline-persistent (2 iters) but a concrete iter-167 closure plan is named, so it has not yet hardened into avoidance.
- **Prover status pattern**: PARTIAL (iter-165 scaffold-by-design), PARTIAL (iter-166 per plan target). 2 PARTIALs is below the 3-of-K CHURNING threshold.
- **Throughput**: ON_SCHEDULE. STRATEGY estimate `Iters left ~5–12` against elapsed-under-current-shape ≈ 2 iters since shortcut decision (iter-164→166). Even using the broader "phase entered iter-152, 14 iters elapsed" framing, 5–12 is the forward forecast, not backlog — it is well inside the iter-164-revised window of 10–18 total iters for the genus-0 base case.
- **Verdict**: CONVERGING.
- Notes: The file has only 2 iters of data and would strictly be UNCLEAR by the "fresh < K iters" rule, but the trajectory signal (33% sorry reduction in one iter, axiom-clean discharge of 3 ℙ¹-points, scaffold-then-discharge pattern intact) is unambiguous. Calling CONVERGING with a watch on the `GrpObj.ofRepresentableBy` deferral: if it persists into iter-168 reports, escalate to STUCK with a Mathlib-idiom consult corrective.

### Route: `AlgebraicJacobian/AbelianVarietyRigidity.lean` (Lane B)

- **Sorry trajectory**: file-local sorries -1 (iter-163, Cor 1.5/Cor 1.2 closed) → 0 (iter-164 hygiene) → 0 (iter-165, no AVR lane) → 3 → 6 (iter-166). The iter-166 *increase* is a structural decomposition: 3 scaffold sorries were replaced by 1 private aux helper (`morphism_P1_to_grpScheme_const_aux`, ~100 LOC, 5 internal sorries) plus the iso-transport outer body of `rigidity_genus0_curve_to_grpScheme` — both refactored theorems' OUTER bodies are now sorry-free.
- **Helper accumulation**: 1 private aux helper this iter (the encapsulator); not a wrapper-proliferation pattern.
- **Prover dispatch pattern**: 1 of 1 ready (this iter); no under-dispatch.
- **Recurring blockers**:
  - `IsDominant iotaGm.left blocked on Lane A gmScalingP1 body` — first appearance iter-166. Cross-route dependency, single occurrence so far.
  - `product-stability for (ℙ¹⊗Gm) over alg-closed base` — first appearance iter-166. Lane A is scheduled to export the missing instances iter-167.
  - `IsReduced ProjectiveLineBar.left not packaged by Mathlib for Proj` — first appearance iter-166.
- **Avoidance patterns**: none. The 6-sorry expansion has a concrete iter-167 closure plan with named instances arriving from Lane A; this is decomposition, not deferral.
- **Prover status pattern**: COMPLETE (iter-163), COMPLETE (iter-164), no-AVR-lane (iter-165), PARTIAL (iter-166). First PARTIAL in the K-window is starting-new-work, not stalled-work.
- **Throughput**: ON_SCHEDULE — same accounting as Lane A.
- **Verdict**: CONVERGING.
- Notes: The sorry-count increase 3 → 6 is the canonical "expose named gaps" decomposition pattern, NOT the "add helpers without closing residual" churn pattern, because (a) BOTH outer-body theorems are sorry-free post-refactor, (b) every new sorry has a named blocker, and (c) the encapsulating helper is 1, not N. This is the same shape Lane A had iter-165→166 (scaffold-then-discharge), just one iter behind. **Hard test**: iter-167's AVR report must close ≥3 of the 5 aux sorries OR demonstrate Lane-A-dependency forced the residual; if iter-167 ends at 6 aux sorries with no Lane-A blocker citation, escalate to CHURNING with a structural-refactor corrective.

## PROGRESS.md dispatch sanity

- **File count**: 2 (cap: 10).
- **Ready but not dispatched**: none identified in the directive.
- **Verdict**: OK — file count 2 within cap 10, no under-dispatch finding. Two file-disjoint lanes with a known within-iter sequential interlock on `iotaGm` dominance is appropriate dispatch shape; the alternative (single-lane Lane A drill) would idle the prover budget Lane B can productively use on the 4 of 5 aux sorries that DON'T require Lane A's `gmScalingP1`.

## Informational

Both routes CONVERGING. Two specific items warrant surfacing for the planner:

1. **`GrpObj.ofRepresentableBy` is the lone two-iter-deferred item.** It has not yet crossed the recurring-blocker threshold, but it is the most likely candidate to slip iter-167 given the directive's own "substantial sub-build" characterization. If the planner picks 1-2 of the 3 CRITICAL items rather than all 3 (per directive Q4), `gm_grpObj`/`GrpObj.ofRepresentableBy` is the right one to scope to iter-168, with `gmScalingP1` body picked iter-167 because Lane B's `iotaGm` dominance is gated on it.

2. **Lane B's 6-sorry expansion is a one-iter pattern, not a trend.** It will be a CHURNING signal if it persists. The single-iter version (refactor exposes named gaps that are then discharged the following iter) is healthy decomposition. The multi-iter version (refactor exposes named gaps that get further refactored next iter without discharge) is churn. iter-167's AVR report is the discriminator.

## Overall verdict

Both lanes CONVERGING (2 routes audited, 0 CHURNING/STUCK, 0 avoidance findings, dispatch OK). Lane A is the leading edge: closed 3 of 9 sorries in iter-166 axiom-clean, with a clean iter-167 plan to attack 3 CRITICAL items + export product instances. Lane B is structurally one iter behind Lane A and looks regressive only on the sorry-count metric — every signal beneath that (outer bodies sorry-free, named blockers, single encapsulator helper) points at decomposition, not churn. **Answers to directive questions**: (1) Genus0BaseObjects = CONVERGING — sorry-elimination is real and axiom-clean, deferrals have closure plans; (2) AVR's "PARTIAL → 6 aux sorries" is structural advance, not regression — outer bodies landed sorry-free and the encapsulator pattern is correct decomposition; (3) 2 lanes is right — file-disjoint with within-iter interlock is exactly what parallel dispatch handles well; (4) the 3 CRITICAL G0BO items are NOT all closable in one iter per the directive's own characterization — recommend the planner pick `gmScalingP1`/`gmScalingP1_collapse_at_zero` (which unblocks Lane B) and defer `gm_grpObj` (the `GrpObj.ofRepresentableBy` substantial sub-build) to iter-168 with a sub-iter Mathlib-idiom consult dispatched mid-iter if the planner wants to de-risk it. Watch items for iter-168: `GrpObj.ofRepresentableBy` becoming a 3-iter recurring blocker, and Lane B's aux-sorry count failing to drop.
