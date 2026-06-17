# Progress Critic — iter-009

Fresh-context convergence audit. Assess the single active route below. Your question is
convergence (is this route closing, or churning/stuck?), NOT strategic soundness or math
correctness.

## Active route: P4 — abstract acyclic-resolution comparison theorem

- **File**: `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`
- **Mode**: `mathlib-build` (builds axiom-clean Mathlib-style infrastructure bottom-up;
  the file has **0 sorry by construction** — the convergence metric is NOT sorry count
  but *named-target closure* against a fixed 5-leaf decomposition of the goal theorem
  `rightDerivedIsoOfAcyclicResolution`).
- **Phase entry**: P4 entered its current phase at iter-004. STRATEGY.md current
  estimate: **~1–2 iters left**.

### Per-iter signals (last 5 iters)

- **iter-004**: built every *consumer* of the horseshoe lemma (dimension-shift engine
  `rightDerivedShiftIsoOfSplitResolutionSES` etc.). Status: PARTIAL (infrastructure).
- **iter-005**: built almost all of the horseshoe core (twisted-biproduct complex, τ
  twist recursion + cocycle). Collapsed the whole P4 chain to ONE precise gap:
  `quasiIso_τ₂`. Status: PARTIAL.
- **iter-006**: built `quasiIso_τ₂` + closed TARGET 1 (horseshoe `ofShortExact`) +
  TARGET 2 (object-level dimension shift `rightDerivedShiftIsoOfAcyclic`, part 1). 14
  new axiom-clean decls. Status: DONE (2/5 named targets closed).
- **iter-007**: built the cosyzygy / applied-cohomology layer — closed 3 of the 5
  TARGET-3 leaves (`cosyzygyShortExact`, `gCosyzygyIsoCocycles`,
  `cohomologyAppliedResolutionIso`). 11 new axiom-clean decls. Status: DONE (partial —
  declined the last 2 leaves at a clean cut with a precise indexing-checked recipe).
- **iter-008**: DAG re-sync stage (no prover phase — no new trajectory data).

### Remaining work (2 of 5 leaves)

1. `rightDerivedOneIsoCokerOfAcyclic` (`lem:acyclic_one_iso_coker`) — frontier-ready.
   The iter-007 prover handed off a precise recipe: horseshoe-lift the SES, read the
   BOTTOM of the homology LES, identify `H⁰(GI_J)→H⁰(GI_Z)` with `G.map ses.g` via the
   `R⁰G ≅ G` naturality. Sized "comparable to `rightDerivedShiftIsoOfSplitResolutionSES`"
   (which was built successfully).
2. `rightDerivedIsoOfAcyclicResolution` (TARGET 3 assembly) — depends on (1); the
   prover states the assembly is then "a straight-line `Nat.rec` composition of the
   closed leaves."

### Recurring blocker phrases across iters

- "comparable in size to `rightDerivedShiftIsoOfSplitResolutionSES`" (the recurring
  unit of work — and that unit HAS been built before, twice).
- "declined at a clean cut to avoid a non-axiom-clean partial under mathlib-build"
  (the prover stops at a clean boundary each iter and hands off a recipe, rather than
  leaving a broken partial).

### This iter's PROGRESS.md objective proposal (for dispatch-sanity)

- **1 file**: `AlgebraicJacobian/Cohomology/AcyclicResolution.lean` — build the 2
  remaining leaves (`rightDerivedOneIsoCokerOfAcyclic` then
  `rightDerivedIsoOfAcyclicResolution`), `[prover-mode: mathlib-build]`. Expected to
  CLOSE P4.

## Question

Is P4 CONVERGING (steady closure of a fixed decomposition, ~2 leaves from done), or is
it CHURNING (each iter adds helpers but the residual doesn't shrink)? Note the
decomposition is FIXED (5 leaves) and closure has gone 0→2→3→(target 5); helpers are
added in service of closing named leaves, not multiplying around an unmoving target.
Give your verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) with the signals you used.
