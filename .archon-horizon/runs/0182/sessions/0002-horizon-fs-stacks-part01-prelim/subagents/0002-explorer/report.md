Implemented and committed the Tag 05N3 theorem in `StacksPart01Lib/SetTheory.lean`.

Commit: `39280d455eac4637fe0c78c8a2a943377a8571a`

The proof uses `c := max κ Cardinal.aleph0`, the regular successor cardinal `(Order.succ c).ord`, and `Cardinal.isRegular_succ`. Verification passed:

- Pre- and post-edit LSP diagnostics: clean
- Narrow Horizon Lean check: passed in 9.1s
- `lean_verify`: only standard axioms (`propext`, `Classical.choice`, `Quot.sound`), no source warnings
- Source scan: no `sorry`, `admit`, or `axiom`
- Commit contains only `SetTheory.lean` and includes a `Summary` trailer
