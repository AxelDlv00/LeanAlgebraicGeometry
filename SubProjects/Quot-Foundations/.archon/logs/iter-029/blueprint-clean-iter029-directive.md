# blueprint-clean directive — iter-029

Three chapters were edited this iter by blueprint-writers. Run the purity gate on them and fix the one
known orphan issue.

## Chapters edited this iter (clean these)
- `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` (FBC — term-mode diamond mechanism folded into
  `lem:base_change_mate_inner_eCancel_assemble` + `lem:base_change_mate_gstar_transpose`; phantom
  `base_change_regroup_linearEquiv` ref removed).
- `blueprint/src/chapters/Picard_QuotScheme.tex` (QUOT — G1-core rewritten as a corollary of gap1; gap1
  elevated + split into `lem:exists_isIso_fromTildeΓ_basicOpen_cover` + Mayer–Vietoris; 2 coverage-debt
  helpers + a `tilde.isUnit_algebraMap_end_basicOpen` `\mathlibok` anchor added).
- `blueprint/src/chapters/Picard_GrassmannianCells.tex` (GR — 4 coverage-debt blocks + `def:gr_glued_scheme`
  expanded with cocycle ring identity + GlueData assembly).

## Standard purity pass (all three)
- Strip any Lean tactic syntax that leaked into RENDERED prose (tactic strings belong only in `% NOTE:`
  comments; the term-mode mechanism note in the FBC chapter must keep `congrArg`/`exact`/etc. inside
  `% NOTE:` comments, not in the theorem/proof body prose).
- Remove project-history / per-iter narrative from rendered prose (iter numbers, "this iter", attempt logs).
- Validate that every `% SOURCE:`/`% SOURCE QUOTE:` present is backed by a real local file under
  `references/` and is verbatim; flag (do NOT fabricate) any citation block lacking a quote.

## Specific fix — remove orphaned Route-F `\mathlibok` anchors (QUOT chapter)
The QUOT writer abandoned the direct 3-field Route-F descent (G1-core is now a corollary of gap1). Four
old Route-F `\mathlibok` anchors are now isolated (no `\uses` in/out): the `isLocalization_basicOpen_of_qcqs`
(qcqs) anchor, the 3-field-constructor anchor, the compact-open-induction anchor, and the
`RingedSpace.isUnit_res_basicOpen` anchor (superseded by the new `tilde.isUnit_algebraMap_end_basicOpen`
anchor). Remove these four orphaned anchor blocks from `Picard_QuotScheme.tex` (they describe a route no
longer taken). Keep the new `tilde.isUnit_algebraMap_end_basicOpen` anchor. After removal, confirm
`leandag` shows no new isolated nodes and no broken `\uses`.

## Do NOT
- Do NOT add or remove `\leanok` (sync_leanok owns it).
- Do NOT alter the mathematical content of the new blocks the writers added — only purity + the orphan removal.
