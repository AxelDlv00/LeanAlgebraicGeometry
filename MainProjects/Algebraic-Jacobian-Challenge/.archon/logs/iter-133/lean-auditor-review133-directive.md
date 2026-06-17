# Lean Auditor Directive

## Slug
review133

## Scope (files)
all

## Focus areas (optional)
Pay extra attention to `AlgebraicJacobian/Cotangent/GrpObj.lean` — the iter-133 refactor lane (`refactor-cotangent-grpobj-docstring-refresh-iter133`) made 5 docstring refreshes + 1 style nit there. Confirm the iter-132 stale-framing findings have been resolved and no new staleness has been introduced.

## Known issues
- The 3 remaining sorries (`AlgebraicJacobian/Jacobian.lean:192` `genusZeroWitness`, `AlgebraicJacobian/Jacobian.lean:213` `nonempty_jacobianWitness`, `AlgebraicJacobian/RigidityKbar.lean:87` `rigidity_over_kbar`) are intentional scaffold sorries; report as INFO only, not major/critical.
- `archon-protected.yaml` lists 9 protected signatures including the iter-128/131/132 declarations in `Cotangent/GrpObj.lean`; signature changes there would be a critical violation.
