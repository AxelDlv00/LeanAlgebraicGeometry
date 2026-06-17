# Blueprint Writer Report

## Slug
dag-writer-grassmannian

## Status
COMPLETE — all 21 helper declarations from the directive now have concise blueprint
entries (label / lean / uses / short proof note), wired into the cocycle machinery;
leandag reports zero `unknown_uses`, zero isolated nodes, and no new `unmatched_lean`
for the cluster.

## Target chapter
blueprint/src/chapters/Picard_GrassmannianCells.tex

## Changes Made

Added two new subsections between `lem:gr_transition_self` and `lem:gr_cocycle`.
All blocks are project-internal matrix/localisation helpers (namespace
`AlgebraicGeometry.Grassmannian`) — no external source/citation (per directive).
None carry `\leanok` (left to `sync_leanok`).

### Subsection "Project-local matrix and minor bookkeeping"
- **Added lemma** `lem:gr_mul_submatrix_col` — `\lean{...mul_submatrix_col}`: column submatrix of a product `(AB)_{•g} = A(B_{•g})`. One-line.
- **Added lemma** `lem:gr_map_nonsing_inv` — `\lean{...map_nonsing_inv}`: a ring map commutes with the Cramer inverse. `\uses{lem:mathlib_mul_nonsing_inv}`.
- **Added lemma** `lem:gr_map_map_eq_of_comp` — `\lean{...map_map_eq_of_comp}`: functoriality of entrywise application.
- **Added lemma** `lem:gr_inv_mul_inv_mul_cancel` — `\lean{...inv_mul_inv_mul_cancel}`: `(B⁻¹A)(A⁻¹M) = B⁻¹M`. `\uses{lem:mathlib_mul_nonsing_inv}`.
- **Added lemma** `lem:gr_universalMatrix_submatrix_self` — `\lean{...universalMatrix_submatrix_self}`: `X^I_I = 1`. `\uses{def:gr_universal_matrix}`.
- **Added lemma** `lem:gr_imageMatrix_submatrix_self` — `\lean{...imageMatrix_submatrix_self}`: `M_J = 1`. `\uses{def:gr_image_matrix, lem:gr_mul_submatrix_col, lem:gr_universalMinorInv_identities}`.
- **Added lemma** `lem:gr_imageMatrix_submatrix_I` — `\lean{...imageMatrix_submatrix_I}`: `M_I = (X^I_J)⁻¹`. `\uses{def:gr_image_matrix, lem:gr_mul_submatrix_col, lem:gr_universalMatrix_submatrix_self}`.
- **Added lemma** `lem:gr_universalMatrix_map_transitionPreMap` — `\lean{...universalMatrix_map_transitionPreMap}`: `(θ̃_{I,J})_* X^J = M`. `\uses{def:gr_universal_matrix, def:gr_image_matrix, def:gr_transition_pre, lem:gr_imageMatrix_submatrix_self}`.
- **Added lemma** `lem:gr_transitionPreMap_minorDet` — `\lean{...transitionPreMap_minorDet}`: `θ̃_{I,J}(P^J_K) = det(M_K)`. `\uses{def:gr_transition_pre, def:gr_minor_det, def:gr_image_matrix, lem:gr_universalMatrix_map_transitionPreMap}`.
- **Added lemma** `lem:gr_imageMatrix_map_eq` — `\lean{...imageMatrix_map_eq}`: naturality of the image matrix, `ι_* M = (Y_X)⁻¹ Y`. `\uses{def:gr_image_matrix, lem:gr_map_map_eq_of_comp, def:gr_universalMinorInv, lem:gr_map_nonsing_inv, lem:gr_minorDet_unit, def:gr_universal_minor}`.

