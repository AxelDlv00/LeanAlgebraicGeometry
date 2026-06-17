# Lean Auditor Directive

## Slug
review132

## Scope (files)
all `.lean` files under `AlgebraicJacobian/` and the top-level `AlgebraicJacobian.lean`. Project root: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/`.

## Focus areas (optional)
Pay extra attention to:
- `AlgebraicJacobian/Cotangent/GrpObj.lean` — the only file edited
  this iter; iter-132 added a new theorem
  `cotangentSpaceAtIdentity_finrank_eq` and made one secondary tactic
  edit (`show` → `change`). Five iters of body-shape activity on the
  central declaration in this file; assess whether the file's
  docstrings (file-level header, `## Status` block, `cotangentSpaceAtIdentity`
  declaration docstring) now contain stale framing relative to the
  current state.

## Known issues
- `AlgebraicJacobian/Jacobian.lean:192` and `:213` carry `sorry`
  bodies (`genusZeroWitness` and `nonempty_jacobianWitness`); these
  are intentional and tracked by the project. Do NOT re-report as
  red flags; mention only if their *docstrings/comments* are stale.
- `AlgebraicJacobian/RigidityKbar.lean:87` carries `sorry` body
  (`rigidity_over_kbar`); intentional scaffold. Same rule as above.
- `AlgebraicJacobian/Cotangent/GrpObj.lean` contains the words
  "opaque" and "sorry" in docstring prose (not in declarations);
  `lean_verify` already confirms kernel-only axioms. Don't flag
  these as suspect bodies.
- Iter-131 introduced the `Classical.choose`-chain `let`-binding
  pattern in `cotangentSpaceAtIdentity`. The body uses
  `Classical.choose` extractions but the outer term shape is
  `(ModuleCat.extendScalars _).obj (ModuleCat.of _ Ω[…])`. This is
  the project's deliberate body-shape choice; not a suspect body.

## Report path
.archon/task_results/lean-auditor-review132.md
