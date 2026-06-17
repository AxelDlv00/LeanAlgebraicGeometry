# Progress Critic Directive

## Slug
iter122

## Iter
122

## Active routes / files under review

### Route: M1 — Bridge (presheaf ↔ algebra-Kähler on affine chart)

- **Started at iter**: 121 (iter-120 closed `smooth_locally_free_omega`
  via signature refactor, eliminating the prior bridge dependency).
  Iter-121 declared M1 as a milestone and landed blueprint prose.
- **Iters audited**: iter-117 through iter-121.

#### Sorry counts per iter (project total)
- iter-117: 2 (1 in `Differentials.lean`, 1 in `Jacobian.lean`)
- iter-118: 2 (same distribution; refactor moved `Differentials.lean`
  signature, sorry relocated)
- iter-119: 2 (PARTIAL on `Differentials.lean`; sorry relocated within
  same file from L93 to L136 inside a structured cascade)
- iter-120: 1 (closure of `smooth_locally_free_omega` via M1-eliminating
  signature refactor; `Differentials.lean` 1 → 0)
- iter-121: 1 (no prover dispatch; deferred per HARD GATE)

#### Helpers added per iter
- iter-117: 0 directly in Differentials.lean / Jacobian.lean (other
  files: scaffolding work in MayerVietorisCover / SheafCompose).
- iter-118: 0 (signature refactor only on `smooth_locally_free_omega`).
- iter-119: ~45 LOC of new body content inside `smooth_locally_free_omega`
  (Steps 1-5 of verified Mathlib chain); 1 new sorry inserted at L136
  in structurally minimal cascade.
- iter-120: 0 new helpers; 11-LOC closure body, no helper declarations
  added. Sorry trajectory `Differentials.lean` 1 → 0.
- iter-121: 0 (no prover dispatch); plan-agent inline blueprint
  rewrites + 2 blueprint-writer dispatches.

#### Prover statuses per iter
- iter-117: N/A (`Differentials.lean` not active prover lane that iter).
- iter-118: COMPLETE on `Differentials.lean` (signature refactor closed).
- iter-119: PARTIAL on `Differentials.lean` (bridge gap identified; sorry
  relocated; ~45 LOC structural advance).
- iter-120: COMPLETE on `Differentials.lean` (`smooth_locally_free_omega`
  closed via signature refactor + 11-LOC body).
- iter-121: NO_PROVER (intentional skip per HARD GATE; blueprint-writer
  passes dispatched instead).

#### Recurring blocker phrases
- "colimit ring `A_colim` is strictly larger than `Γ(S, U)` in general"
  — first surfaced as a mathematical defect in iter-119 PARTIAL report;
  iter-120 fully addressed via signature refactor (Option (iii) per
  iter-120 strategy-critic).
- "Mathlib bridge gap" — appeared iter-119 as the iter-118 false-claim
  defect; resolved iter-120 by signature refactor; re-surfaced iter-121
  as a milestone (M1) in the new "no-deferred-tasks" pivot.

No recurring blockers across iter-120/121 (one-iter window of no-prover
in iter-121 by design).

#### Planner's current proposal for this iter (M1)

The iter-122 planner proposes:

1. Dispatch the refactor subagent to introduce three new declarations
   in `AlgebraicJacobian/Differentials.lean` with `sorry` bodies (the
   bridge `relativeDifferentialsPresheaf_equiv_kaehler_appLE`, the
   auxiliary `IsAffineOpen.appLE_isLocalization`, and the
   `Scheme.kaehler_localization_subsingleton` re-export). Sorry trajectory
   will go 1 → 3 or 1 → 4 (intentional milestone-opening, not regression).

2. Dispatch a prover lane on `AlgebraicJacobian/Differentials.lean`
   targeting **M1.a** as the first concrete sub-step: the submonoid
   `M := {g ∈ A : appLE(g) ∈ B^×}` (the smallest sub-step, ~30 LOC,
   1 iter estimate). M1.b is the larger 2-3 iter / 100-250 LOC piece
   (the cofinality-via-`IsLocalization.of_le` construction). Per
   progress-critic-iter121 watch criterion 4 ("lock in M1.a vs M1.b
   in iter-122's plan"), M1.a is chosen as the entry point.

3. The iter-122 plan agent has applied inline blueprint corrections
   incorporating the iter-121 mathlib-analogist findings:
   `_iso_` → `_equiv_` rename, `Scheme.appLE_isLocalization` →
   `IsAffineOpen.appLE_isLocalization` namespace fix, M1.c framing
   correction (not a Mathlib gap), M1.b cofinality re-framing (use
   `IsLocalization.of_le` not `Functor.Final`).

### Route: M2 — Genus-0 witness (NOT active this iter)

- **Started at iter**: 121 (strategy-level only; no Lean material).
- **Status**: blocked behind M1.
- **Planner's proposal for this iter**: defer.

### Route: M3 — Positive-genus witness (NOT active this iter)

- **Started at iter**: 121 (strategy-level only; no route-pick yet).
- **Status**: blocked behind M1 and route-pick decision.
- **Planner's proposal for this iter**: defer.

## Out of scope

- All Cohomology files (SheafCompose.lean, StructureSheafAb.lean,
  StructureSheafModuleK.lean, MayerVietorisCore.lean,
  MayerVietorisCover.lean) — not active prover lanes this iter; flagged
  scaffolding/dead-chain issues are documented in
  `iter/iter-121/review.md` and the `task_results/lean-auditor-review121.md`.
- `Genus.lean`, `Rigidity.lean`, `AbelJacobi.lean` — closed; not active
  prover lanes.
- `Jacobian.lean:179` `nonempty_jacobianWitness` — the project's
  single foundational existence claim; queued behind M1/M2/M3 per
  the genus-stratified body restructure plan in STRATEGY.md.
