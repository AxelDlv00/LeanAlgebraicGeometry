# Progress Critic Directive

## Slug
iter131

## Iter
131

## Active routes / files under review

### Route: `AlgebraicJacobian/Cotangent/GrpObj.lean` (piece (i.a) `cotangentSpaceAtIdentity`)

- **Started at iter**: 128
- **Iters audited**: 128 to 130

#### Sorry counts per iter
- iter-127: 0 (file did not exist; scaffold landed iter-128)
- iter-128: 0 (definition closure landed kernel-clean; iter-128 was a definition-only iter on a fresh file)
- iter-129: 0 (iter-129 was plan-only — refactor renamed `lieAlgebra` → `cotangentSpaceAtIdentity` and relaxed signature; no body change)
- iter-130: 0 (iter-130 prover lane swapped the body to Replacement (B); body kernel-clean, but **structurally opaque** per iter-130 lean-auditor must-fix)

#### Helpers added per iter
- iter-128: 1 new file + 1 named declaration `cotangentSpaceAtIdentity` (75 LOC scaffold body, kernel-clean but mathematically degenerate — discovered iter-129 by mathlib-analogist)
- iter-129: 0 new declarations (refactor was signature-only; rename + binder relax)
- iter-130: 0 new declarations (body swap on the same declaration); file grew 104 LOC → 172 LOC, most of which is docstring prose (file-level + status + declaration docstring) describing Replacement (B)

#### Prover statuses per iter
- iter-128: COMPLETE — body landed in 3 substantive Edits; kernel-only `lean_verify`. Discovered iter-129 to be mathematically degenerate (computes zero `k`-module).
- iter-129: no prover dispatch (plan-only iter).
- iter-130: COMPLETE — body swap landed in 3 substantive Edits (one parse error on `h⊤` → `htop`; one Prop-elimination error on direct `obtain`; one clean close via `Classical.choice` pivot). Passed iter-130 progress-critic literal acceptance test (~40 LOC, references `smooth_locally_free_omega`, not simp-only). **BUT** iter-130 review-phase lean-auditor flagged structural opacity (body wraps explicit witness in `Classical.choice (α := ModuleCat k) ⟨X⟩` → result not definitionally equal to `X`; only `Nonempty (ModuleCat k)` is structurally exposed; rank lemma unprovable against this body).

#### Recurring blocker phrases
- "computes the zero `k`-module" appears in iter-129 mathlib-analogist verdict on iter-128 body — diagnosed as "vacuity-by-zero-collapse" defect class.
- "opaque past `Nonempty`" appears in iter-130 lean-auditor must-fix on iter-130 body — diagnosed as "vacuity-by-opaque-witness" defect class (different mechanism, same downstream impact: rank lemma still cannot close).
- "rank lemma unprovable against this body" appears in both iter-129 analogist and iter-130 auditor — the rank lemma `cotangentSpaceAtIdentity_finrank_eq` (iter-130+ deferred target) has now been blocked twice across two body-shape iterations of the same declaration.

#### Planner's current proposal for this iter

The iter-131 plan agent's proposal is:

**Refactor lane (NOT prover lane) on `Cotangent/GrpObj.lean`**. Swap the iter-130 body's outer `Classical.choice (α := ModuleCat k) ?_; obtain ⟨…⟩; exact ⟨X⟩` for a `Classical.choose`-chain (or `Classical.indefiniteDescription`) that exposes the chart `V`, the algebra structure on `Γ(G, V)`, and the algebraic Kähler module as named local data. The refactor lane also: (a) refreshes the "Caveat on canonicity" docstring (iter-130 auditor flagged it as a "lying excuse-comment"); (b) piggyback-edits the 2 stale `Jacobian.lean` docstrings the auditor flagged at L195 + L226.

NO prover dispatch this iter on this file. The iter-132 prover lane is the natural follow-up: scaffold + close the rank lemma `cotangentSpaceAtIdentity_finrank_eq` against the iter-131 refactored body (closure chain in `analogies/lieAlgebra-rank-bridge.md` § "Bridge lemma list" — 4 verified Mathlib names).

