# Progress Critic Directive

## Slug
iter126

## Iter
126

## Active routes / files under review

### Route 1: M1.b — `AlgebraicJacobian/Differentials.lean` `IsAffineOpen.appLE_isLocalization` (route CLOSED by iter-126 excise)

- **Started at iter**: 122
- **Iters audited**: 122, 123, 124, 125, 126

#### Sorry counts per iter (project total)
- iter-122: 2 (after intro-then-narrow)
- iter-123: 2 (residual narrowed L304 → L362)
- iter-124: 2 (residual narrowed L362 → L398)
- iter-125: 2 (M1.b PARKED, route off-active; refactor was Rigidity, not M1.b)
- iter-126: 1 (M1 EXCISED iter-126 via `refactor-m1-excise-iter126`; 7 declarations deleted from Differentials.lean; -1 sorry; net cross-refactor 2→2 with M2.a +1)

#### Helpers added per iter
- iter-122: 7 helpers (M1 setup: `appLE_unitSubmonoid`, `appLE_colimRingHom`, `appLE_colimAlgebra`, `appLE_colimRingHom_comp_φV`, `isUnit_appLE_unitSubmonoid_in_colim` Step 0, +2 utility)
- iter-123: 0 new helpers (Steps 1 + 4 closed in body; Steps 2+3 packaged as AlgEquiv hole)
- iter-124: 0 new helpers (`forwardAlg` AlgHom promoted in-body; `commutes'` closed in-body; residual narrowed to `Function.Bijective`)
- iter-125: 0 (route parked; no prover-phase iters)

#### Prover statuses per iter
- iter-122: PARTIAL — opened the route; 3 of 4 sorry sites closed; M1.b helper introduced.
- iter-123: PARTIAL — Steps 1+4 closed; Steps 2+3 packaged.
- iter-124: PARTIAL — `commutes'` closed; bijectivity residual remained.
- iter-125: N/A (no prover dispatch on M1.b this iter; route parked).

#### Recurring blocker phrases
- "filtered-colim element representation" / "cocone universal property" / "no off-the-shelf colim-of-localizations lemma in Mathlib" — verbatim in iter-122, iter-123, AND iter-124 prover task results (3-iter recurrence).
- "basic-open cofinality" — forward-looking concern iter-122; concrete bottleneck iter-124.

#### Planner's current proposal for this iter
- **M1 EXCISED iter-126** via `refactor-m1-excise-iter126`. Per the iter-126 strategy-critic CHALLENGE on the iter-128 deferral framing ("decision iter with no new evidence between now and then is sunk-cost-adjacent"), the plan-agent committed to excise this iter. The 7 declarations were deleted; the M1.d Mathlib-PR candidate (`kaehler_quotient_localization_iso`) stays standalone. The iter-128 trigger no longer fires.

### Route 2: M2.a — `AlgebraicJacobian/RigidityKbar.lean` (NEW iter-126) `AlgebraicGeometry.rigidity_over_kbar`

- **Started at iter**: 125 (preparatory refactor of `Scheme.Over.ext_of_eqOnOpen`)
- **Iters audited**: 125 (refactor only), 126 (scaffold this iter)

#### Sorry counts per iter
- iter-125: 0 added on M2.a (refactor was sorry-neutral)
- iter-126: +1 added on M2.a (`rigidity_over_kbar` body sorry; net project 2 → 3)

#### Helpers added per iter
- iter-125: 0 new declarations on M2.a (refactor was rename + signature weakening + hypothesis-drop on existing declaration `GrpObj.eq_of_eqOnOpen`)
- iter-126: 1 new declaration on M2.a (`rigidity_over_kbar` scaffold)

#### Prover statuses per iter
- iter-125: N/A (refactor subagent, not prover)
- iter-126: N/A (refactor subagent again; no prover dispatched this iter)

#### Recurring blocker phrases
- None yet — fresh route; body closure is gated on the shared cotangent-vanishing pile (iter-129+).

#### Planner's current proposal for this iter
- iter-126 dispatches refactor `m2a-scaffold-iter126` to create `RigidityKbar.lean` with named scaffold + sorry. Plan-phase-only iter; no prover.
- iter-127 dispatches another refactor (M2.b scaffold for `genusZeroWitness` in `Jacobian.lean` or a new file).
- iter-128 forces M1 hard exit decision.
- iter-129+ opens the shared cotangent-vanishing pile lanes, informed by the iter-126 mathlib-analogist consult (also dispatched this iter).

### Out of scope

- `Jacobian.lean:179` `nonempty_jacobianWitness` (off-limits; queued behind M2 + M3).
- All `Cohomology/*.lean` (closed iter-097, off-active).
- `Rigidity.lean` (closed iter-125 refactor; off-active).

## Specific question for the critic

The plan-agent's iter-126 + iter-127 pattern is "plan-phase-only refactor
iters with no prover dispatch". iter-125 was also plan-phase-only. Is
this a 2-3-iter sequence of "plan-phase only" iters that the
progress-critic should flag as CHURNING (helpers added but no
sorry-elimination)? Or is it the legitimate "scaffold-then-build"
pattern where the iter-126/127 scaffolds set up the iter-129+ build?

The plan-agent's defense (please assess):

1. iter-125 refactor was a PREREQUISITE for M2.a (Rigidity.lean needed
   the rename + hypothesis-drop to apply at ℙ¹_kbar, which is not a
   GrpObj). Without it, M2.a body would have been blocked.

2. iter-126 refactor IS the M2.a scaffold per STRATEGY.md sequencing
   (named declaration with sorry body, body closure gated on shared
   pile iter-129+).

3. iter-127 will be the M2.b scaffold (genus-0 witness builder, sorry
   body or vacuous-or-rigidity-application).

4. iter-128 forces the M1 hard exit decision (close or excise).

5. iter-129+ opens the shared cotangent-vanishing pile lanes, where
   substantive multi-iter prover work resumes.

If this pattern is CHURNING by your criteria, the planner needs to
restructure. If it's the legitimate scaffold-then-build pattern, mark
UNCLEAR or CONVERGING-by-scaffolding (the project sorry count grows by
1 this iter, but the scaffold is structurally required infrastructure
for the body work).
