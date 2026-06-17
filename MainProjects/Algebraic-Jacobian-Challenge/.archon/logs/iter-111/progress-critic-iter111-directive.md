# Progress Critic Directive

## Slug
iter111

## Iter
111

## Active routes / files under review

For the iter-111 dispatch decision, the planner is considering exactly
ONE prover lane: **Phase B opening on `AlgebraicJacobian/Differentials.lean`
L122 `relativeDifferentialsPresheaf_isSheaf`**.

### Route: AlgebraicJacobian/Differentials.lean (Phase B)

- **Started at iter**: 111 (fresh opening; iter-110 was deeper-think with no prover dispatch on this file).
- **Iters audited**: iter-108 / iter-109 / iter-110 (Archon canonical).

#### Sorry counts per iter (Differentials.lean only)
- iter-108: 5 (L122, L636, L718, L735, L877)
- iter-109: 5 (unchanged — no prover round)
- iter-110: 5 (unchanged — no prover round, blueprint-writer-differentials iter-110 expanded chapter only)

#### Helpers added per iter (in this file)
- iter-108: 0
- iter-109: 0
- iter-110: 0

#### Prover statuses per iter (for this route only)
- iter-108: not dispatched on this file
- iter-109: not dispatched on this file
- iter-110: not dispatched on this file (HARD GATE blocked — chapter was `complete: partial` pre-writer)

#### Recurring blocker phrases
- None — this is a fresh route. No prover has yet attempted L122. The
  iter-110 blueprint-writer expanded the chapter with Mathlib lemma
  names (`KaehlerDifferential.tensorKaehlerEquiv`, `Presheaf.isSheaf_iff_isSheaf_comp`)
  + Stacks 01UM / 02HQ / 02HW + Hartshorne II.8 refs. iter-110
  mathlib-analogist-serre-duality reclassified L877 as named gap #7
  (out of scope iter-111); L636 remains deferred parallel to
  `instIsMonoidal_W`. So the prover-viable Phase B surface is exactly
  3 sorries (L122/L718/L735), and L122 is the foundational one.

### Route: AlgebraicJacobian/Cohomology/BasicOpenCech.lean (Phase A)

- **Started at iter**: long ago
- **Iters audited**: iter-108 / iter-109 / iter-110

#### Sorry counts per iter (this file)
- iter-108: 6 (L1120 PAUSED, L1212, L1536, L1564, L1754, L1846)
- iter-109: 6 (unchanged)
- iter-110: 6 (unchanged)

#### Helpers added per iter (this file)
- iter-108: 0
- iter-109: 0
- iter-110: 0

#### Prover statuses
- iter-108: PARTIAL on L1846 (Option (i) escape-valve fired — annotation only, sorry preserved)
- iter-109: PARTIAL on L1846 (Step 1c inline scaffolding accreted; sorry preserved)
- iter-110: not dispatched

#### Recurring blocker phrases
- "L1120 PAUSED 7-iter PARTIAL streak frozen"
- "L1846 budget-deferred per Option (i)"
- The iter-110 plan held this file off-limits across the board, in
  line with the iter-108 escape-valve resolution.

**Iter-111 planner position**: this file remains OFF-LIMITS iter-111;
no plan dispatch.

### Route: AlgebraicJacobian/Picard/LineBundle.lean (post-C1)

- **Started at iter**: iter-108 (refactor); iter-109 (prover round)
- **Iters audited**: iter-108 / iter-109 / iter-110

#### Sorry counts per iter (this file)
- iter-108: 1 (pre-C1: just `Pic.pullback` placeholder)
- iter-109: 2 (post-C1 promotion: L82 `pullback_tensorObj` + L96 `pullback_oneIso`; 3 transient sorries closed in same iter)
- iter-110: 2 (unchanged — no prover round)

#### Helpers added per iter (this file)
- iter-108: 0 (refactor)
- iter-109: 1 (the `pullback_oneIso` sister-gap, helper-shaped)
- iter-110: 0

#### Prover statuses
- iter-108: not dispatched (refactor-only)
- iter-109: COMPLETE (closed 3 transient sorries via Path (i) hand-construction)
- iter-110: not dispatched

#### Recurring blocker phrases
- "named-deferred Mathlib-gap pair — collapses when Mathlib refresh
  lands `(SheafOfModules.pullback _).Monoidal`"

**Iter-111 planner position**: this file remains OFF-LIMITS iter-111;
no plan dispatch. The two residuals are named gaps #5/#6.

## What the planner is asking

For the single proposed iter-111 prover lane (Phase B on Differentials.lean
L122), is the route in a state to fire? Specifically:

- Is this a CONVERGING/UNCLEAR fresh-route signal (proceed) or
  a CHURNING/STUCK risk (do not fire)?
- For the 2 OFF-LIMITS routes (BasicOpenCech, LineBundle): the planner
  is NOT proposing to re-dispatch them. Please confirm those continue
  to merit OFF-LIMITS status (ratify the iter-110 verdict).
