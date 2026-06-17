# Blueprint Clean — Cohomology_CechHigherDirectImage.tex (post de-SS rewrite)

## Chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Context
A blueprint-writer just rewrote three proof blocks to remove spectral-sequence arguments
(Route-A migration): `lem:cech_to_cohomology_on_basis`, `lem:open_immersion_pushforward_comp`
part (2), and one sentence of `lem:cech_term_pushforward_acyclic`. Run your standard
post-write cleanup pass on the WHOLE chapter, with attention to the three rewritten blocks.

## Tasks
- Strip any Lean-syntax leakage, tactic strings, or project-history / process narrative
  (`% NOTE (iter-...)`, "to-build", "not yet available in Mathlib") from proof prose.
- Validate that every `% SOURCE QUOTE:` / `% SOURCE QUOTE PROOF:` is verbatim-faithful to
  the cited local reference file and that the `(read from references/<file>)` parenthetical
  names a file that exists. Two quotes were just added: the 01EO proof from
  `references/stacks-cohomology.tex` L1716–1776 (on `lem:cech_to_cohomology_on_basis`) and
  the `lemma-relative-affine-vanishing` proof from `references/stacks-coherent.tex` L187–198
  (on `lem:open_immersion_pushforward_comp`). Verify both against the source files.
- **Specific judgement call for `lem:cech_to_cohomology_on_basis`**: the writer attached the
  Stacks-01EO *embed-into-injective* proof as `% SOURCE QUOTE PROOF:`, but the project's
  written proof body uses the lighter acyclic-resolution route (built from project lemmas
  `lem:cech_augmented_resolution`, `lem:cech_acyclic_affine`,
  `lem:acyclic_resolution_computes_derived`, each already separately cited). If the quoted
  source proof does not mirror the body, prefer treating this block as project-bespoke
  (drop the non-mirroring 01EO `% SOURCE QUOTE PROOF:`, keep the statement `% SOURCE:` +
  `% SOURCE QUOTE:`) rather than leaving a proof quote that argues a different route — a
  source proof quote must match the argument it sits above. Use your judgement per the
  blueprint citation discipline.
- Do NOT touch any STATEMENT, `\lean{}`, `\leanok`, or `\mathlibok`.
- You may spawn a `reference-retriever` if you find a quote that needs a source not present
  (your `--write-domain` includes `references/**`).

## Report
List what you stripped/fixed, the source-quote validation outcome for the two new quotes,
and your decision on the `lem:cech_to_cohomology_on_basis` proof-quote question.
