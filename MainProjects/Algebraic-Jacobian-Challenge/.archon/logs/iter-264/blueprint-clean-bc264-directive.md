# Blueprint-clean directive — bc264

Two chapters were edited this iter by blueprint-writers (bw-tos264, bw-cech264). Purify them:
strip Lean tactic syntax / over-heavy Lean-API name dumps that read as code rather than mathematics,
remove any project-history / iteration narrative, trim verbosity, and validate that all existing
`% SOURCE` / `% SOURCE QUOTE` blocks remain intact and correctly formatted. Do NOT change mathematical
content, do NOT add/remove `\leanok`/`\mathlibok`, do NOT touch `\lean{}`/`\uses{}` hints (those are
intentional). Keep the named-Mathlib-lemma proof-sketch hints (`conjugateEquiv_*`, `pseudofunctor_*`,
`homEquiv_leftAdjointUniq_hom_app`, `restrictScalars.smul_def'`, etc.) — they are deliberate prover
guidance per the writer directives — but ensure they read as named-lemma references in prose, not as
Lean tactic blocks.

## Chapters to clean
- `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (bw-tos264 edits: `lem:slice_dual_transport`
  naturality/invFun/map_smul', `lem:pullback_tensor_map_basechange` Sq1 tail + Sq4)
- `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (bw-cech264 edits: `sec:cech_three_part`
  dependency-claim correction, `lem:push_pull_functor` functor-law block, `\lean{}` pins)

## Out of scope
Any other chapter. If a `% SOURCE QUOTE` block is missing for a NEW externally-sourced claim, you may
dispatch a reference-retriever — but both chapters' new content is project-bespoke (no external source),
so none should be needed.
