# lean-auditor — iter-123 review

## Scope

Read-only whole-project audit of all `.lean` files in `AlgebraicJacobian/` (excluding `.lake/` and `lake-packages/`).

Pay particular attention to `AlgebraicJacobian/Differentials.lean`, which received prover edits this iter on `AlgebraicGeometry.IsAffineOpen.appLE_isLocalization` (the iter-122 introduced residual M1.b body at the project's bridge milestone). The body now contains an explicit `IsLocalization.lift` construction of the forward map plus a `suffices` reduction to a single `AlgEquiv` sorry. Audit for:

- Stale comments / docstrings that no longer match the file's current proof structure.
- Suspect definitions or `@[reducible]`/`noncomputable def` usage.
- Excuse-comments around `sorry` sites (we have **2 sorry sites total**: Differentials.lean:362 inside the `suffices AE` block; Jacobian.lean:179 `nonempty_jacobianWitness`).
- Dead-end proof scaffolding from past iters (commented-out code blocks, unused `have` statements, stale `set` bindings).
- Bad Lean practices (`set_option maxHeartbeats` abuse, `convert; sorry`, etc.).
- Unused private helpers / orphan declarations.

Critical push-back is welcome — the iter-122/123 sequence added substantial new helpers (`appLE_colimRingHom`, `appLE_colimAlgebra`, `appLE_colimRingHom_comp_φV`, `isUnit_appLE_unitSubmonoid_in_colim`, `kaehler_localization_subsingleton`, `kaehler_quotient_localization_iso`, `relativeDifferentialsPresheaf_equiv_kaehler_appLE`). If any of these are mis-shaped or carry unstated assumptions, flag it.

## Files to read

Absolute paths:

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/AbelJacobi.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Differentials.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Genus.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Jacobian.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Rigidity.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/` (any files therein — scaffolding from earlier iters; the iter-117 trim removed the highest-churn material but residual scaffolding may exist).

## Output

Standard lean-auditor report at `task_results/lean-auditor-review123.md`. Per-file checklist + flagged-issues block.
