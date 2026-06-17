# Progress-critic directive — iter-063

Assess convergence per route. Two active routes. K=5 window. For each, decide
CONVERGING / CHURNING / STUCK / UNCLEAR and name the corrective type if not CONVERGING.

## Route A — CSI Sub-brick A Stub 2 — `CechSectionIdentification.lean`

Phase: P5a-resolution (entered ~iter-056). STRATEGY estimate: `Iters left ~3–5`.

Signals (last 5 iters; sorry = sorries IN THIS FILE):
- iter-058: sorry 5; +built Stub-1 distributivity bricks (prodFinSuccIso, overProd helpers). status PARTIAL.
- iter-059: sorry 5; +universe-reduction bricks for Stub 1. status PARTIAL.
- iter-060: sorry 5→4; **Stub 1 `cechBackbone_left_sigma` CLOSED** (universe reduction). status PARTIAL-with-closure.
- iter-061: sorry 4→4; +3 decls (L1 `isIso_modules_of_toPresheaf` CLOSED + 2 prep helpers). L2 blocked. status PARTIAL.
- iter-062: sorry 4→4; +2 decls (`isIso_coprodDecompMap` the claimed-only-leaf + `isIso_map_prodLift_of_isLimit`). status PARTIAL.
- Recurring blocker phrase: "L2 `pushPull_binary_coprod_prod` blocked." NEW finding iter-062: the iter-061
  readiness claim was WRONG — L2 is NOT the single leaf, it is a ~200–300 LOC `q_*`-coherence assembly
  (per-leg coherence ★ + chain iso + induction + specialization). The iter-062 prover worked out the
  COMPLETE reduction and confirmed every required Mathlib lemma exists; left it unbuilt (would need sorry).

## Route B — OpenImm `hqc`/`_comp` — `OpenImmersionPushforward.lean`

Phase: P5a-consumer (entered ~iter-054). STRATEGY estimate: `Iters left ~3–5`, status OVER_BUDGET.

Signals (last 5 iters; sorry = sorries IN THIS FILE):
- iter-058: sorry 3; +Stub-1-adjacent backbone work. status PARTIAL.
- iter-059: sorry 3→2; homological-half + `hjt` progress. status PARTIAL-with-closure.
- iter-060: sorry 2; `hjt` CLOSED via `jShriekOU_transport_along_iso`. status PARTIAL.
- iter-061: sorry 2→2; +2 decls (`coversTop_preimage_of_iso`, `pushforward_iso_qcoh_of_slice_qcoh`); `hqc` reduced to per-slice. status PARTIAL.
- iter-062: sorry 2→2; +6 decls (entire `ψ_r` slice-structure-sheaf infra: `sliceStructureSheafHom` + 4 instances). The "genuine ~100–150 LOC Mathlib wall" CLEARED. status PARTIAL.
- Recurring blocker phrase: residual narrowed each iter (core → homological-half → `hjt` → `hqc` → ψ_r → `pushforwardSlicePullbackIso`). NEW finding iter-062: the blueprint proof of the now-lone residual
  `pushforwardSlicePullbackIso` is mathematically WRONG (handles only the unit module, not general H); the
  prover identified the correct `leftAdjointUniq` route in-file but it requires a blueprint rewrite.

## This-iter PROGRESS.md objective proposal (for dispatch-sanity check)

2 lanes (file count = 2), both `mathlib-build`:
1. `CechSectionIdentification.lean` — build the L2 q_*-coherence chain (`pushPull_binary_coprod_prod` →
   `pushPull_coprod_prod` → close Stub 2 `pushPull_sigma_iso`), recipe = in-file reduction + blueprint.
2. `OpenImmersionPushforward.lean` — build `pushforwardSlicePullbackIso` (leftAdjointUniq route, AFTER
   blueprint rewrite this iter) → `pushforward_iso_preserves_qcoh` → close `hqc`.

Planner's intended corrective BEFORE dispatch: a blueprint-writer pass this iter to (a) rewrite the WRONG
`pushforward_slice_pullback_iso` proof to the leftAdjointUniq route + decompose, (b) effort-break/expand
the CSI L2 node into named sub-lemmas reflecting the prover's q_*-coherence reduction, then a fast-path
scoped blueprint-reviewer to clear the HARD GATE before the provers run.

## Question for you
For each route: is the planner walking into the same wall (bare re-dispatch), or is the blueprint-fix +
build-the-fully-specified-assembly the right structural action this iter? Name the corrective type if
CHURNING/STUCK, and whether the planner's intended pre-dispatch corrective matches it.
