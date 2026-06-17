# Progress-critic directive — iter-074

## Active route: Sub-brick A section identification (P5a-resolution input)

Single active route. Now spread across 3 files after an iter-074 build-wall split
(was one 2475-LOC monolith `CechSectionIdentification.lean`):
- `CechSectionIdentificationBase.lean` (1486 LOC, **0 sorries** — the proved shared engine)
- `CechSectionIdentificationLeg.lean` (273 LOC, **1 sorry**: `coreIso_comm_leg` @68)
- `CechSectionIdentification.lean` (764 LOC, **1 sorry**: `sectionCechAugV_π` @370)

Both residual sorries are atomic geometric leaves; both unwind through the already-PROVED
seams `pushPull_sigma_iso_π` + `pushPull_leg_sections`. Blueprint complete + gate-passed (iter073).

## Last 5 iters' signals (this route)

- iter-069..071: infrastructure OUTAGES (planners ended before awaiting prover waves; provers
  killed/errored). ZERO route signal — not route data.
- iter-072: sorry 2→2 (FLAT count) but REAL structural progress — PROVED the whole `coreIso_comm`
  chain (`_coface`/`_sum`/`coreIso_comm`) + fully ASSEMBLED Stub-6 `cechSection_contractible`
  (dependent engine + (I0)/(I1)/(In) + mkCoinductive). Residual narrowed from composite goals to 2
  atomic leaves. Prover killed mid-final-verify (exit 144). Helpers added: many (the chain). Status: real progress, no task_results.
- iter-073: sorry 2→2 (FLAT). Prover landed **0 edits** — every `lake build`/`lake env lean`
  verification OOM/timeout-killed (exit 137/144; bg lean >6min). NOT math/route blocked; the 2475-LOC
  monolith no longer fits available memory. Helpers added: 0. Status: INCOMPLETE (tooling).
- iter-074 (this iter, plan): build-wall corrective EXECUTED — refactor split the monolith into the 3
  files above (each leaf now in a small isolated module). About to dispatch 2 PARALLEL prover lanes
  (Leg + CSI), one per leaf.

Recurring blocker phrase: iter-073 = "OOM/timeout-killed", "0 edits", "build environment not math".
iter-072 = "killed mid-verify".

## Strategy estimate (from STRATEGY.md P5a row)
- Iters left: ~1–3. Phase status: ACTIVE (OVER_BUDGET) — entered ~iter-056; ~15 informative iters
  elapsed (iters 068–071 were infrastructure outages with zero route signal).

## This iter's PROGRESS.md `## Current Objectives` proposal (2 parallel lanes)
1. `CechSectionIdentificationLeg.lean` — close `coreIso_comm_leg` (@68). 273 LOC.
2. `CechSectionIdentification.lean` — close `sectionCechAugV_π` (@370). 764 LOC.

## Question
Is this route CONVERGING, CHURNING, or STUCK? The count has been flat 2→2 for two iters (the
two-flat-iter watch-flag). Is the build-wall split the right corrective, or is the flat count a
sign of route-level churn that splitting won't address? Render a verdict and (if CHURNING/STUCK)
name the corrective TYPE.
