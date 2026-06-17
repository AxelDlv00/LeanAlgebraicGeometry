# Lean Auditor Directive

## Slug
iter113

## Scope (files)
all

## Focus areas (optional)
`AlgebraicJacobian/Differentials.lean` (iter-113 prover lane modified
helper #1 body at L209 and inserted a new top-level helper
`relativeDifferentialsPresheaf_isSheafUniqueGluing_type` at L168; the
file also received a 3-signature refactor in the plan phase on
L818 / L835 / L976–982).

Bias toward thoroughness on the rest of the project (do not skip).

## Known issues
- Two deprecation warnings on `AlgebraicGeometry.IsSmoothOfRelativeDimension`
  (L818 + L835) are KNOWN (the refactor agent chose the deprecated form
  to match blueprint prose; cosmetic-only `@[deprecated]` for
  `SmoothOfRelativeDimension`). No need to re-flag.
- The 5 sorry sites in `Differentials.lean` (L175, L622, L823, L840, L982)
  and the 6 in `Cohomology/BasicOpenCech.lean` are all named-deferred per
  prior iters; no need to re-flag as "missing proof."
- `archon-protected.yaml` 9 declarations have signature-frozen status —
  signatures must NOT be flagged as wrong; only bodies and surrounding
  scaffolding.

## Absolute paths to read
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/archon-protected.yaml (for protected list)

Report destination: `task_results/lean-auditor-iter113.md`
