# refactor add-lbc-import — DONE

## Change

Added one line to `AlgebraicJacobian.lean` immediately after `import AlgebraicJacobian.Picard.QuotScheme` (line 27):

```
import AlgebraicJacobian.Picard.LineBundleCoherence
```

Now at line 28 of the root aggregator.

## Verification

- `LineBundleCoherence.lean` confirmed to exist at `AlgebraicJacobian/Picard/LineBundleCoherence.lean`.
- `lean_diagnostic_messages` on `AlgebraicJacobian.lean` returns zero errors after the edit.

## Files modified

- `AlgebraicJacobian.lean` (one line added, no other changes)
