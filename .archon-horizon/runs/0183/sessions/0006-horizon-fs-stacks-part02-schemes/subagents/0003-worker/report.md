Follow-up completed in `StacksPart02Lib/OpenImmersion.lean`.

Added:

- `StacksPart02.scheme_openImmersion_comp`
- `StacksPart02.scheme_openImmersion_pullback_fst`
- `StacksPart02.scheme_openImmersion_pullback_fst_range`

The wrappers use Mathlib’s exact `IsOpenImmersion.comp`, pullback projection instance, and `range_pullbackFst` theorem. Added `CategoryTheory.Limits` to the existing `open` declaration for `pullback.fst`.

Verification succeeded:

- LSP diagnostics before and after edits: clean
- `$HORIZON_BIN check --lean StacksPart02Lib/OpenImmersion.lean`: passed
- `lean_verify` for all three declarations: standard axioms only, no warnings
