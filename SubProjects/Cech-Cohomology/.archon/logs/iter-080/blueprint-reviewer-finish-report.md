# Blueprint Review: finish
**Iter:** 080

## Top-level summaries

- **Focus check PASS**: `lem:cech_computes_cohomology` (line 11805) — `\lean{AlgebraicGeometry.cech_computes_higherDirectImage}` ✓; `\uses{lem:cech_augmented_resolution, lem:cech_term_pushforward_acyclic, lem:acyclic_resolution_computes_derived, lem:pushforward_mapHC_cechComplexOnX, lem:cechAugmented_to_acyclicResolutionInput, def:cech_complex, def:higher_direct_image}` matches directive exactly ✓; hypotheses `[X.IsSeparated] [S.IsSeparated]`, affine cover `h𝒰`, `hres` family all present ✓; scope note with ℙ¹/O(-2) counterexample present ✓; `\leanok` on statement and proof ✓.
- **Deleted label CONFIRMED**: grep for `lem:cech_computes_cohomology_affineCover` across all chapters → zero hits ✓.
- **Deps**: `unknown_uses: []` (no broken `\uses{}` edges); `isolated: 0`; `with_sorry: 0` ✓.
- **Rendering**: blueprint-doctor returns `malformed_refs: []`, `broken_refs: []`, `orphan_chapters: []`, `covers_problems: []` ✓.
- **Incomplete**: `Cohomology_CechHigherDirectImage.tex` — 5 blueprint nodes missing `\lean{}` (4 intentional per NOTEs, 1 needs reconciliation); 108 nodes awaiting `sync_leanok` (sorry-free, mechanical sync).
- **Correctness**: `Cohomology_CechHigherDirectImage.tex` — `lem:tile_section_comparison` has `\leanok` on both statement and proof but carries no `\lean{}` pin; its iter-044 NOTE explicitly says "UNFORMALIZED (no `\lean{}`)". State is contradictory: either the declaration exists in Lean and needs a `\lean{}` hint added (and the NOTE updated), or the `\leanok` was applied incorrectly.
- **Structure note**: `lem:pushforward_mapHC_cechComplexOnX` (line 11957) and `lem:cechAugmented_to_acyclicResolutionInput` (line 12000) appear *after* their consumer `lem:cech_computes_cohomology` (line 11801) in the chapter. The `\uses{}` DAG is correct; this is an inverted textual ordering only.

## Per-chapter

### `Cohomology_HigherDirectImage.tex`
- **Complete**: true
- **Correct**: true
- **Notes**: Single `def:higher_direct_image` block; `\leanok`; `\lean{AlgebraicGeometry.higherDirectImage}`; referenced correctly by `lem:cech_computes_cohomology` ✓.

### `Cohomology_AcyclicResolution.tex`
- **Complete**: true
- **Correct**: true
- **Notes**: All blocks have `\lean{}` + (`\leanok` or `\mathlibok`); proof sketches are fully detailed; `\uses{}` graph complete and valid; citation discipline (% SOURCE / % SOURCE QUOTE / \textit{Source:}) consistent throughout ✓.

### `Cohomology_CechHigherDirectImage.tex`
- **Complete**: partial
- **Correct**: partial
- **Notes**:
  1. **`lem:tile_section_comparison`** (line 4738): `\leanok` on statement + proof but no `\lean{}` pin. NOTE (iter-044) calls it "UNFORMALIZED." Inconsistency: if the declaration exists, add `\lean{}` + update NOTE; if not, remove `\leanok`. Impact=0 (not on live `\uses` chain of capstone). **(soon fix)**
  2. **`lem:cech_free_eval_prepend_homotopy`** (line 2252), **`lem:cech_free_eval_prepend_homotopy_spec`** (line 2316): intentionally no `\lean{}` — each carries a NOTE explaining the declaration is obtained by transport from `cechEnginePrepend` / `cechEnginePrepend_spec` (pinned under `lem:cech_engine_complex`). Disposition: **keep** (both impact=25-26 nodes downstream but those are all already proved since sorry=0).
  3. **`lem:isIso_fromTildeGamma_of_quasicoherent`** (line 6016): intentionally no `\lean{}` — NOTE says "dormant Route-A fallback, superseded by Route B `lem:qcoh_isIso_fromTildeGamma`". Disposition: **keep**.
  4. **`lem:pushforward_commutes_restriction`** (line 10842): intentionally no `\lean{}` — NOTE says "superseded, not an active build target, not on any live `\uses` chain." Disposition: **keep**.
  5. **108 nodes need `sync_leanok`**: all sorry-free per leandag; pending mechanical sync pass. Not a blueprint correctness problem.
  6. **Textual ordering issue**: `lem:pushforward_mapHC_cechComplexOnX` (line 11957) and `lem:cechAugmented_to_acyclicResolutionInput` (line 12000) are placed after the main theorem `lem:cech_computes_cohomology` (line 11801) that lists them in its `\uses{}`. DAG is correct; reader sees the theorem before its helper lemmas. **(soon fix — move helpers before capstone, or accept as-is)**

## Severity summary

- **soon**: `lem:tile_section_comparison` — `\leanok` without `\lean{}` contradicts iter-044 NOTE; reconcile by adding `\lean{}` pin (and updating NOTE) or removing `\leanok`.
- **soon** (optional): Move `lem:pushforward_mapHC_cechComplexOnX` and `lem:cechAugmented_to_acyclicResolutionInput` before `lem:cech_computes_cohomology` in the chapter for correct textual reading order.
- **info**: 108 nodes awaiting `sync_leanok` (automatic, not manual blueprint edit).
- **info**: 4 intentionally `\lean{}`-less nodes documented in NOTEs — no action needed.

## Unstarted-phase proposals

*(Omitted — project is at finish line; all phases covered.)*
