# Progress Critic Directive

## Slug
iter127

## Iter
127

## Active routes / files under review

### Route: M2.a — `rigidity_over_kbar` (Albanese rigidity, post-iter-127 over-k commitment) in `AlgebraicJacobian/RigidityKbar.lean`

- **Started at iter**: 126 (NEW iter-126 scaffold)
- **Iters audited**: 124, 125, 126, 127

#### Sorry counts per iter (project total / per-file)
- iter-124: 2 total (Differentials.lean 1 PARKED, Jacobian.lean 1 OFF-LIMITS)
- iter-125: 2 total (same; iter-125 was Rigidity refactor — Differentials.lean PARKED unchanged)
- iter-126: 2 total (M1 EXCISED -1 + M2.a scaffold +1 = net 2; final inventory: Jacobian.lean 1 OFF-LIMITS, RigidityKbar.lean 1 NEW scaffold)
- iter-127: 3 total (M2.b scaffold +1; final inventory: Jacobian.lean 2 — OFF-LIMITS + NEW scaffold genusZeroWitness, RigidityKbar.lean 1 — iter-126 scaffold)

#### Helpers added per iter
- iter-124: 1 helper (`forwardAlg` AlgHom promotion) in `Differentials.lean` Step 1; M1.b residual narrowed
- iter-125: 0 net helpers (Rigidity refactor: 8 hypothesis drops + rename; -8 unused hypotheses, no new declarations)
- iter-126: 0 helpers on M2.a route; 1 NEW declaration `rigidity_over_kbar` (the scaffold itself)
- iter-127: 0 helpers on M2.a route; 1 NEW declaration `genusZeroWitness` in `Jacobian.lean` (the M2.b scaffold)

#### Prover statuses per iter (M2.a route specifically)
- iter-124: n/a (route did not exist; iter-124 was M1.b)
- iter-125: n/a (route did not exist; iter-125 was Rigidity refactor)
- iter-126: SCAFFOLD-LANDED (refactor agent placed declaration with sorry body; not a prover dispatch)
- iter-127: SCAFFOLD-EXTENDED (refactor agent placed `genusZeroWitness` with sorry body; over-k path committed via analogist; no prover dispatch)

#### Recurring blocker phrases (M2.a route)
- "the body closure is gated on the shared cotangent-vanishing pile (iter-129+)" appears in iter-126 + iter-127 reports — by design, not a blocker
- "META-PATTERN TRIPWIRE for iter-128 (must dispatch a prover or flip to CHURNING)" — iter-126 progress-critic flagged this, iter-127 plan-agent staged the target via blueprint-writer-rigiditykbar-piece-i-iter127 dispatch this iter

#### Planner's current proposal for this iter
The iter-127 plan agent has:
1. Adopted the over-k path commitment (iter-127 over-k analogist returned OK_OVER_K on all 3 active pile pieces; M2.c + M2.c.aux DROPPED, saving 7–13 iter / 500–900 LOC).
2. Landed M2.b scaffold (`genusZeroWitness` in `Jacobian.lean:174–178`; single sorry body).
3. Dispatched blueprint-writers to stage iter-128 prover target: piece (i) sub-lemma decomposition in `RigidityKbar.tex` + `genusZeroWitness` definition block in `Jacobian.tex`.
4. Updated STRATEGY.md with the strategic refactor.

The planner's iter-127 plan is **plan-phase-only by design** (refactor + analogist + critics + writers; no prover dispatch). The next iter (iter-128) MUST dispatch a prover lane on the first piece (i) sub-lemma per the iter-126 progress-critic META-PATTERN TRIPWIRE.

### Route: M2.b — `genusZeroWitness` (Genus-0 Albanese witness builder) in `AlgebraicJacobian/Jacobian.lean`

- **Started at iter**: 127 (NEW iter-127 scaffold this iter)
- **Iters audited**: 127 only (route is fresh)

#### Sorry counts per iter (M2.b route)
- iter-127: 1 sorry (the `genusZeroWitness` body, NEW this iter)

#### Helpers added per iter (M2.b route)
- iter-127: 1 declaration (`genusZeroWitness` itself, scaffold ADD)

#### Prover statuses per iter (M2.b route)
- iter-127: SCAFFOLD-LANDED (refactor agent placed declaration with sorry body)

#### Recurring blocker phrases
- None yet (route is fresh)

#### Planner's current proposal for this iter
M2.b scaffold landed via `refactor-m2b-scaffold-iter127`. Body closure is gated on M2.a body (which is gated on the shared cotangent-vanishing pile, iter-128+). Estimated body closure: iter-145+.

### Route: Meta-pattern — consecutive plan-phase-only iters

- **Started at iter**: 125 (first plan-phase-only iter; iter-125 = Rigidity refactor with no prover)
- **Iters audited**: 125, 126, 127

#### Iter-by-iter pattern (plan-phase-only vs prover-dispatch)
- iter-125: plan-phase-only (Rigidity refactor + 3 critics; 0 prover dispatch)
- iter-126: plan-phase-only (M1 excise + M2.a scaffold + analogist + 3 critics; 0 prover dispatch)
- iter-127: plan-phase-only (M2.b scaffold + over-k analogist + 3 critics + 2 blueprint-writers; 0 prover dispatch)

Three consecutive plan-phase-only iters. iter-126 progress-critic explicitly flagged this as the META-PATTERN TRIPWIRE: iter-128 MUST dispatch a prover lane on a piece-(i) sub-lemma OR the meta-pattern flips to CHURNING.

#### Planner's current proposal for this iter
The iter-127 plan agent has STAGED iter-128's prover target via the blueprint-writer-rigiditykbar-piece-i-iter127 dispatch THIS iter. iter-128 plan-phase will: (a) refactor-scaffold the first piece-(i) sub-lemma declaration in a new file `AlgebraicJacobian/Cotangent/GrpObj.lean` (or similar; TBD by the writer's output); (b) dispatch a prover lane on it. The CHURNING meta-pattern is averted only if iter-128 actually fires the prover lane.

## Out of scope

- M1 (EXCISED iter-126; no longer an active route).
- `Jacobian.lean:194` `nonempty_jacobianWitness` (OFF-LIMITS to autonomous loop; iter-148+ work).
- M3 (positive-genus witness; off-critical-path until M2 closes).
- Cohomology files (M5+ infrastructure; all closed, off-active).

## Question

Apply your strict verdict rules per route. Particularly: is the iter-127 plan-phase-only design defensible under the META-PATTERN TRIPWIRE you (the iter-126 critic) raised, or does the staged iter-128 prover dispatch suffice as the corrective?
