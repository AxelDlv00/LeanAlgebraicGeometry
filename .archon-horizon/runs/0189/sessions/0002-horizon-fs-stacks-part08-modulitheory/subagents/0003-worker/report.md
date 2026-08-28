Implemented and committed as `fc5d2affeb`:

- Added [`StacksPart08Lib/ModuliCurves.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part08_TopicsInModuliTheory/StacksPart08Lib/ModuliCurves.lean) with:
  - `FamilyOfCurves`
  - `SatisfiesFamilyConditions`
  - `Prestable`, `Semistable`, and `Stable`
  - definitional iff lemmas
  - proved `Semistable.prestable`, `Stable.prestable`, and `Stable.semistable`
- Updated [`Basic.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part08_TopicsInModuliTheory/StacksPart08Lib/Basic.lean) to import the module and use the standard header.

Verification:

- `$HORIZON_BIN check --json`: passed, 121 jobs, no warnings.
- LSP diagnostics for all three project modules: clean.
- `lean_verify` for the key declarations: no axioms.
- No `sorry`, `admit`, or `axiom` occurrences in the new source.
