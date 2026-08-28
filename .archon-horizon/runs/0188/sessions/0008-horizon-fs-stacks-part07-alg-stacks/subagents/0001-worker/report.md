Implemented `StacksPart07Lib/DescentFunctoriality.lean` with the axiom-free Part07 adaptation of the Part04 descent functoriality API:

- identity and composite transport
- natural-transformation congruence
- pullback/transport compatibility
- coefficient-isomorphism cancellation

Verification passed:

- `lake env lean StacksPart07Lib/DescentFunctoriality.lean`
- `$HORIZON_BIN check --lean StacksPart07Lib/DescentFunctoriality.lean`
- `git diff --check`
- no `sorry` or `axiom` declarations

No other source files were edited; the new file is ready for your path-scoped commit.
