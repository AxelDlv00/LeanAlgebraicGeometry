Metadata-only probe confirms coherent upstream caches:

- `Pic0FiniteStageGluePackage.olean` now exists, built Aug 23 18:16 (3.51 MB).
- `Pic0FiniteStageChartBaseChange`, `GluingBaseChange`, `RestrictionNaturality`, `RestrictionBaseChange`, and `OverlapBaseChange` all have fresh Aug 23 `.olean`s (18:38–18:53).
- `Pic0FiniteStageScalarExtendedAtlas.olean` exists from Aug 22 and its source is older/unchanged.
- `Pic0FiniteStageGluingDiagramIso.lean` source hash is `f59bec269b42ed20`, matching both stale `.trace` and `.trace.nobuild`; it has no `.olean`, only stale output hashes (`8c23f4dc...`, `b21b...`).

A fresh narrow DiagramIso compile should therefore reuse coherent upstream caches; only DiagramIso itself needs elaboration.
