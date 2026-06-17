# Blueprint Writer Report

## Slug
fix-deps

## Status
COMPLETE — all four structural fixes applied; `leandag` reports `unknown_uses: []` and `conflicts: []`.

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### Fix 1 — new node `lem:isLocalizedModule_of_exact` (Archon-original)
- **Added lemma** `\label{lem:isLocalizedModule_of_exact}` / `\lean{AlgebraicGeometry.isLocalizedModule_of_exact}`,
  placed immediately BEFORE `lem:qcoh_section_kernel_comparison`.
- Statement: the abstract left-exact-ladder kernel comparison (converse of Mathlib's
  `IsLocalizedModule.map_exact`): for a commutative ladder `A→B→C / A'→B'→C'` with both rows left-exact and
  the two right-hand verticals `b,c` localisations at `S`, the left vertical `a` is a localisation at `S`.
- Proof sketch added (Y): mathematical diagram chase verifying the three `IsLocalizedModule` clauses for `a`
  — (i) `map_units`, (ii) `surj`, (iii) `exists_of_eq` — no Lean tactics.
- No `% SOURCE`/`% SOURCE QUOTE` lines (project-bespoke, per directive).
- `\uses{}`: statement `lem:localized_module_map_exact_mathlib` (the generic Mathlib-algebra anchor it is the
  converse of — referenced in the statement prose); proof `\uses{}` empty (self-contained chase).

### Fix 2 — flipped the `\uses` edges
- `lem:qcoh_section_isLocalizedModule` (keystone), **statement** `\uses`:
  removed `lem:qcoh_section_kernel_comparison`, added `lem:isLocalizedModule_of_exact`.
  Final: `lem:qcoh_finite_presentation_cover, lem:qcoh_section_equalizer, lem:localized_module_map_exact_mathlib, lem:tile_section_localization, lem:isLocalizedModule_of_exact, lem:section_isLocalizedModule_of_presentation`
- `lem:qcoh_section_isLocalizedModule` (keystone), **proof** `\uses` (also adds the overlap node per Fix 4):
  `lem:qcoh_finite_presentation_cover, lem:qcoh_section_equalizer, lem:localized_module_map_exact_mathlib, lem:tile_section_localization, lem:overlap_section_localization, lem:isLocalizedModule_of_exact, lem:section_isLocalizedModule_of_presentation`
- `lem:qcoh_section_kernel_comparison`, **statement and proof** `\uses` both set to:
  `lem:qcoh_section_isLocalizedModule, lem:isLocalizedModule_linearEquiv_mathlib`

### Fix 3 — reconciled the two proof blocks
- **Keystone proof** now carries the full equalizer→ladder→kernel-comparison chase itself: writes the two
  degree-0/1 sheaf-axiom equalizer rows, assembles the commutative ladder with the section-restriction
  verticals, notes the two right verticals `b,c` are localisations (per-tile + per-overlap), and closes by
  applying `lem:isLocalizedModule_of_exact` to conclude `ρ_f` is a localisation map. The non-circularity
  paragraph is retained.
- **Kernel-comparison proof** reduced to a one-liner corollary: immediate from the keystone, packaging the
  localisation map `ρ_f` as a linear equivalence via `IsLocalizedModule.iso`
  (Lemma~\ref{lem:isLocalizedModule_linearEquiv_mathlib}). `\leanok` preserved on the block.
- Updated the stale `% NOTE:` comments on both blocks: the keystone NOTE now states the direct-proof route
  (kernel comparison runs keystone → corollary), and the corollary NOTE describes it as the packaged-iso
  downstream corollary. The old "INVERTED vs the Lean / planner must flip" language is gone.

### Fix 4 — coverage node + bundled bookkeeping privates
- **Added lemma** `\label{lem:overlap_section_localization}` /
  `\lean{AlgebraicGeometry.overlap_section_localization, AlgebraicGeometry.overlap_target_eq, AlgebraicGeometry.presheaf_map_comp₂_apply}` /
  `\uses{lem:tile_section_localization}`, placed right after `lem:tile_section_localization`.
  Short one-paragraph statement + short proof (the per-tile lemma at `g = a·b`, transported along
  `D(ab)=D(a)⊓D(b)` and `D((ab)f)=D(af)⊓D(bf)`). Archon-derived corollary; no external source lines.
