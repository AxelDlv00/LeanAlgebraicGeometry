# Blueprint Writer Directive

## Slug
dag-writer-fbc

## Target chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Strategy context
This chapter blueprints flat base change for the i=0 pushforward (FBC route), including the three
adjoint-mate seam lemmas. The Lean file `FlatBaseChange.lean` defines a single helper with **no
blueprint entry** (Lean↔blueprint debt): `base_change_mate_inner_value`, the canonical target value
of Seam 2 (`base_change_mate_fstar_reindex`). Add a concise blueprint entry for it.

## Required content
Add one concise `\definition` block for:
- `AlgebraicGeometry.base_change_mate_inner_value` — the canonical `R`-linear map
  `ρ : M → restrictScalars_ψ ((A ⊗_R R') ⊗_A M)` given on elements by `m ↦ (1 ⊗ 1) ⊗ m`
  (read the def in `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` ~L1019 for the exact
  source/target via the tensor inclusions `ι_A : A → A ⊗_R R'`, `ι_{R'} : R' → A ⊗_R R'`). It is the
  "inner value" against which Seam 2 identifies the pushforward-pseudofunctor reindex of the
  base-change mate; i.e. the `Spec R`-section reading of the inner square leg equals this map.

Give it: a short statement in project notation, `\label{def:base_change_mate_inner_value}`, exact
`\lean{AlgebraicGeometry.base_change_mate_inner_value}`, accurate `\uses{}` (the tensor-inclusion /
restrict-scalars constructions it is built from — keep to labels already in this chapter), and a
one-line note `Proved directly in Lean.` (it is a definition; no proof obligation) — do NOT add
`\leanok`.

**Wire `\uses{}`:** add `\uses{def:base_change_mate_inner_value}` to
`lem:base_change_mate_fstar_reindex` (its statement/proof targets this value). Run
`leandag build --json`; confirm the new block is not isolated and no `\uses{}` is broken.

This helper is **project-internal/Archon-original** — no external citation block required.

## Out of scope
- Do NOT modify the three seam lemmas' statements (`lem:base_change_mate_unit_value`,
  `lem:base_change_mate_fstar_reindex`, `lem:base_change_mate_gstar_transpose`) or any other
  meaningful block, beyond adding the one `\uses{}` edge above.
- Do NOT add `\leanok`. Do NOT touch other chapters.

## References
None required (project-internal definition).

## Expected outcome
The chapter gains one concise definition block for `base_change_mate_inner_value`, wired into
`lem:base_change_mate_fstar_reindex`, so `leandag` reports zero unmatched-lean for this file.
