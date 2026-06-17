# refactor add-lbc-import — add LineBundleCoherence to the root import list

## Task (single, mechanical)

The new module `AlgebraicJacobian/Picard/LineBundleCoherence.lean` (created iter-256) is NOT yet in the
root aggregator `AlgebraicJacobian.lean`, so the loop build and `blueprint/lean_decls` do not pick it up.

Add the line:
```
import AlgebraicJacobian.Picard.LineBundleCoherence
```
to `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian.lean`, placed
immediately AFTER the existing line `import AlgebraicJacobian.Picard.QuotScheme` (keep the Picard imports
grouped; the exact ordering among Picard files is not load-bearing).

## Constraints
- This is the ONLY change. Do not touch any other file. Do not modify any declaration.
- `LineBundleCoherence.lean` imports `AlgebraicJacobian.Picard.LineBundlePullback`, which compiles, so the
  new import will not break the build (the file has 5 `sorry` stubs — expected, not an error).
- After editing, confirm `AlgebraicJacobian.lean` still elaborates its import block (a `lake env lean`
  on the root file, or `lean_diagnostic_messages`, with no NEW errors introduced by the added line).

## Write domain
`AlgebraicJacobian.lean` only.