- The two pure-bookkeeping privates `overlap_target_eq` (basicOpen lattice identity) and
  `presheaf_map_comp₂_apply` (triple presheaf-map fold) are bundled into that node's `\lean{}` list, as
  directed.
- `lem:overlap_section_localization` added to the keystone's **proof** `\uses` (see Fix 2).

## Verification
- `leandag build --json`: `unknown_uses: []`, `conflicts: []`, `isolated: 2`.
- The two isolated nodes are pre-existing scaffolding (`lem:isScalarTower_restrictScalars_obj` coverage debt
  + one `lean_aux` node) — neither is one I authored.
- My two new nodes (`lem:isLocalizedModule_of_exact`, `lem:overlap_section_localization`) are NOT isolated
  and NOT in `unmatched_lean` (both `\lean{}` pins resolved).
- The three private helpers (`isLocalizedModule_of_exact`, `overlap_section_localization`,
  `overlap_target_eq`, `presheaf_map_comp₂_apply`) all matched — none appear in `unmatched_lean`, so
  `dag-query unmatched` clears for them.
- Both new nodes each have a statement, proof, `\label`, `\lean`, and `\uses`.
- LaTeX environments balance whole-file: `lemma` 128/128, `proof` 98/98, `array` 4/4.
- No `\leanok` added or removed by me (the keystone and kernel-comparison `\leanok` markers were preserved
  in place during the edits).

## Final `\uses{}` lists set (after the flip)
- `lem:qcoh_section_isLocalizedModule` statement:
  `{lem:qcoh_finite_presentation_cover, lem:qcoh_section_equalizer, lem:localized_module_map_exact_mathlib, lem:tile_section_localization, lem:isLocalizedModule_of_exact, lem:section_isLocalizedModule_of_presentation}`
- `lem:qcoh_section_isLocalizedModule` proof:
  `{lem:qcoh_finite_presentation_cover, lem:qcoh_section_equalizer, lem:localized_module_map_exact_mathlib, lem:tile_section_localization, lem:overlap_section_localization, lem:isLocalizedModule_of_exact, lem:section_isLocalizedModule_of_presentation}`
- `lem:qcoh_section_kernel_comparison` statement & proof:
  `{lem:qcoh_section_isLocalizedModule, lem:isLocalizedModule_linearEquiv_mathlib}`

## `\lean{...}` lists where the three private helpers were bundled
- `lem:overlap_section_localization`:
  `\lean{AlgebraicGeometry.overlap_section_localization, AlgebraicGeometry.overlap_target_eq, AlgebraicGeometry.presheaf_map_comp₂_apply}`

## References consulted
None — all four fixes are Archon-original / project-bespoke reconciliation work (the directive explicitly
omits source lines for these). No citation blocks were written or altered; the pre-existing
`% SOURCE`/`% SOURCE QUOTE` lines on the keystone statement (Stacks 01HV/01I8) were left untouched.

## Macros needed (if any)
None. `\Spec` (used in the new overlap node) is already defined and used elsewhere in the chapter.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- `rem:o1i8_decomposition` (the route-overview remark, ~L5197) still `\uses{... lem:qcoh_section_kernel_comparison ...}`
  and its prose describes "localise the global equalizer at f … giving the kernel comparison". That label
  still exists so no `\uses` is broken, but the remark's narrative now lags the corrected keystone proof
  (the chase lives in the keystone, and kernel_comparison is the packaged corollary). Out of this directive's
  scope (Fix list is the four items); flagging for a future prose refresh if you want the remark to match.

## Strategy-modifying findings
None. The reconciliation is purely a DAG-direction / proof-prose alignment with the iter-047 Lean; the
mathematics and the route are unchanged.
