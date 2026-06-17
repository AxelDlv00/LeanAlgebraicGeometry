# Progress-critic directive — slug route203

Assess convergence for the routes the planner is considering for iter-203
prover dispatch. K=5 window (iter-198..202). Verdict per route.

## Route COE-A4c0 (`AlgebraicJacobian/Albanese/CodimOneExtension.lean`)

- **Sorry trajectory** (iter-198→202): 3 → 3 → 3 → 3 → 3. Zero movement in 5 iters.
- **Helpers added per iter**: 198: 1, 199: 4, 200: 7, 201: 3, 202: 4 (Step B
  bridges B.a/b/c axiom-clean). ~19 across window; 0 sorries eliminated.
- **Prover status**: 198 PARTIAL, 199 PARTIAL, 200 PARTIAL, 201 PARTIAL,
  202 done (HARD BAR ≥2 bridges exceeded — 3 of 4 axiom-clean; 0 sorry closed).
- **Recurring blocker (EVOLVED + now RESOLVED)**: iter-200 "Step 3 Mathlib gap";
  iter-201 "IsRegularLocalRing⟹IsDomain MISSING" — INVERTED by iter-201 lean-auditor
  (project HAS them private in AuslanderBuchsbaum.lean); iter-202 Lane AB **landed
  the private→public promotions** (`RingTheory.CohenMacaulay.isDomain_of_regularLocal`,
  `…regularLocal_quotient_isRegularLocal_of_notMemSq` both public + axiom-clean).
  The cross-file fence that blocked Step A1 is **discharged** as of iter-202.
- **STRATEGY Iters-left**: ~4-7. Phase entered iter-177 (~25 iters elapsed — most
  over-budget route).
- **iter-203 proposed dispatch**: build Step A1 Matsumura witness
  `matsumura_isRegular_of_linearIndependent_cotangent` axiom-clean (consumes the
  two now-public AB helpers; recipe fully specified in blueprint
  `\subsec:stage6_iib_substrate_iter200`), then push Stage 6.A capstone (Stacks
  00OE, still MISSING) + B.d assembly toward the L1262 sorry. mathlib-build mode.

## Route TS-A1cSubT (`AlgebraicJacobian/Picard/TensorObjSubstrate.lean`)

- **Sorry trajectory**: file did not exist before iter-202; iter-202 created it with
  6 typed-sorry stubs (scaffold, by design).
- **Helpers added**: iter-202: 4 pinned stubs + 2 supporting + 1 bodied helper.
- **Prover status**: iter-202 done (scaffold HARD BAR met — GREEN, 4 pins + import).
- **Recurring blocker**: none yet (1 dispatch).
- **STRATEGY Iters-left**: ~3-6. Phase entered iter-202 (scaffold).
- **iter-203 proposed dispatch**: body fill Piece 1 `tensorObj` (lift
  `PresheafOfModules.Monoidal.tensorObj` through Zariski-site sheafification),
  then functoriality + `monoidalCategory` as far as possible. mathlib-build mode.

## Planner's PROGRESS.md `## Current Objectives` proposal (iter-203)

2 files: `CodimOneExtension.lean` (Lane COE Step A1 + push), `TensorObjSubstrate.lean`
(Lane TS body fill). Held: WeilDivisor (substrate DONE, terminal closure USER-blocked),
AuslanderBuchsbaum (CLOSED iter-202, 0 sorries), RelPicFunctor / FGA / Thm32 / RCI
(concrete re-engagement triggers).

## Question for you

For COE: with the iter-202 AB promotions landing and the Step A1 recipe fully
specified in the blueprint, is the route now CONVERGING, or does the 5-iter
0-sorry-movement + 25-iter elapsed still warrant CHURNING/STUCK? Name the
corrective TYPE if not CONVERGING. For TS: UUNCLEAR vs proceed. Also flag any
dispatch-sanity issue with the 2-file proposal.
