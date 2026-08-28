Implemented and committed the periodic multiplicity package in `PeriodicLength.lean`.

Commit: `7d27b34d59c24ba332d67eb00e20ac5282c76b78`

Added:

- `finiteLengthInt` with an explicit `IsFiniteLength` witness.
- Exact-sequence integer-length additivity.
- Linear-equivalence invariance.
- Witnessed integer `multiplicity`.
- Finite-ambient formula `multiplicity_eq_ambient_length_sub`.
- `(2,1)` finite-ambient zero-multiplicity corollary.

Verification passed:

- LSP diagnostics: clean.
- `lake env lean StacksPart03Lib/PeriodicLength.lean`: exit 0.
- Horizon `check --lean` from the project root: passed.
- Axiom/source scans: no warnings beyond standard Lean axioms.
- Commit changed exactly `PeriodicLength.lean`; blob `759ff463...` matches the worktree.
- Temporary `Scratch.lean` removed.

The initial Horizon check from workspace root failed only because it selected the wrong v4.32 toolchain; the project-root invocation passed.
