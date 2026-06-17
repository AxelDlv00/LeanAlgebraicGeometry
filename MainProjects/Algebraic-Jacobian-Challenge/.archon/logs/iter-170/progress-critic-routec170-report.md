# Progress Critic Report

## Slug
routec170

## Iteration
170

## Routes audited

### Route: Genus-0 base case via 𝔾_m-scaling shortcut (`AlgebraicJacobian/Genus0BaseObjects.lean`)

- **Sorry trajectory**: 9 → 9 → 9 → 9 → 8 across iter-165 → iter-169. The `−1` at iter-169 was a *deletion* (`ga_grpObj` removed), not a closure. Functionally **flat** for 5 consecutive iters. The PRIMARY load-bearing body `gmScalingP1` has been `:= sorry` for **all 5 iters** (iter-165 → iter-169) and is **explicitly not attempted** in the iter-170 proposal either — 6th consecutive iter without touching the goal.
- **Helper accumulation**: helpers added in 4 of last 5 iters (iter-165 = 9 new scaffold items; iter-166 = 5 helper sorries from outer-body closure + 3 ℙ¹ points; iter-167 = 7 Lane B exports; iter-168 = 5 ring-homs + 1 new iso-aux sorry; iter-169 = none new, hygiene only). Closures happened at the helper level (Lane B exports, ℙ¹ points, Steps 1+3 of iso) but were offset by new sorries each iter so the count never dropped.
- **Prover dispatch pattern**: 1 file (G0BO) dispatched per iter, which is appropriate — AVR (the only other open file) is file-disjoint and gated on this body landing. **No under-dispatch finding** — the catalog of ready files is genuinely 1.
- **Recurring blockers**:
  - **"Mathlib does not ship..."** appears in iter-166, iter-167, iter-168, iter-169 reports — **4 consecutive iters**, multiple sub-declarations. This is the dominant signal.
  - **"Mathlib gap" / "Mathlib-side blocker"** appears in iter-167, iter-168, iter-169 — **3 consecutive iters** (same theme, different surface).
  - **"deferred to upstream Mathlib"** appears in iter-168 and iter-169 — same RR bridge `genusZero_curve_iso_P1`, same deferral, persisting across consecutive iters.
- **Avoidance patterns**:
  - **Persistent deferral** of `gmScalingP1` body: 5 consecutive iters of "next iter we'll do the body" / "scaffold partial, body deferred" without ever attempting the assembly. This is the textbook STUCK-by-inaction pattern.
  - **Persistent deferral** of the RR bridge `genusZero_curve_iso_P1` to "upstream Mathlib" across iter-168 + iter-169 — same phrase, same item, two iters running.
  - The iter-170 proposal extends this pattern: explicit "NOT attempted: the `gmScalingP1` body itself" with the body deferred again to **iter-173**, a 3-iter horizon from now.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, PARTIAL, PARTIAL — **5 consecutive PARTIAL**. CHURNING-criterion threshold (≥3) cleared 2 iters ago.
