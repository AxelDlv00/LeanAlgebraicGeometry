# Reference retrieval directive — Stacks "Sheaves on Spaces" cofinality lemma

## What to fetch
The Stacks Project **Sheaves on Spaces** chapter lemma referenced from `Schemes` as
`sheaves-lemma-cofinal-systems-coverings-standard-case` — the statement that, for verifying a
sheaf condition / for cohomological cofinality, the coverings by **standard opens** of a
distinguished/basic open form a **cofinal system** among all open coverings. This is the lemma
that Stacks "Cohomology of Schemes" Tag **02KG** (Serre vanishing on affines,
`lemma-quasi-coherent-affine-cohomology-zero`) invokes (via Schemes Lemma `lemma-standard-open`,
already in `references/stacks-schemes.tex` L514-577) to discharge condition (2) — cofinality —
of the Čech-to-cohomology basis criterion (Tag 01EO `lemma-cech-vanish-basis`).

Fetch the original TeX (and PDF if available) for the **Sheaves on Spaces** chapter
(`sheaves.tex`) from the Stacks Project, OR at minimum the specific tag for
`lemma-cofinal-systems-coverings-standard-case`. We need the verbatim statement (and proof if
short) to cite in the blueprint with a `% SOURCE QUOTE:` block.

## Why
The 02KG affine-instantiation lane needs to build a `BasisCovSystem` for an affine scheme whose
cofinality field is discharged by exactly this lemma. We have `references/stacks-schemes.tex` (the
Schemes chapter, which *references* it) and `references/stacks-cohomology.tex` (which contains
01EO), but NOT the Sheaves chapter where the cofinality lemma itself lives.

## Output
Download under `references/stacks-sheaves.{tex,pdf}` and write the pointer card
`references/stacks-sheaves.md` (citation + table of contents + the line range of the cofinality
lemma), then add a row to `references/summary.md`. Do NOT paraphrase the lemma into the pointer
card — the card is a pointer; the verbatim text stays in the downloaded source file.
