# Blueprint-clean directive — chapter `Cohomology_CechHigherDirectImage.tex`

## Scope
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`. A blueprint-writer just edited the
Sub-lemma B region (around `lem:tile_section_comparison`, `lem:modulesSpecToSheaf_smul_eq`,
`lem:modulesRestrictBasicOpen_smul_eq`). Purify ONLY that region; do not rewrite settled blocks
elsewhere.

## Focus
- Strip any residual Lean leakage from the three blocks above: tactic names (`rfl`, `simp`,
  `congr`, `IsLocalization.Away` used as a Lean lemma rather than the mathematical object), Lean
  identifiers in prose (`ringCatSheaf.map`, `appIso`, `globalSectionsIso`, `modulesSpecToSheaf.obj`),
  and any `% NOTE (review iter-NNN)` / "iter-043" / project-history phrasing. The displayed residual ring
  identity should read as mathematics (`ρ`, `θ`, `β`, `α`, algebra maps), not Lean.
- The two closure "routes (A)/(B)" should be stated as mathematical strategies (Γ–Spec naturality;
  localization uniqueness), not as tactic recipes.
- These three blocks are project-bespoke reconciliations with NO external source — do NOT add
  `% SOURCE`/`% SOURCE QUOTE` lines and do NOT spawn a reference-retriever for them.
- Fix any `\uses{}`/`\label{}` formatting issues you find. Do NOT add or remove `\leanok`.

## Out of scope
Everything outside the Sub-lemma B region. Do not touch `lem:tile_image_opens_identities`,
`lem:tile_section_localization`, the keystone block, or the equalizer blocks.
