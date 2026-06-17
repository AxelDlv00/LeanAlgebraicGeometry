# Progress Critic Directive

## Slug
iter121

## Iter
121

## Active routes / files under review

### Route: AlgebraicJacobian/Differentials.lean — bridge to algebra-Kähler form (NEW M1 milestone)

- **Started at iter**: 121 (this iter introduces the bridge declaration; was previously deferred as out-of-scope)
- **Iters audited**: N/A — fresh route. Provide an UNCLEAR verdict pending iter-122 data.

#### Sorry counts per iter
- iter-117: 2 (`smooth_locally_free_omega`, `nonempty_jacobianWitness`)
- iter-118: 2 (signature refactor only; sorry moved L81 → L93 on the iff-to-forward demotion)
- iter-119: 2 (PARTIAL prover lane on `smooth_locally_free_omega`; sorry moved L93 → L136)
- iter-120: 1 (COMPLETE prover lane closes `smooth_locally_free_omega`; `nonempty_jacobianWitness` is the lone remaining)
- iter-121 (planned, this iter): 2 (CLOSED `smooth_locally_free_omega` + 1 NEW sorry for the bridge declaration M1)

#### Helpers added per iter
- iter-117: 0
- iter-118: 0
- iter-119: 0
- iter-120: 0
- iter-121: 1 NEW declaration (the bridge `relativeDifferentialsPresheaf_iso_kaehler_appLE`), with three subsidiary `\lean{...}`-tagged blueprint lemmas (appLE_isLocalization, kaehler_localization_subsingleton, kaehler_quotient_localization_iso) that may or may not become Lean declarations depending on the refactor agent's choice.

#### Prover statuses per iter
- iter-117: COMPLETE (trim refactor; no prover lane on the smoothness criterion)
- iter-118: NO_PROVER (deferred to iter-119 per blueprint-reviewer hard-gate)
- iter-119: PARTIAL (Steps 1–5 of 6 landed; bridge-step residual sorry at L136)
- iter-120: COMPLETE (algebra-Kähler signature refactor + closure in 11 LOC)
- iter-121 (planned): PARTIAL or PARTIAL-then-COMPLETE expected on the M1.a step (Submonoid definition) or M1.b step (cofinality + IsLocalization), depending on which the prover picks first.

#### Recurring blocker phrases
- None across the last 4 iters. The iter-119 PARTIAL was a real, named blocker
  (presheaf-form vs. appLE-form ring source mismatch); iter-120 closed it via
  signature refactor. No phrase recurs.

#### Planner's current proposal for this iter

Introduce the bridge declaration `relativeDifferentialsPresheaf_iso_kaehler_appLE`
in `Differentials.lean` (via refactor subagent), then run a prover lane to
close milestone-M1's first sub-step. The prover may choose between:
- M1.a (Submonoid `M` of "good" elements of `A`) — small, concrete, the obvious
  starting block. Estimated 1 iter / 30 LOC.
- M1.b (the cofinality / `IsLocalization` statement itself, as the standalone
  contribution candidate) — more ambitious but matches the Mathlib-contributor
  framing. Estimated 2 iters / 120 LOC.

The planner expects PARTIAL outcome on the first iter regardless of which the
prover picks; the bridge is multi-iter work. Note: this is a NEW route, no
prior data on convergence. Provide UNCLEAR until iter-122 / iter-123 give the
first signal.

### Route: AlgebraicJacobian/Jacobian.lean — nonempty_jacobianWitness via genus-0 route C (M2 milestone)

- **Started at iter**: 121 (newly on the active roadmap)
- **Iters audited**: N/A — fresh route. Provide UNCLEAR.

#### Sorry counts per iter
- iter-117 through iter-120: 1 (`nonempty_jacobianWitness` was the lone foundational sorry; treated as "off-limits" / "intended end-state")
- iter-121 (planned): 1 (NOT yet on the prover dispatch list this iter; planner is queuing M2 for iter-123+ pending M1 progress)

#### Helpers added per iter
- iter-117 through iter-120: 0 (route was deferred)
- iter-121: 0 (route is queued; M2.a rigidity blueprint section already covers the math)

#### Prover statuses per iter
- iter-117 through iter-120: NO_PROVER (off-limits)
- iter-121: NO_PROVER (queued; M2.a prover lane in iter-122 or iter-123 depending on M1 progress)

#### Recurring blocker phrases
- None — the route was treated as deferred. The blueprint chapter `Jacobian.tex`
  has Route C documented at sub-step level; no blocker has been encountered
  because no prover lane has run.

#### Planner's current proposal for this iter

Do NOT dispatch a prover on this route this iter. Instead, the M1 bridge work
is the iter-121 prover lane (the bridge is smaller, more concrete, more
"Mathlib-contribution-shaped"). M2 enters the prover queue in a future iter
after M1 produces enough structural advance to absorb the planner's attention.

This is a fresh route on the active roadmap; UNCLEAR is the expected verdict.

## Out of scope

- `nonempty_jacobianWitness` via Route A (Picard scheme / FGA) or Route B
  (symmetric powers + Stein) — the M3 milestone. Multi-month roadmap; no
  prover lane this iter; not under active churn-detection scrutiny.
- Polish-stage backlog items (dead `IsAffineHModuleHomFinite` chain, redundant
  typeclass args on `Rigidity.eq_of_eqOnOpen`, dormant `HasCechToHModuleIso`
  scaffolding class) — these are deprioritized under the iter-121 pivot.
  The Mathlib-contributor framing makes them low-value compared to filling
  the actual gaps. Not relevant to this iter's progress assessment.

## Note on the strategic pivot

This iter introduces a major strategic shift (per user directive: act as
Mathlib contributor; no deferred Mathlib gaps). Two previously-deferred
routes (the bridge; genus-0 witness) become active in the roadmap. They
are FRESH routes for the purpose of convergence assessment. Please
provide UNCLEAR verdicts and name the watch criteria for iter-122 / iter-123
to resolve.
