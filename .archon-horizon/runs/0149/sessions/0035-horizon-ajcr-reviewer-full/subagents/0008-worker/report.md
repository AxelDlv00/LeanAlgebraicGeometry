Direct-specialized approach was rejected and saved as Horizon attempt `0003`.

- Post-edit LSP was clean.
- `lake env lean AlgebraicJacobian/Picard/Pic0FiniteStageRightRestrictionNaturality.lean` exited `1` after about 30 minutes.
- Failures were dependent `Semiring`, `CommRing`, and `Algebra` synthesis for specialized `FinalModelRing` tags, followed by cascading errors and a `whnf` heartbeat timeout.
- No axiom audit was run because kernel verification failed.

The current file is a generic-`q` follow-up draft. Its partial LSP pass reports a syntax error at line 137: theorem result inference requires an explicit `:` type. I stopped without further edits or another standalone run as directed.
