# Blueprint-clean directive — iter-232

Two chapters received blueprint-writer edits this iter. Run the post-write purity gate on
BOTH: strip any Lean syntax/tactic leakage, remove project-history/iter-narrative verbosity,
validate that every external citation has a `% SOURCE:` + verbatim `% SOURCE QUOTE:` (insert
missing quotes from the named reference files if needed), and confirm LaTeX `\begin`/`\end`
balance.

## Chapters to clean
1. `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` — newly added section: the
   tensor-invertibility carrier group law (`def:pic_carrier`, `lem:isinvertible_tensor`,
   `lem:isinvertible_unit`, `lem:isinvertible_inverse_welldef`, `thm:pic_commgroup`,
   `lem:tensorobj_assoc_iso_invertible`) + a dual-section demotion note + a corrected
   `lem:sheafofmodules_hom_of_local_compat` rationale. Sources: `references/stacks-modules.tex`
   (tags 01CX, 01CR, 0B8M).
2. `blueprint/src/chapters/Cohomology_HigherDirectImage.tex` — newly created chapter
   (`def:higher_direct_image`, `lem:higher_direct_image_quasi_coherent`,
   `lem:higher_direct_image_affine_vanishing`, `thm:flat_base_change_higher`). Sources:
   `references/stacks-coherent.tex` (tags 02KE, 02KG, 02KH).

Do NOT touch `\leanok`/`\mathlibok` markers. Do NOT edit other chapters.
