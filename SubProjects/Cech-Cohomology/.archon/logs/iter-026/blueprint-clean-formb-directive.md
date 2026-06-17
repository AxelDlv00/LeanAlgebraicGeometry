# Directive: purity pass on the absolute-cohomology Form-B rewrite

## Chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` — focus the pass on the newly
edited "Absolute sheaf cohomology as Ext of the corepresenting object" section and the
`lem:cech_to_cohomology_on_basis` (01EO) proof, but scan the whole chapter for regressions.

## What changed this iter (context)
The absolute-cohomology realization was rewritten from Form A (`Ext^p_{Mod(O_U)}(O_U, F|_U)`) to
**Form B** (`H^p(U,F) := Ext^p_{X.Modules}(jShriekOU U, F)`, `jShriekOU U := sheafify(free(yoneda U))`).
New blocks: `def:jshriek_ou`, `lem:jshriek_corepr`. `def:absolute_cohomology` rewritten; the
`restrictFunctor` anchor removed; the 01EO proof prose updated to Form B.

## Pass goals
- Strip any Lean tactic syntax / Lean leakage that crept into prose (the new blocks must be
  math-only).
- Strip project-history / per-iter narrative ("decided iter-NNN", "the analogist said", "Form A vs
  Form B" meta-commentary) from the rendered prose — the blueprint states current mathematics, not
  decision history. (LaTeX `%` comments documenting sources stay.)
- Verify the existing Stacks `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` verbatim comments on
  `lem:cech_to_cohomology_on_basis`, `lem:affine_serre_vanishing`, and the Ext `\mathlibok` anchors
  are intact and unaltered (byte-for-byte). The new `def:jshriek_ou`/`lem:jshriek_corepr` are
  project-original (no external source) — they should carry NO `% SOURCE` line; confirm none was
  fabricated.
- Do NOT add or remove `\leanok`. `\mathlibok` stays only on genuine Mathlib anchors.
- Confirm the section reads cleanly with no leftover Form-A formulas (`Ext^p_{Mod(O_U)}`, `F|_U`,
  `O_U` as a realization object).

## Write domain
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` and `references/**` (for source-quote
validation only).
