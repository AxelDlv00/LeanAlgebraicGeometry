# Blueprint-clean directive — purity pass on the 02KG / 01EO reconcile

Chapter just edited by blueprint-writer `02kg`:
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

The writer (1) reconciled `def:basis_cov_system` to the real 5-field Lean structure, fixed
`[EnoughInjectives]` disclosures + coverage-debt `\lean{}` pins, de-pinned the dead
`CechAcyclic.affine`, and (2) decomposed `lem:affine_serre_vanishing` (Tag 02KG) into an 8-block
`\uses`-chain (`def:affine_cover_system`, `lem:affine_faces_mem`, `lem:standard_cover_cofinal`,
`lem:affine_surj_of_vanishing`, `lem:cover_datum_bridge`, `lem:affine_injective_acyclic`,
`lem:qcoh_iso_tilde_sections`, `lem:affine_cech_vanishing_qcoh`).

Your job (purity only, math-preserving):
- Strip any Lean syntax / tactic leakage, project-history verbosity, or planner-narrative that
  crept into the new/edited blocks.
- Verify every NEW block deriving from a source has a `% SOURCE:` with `(read from references/<file>)`,
  a verbatim `% SOURCE QUOTE:` (and `% SOURCE QUOTE PROOF:` before proofs), and a visible
  `\textit{Source: …}` first line. The sources are local: `references/stacks-schemes.tex` (∩ of
  standard opens L513-517; cofinality L573-577; Tag 01HV L691-719), `references/stacks-sheaves.tex`
  (Tag 009L L3861-3879), `references/stacks-cohomology.tex` (ses-cech-h1 L1592-1605;
  injective-trivial-cech L1407-1422), `references/stacks-coherent.tex` (Tag 02KG L145-173). If a
  quote is missing or paraphrased, insert the verbatim text from the named file.
- Project-bespoke blocks (`lem:cover_datum_bridge`, the BasisCovSystem-encoding glue) correctly omit
  source lines — leave them.
- Do NOT touch `\leanok`/`\mathlibok` markers, do NOT change any mathematics, do NOT edit `\lean{}`
  or `\uses{}` lists.
