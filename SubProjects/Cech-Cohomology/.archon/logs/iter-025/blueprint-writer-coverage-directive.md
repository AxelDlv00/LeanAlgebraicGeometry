# Blueprint-writer directive — clear coverage debt (32 unmatched `lean_aux` helpers)

## Chapter to edit
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (the consolidated chapter
covering CechAcyclic / PresheafCech / FreePresheafComplex / CechBridge / etc.).

## Goal
`archon dag-query unmatched` currently lists **32 prover-created Lean helper declarations with
NO blueprint entry**. Each is an isolated `lean_aux` node invisible to the dependency graph.
Your job: restore the 1-to-1 Lean↔blueprint correspondence by **bundling each helper's fully
qualified Lean name into the `\lean{...}` list of the existing blueprint block it belongs to**.
Do NOT create new standalone theorem blocks for trivial helpers — append the name to the parent
block's `\lean{...}` list. (Per project convention `private` does NOT exempt a name from
`unmatched`; bundling the name into a parent block's `\lean{}` list is the fix.)

You are NOT proving anything and NOT changing any mathematical statement. This is a pure
`\lean{...}`-list reconciliation pass plus, where a helper's home block does not yet exist,
adding ONE short trivial sub-statement with a one-line informal proof. Do **not** add or remove
any `\leanok` / `\mathlibok` marker.

## The 32 unmatched helpers and their home blocks
The prover task results give the intended home for each. Use these mappings; verify each name
exists in the corresponding `.lean` file before bundling (read the file if unsure):

### A. CechBridge `ses_cech_h1` helpers → append to `\lean{...}` of `lem:ses_cech_h1`
- `AlgebraicGeometry.restr_trans`, `AlgebraicGeometry.restr_inj_of_eq`,
  `AlgebraicGeometry.restr_op_unique`, `AlgebraicGeometry.restr_g'_transport`,
  `AlgebraicGeometry.fι_sectionCechFaceRestr`, `AlgebraicGeometry.coverConst_iInf`,
  `AlgebraicGeometry.coverPair_iInf`, `AlgebraicGeometry.pair_comp_δ0`,
  `AlgebraicGeometry.pair_comp_δ1`

### B. CechBridge Čech-H¹-coboundary heart (iter-023) → `lem:ses_cech_h1` is fine, OR if you judge they deserve their own block, add a trivial `lem:cech_h1_coboundary` block with a one-line proof and `\uses{def:section_cech_complex}`
- `AlgebraicGeometry.sectionCech_objD_exact_of_isZero_homology`
- `AlgebraicGeometry.sectionCech_one_coboundary_of_isZero_homology`
(These two state "IsZero homology ⟹ Function.Exact" and "Ȟ¹=0 ⟹ 1-cocycle is a coboundary".
The `ses_cech_h1` proof consumes the second directly, so folding them into `lem:ses_cech_h1`'s
`\lean{}` list is acceptable and simplest.)

### C. FreePresheafComplex engine-augmentation helpers → append to `\lean{...}` of `lem:cech_engine_complex`
- `AlgebraicGeometry.cechEngineAug0`, `AlgebraicGeometry.cechEngineAug0_split`,
  `AlgebraicGeometry.cechEngineAug0_ι`, `AlgebraicGeometry.cechEngineComplexAug`,
  `AlgebraicGeometry.cechEngineComplexAug_f_zero`, `AlgebraicGeometry.cechEngineComplex_exactAt`,
  `AlgebraicGeometry.cechEngineD_comp_aug`

### D. FreePresheafComplex engine-iso component helpers → append to `\lean{...}` of `lem:cech_free_eval_engine_iso`
- `AlgebraicGeometry.cechFreeAug_eval_eq`, `AlgebraicGeometry.cechFreeEvalEngineIso_hom_f`,
  `AlgebraicGeometry.cechFreeEvalEngine_X_inv_hom_ι`, `AlgebraicGeometry.cechFreeEvalEngine_comm`,
  `AlgebraicGeometry.cechFreeEvalEngine_map_ι`, `AlgebraicGeometry.cechFreeEval_X_ι_inv`,
  `AlgebraicGeometry.cechFree_d_ι`, `AlgebraicGeometry.freeYonedaAug_app_comp`,
  `AlgebraicGeometry.freeYonedaEval_iso_of_le_hom_eq_aug`,
  `AlgebraicGeometry.freeYonedaEval_iso_of_le_natural`

### E. FreePresheafComplex nonempty-quasi-iso helpers → append to `\lean{...}` of `lem:cech_free_eval_nonempty`
- `AlgebraicGeometry.cechEngineComplexAug_quasiIso`,
  `AlgebraicGeometry.coverStructurePresheafEval_iso`,
  `AlgebraicGeometry.coverStructurePresheafEval_iso_hom`,
  `AlgebraicGeometry.epi_cechEngineAug0`

## Acceptance
After your edits, every one of the 32 names above must appear in some block's `\lean{...}` list
in the chapter. Do not introduce broken `\uses{}` (use only existing blueprint labels). Keep all
existing prose, `% SOURCE` quotes, and statements verbatim — you are only extending `\lean{...}`
lists (and at most adding the optional trivial block in B). Report which block received each name
and confirm no `\uses{}` label is dangling.

## Out of scope
- Do NOT touch `lem:injective_cech_acyclic`, `lem:cech_to_cohomology_on_basis`,
  `lem:affine_serre_vanishing`, `lem:cech_augmented_resolution` statements/proofs — they are
  complete and correct already.
- Do NOT add `\leanok` or `\mathlibok` anywhere.
- Do NOT edit any `.lean` file.
