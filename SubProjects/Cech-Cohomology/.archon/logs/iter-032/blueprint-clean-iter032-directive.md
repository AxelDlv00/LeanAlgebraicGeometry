# Blueprint-clean directive — iter-032

Purity pass on `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` after the iter-032
blueprint-writer round. Focus on the blocks edited/added this iter:

- New: `lem:isQuasicoherent_restrict_basicOpen` (P1a), `lem:isLocalizedModule_of_span_cover` (P1b).
- Edited: `lem:qcoh_localized_sections` (proof + `\uses` rewritten), `lem:tilde_preserves_kernels`
  (informal proof added), `lem:cech_complex_hom_identification` + `lem:cech_complex_op_identification`
  (`\lean{}` lists extended with 9 `…Fam` helpers).

Checks:
- Strip any Lean syntax / tactic strings / project-history verbosity from prose (math only).
- Verify every `% SOURCE:` / `% SOURCE QUOTE:` / `% SOURCE QUOTE PROOF:` quote is VERBATIM against the
  named local source file (`references/stacks-schemes.tex` for the 01HV / `lemma-widetilde-pullback` /
  `lemma-quasi-coherent-affine` / `lemma-spec-sheaves` quotes). Insert any missing required quote.
- Confirm the visible `\textit{Source: …}` lines are present where a source is cited.
- Do NOT add/remove `\leanok`. Do NOT change `\lean{}` pins or `\uses{}` edges (those are validated).
- Leave the project-bespoke P1b block without source lines (it is pure algebra, no external source) — that is
  correct, not a missing-quote defect.

You MAY spawn a reference-retriever if a required source quote cannot be located locally.
