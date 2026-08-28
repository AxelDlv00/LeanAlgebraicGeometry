Implemented and committed the reindex layer in [ModuliCurves.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part08_TopicsInModuliTheory/StacksPart08Lib/ModuliCurves.lean:36).

Added:

- Universe-polymorphic `FamilyOfCurves.reindex`
- Simplification lemmas for every field
- `reindex_id` and `reindex_comp`
- Preservation of `Prestable`, `Semistable`, and `Stable`
- Surjective reflection for semistability and stability
- Method-style `Prestable.reindex`, `Semistable.reindex`, and `Stable.reindex`

Verification passed:

- LSP diagnostics: clean
- `horizon check --lean StacksPart08Lib/ModuliCurves.lean`
- `lake env lean StacksPart08Lib/ModuliCurves.lean`
- Three-universe consumer smoke test
- Axiom audit: `[]`
- No `sorry`, `admit`, or `axiom`

Commit: `344a425`

Caveat: the shared index already contained staged `MilneLib/LocalProperties.lean`, so commit `344a425` includes that unrelated file as well. I preserved it rather than altering another lane’s work.
