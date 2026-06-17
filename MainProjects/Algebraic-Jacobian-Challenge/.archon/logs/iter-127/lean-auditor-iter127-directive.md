# Lean Auditor Directive

## Slug
iter127

## Scope (files)
all `.lean` files under `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/` (and `AlgebraicJacobian.lean` at project root).

## Focus areas (optional)
- `AlgebraicJacobian/Jacobian.lean` — new declaration `genusZeroWitness` (lines 162–178) landed iter-127 via `refactor-m2b-scaffold-iter127`. Single sorry body. Check that the signature and docstring are honest and that no excuse-comments were introduced; verify the sorry is straightforwardly a scaffold (not a fake/placeholder body claiming to encode actual proof content).
- `AlgebraicJacobian/RigidityKbar.lean` — created iter-126; unchanged this iter. Already audited iter-126; please re-audit briefly to catch any new cross-file drift (e.g. callers in Jacobian.lean now consuming it).
- `AlgebraicJacobian/Differentials.lean` — post iter-126 excise; should be small (~140 lines) and standalone. Verify residual declarations are kernel-clean (no sorries, no axioms).

## Known issues
- The 3 active sorry sites (`Jacobian.lean:178`, `Jacobian.lean:197`, `RigidityKbar.lean:87`) are recognized scaffolds — do NOT flag them as must-fix; they are tracked in PROGRESS.md and have honest docstring status notes.
- Long docstrings on `genusZeroWitness` and `nonempty_jacobianWitness` are intentional; do not flag as bad practice.
- The iter-126 lean-auditor flagged 3 majors on RigidityKbar.lean (docstring/signature framing); those are deferred and not in scope this iter.
