# Progress Critic Directive

## Slug
iter128

## Iter
128

## Active routes / files under review

### Route: M2.a `rigidity_over_kbar` (iter-126 scaffold; gated on shared pile)

- **Started at iter**: 126
- **Iters audited**: 126, 127

#### Sorry counts per iter (file `RigidityKbar.lean`)
- iter-126: 1 (NEW scaffold at L87; +1 net iter-126)
- iter-127: 1 (unchanged; iter-127 plan-phase-only)

#### Helpers added per iter (file `RigidityKbar.lean`)
- iter-126: 1 new declaration `rigidity_over_kbar` (the scaffold itself).
- iter-127: 0 new declarations in the Lean file; +101 LOC to `RigidityKbar.tex` blueprint chapter (piece-(i) sub-decomposition staging iter-128 prover target).

#### Prover statuses per iter
- iter-126: N/A (plan-phase-only iter; no prover dispatch).
- iter-127: N/A (plan-phase-only iter; no prover dispatch).

#### Recurring blocker phrases
- None — no prover attempts yet on this declaration. The body closure is gated on shared cotangent-vanishing pile pieces (i)+(ii)+(iii) per STRATEGY.md § M2.a + § M2.body-pile.

#### Planner's current proposal for this iter
The plan agent does NOT propose direct prover work on `rigidity_over_kbar` this iter. Instead, the iter-128 prover lane targets the first sub-lemma of piece (i) of the shared pile (which is what the body closure of `rigidity_over_kbar` ultimately depends on). The piece-(i.a) Lean target `AlgebraicGeometry.GrpObj.lieAlgebra` is the iter-128 prover target. The body closure of `rigidity_over_kbar` itself remains iter-143+ work.

### Route: M2.b `genusZeroWitness` (iter-127 scaffold)

- **Started at iter**: 127
- **Iters audited**: 127

#### Sorry counts per iter (file `Jacobian.lean`, the `genusZeroWitness` declaration only)
- iter-127: 1 (NEW scaffold at L174–178; +1 net iter-127).

#### Helpers added per iter
- iter-127: 1 new declaration `genusZeroWitness` (the scaffold itself); also +31 LOC to `Jacobian.tex` blueprint chapter (def:genusZeroWitness block).

#### Prover statuses per iter
- iter-127: N/A (plan-phase-only iter).

#### Recurring blocker phrases
- None — no prover attempts yet on this declaration. The body closure is gated on M2.a body closure per STRATEGY.md (iter-145+).

#### Planner's current proposal for this iter
The plan agent does NOT propose direct prover work on `genusZeroWitness` this iter. Closure remains iter-145+.

### Route: META-PATTERN (consecutive plan-phase-only iters)

- **Started at iter**: 125 (first plan-phase-only iter under the iter-122 framing; iter-125 was the iter-124-staged unconditional M2.a pivot)
- **Iters audited**: 125, 126, 127

#### Plan-phase-only iter counts
- iter-125: plan-phase-only (Rigidity refactor `Scheme.Over.ext_of_eqOnOpen`; no prover dispatch).
- iter-126: plan-phase-only (M1 excise refactor + M2.a scaffold refactor + cotangent-vanishing-pile analogist; no prover dispatch).
- iter-127: plan-phase-only (M2.b scaffold refactor + over-k commitment analogist + 2 blueprint-writers; no prover dispatch).

#### Helpers added per iter (project-wide)
- iter-125: 1 new declaration `Scheme.Over.ext_of_eqOnOpen` (Rigidity.lean; refactor); −1 sorry.
- iter-126: 7 declarations excised from Differentials.lean (M1 excise; −1 sorry); 1 new declaration `rigidity_over_kbar` in new file RigidityKbar.lean (M2.a scaffold; +1 sorry). Net: 0 sorry change.
- iter-127: 1 new declaration `genusZeroWitness` in Jacobian.lean (M2.b scaffold; +1 sorry). Net: +1 sorry change (2 → 3).

#### Prover statuses per iter
- iter-125, iter-126, iter-127: N/A — three consecutive plan-phase-only iters by design (each was deliberate plan-agent commitment for refactor/strategy/scaffold work).

