## Progress

- Added `AffineRingGluePresentation.ofData` and `AffineRingGluePackage.pin` so a selected
  `Scheme.GlueData`/`GluedMapData` pair crosses the gluing boundary without re-elaborating
  proof-sensitive coherence arguments (`eac8d7488f`).
- Added producer-side `choose` APIs for all six finite-stage records while retaining the
  existing `Nonempty` adapters (`62e2ab2d77c6`).
- Added the stable representer choice boundary and the stable glued-over compatibility
  projection (`05201f9fe3`, `aed21b3cc0`).

## Checks

- Horizon/Lake checks passed for `AffineRingGlueData` (11.1s), `RepresenterData` (4.8s),
  `Pic0FiniteStageStableGluedOver`, and the public `FiniteStageApi` (9362/9362 in the
  preceding checkpoint).  Affine LSP diagnostics are clean apart from the pre-existing
  long-line warning at line 329.
- A bounded kernel check of `Pic0FiniteStageGlueData` reached two minutes with no output
  and no `.olean`; the dependent face module likewise exceeded 16 minutes.  The temporary
  context-face adapter was therefore not committed.  The failed `horizon attempt save`
  invocation was blocked by the shared ledger lock; the rejection and exact blocker are
  recorded here.

## Handoff

The task remains `running`, partly advanced.  Downstream work should use `FiniteStageApi`,
the pinned affine presentation, and the explicit producer choices.  The next bounded unit
is to build or split `Pic0FiniteStageGlueData`/`GlueDataFace` so the context comparison family
`D.Q` can be consumed without the legacy separately supplied certificate; no mathematical
endpoint or representability claim was manufactured.
