# lean-auditor — iter-168 review directive

## Files

Whole-project audit, full pass. The file modified this iter is:

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Genus0BaseObjects.lean`

Pay extra attention to it, but produce the standard per-file checklist for every
`.lean` file under the project tree.

## Project tree (read-only)

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/`
  - `AbelianVarietyRigidity.lean`
  - `Genus0BaseObjects.lean` (iter-168 edits)
  - `Jacobian.lean`
  - `RigidityKbar.lean`
  - `Cotangent/ChartAlgebra.lean`
  - `Cotangent/GrpObj.lean`
  - other files

## Focus

- Newly introduced declarations in `Genus0BaseObjects.lean` lines 196–386 (the
  iter-168 chart-cover + ring-iso scaffold) and L719–753
  (`projectiveLineBar_isReduced`).
- The residual sorry on `homogeneousLocalizationAwayIso_aux_left` (L368–372):
  judge whether the docstring's framing is honest (it claims "structural setup
  via `ext`, `Away.mk_surjective`, `val_injective`" but the body is `sorry`).
- Any stale narrative / docstring drift from prior iters (e.g. the L708–712
  "Mathlib gap" comment on `projectiveLineBar_isReduced` claiming the bridge is
  missing when the iter-168 prover discovered it is NOT missing).

## Output

Per-file checklist plus the standard flagged-issues block. Severity:
must-fix-this-iter / major / minor.
