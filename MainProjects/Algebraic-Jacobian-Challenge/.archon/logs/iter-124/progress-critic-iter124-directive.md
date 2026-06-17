# Progress Critic Directive

## Slug
iter124

## Iter
124

## Active routes / files under review

### Route: M1.b body — `AlgebraicGeometry.IsAffineOpen.appLE_isLocalization`

- **Started at iter**: 117 (M1 milestone began iter-117 after the
  iter-116 strategic pivot to the bridge formalization).
- **Iters audited**: 119 to 123 (K = 5).

#### Sorry counts per iter (project total)

- iter-119: 5 → 4 (one closure on Differentials.lean).
- iter-120: 4 → 1 (Differentials closure;
  `smooth_locally_free_omega` landed).
- iter-121: 1 → 1 (no prover dispatch; strategic pivot iter — user
  directive moved end-state from "ship with one sorry" to "zero
  sorry", multi-iter M1/M2/M3 roadmap committed).
- iter-122: 1 → 5 (refactor introduces M1 scaffolding) → 2 by close
  (refactor introduces 4 new sorries on Differentials; prover
  closes 3 of those 4 — `appLE_colimAlgebra` letI L109, module letI
  L142, M1.e bridge body L145; one new helper Step 0 closed as
  `isUnit_appLE_unitSubmonoid_in_colim`).
- iter-123: 2 → 2 (Differentials.lean 1 → 1, the sorry moved L304
  → L362; Steps 1 + 4 closed in body, Steps 2 + 3 packaged into a
  single AlgEquiv residual sorry; no net sorry-count change but
  substantial structural advance).

#### Helpers added per iter (M1.b lane)

- iter-119: 0 helpers (file-internal refactor / `appLE` API).
- iter-120: 0 helpers; one sorry closure
  (`smooth_locally_free_omega`).
- iter-121: 0 helpers (no prover dispatch).
- iter-122: 4 new named declarations:
  `appLE_unitSubmonoid` (def, L78), `appLE_colimRingHom` (def, L97),
  `appLE_colimAlgebra` (`@[reducible] noncomputable def`, L106),
  `appLE_colimRingHom_comp_φV` (theorem, L116);
  plus 1 new theorem `isUnit_appLE_unitSubmonoid_in_colim` (L164,
  ~70 LOC — Step 0 of M1.b); plus 2 new theorems
  `kaehler_localization_subsingleton` (L314, ~6 LOC) and
  `kaehler_quotient_localization_iso` (L330, ~25 LOC — M1.d).
  All 7 helpers fully proved; Step 0 is the key one for M1.b.
- iter-123: 0 new named declarations; in-body Step 1 (`IsLocalization.lift`
  forward map, ~30 LOC) + Step 4 (`IsLocalization.isLocalization_of_algEquiv`
  reduction, ~5 LOC) landed in the proof body of
  `appLE_isLocalization`. The residual sorry remains 1, on the
  AlgEquiv hole; the structural reduction is in place.

#### Prover statuses per iter

- iter-119: PARTIAL — closed 1 of N sorries on Differentials.lean
  via API refactor; remaining sorry is `smooth_locally_free_omega`.
- iter-120: COMPLETE — closed `smooth_locally_free_omega`.
- iter-121: NO_DISPATCH — strategic-pivot iter (user directive);
  intentional plan-phase-only iter.
- iter-122: PARTIAL — refactor introduces 4 new sorries; prover
  closes 3 of 4 + adds Step 0 as named helper. Substantial
  structural advance. The PARTIAL reflects "one residual sorry
  remains (Step 1–4 of M1.b body)" rather than "no progress."
- iter-123: PARTIAL — Step 1 (`IsLocalization.lift` forward map)
  + Step 4 (`isLocalization_of_algEquiv` reduction via `suffices`)
  closed concretely in body; Steps 2 + 3 packaged as a single
  AlgEquiv residual sorry. Substantial structural advance. The
  PARTIAL reflects "the AlgEquiv hole remains" rather than "no
  progress."

#### Recurring blocker phrases

- "Lan-functor `map_comp` does not unify under `set` aliases" —
  appears in iter-122 prover report; iter-123 mathlib-analogist
  consult landed canonical workaround (pre-prove + `erw`,
  avoid `set` aliases inside rewrite region); iter-123 prover
  did not re-hit this blocker.
- "cofinality on the cocone universal property is the largest
  remaining step" — appears in iter-122 and iter-123 prover
  reports as the Step 2 description; not yet "hit" as a blocker
  since iter-123 did not attempt Step 2 in detail.
- "AlgEquiv vs RingEquiv (Step 4 closure pattern)" — appears in
  iter-122 prover (used wrong constructor name in plan) and
  iter-123 mathlib-analogist consult (verified `AlgEquiv` is
  required); iter-123 prover used the correct one.

#### Planner's current proposal for this iter

The planner intends to assign the iter-124 prover lane to
**continue M1.b** with a focused Step 2 + Step 3 prover lane on
`Differentials.lean`, targeting the residual AlgEquiv sorry at
L362. The decomposition the iter-123 prover provided
(Step 2a/b/c/d + Step 3 + Step 4 assembly) is the recommended
shape; estimated 140–230 LOC.

The iter-124 plan also schedules:
- M2.c + M2.d-alt phantom prereq spot-checks (Mathlib namespace
  scans; non-prover plan-phase work).
- M3 user escalation via the iter-124 sidecar (review agent will
  surface in TO_USER.md).

The planner is NOT considering a route pivot to M2.a this iter,
on the rationale that iter-123 delivered substantial structural
advance (Step 1 + Step 4 closed in body) and the M1 milestone is
closer than the 2-iter CHURNING rule's pivot trigger requires.

## Out of scope

- `Jacobian.lean:179` `nonempty_jacobianWitness` — the single
  foundational sorry, off-limits to the autonomous loop until M2
  + M3 land.
- M2.a Rigidity.lean refactor scoping — queued for iter-125 or
  later (only if M1 stalls further).
- Cohomology files (M5-M8) — not active prover lanes; iter-124
  lean-auditor flagged some dead-class cleanup work but that is
  refactor-scope, not prover-scope.
