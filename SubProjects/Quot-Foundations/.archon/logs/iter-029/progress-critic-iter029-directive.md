# Progress-critic directive — iter-029

Assess convergence per active prover route. K=4 prover rounds (note: odd iters were
dag/plan-only; the prover rounds are iter-024 parent, iter-026, iter-028).

## Route FBC — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

Target: the i=0 base-change map iso (Seam-3 `gstar_transpose` chain). The whole chain now
reduces to ONE root telescoping (`base_change_mate_fstar_reindex_legs`, step iii) plus the
`gstar_transpose` assembly — both blocked by the SAME `X.Modules` instance diamond.

Signals (sorry count / helpers added / status / blocker phrase):
- parent iters 018–024: FBC-A churned — PARTIAL×4, OVER_BUDGET (entered phase iter-018, est 2–4 iters).
- iter-026 prover: 5→5 sorry. Helper: `erw`-unlock of the `_legs` unit expansion (broke the
  4-iter "literal-form lock"). Status PARTIAL. Blocker: "literal-form lock" (resolved via erw).
- iter-028 prover: 5→4 sorry. Closed `inner_value_eq` via one-line cascade onto `fstar_reindex`.
  Root crux `_legs` PARTIAL. Helper: a proven `hpfc` term (now dead). Status PARTIAL.
  Blocker phrase: "`X.Modules` instance diamond — composed-⋙ vs nested-obj domains; `rw`/`simp`
  no-match, `erw` whnf-timeout at 4M heartbeats." Same diamond also blocks `gstar_transpose`.

Strategy: FBC-A `Iters left` = 2–4; entered its current phase at iter-018 (≥10 iters elapsed).

This-iter proposal: do NOT re-dispatch FBC with a reworded recipe. The iter-028 tripwire named a
mathlib-analogist consult as the corrective; I am executing it this iter (cross-domain consult on a
diamond-robust term-mode mechanism, seeded with the GR lane's WORKING recipe for the same diamond
class — `erw` + `exact congrArg (_ ≫ ·)` + `Iso.inv_comp_eq`, defeq-inside-`exact`). I then plan to
dispatch FBC with that genuinely-new term-mode mechanism (not the old rw/simp/erw recipe). Tell me if
this still reads as churning.

## Route QUOT (G1-core) — `AlgebraicJacobian/Picard/QuotScheme.lean`

Target: G1-core `isLocalizedModule_basicOpen_of_isQuasicoherent` (Stacks 01HA). mathlib-build mode.

Signals:
- iter-026 prover: 4→4 sorry, +5 axiom-clean glue decls (`G1-core ⟹ gap1 ⟹ keystone` glue). Status PROGRESS.
- iter-028 prover: 4→4 sorry, +2 axiom-clean decls. Established G1-core ≡ gap1 ≡ ONE lemma
  `isIso_fromTildeΓ_of_isQuasicoherent` (the QCoh(Spec R)≃Mod R essential-image gap). Verified by
  source-grep that Mathlib has NO bridge. Handed off a named sub-build:
  `exists_isIso_fromTildeΓ_basicOpen_cover` (finite basic-open tilde cover from QuasicoherentData) +
  Mayer–Vietoris induction. Status PROGRESS (gap narrowing each iter).

Strategy: QUOT-defs / GF-geo `Iters left` = 4–7 / 2–4; G1-core sub-phase entered ~iter-026.

This-iter proposal: dispatch QUOT prover (mathlib-build) at the handed-off Step-1 sub-build
`exists_isIso_fromTildeΓ_basicOpen_cover`, then the induction. Is this a converging port or churn?

## Route GR (glue) — `AlgebraicJacobian/Picard/GrassmannianCells.lean`

Target: `Grassmannian.scheme` via `Scheme.GlueData`. mathlib-build mode.

Signals:
- iter-026 prover: 0→0 sorry, +11 axiom-clean decls (7 easy GlueData fields + `awayPullbackIso` + legs +
  `awayMulCommEquiv`). Status PROGRESS.
- iter-028 prover: 0→0 sorry, +4 axiom-clean decls (`t'`, `t_fac`, ring identity, helper). `cocycle`
  reduced to a ring identity `Φ = RingHom.id` (rotated `cocycleCondition`), ~30–50 LOC, concrete recipe
  handed off; then `theGlueData` + `.glued`. Status PROGRESS.

Strategy: QUOT-repr `Iters left` = 6–12; GR-glue sub-phase entered ~iter-026 (2 prover rounds).

This-iter proposal: dispatch GR prover (mathlib-build) to close `cocycle` (ring identity) + `theGlueData`
+ `Grassmannian.scheme`. Converging?

## This iter's `## Current Objectives` proposal (file count + basenames)

3 files (one prover each, import-independent):
1. `FlatBaseChange.lean` (FBC — term-mode diamond mechanism from the analogist consult)
2. `QuotScheme.lean` (QUOT — Step-1 sub-build `exists_isIso_fromTildeΓ_basicOpen_cover`)
3. `GrassmannianCells.lean` (GR — cocycle ring identity + glue assembly)

Give per-route verdicts (CONVERGING/CHURNING/STUCK/UNCLEAR), name the corrective TYPE for any
CHURNING/STUCK, and run the dispatch-sanity check on the 3-file proposal.
