# Blueprint-clean — 02KG chapter purity pass (iter-030)

Post-writer purity pass on the single chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`, which a blueprint-writer just
edited (02KG design-fork reconciliation: family-form `injective_cech_acyclic` discharge,
`cover_datum_bridge` repin, `affine_surj_of_vanishing` local-surjectivity route with 4 new
helper/anchor blocks, 01I8 presentation lemma + 3-step decomposition remark).

## Your job
- Strip any Lean tactic syntax / code leakage from prose and proof bodies (mathematical prose only).
- Strip project-history / iter-narrative verbosity from the newly-edited blocks (the math should
  stand on its own; `% NOTE` comments documenting resolved-fork status are acceptable as concise
  pointers but trim anything that reads like a changelog).
- **Validate the verbatim source quotes** the writer added/relied on, especially:
  - `lem:qcoh_iso_tilde_sections_of_presentation` + `rem:o1i8_decomposition` — Tag 01I8 quotes
    claimed from `references/stacks-schemes.tex` (L1279–1387). Confirm the `% SOURCE QUOTE` /
    `% SOURCE QUOTE PROOF` text is genuinely present verbatim in that file (original language,
    character-for-character). If a quote is missing or paraphrased, fix it by reading the source.
  - The `affine_surj_of_vanishing` / injective-acyclic blocks' existing Stacks quotes
    (`stacks-cohomology.tex`, `stacks-coherent.tex`) must remain intact and accurate.
- Do NOT add or remove `\leanok`. Do NOT change `\lean{}` pins or `\uses{}` edges (the writer set
  those; only fix outright LaTeX/quote errors). `\mathlibok` anchors may stay as the writer placed
  them.
- If you spawn a reference-retriever for a missing quote, it may write under `references/**`.

## Report
List what you stripped/fixed and confirm every `% SOURCE QUOTE` in the edited blocks is verbatim-present
in the named local file.
