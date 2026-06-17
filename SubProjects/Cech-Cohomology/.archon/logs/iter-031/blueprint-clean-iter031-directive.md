# blueprint-clean directive — iter-031

## Chapter to clean
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (the consolidated chapter,
`% archon:covers` all 10 Cohomology files). It was just heavily edited by the iter-031
blueprint-writer, which (JOB 1) bundled 50 `…Fam` decls + 3 QcohTilde decls into existing
`\lean{...}` lists, (JOB 2) added CechBridge family-form pins, and (JOB 3) expanded
`rem:o1i8_decomposition` into a P0–P4 `\uses`-chain (`lem:exists_finite_basicOpen_subcover`,
`lem:qcoh_localized_sections`, `lem:qcoh_global_generation`, `lem:qcoh_kernel_qcoh`,
`lem:tilde_preserves_kernels`, `lem:isIso_fromTildeGamma_of_quasicoherent`) plus 3 small
QcohTilde blocks (`free_isQuasicoherent`, `isIso_fromTildeΓ_of_genSections`,
`qcoh_iso_tilde_sections_of_genSections`).

## Your job (purity pass)
1. Strip any Lean syntax / tactic strings that leaked into prose or proof bodies.
2. Strip project-history verbosity ("iter-NNN", "the prover added", "this iter") from the new blocks.
3. Verify every NEW block that derives from a source carries a `% SOURCE:` + verbatim `% SOURCE QUOTE:`
   (original language/notation) + visible `\textit{Source: …}`. The P0–P4 chain anchors to
   `references/stacks-schemes.tex` (the "Quasi-coherent sheaves on affine schemes" section, the
   `lemma-widetilde-pullback` / `lemma-spec-sheaves` / `lemma-kernel-cokernel-quasi-coherent` tags) — open
   that file and CONFIRM the quotes are verbatim; insert/repair any missing or paraphrased quote. P0
   (pure topology) may stand on its informal proof if no single source line fits, but if a Stacks line is
   cited it must be verbatim.
4. Do NOT touch `\leanok` (sync owns it) or `\mathlibok`. Do NOT remove `% NOTE:` annotations.
5. Confirm no broken `\uses{}` (every referenced label exists in the chapter).

## Out of scope
Do not rewrite mathematical content or restructure the P0–P4 chain — the blueprint-writer already
authored it. You are a purity + source-quote-verification pass only.