#### Recurring blocker phrases
- None per se; the meta-blocker is "no prover dispatch fires" across these three iters. The iter-127 progress-critic flagged this as CHURNING on the meta-pattern with iter-128 as the hard TRIPWIRE (if iter-128 is also plan-phase-only, the verdict flips to STUCK + user escalation).

#### Planner's current proposal for this iter
**META-PATTERN TRIPWIRE fires.** The plan agent commits to:
1. **Refactor** dispatch this iter: scaffold `AlgebraicGeometry.GrpObj.lieAlgebra` (and optionally its rank lemma `lieAlgebra_finrank_eq_dim`) in a new file `AlgebraicJacobian/Cotangent/GrpObj.lean` with `sorry` bodies. Add 2 new sorries to the project (3 → 5).
2. **Prover dispatch** in the same iter on the new file. The prover attempts to fill at least the `lieAlgebra` definition (and ideally the rank lemma).

The planner explicitly believes this satisfies the iter-127 progress-critic's stagger threat: iter-128 is no longer plan-phase-only; both a refactor and a prover lane fire.

### Route: NEW iter-128 piece (i.a) `AlgebraicGeometry.GrpObj.lieAlgebra` (fresh route)

- **Started at iter**: 128 (this iter; staged blueprint-only iter-127)
- **Iters audited**: only iter-128 will have signal post-iter

#### Sorry counts per iter
- iter-128: 1 or 2 (the refactor creates 1–2 new declarations with `sorry` body; net new sorries +1 or +2).

#### Helpers added per iter
- iter-128: 1–2 new declarations in `AlgebraicJacobian/Cotangent/GrpObj.lean` (`lieAlgebra` + optional `lieAlgebra_finrank_eq_dim`).

#### Prover statuses per iter
- iter-128: pending (this iter's prover lane).

#### Recurring blocker phrases
- N/A — fresh route.

#### Planner's current proposal for this iter
- Refactor + prover dispatch on `AlgebraicGeometry.GrpObj.lieAlgebra`. Realistic outcome: COMPLETE in 1 iter (if the declaration is small enough — defines `eta_G^* Omega_{G/k}` as a finite-free k-module via existing project infra `relativeDifferentialsPresheaf` + Mathlib smooth/regular local ring) OR PARTIAL with narrower residual (e.g. prover closes `lieAlgebra` but leaves `lieAlgebra_finrank_eq_dim` with sorry).

Pre-existing project infra available to the prover:
- `relativeDifferentialsPresheaf : (X ⟶ S) → X.PresheafOfModules` (project's `Differentials.lean`).
- `relativeDifferentialsPresheaf_obj_kaehler` (rfl identification).
- Mathlib `GrpObj` API in `Mathlib.AlgebraicGeometry.Group.Smooth` (per iter-127 over-k analogist).

## Out of scope

- `Jacobian.lean:194` `nonempty_jacobianWitness` (OFF-LIMITS; the iter-148+ genus-stratified body restructure is gated on M2 + M3 closure).
- M3 (`positiveGenusWitness`) — off-critical-path until M2 closes per iter-127 sequencing.
- Cohomology files (M5–M8 scaffolding) — DONE; not active prover lanes.
- M1 (EXCISED iter-126).

## Specific questions for the critic

1. Is the iter-128 META-PATTERN TRIPWIRE prover dispatch a real corrective, or does the planner's "refactor + prover in same iter" framing still constitute plan-phase-only behaviour (since the refactor creates new sorries that the same-iter prover may not close)?
2. Is the iter-128 prover target choice (piece (i.a), `lem:GrpObj_lieAlgebra`) appropriately sized for a 1-iter close-or-PARTIAL outcome, or is it too ambitious (requires scheme-level Kaehler infrastructure beyond the project's existing `relativeDifferentialsPresheaf`)?
3. Should the iter-128 plan-phase add an explicit fallback rule: if the prover returns INCOMPLETE on the new `lieAlgebra` declaration, what is the iter-129 corrective?
