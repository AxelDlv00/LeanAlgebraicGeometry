# Blueprint-Clean Report — iter034

## Summary

Purity pass completed over the five blueprint chapters specified in the directive.

## Files Modified

### `blueprint/src/chapters/Picard_RelativeSpec.tex`
**Change 1 — Filled missing SOURCE QUOTE PROOF.**
The `% SOURCE QUOTE PROOF:` for `thm:relative_spec_univ` (line 247) was flagged `TODO`. Retrieved
the verbatim proof text of `lemma-spec` from `references/stacks-constructions.tex` (L553–599) and
replaced the TODO block with the full quoted passage (Zariski sheaf check, subfunctor representability
via `lemma-spec-base-change` + `lemma-spec-affine`, open-subfunctor and coverage arguments).

**Change 2 — Lean leakage in proof body.**
`def:relspec_structure_morphism` proof read
_"Constructed directly in Lean as the base morphism of the relative gluing data…"_ →
_"The structure morphism is the base morphism of the relative gluing data of $\mathcal{A}$; it is
the projection underlying \cref{thm:relative_spec_exists}."_

### `blueprint/src/chapters/Picard_FlatteningStratification.tex`
Four Lean-leakage instances in prose bodies removed (comprehensive purity scope):

| Location | Original | Cleaned |
|---|---|---|
| L240, end of `lem:gf_splice_shortExact` proof | `…returns the displayed sequence. Proved directly in Lean.` | Removed trailing Lean phrase |
| L755–756, `lem:gf_t1_comp_t1_neg` proof | `…Proved directly in Lean.` at end | Removed trailing Lean phrase |
| L872, `lem:gf_finSuccEquiv_map_comm` proof | `Proved directly in Lean by induction on \(q\).` | Replaced with mathematical induction argument |
| L884, `lem:gf_finSuccEquiv_rename_succ` proof | `Proved directly in Lean by induction on \(s\).` | Replaced with mathematical induction argument |

## Files Inspected — No Changes Needed

### `blueprint/src/chapters/Picard_QuotScheme.tex`
New blocks (`def:over_restrict_unit_iso`, `def:over_restrict_presentation`,
`def:presentation_pullback_iota_of_quasicoherentData`) at lines 3229–3317 are clean:
- No Lean tactic syntax in prose bodies of new blocks.
- No iter-references in prose bodies.
- No external citations claimed by these project-bespoke helpers, so no SOURCE QUOTE needed.
- Pre-existing `% NOTE (iter-031):` at line 3112 is a structural formalization-status NOTE — left as is per directive.

### `blueprint/src/chapters/Picard_GrassmannianCells.tex`
New `sec:gr_separated` blocks (lines 1712–1868) are clean:
- `lem:gr_transitionPreMap_minorDet_swap_mul`, `def:gr_diagonalRingMap`,
  `lem:gr_diagonalRingMap_left/right`, `lem:gr_diagonalRingMap_surjective`, `def:gr_pullbackιIso`:
  all have mathematical prose proofs, no Lean leakage.
- `lem:gr_separated` at line 1871 has its `% SOURCE QUOTE:` from Nitsure §1 correctly filled in.
- Pre-existing `% NOTE (formalization status, iter-031):` and `% NOTE (iter-033):` are structural
  formalization-status NOTEs — left as is per directive.

### `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`
New blocks (`lem:base_change_mate_codomain_read_legs` and H⁰-equalizer/eqLocus FBC-B blocks at
lines 3218–3484) are clean:
- No iter-references or Lean tactic syntax in prose bodies of new blocks.
- SOURCE QUOTEs from Stacks Tag 02KH are correctly filled in for blocks that cite it.
- Pre-existing `% NOTE: ... iter-035 refactor` lines are structural formalization-status NOTEs
  (pending refactor annotation) — left as is per directive.

## SOURCE QUOTE Validation Summary

| File | Result |
|---|---|
| Picard_RelativeSpec.tex | Fixed: `thm:relative_spec_univ` proof quote retrieved from Stacks L553–599 |
| Picard_QuotScheme.tex | All SOURCE QUOTEs present and attributed |
| Picard_GrassmannianCells.tex | All SOURCE QUOTEs present and attributed |
| Cohomology_FlatBaseChange.tex | All SOURCE QUOTEs present and attributed |
| Picard_FlatteningStratification.tex | All SOURCE QUOTEs present (pointer-style `see comment above` entries are legitimate back-references, not missing quotes) |

## What Was NOT Changed (Per Directive)
- `\leanok` markers: not added or removed anywhere.
- `\lean{}` pins: not altered.
- `\uses{}` edges: not altered.
- Structural `% NOTE:` markers recording formalization status: preserved in all files.
- Mathematical content of all statements and proofs: preserved.
- Pre-existing "Proved directly in Lean." style in OLD blocks of QuotScheme, GrassmannianCells,
  FlatBaseChange (outside the iter-034 new-block scope): left as-is.
