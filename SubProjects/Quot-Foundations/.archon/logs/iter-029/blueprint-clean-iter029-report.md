# Blueprint Clean — Iter 029 Report

## Summary

Standard purity pass on three chapters (FBC, QUOT, GR) and removal of four orphaned Route-F `\mathlibok` anchors from `Picard_QuotScheme.tex`.

---

## Chapter: Cohomology_FlatBaseChange.tex

**Status: Clean — no changes needed.**

- Tactic strings (`congrArg`, `exact`, `erw`, `rw`, `simp`) are confined to `% NOTE:` comment blocks only (around lines 2174–2187 and 2463–2471). No rendered prose contamination.
- No project-history narrative in rendered prose (one `iter-020` reference in a `%` comment — not rendered).
- No phantom `base_change_regroup_linearEquiv` reference (already removed prior to this iter).
- All `% SOURCE:` citations point to local files under `references/` that exist on disk.

---

## Chapter: Picard_GrassmannianCells.tex

**Status: Clean — no changes needed.**

- Tactic strings (`erw`, `congrArg`, `Iso.inv_comp_eq`) are confined to a single `% NOTE:` comment block at lines 1419–1422 inside `lem:gr_chartTransition'_fac`. No rendered prose contamination.
- No project-history narrative in rendered prose.
- No citation issues.

---

## Chapter: Picard_QuotScheme.tex

**Status: 4 orphaned anchors removed.**

### Anchors removed

The following four Route-F `\mathlibok` lemma blocks were deleted (they described the abandoned direct 3-field `IsLocalizedModule` G1-core descent, which is now superseded by the gap1 corollary approach):

| Label | Lean decl |
|---|---|
| `lem:isLocalization_basicOpen_of_qcqs_mathlib` | `AlgebraicGeometry.isLocalization_basicOpen_of_qcqs` |
| `lem:isLocalizedModule_constructor_mathlib` | `IsLocalizedModule` |
| `lem:isUnit_res_basicOpen_mathlib` | `AlgebraicGeometry.RingedSpace.isUnit_res_basicOpen` |
| `lem:compact_open_induction_mathlib` | `AlgebraicGeometry.compact_open_induction_on` |

The Route-F section comment block was removed together with the three contiguous lemmas above it. The compact-open induction block (which followed `lem:isIso_fromTildeΓ_of_presentation_mathlib`) was removed separately.

### Anchors preserved

- `lem:isIso_fromTildeΓ_of_presentation_mathlib` — kept (8 live `\uses` references in the chapter).
- `lem:tilde_isUnit_algebraMap_end_basicOpen` — kept (the new Mathlib anchor replacing `isUnit_res_basicOpen`).

### Verification

- `grep` confirms none of the four removed labels appear in any `\uses{}`, `\cref{}`, or `\ref{}` anywhere in any chapter.
- `leandag build` ran successfully: **277 nodes, 562 edges**.
- `leandag show isolated` reports **0 isolated nodes**.
- No broken `\uses` introduced.

### Purity pass (QUOT)

- No tactic leakage in rendered prose (all `% NOTE:` blocks are comment-only).
- One `iter-020` reference at line 407 is inside a `%` comment — not rendered.
- No `% SOURCE:` citation issues.
