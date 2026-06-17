# Progress Critic Directive

## Slug
p4

## Iter
005

## Active routes / files under review

### Route: P4 — `AlgebraicJacobian/Cohomology/AcyclicResolution.lean` (acyclic resolution computes right-derived functor)

- **Started at iter**: 003 (file scaffolded)
- **Iters audited**: 003 to 004

#### Sorry counts per iter
(Note: this file is built in `mathlib-build` mode — it never carries `sorry`; the meaningful
metric is "named P4 targets closed of 3" and "axiom-clean decls added". Global project sorry
count is 2 and lives in a different file, unchanged by this route.)
- iter-003: 0 sorries in file; 0 of 3 named targets closed (file just scaffolded)
- iter-004: 0 sorries in file; 0 of 3 named targets closed; 1 of 3 PARTIAL

#### Helpers / decls added per iter
- iter-003: 2 (`IsRightAcyclic` class + its `[Injective]` instance)
- iter-004: 5 axiom-clean decls (`isZero_homology_mapHomologicalComplex_of_isRightAcyclic`,
  `shortExact_of_degreewise_splitting`, `shortExact_map_mapHomologicalComplex_of_degreewise_splitting`,
  `rightDerivedShiftIsoOfSplitResolutionSES` [the dimension-shift engine, substantive],
  `mono_biprod_lift_factorThru_of_exact` [the per-stage horseshoe mono, substantive])

#### Prover statuses per iter
- iter-003: NOOP — lane never launched (mechanical plan-validate filter dropped a zero-sorry
  objective lacking a scaffold keyword; NOT a prover failure)
- iter-004: DONE (mathlib-build) — built every CONSUMER of the horseshoe, verified all Mathlib
  inputs present, collapsed the whole P4 chain to ONE remaining construction (the horseshoe
  object `InjectiveResolution.ofShortExact`), which it explicitly declined as a monolith

#### Prover count per iter (files dispatched)
- iter-003: 0 dispatched (mechanical noop) of 1 ready
- iter-004: 1 dispatched of 1 ready (P4 is the only gate-cleared lane; P3/P5 blocked)

#### Recurring blocker phrases
- "horseshoe is a monolithic ℕ-recursion with no sorry-free partial fragment" — appears in
  iter-004 report only (first real prover iter on this route). Not yet recurring.

#### Route status changes per iter
- iter-003: active (scaffold prepared)
- iter-004: active (real progress)

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md**: ~3–5
- **Elapsed iters in current phase**: 2 (iter-003, iter-004; iter-003 was a mechanical noop)
- **Phase started at iter**: 003

#### Planner's current proposal for this iter
Decompose the horseshoe (`lem:injective_resolution_of_ses`) via `effort-breaker` at fine
granularity into independently-formalizable sub-lemmas (per-stage mono [already a Lean decl],
the off-diagonal twist `τ`, the twisted differential + `d∘d=0`, chain-map laws, resolves-B,
packaging). The per-stage mono and ALL downstream consumers are already built and axiom-clean.
If a same-iter scoped blueprint re-review then clears the decomposed chapter, dispatch the P4
prover (`mathlib-build`) on the new leaves this iter; otherwise the prover defers one iter to
the next mandatory blueprint review (the freshly-decomposed blueprint must clear the gate first).

## PROGRESS.md proposal (this iter)

- **File count**: 1 (AcyclicResolution.lean) IF the same-iter fast-path scoped review clears;
  else 0 prover files (decompose-only blueprint iter)
- **Files**: `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`
- **Files with complete blueprint chapters and open sorries (ready but not dispatched)**: none.
  P3 (`CechAcyclic.affine`) is blocked by a standard-cover-vs-general-cover statement gap
  (signature decision pending); P5 (`cech_computes_higherDirectImage`, protected) needs P3+P4.
- **Dispatch cap**: 10

## Out of scope
P3 and P5 are not under consideration for a prover this iter (both genuinely blocked, not
under-dispatched) — assess only the P4 route's convergence and whether the
decompose-then-build plan is the right response to the horseshoe-monolith blocker.
