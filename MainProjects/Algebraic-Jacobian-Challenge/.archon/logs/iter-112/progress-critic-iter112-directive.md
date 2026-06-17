# Progress Critic Directive

## Slug
iter112

## Iter
112

## Active routes / files under review

### Route: AlgebraicJacobian/Differentials.lean (Phase B opening, L122 candidate)

- **Started at iter**: 110 (blueprint expansion iter)
- **Iters audited**: 109–111

#### Sorry counts per iter (project total, file detail)

- iter-109: 16 total / Differentials 5 (L122, L636, L718, L735, L877)
- iter-110: 16 total / Differentials 5 (unchanged; deeper-think iter, no prover)
- iter-111: 16 total / Differentials 5 (unchanged; deeper-think iter, blueprint writer only)

#### Helpers added per iter
- iter-109: 0 (Differentials.lean untouched)
- iter-110: 0 (Differentials.lean untouched; blueprint writer expanded Differentials.tex)
- iter-111: 0 (Differentials.lean untouched; blueprint writer rewrote `\thm:relative_kaehler_isSheaf` proof block of Differentials.tex)

#### Prover statuses per iter
- iter-109: N/A (file not assigned; LineBundle.lean was the prover target)
- iter-110: N/A (no prover dispatched; deeper-think iter)
- iter-111: N/A (no prover dispatched; deeper-think iter, blueprint-writer only)

#### Recurring blocker phrases
- None for this file (no prover work).
- iter-110 mathlib-analogist-serre-duality reclassified L877 as named-gap #7 (out of scope).
- iter-111 blueprint-writer-iter111 flagged basis-to-opens descent for `Scheme.PresheafOfModules` as honest `[gap]` (no off-the-shelf Mathlib lemma; two prover-side construction routes documented: Route (a) refinement-cofinality vs `isSheafOpensLeCover`, Route (b) explicit gluing via `Modules.tilde`).

#### Planner's current proposal for this iter
Dispatch single Phase B prover lane on `Differentials.lean` targeting L122 `relativeDifferentialsPresheaf_isSheaf`. Blueprint coverage adequate (chapter rewritten iter-111 with all Mathlib names `[verified]` + 1 honest `[gap]` documenting both construction routes). LOC budget revised upward iter-111 to ~100–200 LOC / ~2-3 iters due to basis-to-opens descent. Iter-112 prover should follow the Lean stub at L113-122 (already contemplates Route (a)).

### Route: AlgebraicJacobian/Cohomology/BasicOpenCech.lean (STUCK RATIFIED OFF-LIMITS)

- **Started at iter**: ~97 (long-running route, paused iter-108)
- **Iters audited**: 109–111

#### Sorry counts per iter
- iter-109: 6 (unchanged from iter-108)
- iter-110: 6 (unchanged)
- iter-111: 6 (unchanged)

#### Helpers added per iter
- iter-109/110/111: 0 (file untouched; OFF-LIMITS since iter-108 Option (i) escape-valve)

#### Prover statuses per iter
- iter-109/110/111: N/A (no prover dispatched)

#### Recurring blocker phrases
- "PARTIAL on L1846 Step 1c" — iter-106, iter-107, iter-108 reports (RESOLVED iter-108 via Option (i) budget-deferral annotation).

#### Planner's current proposal for this iter
**Continue OFF-LIMITS.** No prover work on this file. Phase A deferred-gated per STRATEGY.md.

### Route: AlgebraicJacobian/Picard/LineBundle.lean (STUCK external-Mathlib-dep RATIFIED OFF-LIMITS)

- **Started at iter**: 109 (C1 promotion landed iter-109)
- **Iters audited**: 109–111

#### Sorry counts per iter
- iter-109: 2 (post-C1: L82 pullback_tensorObj, L96 pullback_oneIso)
- iter-110: 2 (unchanged)
- iter-111: 2 (unchanged)

#### Helpers added per iter
- iter-109: +1 helper `pullback_oneIso` (sister gap split from `pullback_tensorObj` during C1 promotion)
- iter-110/111: 0 (untouched)

#### Prover statuses per iter
- iter-109: COMPLETE (C1 promotion landed 3 transient sorries; 1 sister-gap helper added)
- iter-110/111: N/A (OFF-LIMITS)

#### Recurring blocker phrases
- Both L82 / L96 named Mathlib gaps #5/#6; collapse together when Mathlib lands `(SheafOfModules.pullback _).Monoidal`. External-dep bounded; no project-side action possible.

#### Planner's current proposal for this iter
**Continue OFF-LIMITS.** No prover work on this file.

## Out of scope

- Modules/Monoidal.lean L173 (named gap #1, load-bearing post-C1).
- Differentials.lean L636 (named gap #2, parallel to instIsMonoidal_W).
- Differentials.lean L877 (named gap #7, Serre duality).
- Jacobian.lean L179 (named gap #3, C3-deferred).
- Picard/Functor.lean L181 (named gap #4, C3-deferred).
