# Blueprint Writer Report

## Slug
coverage-025

## Status
COMPLETE — all 32 prover-created `lean_aux` helpers bundled into the `\lean{...}` list
of their home block; `archon dag-query unmatched` now reports 0 of 0.

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Approach
Pure `\lean{...}`-list reconciliation. No mathematical statement, prose, `% SOURCE`
quote, `\leanok`, or `\mathlibok` was added, removed, or altered. No new theorem block
was created (group B was folded into `lem:ses_cech_h1`, the directive's "acceptable and
simplest" option, since `ses_cech_h1`'s proof consumes
`sectionCech_one_coboundary_of_isZero_homology` directly). Every helper name was verified
to exist as a real declaration in its `.lean` file before bundling, and confirmed to live
in the `AlgebraicGeometry` namespace (CechBridge: `restr_*`/`coverConst_iInf`/etc. sit in
`section` blocks, not nested namespaces; FreePresheafComplex: all decls are past
`end FreeCechEngine` at L559, so under `namespace AlgebraicGeometry`).

## Changes Made — which block received each name

### `lem:ses_cech_h1` (`\lean{}` extended; group A + group B, 11 names added)
- `AlgebraicGeometry.sectionCech_objD_exact_of_isZero_homology` (CechBridge L456)
- `AlgebraicGeometry.sectionCech_one_coboundary_of_isZero_homology` (CechBridge L495)
- `AlgebraicGeometry.restr_trans` (L549)
- `AlgebraicGeometry.restr_inj_of_eq` (L562)
- `AlgebraicGeometry.restr_op_unique` (L575)
- `AlgebraicGeometry.restr_g'_transport` (L586)
- `AlgebraicGeometry.fι_sectionCechFaceRestr` (L601)
- `AlgebraicGeometry.coverConst_iInf` (L614)
- `AlgebraicGeometry.coverPair_iInf` (L618)
- `AlgebraicGeometry.pair_comp_δ0` (L625)
- `AlgebraicGeometry.pair_comp_δ1` (L630)

### `lem:cech_engine_complex` (`\lean{}` extended; group C, 7 names added)
- `AlgebraicGeometry.cechEngineAug0` (FreePresheafComplex L1194)
- `AlgebraicGeometry.cechEngineAug0_split` (L1234)
- `AlgebraicGeometry.cechEngineAug0_ι` (L1199)
- `AlgebraicGeometry.cechEngineComplexAug` (L1219)
- `AlgebraicGeometry.cechEngineComplexAug_f_zero` (L1258)
- `AlgebraicGeometry.cechEngineComplex_exactAt` (L1171)
- `AlgebraicGeometry.cechEngineD_comp_aug` (L1207)

### `lem:cech_free_eval_engine_iso` (`\lean{}` extended; group D, 10 names added)
- `AlgebraicGeometry.cechFreeAug_eval_eq` (L1326)
- `AlgebraicGeometry.cechFreeEvalEngineIso_hom_f` (L1386)
- `AlgebraicGeometry.cechFreeEvalEngine_X_inv_hom_ι` (L1031)
- `AlgebraicGeometry.cechFreeEvalEngine_comm` (L1108)
- `AlgebraicGeometry.cechFreeEvalEngine_map_ι` (L1092)
- `AlgebraicGeometry.cechFreeEval_X_ι_inv` (L1012)
- `AlgebraicGeometry.cechFree_d_ι` (L1061)
- `AlgebraicGeometry.freeYonedaAug_app_comp` (L1051)
- `AlgebraicGeometry.freeYonedaEval_iso_of_le_hom_eq_aug` (L980)
- `AlgebraicGeometry.freeYonedaEval_iso_of_le_natural` (L1000)

### `lem:cech_free_eval_nonempty` (`\lean{}` extended; group E, 4 names added)
- `AlgebraicGeometry.cechEngineComplexAug_quasiIso` (L1267)
- `AlgebraicGeometry.coverStructurePresheafEval_iso` (L1359)
- `AlgebraicGeometry.coverStructurePresheafEval_iso_hom` (L1392)
- `AlgebraicGeometry.epi_cechEngineAug0` (L1348)

## Cross-references introduced
None. No `\uses{}` was added or changed; only `\lean{...}` lists were extended. All four
home blocks already carried their `\uses{}` edges.

## Verification
- `archon dag-query unmatched` (the lean_aux coverage-debt list this directive targets):
  **0 of 0** — every one of the 32 helpers is now matched to a blueprint block.
- `leandag build --json`: `unknown_uses: []` — no broken/dangling `\uses{}` label was
  introduced.
- Grep confirms all 32 fully-qualified names appear in the chapter's `\lean{}` lists;
  brace balance of all four edited blocks intact.
- `leandag build` also reports 18 `unmatched_lean` blueprint nodes. These are a separate,
  pre-existing category (blueprint nodes whose `\lean{}` points at a Mathlib/external
  target — `CategoryTheory.*`, `PresheafOfModules.*` — or a project decl the parser indexes
  as external). None of the 18 are among the 32 helpers I bundled, and the project ones
  (`lem:injective_cech_acyclic`, `lem:affine_serre_vanishing`, `lem:cech_to_cohomology_on_basis`,
  `lem:cech_augmented_resolution`) are explicitly out-of-scope per the directive. They
  pre-date this pass and were not touched.

## References consulted
None — this was a pure `\lean{...}`-list reconciliation pass. No citation block was
written, so no `references/` file was opened.

## Macros needed (if any)
None.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- The 18 `unmatched_lean` nodes reported by `leandag build --json` (distinct from the
  `archon dag-query unmatched`/lean_aux list, which is now empty) suggest the indexer is
  not resolving certain `\lean{}` targets — both the `\mathlibok` anchors (expected: they
  point at real Mathlib decls) and a handful of live project decls
  (`AlgebraicGeometry.injective_cech_acyclic`, `affine_serre_vanishing`,
  `cech_eq_cohomology_of_basis`, `cechAugmented_exact`, `higherDirectImage_openImmersion_comp`,
  `cechTerm_pushforward_acyclic`). The project ones existing in their `.lean` files but
  showing as `unmatched_lean` may indicate a leandag indexing lag rather than a real gap —
  worth a glance if the dashboard's `unmatched_lean` figure is being tracked, but it is
  outside this directive's scope.

## Strategy-modifying findings
None.
