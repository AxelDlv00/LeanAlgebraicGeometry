# Progress Critic Directive

## Slug
iter133

## Iter
133

## Active routes / files under review

The plan agent is considering THREE active routes for iter-133:

### Route 1: `AlgebraicJacobian/Cotangent/GrpObj.lean` (piece (i.a) — JUST CLOSED iter-132)

- **Started at iter**: 128
- **Iters audited**: 128 to 132 (5 iters; this is the iter that should resolve the iter-128→iter-132 5-iter META-PATTERN watch)

#### Sorry counts per iter (project-wide; file-specific where noted)
- iter-128: 4 (file: 0 — `cotangentSpaceAtIdentity` definition landed with no sorry, but body was found in iter-129 to compute the zero `k`-module for the consumer class — mathematically WRONG)
- iter-129: 3 (file: 0; plan-only refactor — rename + signature relax + diagnostic; no sorry change)
- iter-130: 3 (file: 0 — body swapped to Replacement (B) but outer `Classical.choice` wrapper made the body opaque past `Nonempty (ModuleCat k)`)
- iter-131: 3 (file: 0; plan-only refactor — body shape refactored to pure-term `Classical.choose`-chain `noncomputable def` + strong acceptance lemma `cotangentSpaceAtIdentity_eq_extendScalars` closing by `rfl`)
- iter-132: 3 (file: 0; rank lemma `cotangentSpaceAtIdentity_finrank_eq` CLOSED at line 244 with no sorry, kernel-only axioms; ~40 LOC body)

#### Helpers added per iter
- iter-128: 1 (`cotangentSpaceAtIdentity` — body subsequently shown WRONG iter-129)
- iter-129: 0 (plan-only)
- iter-130: 0 (body swap to Replacement (B); declaration count unchanged but body opaque)
- iter-131: 1 (`cotangentSpaceAtIdentity_eq_extendScalars` companion structural-shape lemma)
- iter-132: 1 (`cotangentSpaceAtIdentity_finrank_eq` rank lemma — substantive theorem closed against the iter-131 body)

#### Prover statuses per iter
- iter-128: COMPLETE — body lands; subsequent analogist showed body is zero-collapse
- iter-129: PLAN-ONLY (no prover); refactor lane lands signature relax + diagnostic analogist
- iter-130: COMPLETE — body swap to Replacement (B); subsequent review showed body is opaque past `Nonempty (ModuleCat k)`
- iter-131: PLAN-ONLY (no prover); refactor lane lands pure-term `Classical.choose`-chain body + strong acceptance lemma
- iter-132: COMPLETE — rank lemma `cotangentSpaceAtIdentity_finrank_eq` lands; reviewer audits found 0 must-fix, 0 major (5 majors are stale-framing docstring claims rendered inaccurate by the iter-132 in-file rank-theorem addition); 2 minor on the lean-vs-blueprint side (companion lemma lacks `\lean{...}` block; chapter rewrite-pattern drift)

#### Recurring blocker phrases
- "opaque past `Nonempty`" appears in iter-130 review reports — body's outer `Classical.choice (Nonempty.intro X)` wrapper discarded structural access
- "computes the zero `k`-module" appears in iter-129 diagnostic and `analogies/lieAlgebra-rank-bridge.md` — iter-128 body's mathematical defect (NOT structural)

#### Planner's current proposal for this iter
Declare Route 1 CONVERGING after the iter-132 close. No prover lane on Route 1 this iter (META-PATTERN TRIPWIRE non-promise commitment: no 4th body reshape under any branch). Dispatch a HIGH-A docstring-refresh refactor lane on `Cotangent/GrpObj.lean` to fix the 5 stale-framing sites in docstrings (pure docstring edits; no semantics change).

### Route 2: `AlgebraicJacobian/Jacobian.lean` (piece (i.a) downstream consumer; OFF-LIMITS)

- **Started at iter**: 127
- **Iters audited**: 127 to 132 (deferred-by-design)

#### Sorry counts per iter (file-specific)
- iter-127: 2 (`genusZeroWitness` scaffold + `nonempty_jacobianWitness` body)
- iter-128 to iter-132: 2 (unchanged — both intentionally deferred per directive; not active prover targets)

#### Helpers added per iter
- 0 each iter (file is OFF-LIMITS this whole run)

