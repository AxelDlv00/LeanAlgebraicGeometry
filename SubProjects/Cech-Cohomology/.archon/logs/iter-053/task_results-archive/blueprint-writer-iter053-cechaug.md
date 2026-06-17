# Blueprint Writer Report

## Slug
iter053-cechaug

## Status
COMPLETE — all 5 directive tasks landed in the single chapter; `leandag` clean
(`unknown_uses: []`, `conflicts: []`, isolated back to the pre-existing lean_aux node only).

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### Task 1 — extended `% archon:covers`
- Added two covers lines after `QcohRestrictBasicOpen.lean`:
  - `% archon:covers AlgebraicJacobian/Cohomology/CechAugmentedResolution.lean`
  - `% archon:covers AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean`

### Task 2 — new block `lem:sheafify_kills_locally_zero`
- **Added lemma** `\label{lem:sheafify_kills_locally_zero}` placed immediately before
  `lem:cech_augmented_resolution`. `\lean{}` bundles the three site lemmas
  (`isZero_presheafToSheaf_obj_of_W`, `..._of_W_isZero`, `..._of_isLocallyBijective`).
  Statement: sheafification inverts the local-isomorphism class `J.W`; a presheaf locally
  bijective to a presheaf with zero sheafification (in particular one locally zero on a basis)
  has zero sheafification; abelian case = local injectivity + local surjectivity.
  Proof sketch cites the three Mathlib facts in prose (`GrothendieckTopology.W_iff`,
  `presheafToSheaf_additive`, `GrothendieckTopology.W_of_isLocallyBijective`).
  No `% SOURCE` block — project-bespoke pure site theory, no external textbook source named.
  No project-internal `\uses{}` (per directive).

### Task 3 — refreshed `lem:cech_augmented_resolution`
- **NOTE comment**: now records the theorem is *placed* in the new
  `CechAugmentedResolution.lean` (imports CechAcyclic + HigherDirectImagePresheaf +
  AffineSerreVanishing + QcohTildeSings); kept the import-cycle explanation; noted the
  Step-2 site lemmas + `lem:sheafify_kills_locally_zero` live upstream and are importable;
  the `toSheaf`-reflection bridge is built next to the relocated theorem.
- **Step 1**: now names the faithful additive forgetful functor `SheafOfModules.toSheaf`
  (X.Modules → abelian sheaves) which reflects `IsZero`.
- **Step 3**: added the sheafification-square bridge
  `toSheaf ∘ sheafify ≅ presheafToSheaf ∘ forget` connecting the module-level
  `homologyIsoSheafify` (via `lem:cohomology_sheaf_is_sheafify_homology`) to the abelian
  site lemma `lem:sheafify_kills_locally_zero`, which now does the killing.
- **Step 4**: names the degree-0 exactness certificates `combDifferential_exact` /
  `exact_of_isLocalized_span` explicitly in prose.
- **`\uses{}`**: added `lem:sheafify_kills_locally_zero` to BOTH the statement-level and the
  proof-level `\uses{}` (statement-level was required to register the dependency edge —
  `leandag` only reads statement-level `\uses{}` for the DAG, so the proof-only edge left the
  new block isolated).

### Task 4 — folded private helper `affine_tildeVanishing`
- Added `AlgebraicGeometry.affine_tildeVanishing` to the `\lean{}` list of
  `lem:affine_cech_vanishing_qcoh` (its NOTE already names this reshaper; it is matched by
  `leandag`, so `dag-query unmatched` stays clean).

### Task 5 — renamed mislabeled block
- `def:cohomology_sheaf_is_sheafify_homology` → `lem:cohomology_sheaf_is_sheafify_homology`
  (the block is a `\begin{lemma}`). Renamed the `\label` and all 5 in-chapter
  `\ref{}`/`\uses{}` occurrences (lines were 7211, 7228, 7312, 7367, 7372). Confirmed no
  references to the old label exist in any other chapter or in `content.tex`.

## Cross-references introduced
- `\uses{lem:sheafify_kills_locally_zero}` in statement + proof of `lem:cech_augmented_resolution`
  — target is the new block in this same chapter.

## References consulted
None opened this session for new citation blocks — the one new block
(`lem:sheafify_kills_locally_zero`) is project-bespoke pure Mathlib site theory with no
external textbook source (Mathlib `\lean{}` targets + in-prose Mathlib fact names are the
citation). All other edits are prose/label refresh on existing blocks whose `% SOURCE`
quotes were left untouched.

## Macros needed (if any)
None. New block uses only standard amsmath/LaTeX (`\operatorname`, `\widehat`, `\mathcal`,
`\mathbf{Ab}`, `\texttt`, `\emph`, `\varphi`, `\iff`).

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- `leandag` still lists `AlgebraicGeometry.cechAugmented_exact`,
  `higherDirectImage_openImmersion_comp`, and `cechTerm_pushforward_acyclic` under
  `unmatched_lean` — expected, these are the to-be-relocated / to-be-proved Lean targets, not
  blueprint errors.
- The new block's three `\lean{}` site lemmas and `affine_tildeVanishing` are all matched by
  `leandag` (they exist in Lean), so `dag-query unmatched` is clean for the items this
  directive touched.
- The sole remaining isolated node is the pre-existing lean_aux
  `lean:AlgebraicGeometry.CechAcyclic.affine` — untouched by this round.

## Strategy-modifying findings
None.
