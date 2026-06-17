# Lean Auditor Directive

## Slug
review120

## Scope (files)
all `.lean` files under `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/` and the entry point `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian.lean`.

## Focus areas (optional)
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Differentials.lean` — received prover work this iteration; freshly-closed forward smoothness criterion `smooth_locally_free_omega` at line 91. Audit the new proof body (L99–L109) as Lean, no strategy bias.
- Polish-stage backlog flagged in prior iters (DO NOT re-report — just confirm fate):
  - `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` — dead `IsAffineHModuleHomFinite` chain (lean-auditor-review118 must-fix).
  - `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean` — `HasCechToHModuleIso` / `HasAffineCechAcyclicCover` scaffolding-class fate.
  - `AlgebraicJacobian/Rigidity.lean` L62-67 — redundant typeclass args on `GrpObj.eq_of_eqOnOpen`.
- The only remaining intentional sorry is `Jacobian.lean:179` `nonempty_jacobianWitness` (project-external; do not flag it — but verify it is still the **only** unintended-or-intended sorry in the project).

## Known issues
- `Jacobian.lean:179` `nonempty_jacobianWitness` is the single intended foundational existence hypothesis. Do NOT flag.
- The commented-out block in `Genus.lean` around L52 is intentional historical scaffolding; do NOT flag unless it's accompanied by an excuse comment.
- The deprecated `IsSmoothOfRelativeDimension` alias was already migrated to `SmoothOfRelativeDimension` in iter-118; no need to re-report.
- The "Mathlib gap" disclosures in `Differentials.lean` (docstring of `smooth_locally_free_omega`) are honest scope statements, not excuse comments. Flag them only if a Lean declaration they reference is missing or fake.
