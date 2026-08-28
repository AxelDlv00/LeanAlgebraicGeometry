Implemented and committed the finite-type infrastructure.

Commit: `44cf306b1ed22712f54859a460173c912af98bbb`

Added `StacksPart05Lib/FiniteType.lean` and imported it from `StacksPart05Lib.lean`. The new API provides:

- `schemeFiniteType_isMultiplicative`
- `schemeFiniteType_respectsIso`
- `scheme_finiteType_of_isIso`
- `scheme_finiteType_comp_of_mem`
- `scheme_finiteType_baseChange_of_mem`
- `scheme_finiteType_baseChange_fst_of_mem`

Verification passed with clean LSP diagnostics, `LEAN_NUM_THREADS=1 lake build StacksPart05Lib` (`2502/2502` jobs), Horizon Lean check, and axiom/source audit. Only standard Lean axioms were reported; no `sorry`, `admit`, or project axioms.
