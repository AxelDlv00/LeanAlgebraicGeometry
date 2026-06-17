# Progress-critic directive — iter-016 convergence audit

Assess per-route convergence from the trajectory signals below. Two active prover routes.
Note: iters 012–014 had NO real prover phase (dag/interrupted), and the iter-011 prover phase
was killed mid-run by an external weekly-API limit (not a feasibility signal). So the only
genuine prover-trajectory data point per route so far is **iter-015**.

## Route P3 — `AlgebraicJacobian/Cohomology/CechAcyclic.lean` (target: close `CechAcyclic.affine` sorry)
- Strategy `Iters left`: ~3–5. Entered current phase: ~iter-011.
- iter-011: lane dispatched (mathlib-build); **externally killed at turn 12** (weekly API limit). 0 declarations landed.
- iter-012/013/014: no prover phase (dag / interrupted).
- iter-015: lane ran to completion. **+9 axiom-clean private declarations** (the L3 combinatorial
  contracting homotopy: `combDifferential`, `combHomotopy`, `combHomotopy_spec` (`d∘h+h∘d=id`),
  `combDifferential_comp` (`d²=0`), `combDifferential_exact` (`Function.Exact`), + 4 helpers).
  Target sorry count: 1 → 1 (UNCHANGED). Status: PARTIAL.
  Recurring blocker phrase: "blocked on **L1** (categorical→module bridge identifying abstract
  `CechComplex` with concrete `∏_σ M_{s_σ}`) + dependent-coefficient port of L3."
- Planner's iter-016 proposal for this file: **NO prover dispatch** — instead a blueprint-writer
  fills the L1 gap this iter (blueprint was silent on L1); P3 prover deferred to next iter.

## Route P3b — `AlgebraicJacobian/Cohomology/PresheafCech.lean` (build presheaf-Čech bridge bottom-up)
- Strategy `Iters left`: ~6–9. Entered current phase: ~iter-011.
- iter-011: lane dispatched (mathlib-build); **externally killed** (weekly API limit). 0 declarations landed.
- iter-012/013/014: no prover phase.
- iter-015: lane ran to completion. **+2 axiom-clean declarations** (`injective_toPresheafOfModules`,
  `freeYonedaHomEquiv`); 3 of 5 planned bricks blocked (each a large category-theory construction,
  precise recipes handed off). sorry count 0 → 0 (build-new lane). Status: PARTIAL.
  No recurring blocker phrase yet (first real attempt).

## Planner's iter-016 `## Current Objectives` proposal (file count + basenames)
2 prover lanes (P3b split into two parallel files per the standing parallelism directive):
1. `PresheafCech.lean` — build `sectionCechComplex` (section/cosimplicial complex). [mathlib-build]
2. `FreePresheafComplex.lean` (NEW file, scaffolded this iter) — build `cechFreePresheafComplex` +
   `cechFreeComplex_quasiIso` (free complex + its quasi-iso). [mathlib-build]
(P3 `CechAcyclic.lean` not dispatched this iter — blueprint-writer fills L1 first.)

## Question
Per route: CONVERGING / CHURNING / STUCK / UNCLEAR? In particular: is splitting P3b into two
parallel files a sound move, or does the single real data point (iter-015 = first genuine attempt
after external kills) make any "churning" read premature? Flag if you see helper-accretion without
residual progress, but weigh that only iter-015 is real trajectory data.