- **Throughput**: **SLIPPING with OVER_BUDGET trajectory**. STRATEGY.md `Iters left` = ~5-12 (entered phase at iter-164); elapsed = 6 iters. The planner's own arithmetic in the directive (≈1500-3500 LOC ÷ ~80/iter ≈ 15-44 iters) concedes 5-12 is aggressive. If the proposed 4-iter decomposition holds *exactly*, body lands at iter-173 = 9 iters elapsed (upper-middle of estimate) — but every previous estimate of "next iter" for the body has slipped, so the realistic projection is iter-175+ = clearly OVER_BUDGET against 5-12.
- **Verdict**: **CHURNING**, with multiple STUCK-flavored signals (5-iter recurring "Mathlib does not ship" blocker; 5-iter persistent body-deferral; 5-iter PARTIAL streak). I am classifying CHURNING rather than STUCK because the helper-level work *is* structurally non-trivial (Steps 1+3 of the iso went axiom-clean iter-168, ℙ¹ points went kernel-clean iter-166) — but the route has not converged on the actual goal in K=5 iters and the proposal extends that streak.
- **Primary corrective**: **Force a body-first attempt this iter** — invert the proposal so iter-170's PRIMARY is `gmScalingP1` body itself (a `Scheme.Cover.glueMorphisms` skeleton with chart-morphism and cross-chart-agreement *internal* sorries), and demote PRIMARY-1 (`aux_left`) + PRIMARY-2 (`projGm_isReduced`) + SECONDARY-1 (Step A ring maps) to backup-only tasks for the same iter. **Why**: the 5-iter pattern is "build helpers, hypothesize their shape fits, defer assembly." That is exactly the CHURNING pattern the no-helpers rule exists to prevent. The fix is the *opposite* direction the planner has been moving: commit the body shape FIRST, then the iter-171/172/173 helper work is testable against a concrete consumer. Landing the body as PARTIAL with named internal sorries (a) gives the prover a concrete API surface to type-check against, (b) catches shape mismatches now rather than at iter-173 when 3 more iters of helpers are already in the bank, and (c) makes the residual sorry-trajectory legible — every closed internal sorry is unambiguous body-progress. The current proposal cannot fail this iter (any of 3 wins counts) and therefore cannot produce real signal about the route. Body-first attempt can fail loudly, which is what we need.
- **Secondary correctives**:
  1. **Mathlib analogy consult** on the *entire* iso/chart construction, not per-helper. The recurring "Mathlib does not ship..." blocker across 4 iters indicates the API mismatch is load-bearing and per-helper consults (gmscaling-deep iter-168 was per-helper) are not catching it at the right level. Consult should validate that the Step A/B/C decomposition itself fits Mathlib's `Scheme.Cover.glueMorphisms` idiom before another helper round.
  2. **STRATEGY.md estimate revision** — current `~5-12` is dishonest given the planner's own velocity arithmetic. Should be **~10-20 iters** (a >40% downgrade, midpoint 15 vs current midpoint 8.5). The directive itself flags this; the revision should land in the same plan-write that addresses this critic.

## PROGRESS.md dispatch sanity

Verdict: OK — file count 1 within cap, no under-dispatch (AVR is file-disjoint and gated on this body landing; no other file is "ready but not dispatched").

The single-prover dispatch is *appropriate* here, NOT an avoidance pattern — there is genuinely no second ready file. The under-dispatch rule fires when N < M ready; here N = M = 1.

## Must-fix-this-iter

- **Route G0BO**: CHURNING — primary corrective: **body-first attempt this iter**. Why: 5 consecutive iters of helper accumulation with the PRIMARY body untouched is the canonical churn pattern; the planner's proposal extends this to a 6th iter. The structural fix is to invert the order — commit the body skeleton now (PARTIAL with internal sorries is fine), test that the helpers actually plug in, and only then continue closing them.
- **Recurring blocker — "Mathlib does not ship..."**: secondary corrective: **full-chain Mathlib analogy consult** (not per-helper). 4 consecutive iters of the same blocker phrase across multiple sub-declarations means the API mismatch is at the architecture level.
- **Throughput SLIPPING with OVER_BUDGET trajectory**: STRATEGY.md estimates 5-12 iters, elapsed = 6 with PRIMARY body still bare sorry and a 4-iter further-deferral committed (= ≥10 iters minimum, realistically 12-15+). **Revise the `Iters left` row to ~10-20 iters this plan phase.** Per the rule for OVER_BUDGET with positive `Iters left`: revise the estimate.

## Informational

None of the helper-level work to date is *wasted* — the Lane B exports, the kernel-clean ℙ¹ points, the iso Steps 1+3, and the `projectiveLineBarAffineCover` infrastructure are all axiom-clean and re-usable. The criticism is about *order of operations*, not about the helper work being incorrect. The corrective is to test the assembly now, not to throw away the helpers.

## Overall verdict

One route audited (G0BO); one CHURNING verdict; one OVER_BUDGET throughput finding; dispatch sanity = OK. The dominant signal is that the PRIMARY body `gmScalingP1` has been `:= sorry` for 5 consecutive iters with the recurring blocker "Mathlib does not ship..." across 4 of those iters, and the iter-170 proposal explicitly defers the body for a 6th iter (with a further 3-iter horizon to iter-173). The 4-iter decomposition with named milestones is welcome scaffolding *if* it survives contact with the actual body shape — but the planner has not yet performed that contact test, and every iter spent building helpers without an assembly attempt is an iter that cannot disprove a wrong route shape. **The right iter-170 dispatch is to assemble the body now (PARTIAL with internal sorries acceptable) and let the helper queue follow.** Answering the directive's question 3 explicitly: landing BOTH PRIMARYs + scaffolding Step A this iter is **not** decisive evidence of route-soundness — it is one more iter of helper progress without the load-bearing test. The decisive test is whether `gmScalingP1`'s body assembles via `Scheme.Cover.glueMorphisms` at all, and that test should run this iter, not iter-173.
