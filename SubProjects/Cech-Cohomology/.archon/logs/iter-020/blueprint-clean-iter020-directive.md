# Blueprint-clean directive — iter-020

## Chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` was edited this iter by two subagents:
1. an effort-breaker split `lem:cech_free_complex_quasi_iso` into a 6-link `\uses` chain
   (`lem:quasiIso_of_evaluation`, `lem:cech_free_eval_sectionwise`, `lem:cech_free_eval_empty`,
   `lem:cech_free_eval_prepend_homotopy`, `lem:cech_free_eval_prepend_homotopy_spec`,
   `lem:cech_free_eval_nonempty`);
2. a blueprint-writer added `def:section_cech_module_complex` + `lem:section_cech_module_exact` and
   bundled coverage-debt helpers into several `\lean{...}` lists.

## Task
Run the standard post-write purity pass over this chapter, focused on the newly added/edited blocks
(the 6-link quasi-iso chain + the two new D• blocks):
- Strip any Lean syntax / tactic leakage / project-history verbosity that crept into the prose.
- Verify each new block's `% SOURCE` / `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` is present where the
  statement derives from Stacks (the quasi-iso chain reuses `lemma-homology-complex`,
  references/stacks-cohomology.tex L1198–1285; the D• blocks rest on localisation + Stacks Schemes
  01HV already cited in the chapter). Insert any missing verbatim quote from the local source files;
  do NOT fabricate — if a source is missing, flag it.
- Keep the math intact; do not alter statements or `\lean{}`/`\uses{}` wiring.
- Do NOT touch `\leanok`.

Include `references/**` in scope so a reference-retriever child can be spawned if a quote source is
genuinely absent.
