# Blueprint-clean directive — iter-021

## Chapter to clean
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Context
A blueprint-writer pass (iter-021) just edited this chapter: it added a `FreeCechEngine` engine block
(`lem:free_cech_engine`), a differential-match node (`lem:cech_free_eval_engine_iso`), a 3-sub-lemma
section-homology chain (`lem:section_cech_product_equiv` / `_coface_match` / `_ab_exact` — names may
differ), three bridge blocks (`homCechComplexMapOpIso` / `sectionCechComplexMapOpIso` /
`hom_into_injective_exact`), and updated several `\lean{}`/`\uses{}` lists.

## Task
Run the standard purity pass over THE EDITED REGIONS (and the chapter as a whole if cheap):
- Strip any Lean-syntax leakage (tactic strings, `:=`, Lean-only operators) from prose/proof bodies —
  keep `\lean{...}` / `\operatorname{...}` math names, which are legitimate.
- Remove project-history / process verbosity that may have crept in (e.g. "the prover", "iter-NNN",
  "churning", "to-be-built", "mid-convergence" as prose — a `% NOTE:` LaTeX comment recording the
  FreeCechEngine-vs-private-CombinatorialCech tradeoff is acceptable to KEEP as a comment but must not
  appear in rendered prose).
- Validate that every `% SOURCE:` / `% SOURCE QUOTE:` block on the new nodes quotes text that actually
  exists in the cited local source file (the new engine/differential-match nodes reuse the
  `lemma-homology-complex` region of `references/stacks-cohomology.tex`; the section nodes reuse
  `references/stacks-coherent.tex`). If a quote is missing or fabricated, fix it from the local source
  (you may spawn a reference-retriever via your `references/**` domain only if a source file is
  genuinely absent — it should not be).
- Do NOT touch `\leanok`. Do NOT change mathematical content. Do NOT remove the `% NOTE:` tradeoff
  comment.
