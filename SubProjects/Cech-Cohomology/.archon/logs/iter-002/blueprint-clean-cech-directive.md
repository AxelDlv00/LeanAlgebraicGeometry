# Blueprint Clean Directive

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Context
This chapter was just edited (iter-002) with a SCOPED fix to two nodes only:
- `lem:cech_to_cohomology_on_basis` gained a verbatim `% SOURCE QUOTE:` from the newly-retrieved
  `references/stacks-cohomology.tex` (Tag 01EO).
- `lem:cech_term_pushforward_acyclic` gained two new dependency sub-lemmas
  (`lem:higher_direct_image_presheaf`, `lem:open_immersion_pushforward_comp`) with verbatim
  Stacks quotes, wired into `\uses{}`.

## Tasks
Apply your standard purity/citation/LaTeX pass, focusing on the just-added blocks. In particular:
- Confirm the new `% SOURCE QUOTE:` blocks are verbatim and that `% SOURCE:` pointers name the
  correct local file (`references/stacks-cohomology.tex` or `references/stacks-coherent.tex`)
  with the `(read from ...)` parenthetical.
- Strip any Lean-implementation leakage or project-history phrasing.
- Do NOT alter the push–pull sub-graph or other out-of-scope blocks beyond purity fixes.
