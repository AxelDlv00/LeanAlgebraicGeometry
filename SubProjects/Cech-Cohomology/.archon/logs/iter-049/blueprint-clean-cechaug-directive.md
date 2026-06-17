# Blueprint-clean directive — purify the rewritten `lem:cech_augmented_resolution` proof

## Chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Focus
The `\begin{proof}` of `\label{lem:cech_augmented_resolution}`
(`\lean{AlgebraicGeometry.cechAugmented_exact}`, ~lines 6826–6845) was just rewritten this iter by a
blueprint-writer to the stalk-at-prime / contracting-homotopy argument. Verify it is pure
mathematical prose: strip any Lean identifier leakage (Lean field/def names presented as math,
tactic fragments), fix missing/garbled source quotes, and remove project-history or
planner-narrative verbosity. Confirm the `% SOURCE QUOTE PROOF:` fragment the writer added matches
`references/stacks-coherent.tex` (do not invent quotes; if it doesn't match, flag it).

Do NOT touch markers (`\leanok`/`\mathlibok`/`\lean{}`) or any other block. Light-touch: this is a
single-block purity pass, not a rewrite.

Report to `task_results/blueprint-clean-cechaug.md`.
