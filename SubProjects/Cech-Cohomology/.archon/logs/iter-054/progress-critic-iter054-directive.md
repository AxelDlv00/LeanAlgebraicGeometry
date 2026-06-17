# Progress-critic directive — iter-054

Assess convergence of the two ACTIVE prover routes below. Verdict per route
(CONVERGING / CHURNING / STUCK / UNCLEAR) + named corrective for any CHURNING/STUCK.

## Route 1 — `AlgebraicJacobian/Cohomology/CechAugmentedResolution.lean` (target `cechAugmented_exact`)
Strategy phase: P5a-resolution. Strategy `Iters left` estimate: ~1–2. Entered phase: iter-052/053.
Signals (per iter):
- iter-053: file SCAFFOLDED (1 stub sorry); then FIRST real prover pass same iter. Result PARTIAL-strong:
  whole-theorem sorry collapsed to ONE crisp residual (`IsZero` of the F-valued augmented Čech *section*
  complex homology over `V ≤ coverOpen i`); +2 axiom-clean reusable helpers added
  (`isZero_of_faithful_preservesZeroMorphisms`, `isZero_presheafToSheaf_of_locally_isZero`).
  sorry count 1→1 (residual moved, not closed). Blocker phrase: "F-valued objectwise prepend-i_fix
  contracting homotopy on the section complex + categorical↔combinatorial (mapHomologicalComplex↔depDiff)
  identification — the same bridge that keeps CechAcyclic.affine open, but at the easier section level."
- (no earlier prover data — fresh route, 1 iter.)
This iter's proposal: re-dispatch this file (mathlib-build) to build the F-valued prepend homotopy + close
the residual, AFTER expanding the blueprint Step 3/4 to name the Lean comparison/contractibility mechanism.

## Route 2 — `AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean` (targets `_acyclic`, `_comp`)
Strategy phase: P5a-consumer. Strategy `Iters left` estimate: ~2–3. Entered phase: iter-053.
Signals (per iter):
- iter-053: file SCAFFOLDED (2 stub sorries); then FIRST real prover pass same iter. Result PARTIAL:
  +1 axiom-clean private (`isAffineHom_of_affine_separated`); both top theorems reduced from bare sorry to
  real partial reductions, both bottoming out on the SAME 3 unbuilt bridges. sorry 2→2 (not closed).
  Blocker phrase: "bridge (1) cohomology-presheaf identification = the upstream-deferred hand-off in
  HigherDirectImagePresheaf.lean; gates Part 1, Part 2, and likely cechTerm_pushforward_acyclic."
- (no earlier prover data — fresh route, 1 iter.)
This iter's proposal: re-dispatch this file (mathlib-build) re-scoped to build bridge (1) FIRST (the
cohomology-presheaf identification) + the Serre-transport + PresheafOfModules.sheafification site lemma,
AFTER blueprint expansion naming the 3 bridges; also re-sign `_comp` to canonical `A ≅ B`.

## This iter's `## Current Objectives` proposal (file count + basenames)
2 files: `CechAugmentedResolution.lean`, `OpenImmersionPushforward.lean` (both mathlib-build).

## Question for you
Both routes are 1 iter of real prover data (fresh). Is "re-dispatch the same two files with expanded
blueprint" the right move, or is either route showing an early churn/stuck signal (e.g. the shared
deep categorical↔combinatorial bridge being a multi-iter wall that should be attacked as its own
foundational lane rather than inside the top theorems)? Name the corrective if so.