The pattern so far on this route: iter-128 prover (body wrong-by-zero), iter-129 plan (diagnose + repair scaffold), iter-130 prover (body wrong-by-opacity), iter-131 plan (refactor body shape). **This is the second iter-N (plan) / iter-N+1 (prover) correction-cycle on the same declaration in 2 cycles.** The iter-130 review explicitly named the "tripwire is not yet armed" condition: it would arm only if iter-131's fix-up also fails to deliver an accessible body. The iter-131 plan agent is asking: is the iter-131 refactor lane the right corrective, or should the route be re-thought at a deeper level (e.g. abandon Replacement (B) in favour of (A) stalk-side or (C) sheafified, or pivot to the strategy's fibre-free piece (i) reformulation alternative)?

### Route: `AlgebraicJacobian/RigidityKbar.lean` (piece M2.a `rigidity_over_kbar` body)

- **Started at iter**: 126
- **Iters audited**: 128 to 130

#### Sorry counts per iter
- iter-128: 1 (L87 `rigidity_over_kbar := sorry` scaffold; same as iter-126/127 entry state)
- iter-129: 1 (unchanged; iter-129 plan-only)
- iter-130: 1 (unchanged; deferred-by-design pending pieces (i)+(ii)+(iii) closure)

#### Helpers added per iter
- iter-128 to iter-130: none on this file.

#### Prover statuses per iter
- iter-128/129/130: no prover dispatch (OFF-LIMITS pending shared pile closure).

#### Recurring blocker phrases
- None — this is a deferred-by-design route.

#### Planner's current proposal for this iter

No work on this file this iter (deferred until piece (i.a) trio + (i.b) + (i.c) + (ii) + (iii) close, multi-iter).

### Route: `AlgebraicJacobian/Jacobian.lean` (piece M2.b `genusZeroWitness` body + Phase-C `nonempty_jacobianWitness`)

- **Started at iter**: 127 (M2.b scaffold)
- **Iters audited**: 128 to 130

#### Sorry counts per iter
- iter-128 to iter-130: 2 (L188 `genusZeroWitness` scaffold + L211 `nonempty_jacobianWitness` Phase-C OFF-LIMITS)

#### Helpers added per iter
- iter-129: 1 docstring rewrite (file-level header; iter-127 stale-header repair)
- iter-130: 0

#### Prover statuses per iter
- iter-128/129/130: no prover dispatch (OFF-LIMITS pending M2.a + terminal-object cluster on `Spec k`).

#### Recurring blocker phrases
- None — deferred-by-design routes.

#### Planner's current proposal for this iter

No work on this file this iter (deferred until M2.a body + terminal-object cluster + vacuity-branch encoding, iter-152+).

## What I need from you

For each route, render CONVERGING / CHURNING / STUCK / UNCLEAR. Particular questions for Route 1 (`Cotangent/GrpObj.lean`):

1. The pattern iter-128 prover → iter-129 plan → iter-130 prover → iter-131 plan is a **2-cycle correction loop** on the same declaration. The first cycle fixed a "zero-collapse vacuity" defect; the second cycle is fixing an "opaque-Nonempty vacuity" defect. Does this constitute CHURNING (the route adds work-and-corrections per iter but never delivers an accessible-and-correct body)?
2. The strategy's auto-revert trigger (a') in STRATEGY.md is wired to fire on piece (i.b) shear-iso closure failure under (B), not on iter-130/131 body-shape opacity. Does the iter-130 opacity defect constitute a deeper failure of (B) that should fire a route pivot **now** (to Replacement (A) stalk-side, or to the fibre-free piece (i) reformulation) instead of pursuing a refactor on (B)?
3. Is the iter-131 plan agent's proposed refactor lane (without dispatching a mathlib-analogist on whether `Classical.choose` actually fixes the issue, vs reaching for (A)/(C) instead) the right corrective? If a mathlib-analogist consult is needed FIRST, name it.
4. **META-PATTERN check**: would your verdict change if I told you this is the 4th iter on the same declaration with body-shape problems (iter-128 wrong body, iter-129 diagnostic + signature refactor, iter-130 wrong body again, iter-131 proposed body refactor)?
