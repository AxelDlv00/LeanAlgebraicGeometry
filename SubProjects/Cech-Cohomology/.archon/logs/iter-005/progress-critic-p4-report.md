# Progress Critic Report

## Slug
p4

## Iteration
005

## Routes audited

### Route: P4 — `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`

- **Sorry trajectory**: This is a `mathlib-build` file — no sorries exist. The meaningful residual
  is "named P4 targets closed of 3": iter-003 = 0/3 (scaffold only; prover mechanical noop),
  iter-004 = 0/3 closed, 1/3 partial (`rightDerivedShiftIsoOfAcyclic` engine built; horseshoe
  absent). The named-target count is net unchanged across 2 iters, but iter-003 was a mechanical
  noop (plan-validate `_SCAFFOLD_RE` filter dropped the objective — tooling issue, not prover
  failure). Effective prover iterations: 1.

- **Helper accumulation**: 7 declarations added across 2 iters (2 scaffold iter-003, 5 axiom-clean
  iter-004), 0 named targets closed. However, the iter-004 additions are not neutral infrastructure
  churn: they are all *consumers* of the horseshoe, and together they reduce the entire P4 lane to
  a single, precisely characterized remaining gap (`InjectiveResolution.ofShortExact`). The
  per-stage mono (`mono_biprod_lift_factorThru_of_exact`) is itself a horseshoe sub-component,
  already axiom-clean. This is structural reduction, not accumulation for its own sake.

- **Prover dispatch pattern**: iter-003: 0 of 1 ready dispatched (mechanical noop — tooling);
  iter-004: 1 of 1 ready dispatched (only lane cleared; P3 statement-gap-blocked, P5 needs P3+P4).
  No under-dispatch finding: there was genuinely no second gate-cleared lane in either iter.

- **Recurring blockers**: none — "horseshoe is a monolithic ℕ-recursion with no sorry-free partial
  fragment" appears only in the iter-004 report. One occurrence, not recurring.

- **Avoidance patterns**: none detected.
  - No "off-critical path" reclassification.
  - iter-003 zero-dispatch is a confirmed mechanical noop (tooling), not a planning avoidance.
  - No persistent deferral language across iters (iter-004 plan explicitly re-dispatches iter-003
    work with corrected phrasing).

- **Prover status pattern**: NOOP (mechanical) → DONE. Only 1 real prover iteration; too thin to
  classify as CHURNING or STUCK.

- **Throughput**: ON_SCHEDULE — strategy estimate ~3–5 iters; elapsed 2 iters (one of which was a
  mechanical noop). Wall-clock progress is inside the lower bound of the estimate range, though
  the noop means the effective prover contribution is from 1 iter, not 2.

- **Verdict**: UNCLEAR — the route is fresh. With only 1 effective prover iteration there is
  insufficient signal to apply the CHURNING (≥2 iters of helper accumulation without target
  closure and no structural change) or STUCK (K-iter window with INCOMPLETE or recurring blocker)
  rules. The one real prover iteration made genuine structural progress: the horseshoe is the sole
  remaining gap, its consumer infrastructure is complete and axiom-clean, and the plan has pivoted
  to effort-breaking the monolith into independently-provable sub-lemmas — a structural change in
  approach that explicitly responds to the iter-004 monolith finding.

## PROGRESS.md dispatch sanity

Verdict: OK — file count conditional (1 if fast-path blueprint re-review clears this iter, else 0
for the effort-breaker-only path); cap 10; no over-cap; no under-dispatch (P3 statement-gap-blocked,
P5 needs P3+P4 — no gate-cleared lanes absent from the proposal).

## Informational

**Watch signal for iter-006:** The plan's "conditional prover dispatch" structure warrants
monitoring. If the effort-breaker runs but the same-iter scoped blueprint re-review does NOT clear
(e.g. the freshly-decomposed chapter needs another pass), iter-005 becomes a second near-zero-prover
iter alongside the iter-003 mechanical noop. That would put the plan-phase-only meta-pattern
(≥3 consecutive iters with zero prover dispatches) within one iter of triggering. The planner
should treat the fast-path blueprint re-review as a hard requirement for iter-005, not an optional
optimization — if the effort-breaker sub-lemma decomposition is sound, the blueprint chapter
update and re-review should complete in the same iteration so that the prover can fire on the new
leaves immediately. Deferring the prover to iter-006 "to be safe" would be avoidance, not caution.

**False `\leanok` / DAG poisoning (operational risk, not convergence signal):** The horseshoe's
blueprint block (`lem:injective_resolution_of_ses`) currently carries false `\leanok` markers
(the `refactor-fence-fix` directive addresses the backtick-fenced phantom `def` in the strategy
comment). Once the fence fix lands and `sync_leanok` runs, the DAG will correctly show the
horseshoe as unformalized. This is a prerequisite for any blueprint-gated dispatch on the horseshoe
sub-lemmas and must precede the effort-breaker's `\lean{}` tag additions; confirm the fence fix
is resolved before the blueprint re-review.

## Overall verdict

One route audited; verdict UNCLEAR. The route is too fresh (1 effective prover iteration) to
classify as CHURNING or STUCK: the single real prover dispatch (iter-004) made genuine structural
progress (reducing 3 targets to 1 remaining gap with all consumer infrastructure axiom-clean), and
the plan's pivot to effort-breaking the horseshoe monolith is a correct structural response, not
avoidance. No recurring blockers, no avoidance patterns, no under-dispatch finding. Throughput is
ON_SCHEDULE. The planner should proceed with the iter-005 decompose-then-build plan, with one
caveat: treat the same-iter blueprint re-review as mandatory — deferring the prover past this iter
would bring the plan-phase-only meta-pattern within one iteration of the CHURNING threshold.
