# Blueprint Clean Directive

## Slug
injcech

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Context

A blueprint-writer round just added a new `\subsection{Presheaf-level Čech machinery}` immediately
before `lem:injective_cech_acyclic`, containing 7 new blocks:
`def:cech_free_presheaf_complex`, `lem:cech_complex_hom_identification`,
`lem:cech_free_complex_quasi_iso`, two `\mathlibok` anchors
(`lem:grothendieck_enough_injectives`, `lem:module_cat_grothendieck`),
`lem:presheaf_modules_enough_injectives`, `lem:cech_delta_functor_presheaves`. It also edited the
`lem:injective_cech_acyclic` proof prose + `\uses{}`, and added one clarifying sentence to the
`lem:cech_to_cohomology_on_basis` statement.

## Tasks (focus on the new/edited blocks, but scan the whole chapter)

1. Strip any Lean leakage / project-history phrasing the writer may have introduced (e.g. "the
   lean-scaffolder will create", "not yet in Mathlib", "to-build", iter references). The blueprint
   must read as timeless mathematics. The phrase that PMod's `IsGrothendieckAbelian` instance is "the
   project-side obligation" should be reworded to a mathematical statement (the category is
   Grothendieck abelian, hence has enough injectives) without prover/process framing.
2. Verify each new derived block has a `% SOURCE:` (with `(read from references/stacks-cohomology.tex)`
   parenthetical) and verbatim `% SOURCE QUOTE:` / `% SOURCE QUOTE PROOF:` matching
   `references/stacks-cohomology.tex` at the cited lines. The two `\mathlibok` anchors carry NO source
   block (the `\lean{}` target is the citation) — that is correct, do not add quotes to them.
3. Confirm `\uses{}`/`\label{}` formatting is correct and the dependency order is acyclic (defs before
   the lemmas that use them).
4. Do NOT touch `\leanok` (deterministic sync owns it). Preserve the two `\mathlibok` markers.
5. Do NOT alter the mathematics or any block outside the new subsection + the two edited blocks.

## References
- `references/stacks-cohomology.tex` — the source for all new quotes (already present locally; no
  retrieval expected).