#### Prover statuses per iter
- iter-127 to iter-132: NOT DISPATCHED — file is OFF-LIMITS until M2 + M3 close

#### Recurring blocker phrases
- "gated on M2 + M3" appears in iter-127+ — both sorries are scaffolds for downstream witnesses, body closure ~iter-148+ (Phase C)

#### Planner's current proposal for this iter
Continue deferring. No prover dispatch.

### Route 3: `AlgebraicJacobian/RigidityKbar.lean` (M2.a scaffold; OFF-LIMITS)

- **Started at iter**: 126
- **Iters audited**: 126 to 132 (deferred-by-design)

#### Sorry counts per iter (file-specific)
- iter-126: 1 (`rigidity_over_kbar` scaffold)
- iter-127 to iter-132: 1 (unchanged — body gated on shared cotangent-vanishing pile pieces (i.a), (i.b), (i.c), (ii), (iii); only (i.a) closed)

#### Helpers added per iter
- 0 each iter (scaffold-bodied; downstream pile pieces are in `Cotangent/GrpObj.lean` and future files)

#### Prover statuses per iter
- iter-126 to iter-132: NOT DISPATCHED — body gated on pile

#### Recurring blocker phrases
- "gated on pile pieces (i)+(ii)+(iii)" appears in iter-126+ — body closure ~iter-151+

#### Planner's current proposal for this iter
Continue deferring. No prover dispatch.

### Route 4 (NEW for iter-133): `AlgebraicJacobian/Cotangent/GrpObj.lean` (piece (i.b) `mulRight_globalises_cotangent` — NEXT TARGET)

- **Started at iter**: 133 (THIS ITER, new route)
- **Iters audited**: 133 only (fresh)

#### Sorry counts per iter
- iter-133: 0 (route is new; no declaration scaffolded yet)

#### Helpers added per iter
- iter-133: 0 (pending mathlib-analogist consult this iter per `strategy-critic-iter131` Q3 must-fix carry-over)

#### Prover statuses per iter
- iter-133: NOT YET DISPATCHED — analogist consult fires this iter; prover lane scheduled iter-134+ pending analogist verdict

#### Planner's current proposal for this iter
Dispatch a mathlib-analogist consult on piece (i.b) `mulRight_globalises_cotangent` BEFORE any prover lane begins. The question: does the functorial shear iso `σ = ⟨pr₁, μ⟩` compose cleanly with the iter-131 `Classical.choose`-chain body of `cotangentSpaceAtIdentity`, or does the chart-dependent fibre require an inline (B)→(A) bridge construction (~300–600 LOC) that would re-open the (B) vs (A) decision?

## Specific signal-level questions

1. **Route 1 verdict for iter-133.** Given the 5-iter signal trail (iter-128 prover wrong / iter-129 plan corrective / iter-130 prover wrong / iter-131 plan corrective / iter-132 prover CORRECT closure of `cotangentSpaceAtIdentity_finrank_eq` with reviewer audits passing 0 must-fix), does Route 1 flip to CONVERGING, or is there a residual churn signal (e.g., the iter-132 review-phase 5 stale-framing docstring findings are a soft churn signal that the file's narrative is lagging the substantive content)?

2. **Route 4 (new) verdict.** Fresh route; the planner's proposal is "dispatch analogist this iter, no prover lane this iter." Is this a UNCLEAR verdict, or does the iter-131 strategy-critic Q3 must-fix carry-over make the analogist dispatch a CHURNING-protective action (i.e., the planner is correctly NOT dispatching a prover lane until the design question is resolved)?

3. **Meta-pattern verdict.** Iter-128 → iter-132 was a 5-iter run on the central declaration with 2 critic-flagged defect classes (degenerate iter-128 body; opaque iter-130 body) and 0 sorry-elimination through iter-131. Iter-132 closes the rank lemma. Does the META-PATTERN TRIPWIRE non-promise commitment (no 4th body reshape on `cotangentSpaceAtIdentity`) remain binding for iter-133, or does the route's CONVERGING status retire the tripwire?

## Format expected

Per `.archon/subagents/progress-critic.md`: per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) + specific corrective action when CHURNING or STUCK. Write to `task_results/progress-critic-iter133.md`.
