# Recommendations for iter-002 (from review of iter-001)

iter-001 was a **planning-only / no-prover** iteration: a strategy pivot (two spectral
sequences → acyclic-resolution route, Stacks 015E) plus a full blueprint rewrite. No proof
progress to extrapolate from, so there are no "promising-approach" or "do-not-retry" prover
findings. The recommendations below are structural readiness items the planner must clear
before provers can fan out.

## HIGH — scaffold the new file at the exact covers path
- The doctor flags `Cohomology_AcyclicResolution.tex` covers
  `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`, which **does not exist**. Have the
  scaffolder create that file at exactly that path (matching the `% archon:covers` line) so the
  dispatch gate routes to the right chapter. Until the file exists the doctor will keep flagging
  it and the chapter cannot gate any prover lane.

## HIGH — scaffold the frontier, then clear the HARD GATE before any prover
- Four frontier `\lean{}` targets have **no Lean declaration yet** (verified absent in
  `AlgebraicJacobian/`): `IsRightAcyclic`, `pushPullMap_comp`, `cech_eq_cohomology_of_basis`,
  `cechAugmented_exact`. They must be scaffolded (sorry bodies) so `unmatched`/frontier become
  honest, then the mandatory blueprint-reviewer must re-confirm the rewritten chapters
  (`Cohomology_AcyclicResolution.tex`, `Cohomology_CechHigherDirectImage.tex`) as
  `complete: true ∧ correct: true` before any `.lean` file enters objectives. The plan agent
  already scheduled exactly this sequence (D1/D4) — confirm the gate clears before dispatching.

## MEDIUM — 1-to-1 coverage debt: 4 unmatched `lean_aux` push-pull helpers
`archon dag-query unmatched` reports 4 prover-era helpers in
`AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean` with **no blueprint entry** (all
proved, no sorry, mathlib_ok=false). The planner (not the review agent) should author the
informal blueprint entries so the dependency graph sees them:
- `AlgebraicGeometry.rawPushPullMap` — the raw (un-normalized) push-pull comparison map.
- `AlgebraicGeometry.pushPullMap_eq_raw` — identifies the normalized `pushPullMap` with `rawPushPullMap`.
- `AlgebraicGeometry.pushPull_unit_comp` — a unit-compatibility lemma for the push-pull adjunction.
- `AlgebraicGeometry.pushforwardComp_hom_app_id` — pushforward-of-composite hom application at the identity.

(Read each declaration's signature in the source for the exact statement.) The plan agent's own
carry-forward note already flags this: "the 4 `lean_aux` push–pull helpers still need blueprint
entries once `pushPullMap_comp` closes." Doing it earlier keeps the graph honest for the
`pushPullMap_comp` frontier node.

## Watch — mate-calculus path for `pushPullMap_comp`
When `pushPullMap_comp` is scaffolded and proved, ensure it follows the
`CategoryTheory.conjugateEquiv_comp` mate route (`analogies/pushpull-functoriality.md`), NOT the
old pushforward-side `erw` grind that triggered the documented kernel `whnf` explosion. This is
recorded as a known blocker to avoid re-hitting.

## Carry-forward retrieval (from plan.md)
- Retrieve Stacks `cohomology.tex` for the standalone statement of
  `cohomology-lemma-cech-vanish-basis` before scaffolding `cech_eq_cohomology_of_basis`.

## Blocked / do-not-retry
- None. No prover attempts were made this iter, so nothing is in a repeated-blocker state.
