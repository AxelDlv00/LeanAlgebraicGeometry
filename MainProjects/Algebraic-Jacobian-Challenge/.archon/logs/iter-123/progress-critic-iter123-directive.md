# Directive: progress-critic-iter123

## Active routes for this iter

### Route M1 — bridge between presheaf and algebra-Kähler forms (Differentials.lean)

**Target file/declaration**: `AlgebraicJacobian/Differentials.lean:282`
`AlgebraicGeometry.IsAffineOpen.appLE_isLocalization` (sorry residual
at L304).

**Status**: PARTIAL on entry to iter-123. The iter-122 prover-phase
closed 3 of 4 sorry sites introduced by the iter-122 plan-phase
refactor + Step 0 of the residual M1.b body.

### Per-iter signals (last 5 iters)

| Iter | Sorry count in `Differentials.lean` | Helpers added (this iter, fully proved) | Prover status | Recurring blocker phrases |
|---|---|---|---|---|
| iter-118 | from 1 (entered) → 2 (4 sorries during iter, ended 2) | bridge scaffolding (Steps 1-4) | PARTIAL | colimit-source bridge gap |
| iter-119 | 2 → 1 | Step 5 attempted; failed on "definitional equality" claim | PARTIAL | Step-5 colimit mismatch (mathematical defect) |
| iter-120 | 1 → 0 | refactor of signature; `smooth_locally_free_omega` closed | COMPLETE | (no blockers — single Edit) |
| iter-121 | 0 → 0 (no prover; strategic pivot iter; HARD GATE deferral) | (no prover) | NO DISPATCH | (HARD GATE deferred) |
| iter-122 | 0 → 4 (refactor introduced) → 1 (prover closed 3) | `appLE_colimRingHom`, `appLE_colimAlgebra`, `appLE_colimRingHom_comp_φV`, `isUnit_appLE_unitSubmonoid_in_colim` (Step 0), `kaehler_localization_subsingleton` (M1.c), `kaehler_quotient_localization_iso` (M1.d), bridge body M1.e closed modulo M1.b | PARTIAL | `rw [Functor.map_comp]` on Lan-defined functors; `rw [Category.assoc]` failures; `change`/`show` on `algebraMap` (workarounds: pre-prove + `erw`, `exact`, route via `IsUnit`) |

### Iter-122 progress-critic verdict

UNCLEAR on M1 (fresh milestone framing; 1 iter of data at iter-122
plan time). Zero CHURNING/STUCK; proceed-but-watch.

### Iter-123 entry status

- **Project sorry count**: 2 (Differentials.lean:304, Jacobian.lean:179
  `nonempty_jacobianWitness` off-limits this iter).
- **Net iter-122 change**: 1 → 2 (one new sorry site remains from the
  M1 scaffolding the planner introduced this iter as intentional
  milestone-opening, per the PARTIAL framing in iter-122 PROGRESS.md).
- **Structural advance**: ~200 LOC of fully-proved declarations
  (top-level helpers + factorisation + bridge body + Step 0 +
  M1.c/M1.d).
- **Decomposition update**: M1.b body decomposes into Steps 1-4 of
  `IsLocalization.of_le`, with Step 0 (each `g ∈ M` is a unit in
  `A_colim`) closed as a named helper.

## What the planner intends to do iter-123

Continue M1.b: dispatch a prover lane on
`AlgebraicJacobian/Differentials.lean` targeting Steps 1-4 of the
`appLE_isLocalization` body (estimated 100-250 LOC; effort-honesty
expectation of PARTIAL with Steps 1+3+4 closed and Step 2 residual,
or COMPLETE if Step 2 closes in one shot).

## What I want from you

Render a verdict per route:
- CONVERGING / CHURNING / STUCK / UNCLEAR.

If CHURNING or STUCK, name the corrective action from {blueprint
expansion, mathlib-analogist consult, refactor, route pivot, user
escalation}.

If CONVERGING, confirm the planner should proceed with the M1.b lane.
If UNCLEAR, name what next-iter signal would resolve it.

## Strict context discipline

I have NOT included STRATEGY.md, blueprint chapters, or full iter-sidecar
content. Only the extracted signals above. If you find I have
accidentally included anything I should not have, ignore it.
