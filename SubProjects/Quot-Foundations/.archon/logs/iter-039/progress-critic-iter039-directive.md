# Progress critic — iter-039

Fresh-context convergence audit of the two active prover routes the planner is about to dispatch.
Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) + the corrective TYPE for any
CHURNING/STUCK. Use ONLY the signals below; do not read STRATEGY/PROGRESS/blueprint.

## Route FBC — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

Target: close the affine base-change iso `IsIso pushforwardBaseChangeMap`, which bottoms at
`gstar_transpose`, which reduces to the inner reindex `_legs_conj`
(`base_change_mate_fstar_reindex_legs_conj`, sorry @1700).

Phase entered: ~iter-034 (FBC-A1). Strategy `Iters left` estimate: 1–3.

Signals (last 5 iters):
- iter-035: pivot to element-`ext` route, then REVERTED same iter. sorry 4→4. helpers +0 net.
- iter-036: landed step (b) `base_change_mate_extendScalars_inner_value_counit` (axiom-clean). sorry 4→4. helpers +1.
- iter-037: "clean assembly pass" closed nothing; NO code edits; tripwire fired. sorry 4→4. helpers +0.
- iter-038: NO FBC prover — plan-cycle mathlib-analogist (cross-domain) returned KEEP (route is
  irreducible mate coherence; no module-level/geometric bypass; the proof-free conjugate read is
  already built). sorry 4 untouched.
- iter-039 (PROPOSED): fine-grained prover. Build the two frontier standalone lemmas conj-2b
  `reindex_conj_pullbackLeg` + conj-2d `reindex_conj_crossLayer` (neither exists in Lean yet —
  these are NEW atomic decls, not re-attempts), then attempt the single-`conjugateEquiv`-component
  reframing that discharges `_legs_conj`. The reframing is the heaviest node.
- Recurring blocker phrase: "dependent-motive obstruction on `_legs_conj`/step-(a)"; "the conjugate
  reinterpretation of the section composite as a single `conjugateEquiv` component is the heaviest
  remaining step."

Question for you: is dispatching the iter-039 fine-grained round (build 2 NEW frontier atoms +
attempt the reframing) genuine new work, or a reworded re-run of the iter-037 assembly pass that
closed nothing? Note iter-038's progress-critic already endorsed this exact iter-039 action
(prover on conj-2b/2d, NOT another consult).

## Route QUOT — `AlgebraicJacobian/Picard/QuotScheme.lean`

Target: close gap1 — build `isLocalizedModule_basicOpen_descent` (the Hfr assembly keystone) then
the one-line `isIso_fromTildeΓ_of_isQuasicoherent`.

Phase entered: QUOT-defs gap1 sub-build (long-running). Strategy `Iters left`: 3–6.

Signals (last 5 iters):
- iter-034: gap1 P1 COMPLETE (+7 axiom-clean; `isIso_fromTildeΓ_restrict_basicOpen`).
- iter-036: `gammaPullbackTopIso` + image variant + naturality (+3 axiom-clean).
- iter-037: bridges (I) `isLocalizedModule_of_ringEquiv_semilinear` + (II)
  `isLocalizedModule_restrictScalars_powers_algebraMap` (+2 axiom-clean).
- iter-038: semilinearity wall — `gammaImageRingEquiv` (σ_V) + `gammaPullbackImageIso_hom_semilinear`
  (+2 axiom-clean). Handed off a precise 6-step Hfr assembly decomposition.
- iter-039 (PROPOSED): mathlib-build — assemble Hfr from the now-DONE ingredients → named descent →
  gap1. Critical path = "step 1" (slice presentation ↔ scheme-pullback `IsIso fromTildeΓ` transport),
  flagged by the iter-038 prover as possibly Mathlib-absent (though the blueprint treats it as an
  application of the DONE `isIso_fromTildeΓ_basicOpen_of_quasicoherent`).
- Each iter added 2–7 axiom-clean decls toward gap1; the residual chain has shrunk to the final
  assembly.

Question for you: is QUOT converging (residual shrinking each iter, ingredients landing) or churning
(helpers multiply, gap1 never closes)?

Write your report to `task_results/progress-critic-iter039.md`.
