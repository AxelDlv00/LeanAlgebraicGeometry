# Blueprint-clean directive — iter-030

## Scope
Two chapters were heavily edited this iter and need a purity pass before provers run:

1. `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — an **effort-breaker** split the crux
   `lem:base_change_mate_fstar_reindex_legs` into a `\uses`-linked chain of **5 new link sub-lemmas**
   (`..._link_distribute`, `..._link_collapseComp`, `..._link_cancelEUnit`,
   `..._link_cancelPullbackComp`, `..._link_survivor`) inserted between `..._gammaDistribute` and the
   target (chapter L1693–L1860). The target's proof was rewritten to chain them.

2. `blueprint/src/chapters/Picard_QuotScheme.tex` — a **blueprint-writer** rewrote the gap1 cone per a
   mathlib-analogist corrected decomposition. New/changed blocks around L2462–L3130: mathlib anchors
   (`lem:isLocalization_basicOpen_mathlib`, `lem:presentation_map_mathlib`,
   `lem:quasicoherentData_bind_mathlib`, `lem:existsUnique_gluing_mathlib`,
   `lem:isLocalizedModule_linearEquiv_mathlib`, `lem:isLocalizedModule_linearMap_ext_mathlib`); the two
   project keystones `lem:over_restrict_iso` (C) and `lem:section_localization_descent` (D); the
   transport step `lem:qcoh_affine_section_localization`; and the gap1 keystone
   `lem:qcoh_affine_isIso_fromTildeΓ`.

## Task
Standard blueprint-clean pass on **these two chapters only**:
- Strip any Lean syntax / tactic strings / Lean-name leakage from prose bodies (keep `\lean{...}`,
  `\uses{...}`, `\label{...}`, and `% SOURCE`/`% NOTE` comments).
- Remove project-history / iter-narrative verbosity ("this iter", "the prover last round", attempt logs)
  from prose — the math must stand on its own.
- Validate that every block deriving from an external reference carries a `% SOURCE:` + `% SOURCE QUOTE:`
  with the `(read from references/<file>)` parenthetical, and that the verbatim quote is actually present.
  The QUOT descent (D) cites Stacks 01HA / properties tags and Hartshorne II.5.3; the mathlib anchors are
  Archon-original re-statements of Mathlib decls (no external SOURCE needed beyond the `\lean{}` target).
  If a required source quote is missing and you can retrieve it (you have `references/**` write access to
  spawn a reference-retriever), insert it; otherwise leave a `% SOURCE: ... (verbatim text not yet
  retrieved)` flag.
- Do NOT add or remove `\leanok` (deterministic sync owns it). Do NOT add `\mathlibok` to project
  to-be-proved decls — the existing `\mathlibok` anchors (Mathlib re-exports) are correct and stay.
- Do NOT restructure the math or change `\uses{}` edges — purity/quote-validation only.

## Out of scope
All other chapters. GrassmannianCells was not edited this iter.
