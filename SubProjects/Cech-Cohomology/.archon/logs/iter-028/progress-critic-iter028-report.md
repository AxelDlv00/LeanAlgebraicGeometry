# Progress Critic Report

## Slug
iter028

## Iteration
028

## Routes audited

### Route: 01EO Čech↔cohomology comparison chain → `affine_serre_vanishing`
Files: `AbsoluteCohomology.lean`, `CechToCohomology.lean`

- **Sorry trajectory**: 2 → 2 → 2 → 2 across iter-025 to iter-027 (constant). Both sorries are intentionally frozen
  (a superseded relative-form `CechAcyclic.affine` and the protected P5b target); neither sits in any file
  under active prover work. The "sorry count" metric is a non-indicator for this route — the route's
  actual forward-progress metric is axiom-clean named targets closed per iter (see prover status pattern).
- **Helper accumulation**: +1 (iter-025), +10 (iter-026), +17 (iter-027). Every helper batch is consumption-matched
  to named targets closed that same iter; coverage debt returns to zero each plan cycle; no orphan helpers
  detected across any of the four audited iters.
- **Prover dispatch pattern**: 1 file (iter-025, closing P3b); 1 file (iter-026, Form-B scaffold);
  2 files (iter-027, Lane 1 + Lane 2). Dispatch width is expanding as more lanes become ready, not
  artificially throttled. iter-028 proposes 1 prover lane (only `CechToCohomology.lean`) because
  `AbsoluteCohomology.lean`'s Lane 1 closed in iter-027 and no fresh sorry was opened there.
- **Recurring blockers**: none across all four iters.
- **Avoidance patterns**: none. Route has been active and prover-dispatched every iter without exception.
  No "off-critical path" reclassification, no consecutive plan-only iters, no persistent deferral language.
- **Prover status pattern**: COMPLETE, COMPLETE, COMPLETE (iter-025 through iter-027). First-attempt
  axiom-clean closure on every planned target; zero reverts; zero route-restarts.
- **Throughput**: ON_SCHEDULE — STRATEGY estimates ~3–4 iters for the current phase (opened at iter-026);
  iter-028 is elapsed iter 3 of an estimated 3–4, placing us at the near end of the window.
- **Verdict**: **CONVERGING**

**Clarification on the sorry-constant signal:** The STUCK rule's "helpers added without any sorry-elimination
across K iters" clause technically fires because the project sorry count never moves. However, mechanically
applying that clause here would be a false positive: the two frozen sorries are in *different files* under
no active prover assignment and are intentionally preserved. The route's actual residual (open named targets
in CechToCohomology.lean) has shrunk each iter via first-attempt axiom-clean closures. The recurring-blocker
and prover-status conditions that make the STUCK rule meaningful are both absent. CONVERGING is the correct
read.

**On the single-lane loading question (per-face-SES + L3 + L4 + top):** The track record supports ambitious
loading — every planned set has closed axiom-clean on first attempt. The hedge ("hand off a clean
decomposition if L4's induction proves heavy") is already embedded in the proposal, which is the right
discipline. Two observations for the planner:

1. L4's `BasisCovSystem` induction is the session's only genuine risk factor. If `HasVanishingHigherCech`
   is defined mid-session and the induction step needs more than one cycle of `induction n` + `exact` /
   `apply`, the prover should stop at an axiom-clean L3-only deliverable and decompose L4 to its own iter.
   The hedge is sound; the planner should enforce it strictly (i.e., do not let the prover run open-ended
   on L4 if L3 + the definitions already constitute a clean deliverable).

2. The top assembly (`cech_eq_cohomology_of_basis`) depends on L4 being closed. If L4 is split, top
   assembly shifts to iter-029. That is fine and on-schedule.

## PROGRESS.md dispatch sanity

Verdict: **OK** — file count 1 (prover lane) within cap 10; no under-dispatch finding. `AbsoluteCohomology.lean`
has no open sorries in the active route after iter-027's Lane-1 closure; its absence from this iter's
prover dispatch is correct, not a gap. Blueprint-writer and root-import refactor are non-prover work items,
not counted against the prover cap.

## Overall verdict

One route active, one route CONVERGING. The sorry-constant metric is a red herring for this project: both
frozen sorries are intentionally parked in superseded/protected declarations and are irrelevant to the
active chain. The real trajectory — axiom-clean named targets, first-attempt closure, no recurring blockers,
dispatch width expanding with lane readiness — is clean across four iters and on schedule relative to
STRATEGY's 3–4 iter estimate. The iter-028 single-lane proposal is reasonable given the track record and
the built-in hedge on L4 induction depth. The planner should enforce the hedge strictly: if L4's
`BasisCovSystem` induction runs long, close at axiom-clean L3 + definitions and defer top assembly to
iter-029, which remains within the phase estimate.