### Subsection "Triple-overlap rings and the localised transition maps"
- **Added definition** `def:gr_away_incl_left` — `\lean{...awayInclLeft}`: `R[1/x] → R[1/(xy)]`. `\uses{lem:mathlib_away_lift, lem:mathlib_away_algebraMap_isUnit}`.
- **Added definition** `def:gr_away_incl_right` — `\lean{...awayInclRight}`: `R[1/y] → R[1/(xy)]`. Same uses.
- **Added lemma** `lem:gr_awayInclLeft_comp_algebraMap` — `\lean{...awayInclLeft_comp_algebraMap}`. `\uses{def:gr_away_incl_left}`.
- **Added lemma** `lem:gr_awayInclRight_comp_algebraMap` — `\lean{...awayInclRight_comp_algebraMap}`. `\uses{def:gr_away_incl_right}`.
- **Added lemma** `lem:gr_isUnit_algebraMap_away_left` — `\lean{...isUnit_algebraMap_away_left}`: `x` a unit in `R[1/(xy)]`. `\uses{lem:mathlib_away_algebraMap_isUnit}`.
- **Added lemma** `lem:gr_isUnit_algebraMap_away_right` — `\lean{...isUnit_algebraMap_away_right}`: `y` a unit. Same uses.
- **Added lemma** `lem:gr_isUnit_incl_transitionPreMap_cross` — `\lean{...isUnit_incl_transitionPreMap_cross}`: the cross minor becomes a unit after inclusion. `\uses{lem:gr_transitionPreMap_minorDet, lem:gr_mul_submatrix_col, lem:gr_universalMinorInv_identities, def:gr_image_matrix}`.
- **Added definition** `def:gr_cocycle_theta_ij` — `\lean{...cocycleΘIJ}`: `Θ_{I,J} : S_J → S_I`. `\uses{lem:mathlib_away_lift, def:gr_away_incl_left, def:gr_transition_pre, lem:gr_transition_pre_unit, lem:gr_isUnit_incl_transitionPreMap_cross, lem:gr_awayInclLeft_comp_algebraMap, lem:gr_isUnit_algebraMap_away_right, def:gr_minor_det}`.
- **Added definition** `def:gr_cocycle_theta_jk` — `\lean{...cocycleΘJK}`: `Θ_{J,K} : S_K → S_J`. Analogous uses (right inclusion).
- **Added definition** `def:gr_cocycle_theta_ik` — `\lean{...cocycleΘIK}`: `Θ_{I,K} : S_K → S_I`. Analogous uses (right inclusion).
- **Added lemma** `lem:gr_cocycle_imageMatrix_eq` — `\lean{...cocycle_imageMatrix_eq}`: the image-matrix identity over the triple overlap; both sides reduce to `(Y_K)⁻¹ Y`. `\uses{lem:gr_imageMatrix_map_eq, def:gr_cocycle_theta_ij, def:gr_away_incl_right, def:gr_away_incl_left, lem:gr_awayInclRight_comp_algebraMap, lem:gr_awayInclLeft_comp_algebraMap, lem:gr_universalMatrix_map_transitionPreMap, lem:gr_map_map_eq_of_comp, lem:gr_map_nonsing_inv, lem:gr_mul_submatrix_col, lem:gr_inv_mul_inv_mul_cancel, lem:gr_isUnit_algebraMap_away_left, lem:gr_minorDet_unit, def:gr_image_matrix, def:gr_universal_minor}`.

### Edges added to existing block (no statement change beyond `\uses`)
- **Fixed dependencies** `lem:gr_cocycle` — added `def:gr_cocycle_theta_ij, def:gr_cocycle_theta_jk, def:gr_cocycle_theta_ik, lem:gr_cocycle_imageMatrix_eq` to both the statement and proof `\uses{}` (the Lean proof of `cocycleCondition` invokes exactly these). No other change to the statement.

## Cross-references introduced
All new `\uses{}` targets resolve (verified `unknown_uses: []`). Mathlib anchors
reused, not re-authored: `lem:mathlib_away_lift`, `lem:mathlib_away_algebraMap_isUnit`,
`lem:mathlib_mul_nonsing_inv`. Project blocks reused: `def:gr_universal_matrix`,
`def:gr_minor_det`, `def:gr_universal_minor`, `def:gr_universalMinorInv`,
`def:gr_image_matrix`, `def:gr_transition_pre`, `lem:gr_minorDet_unit`,
`lem:gr_universalMinorInv_identities`, `lem:gr_transition_pre_unit`.

## leandag verification
- `leandag build --json`: `unknown_uses: []`; `unmatched_lean` unchanged — only the
  three not-yet-formalized scheme-level decls (`def:gr_glued_scheme`,
  `lem:gr_separated`, `lem:gr_proper`), none in this helper cluster.
- `leandag query --isolated --chapter Picard_GrassmannianCells`: 0 results.
- All 21 new `\lean{}` targets (including the `private` lemmas and the unicode
  `cocycleΘIJ/JK/IK`) appear in `.leandag/dag.json` matched to their Lean decls.
- LaTeX environments balanced (66 begin / 66 end; definition 14/14, lemma 27/27,
  proof 23/23).

## References consulted
None — all added blocks are project-internal matrix-algebra/localisation helpers
with no external source (per directive; no `% SOURCE QUOTE:` required). The chapter's
pre-existing source-backed blocks (Nitsure §1) were left untouched.

## Macros needed (if any)
None. Only standard LaTeX (`\Theta`, `\operatorname{Mat}`, `\det`, `\cref`, `\mathbb`,
`\mathrm`) and existing project macros were used.

## Notes for Plan Agent
- The three remaining `unmatched_lean` nodes (`scheme`, `isSeparated`, `isProper`)
  are blueprint statements whose Lean declarations are not yet formalized — unrelated
  to this directive, untouched here.
- The Lean private lemmas (`mul_submatrix_col`, `map_nonsing_inv`,
  `map_map_eq_of_comp`, `inv_mul_inv_mul_cancel`, `imageMatrix_map_eq`,
  `isUnit_incl_transitionPreMap_cross`, `isUnit_algebraMap_away_{left,right}`,
  `cocycle_imageMatrix_eq`) match by fully-qualified name and resolve fine in leandag.

## Strategy-modifying findings
None.
