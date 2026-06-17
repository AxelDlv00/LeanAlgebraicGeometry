# Lean ↔ blueprint check — QuotScheme

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_QuotScheme.tex

## Focus
gap2 was closed this iter. Verify the 11 new decls (Piece A chain L1–L6 + `isQuasicoherent_pullback_fromSpec`
+ `isLocalizedModule_basicOpen`) match their blueprint blocks (`def:over_restrict_unit_iso_inv`,
`def:over_restrict_presentation_inv`, `def:presentation_pullback_iota_preimage`,
`lem:isQuasicoherent_over_preimage`, `lem:coversTop_preimage`,
`lem:isQuasicoherent_pullback_of_isOpenImmersion`, `lem:qcoh_pullback_fromSpec`,
`lem:qcoh_section_localization_basicOpen`) — signatures, `\lean{}` pins, no fake/weakened statements.
Two NEW helpers have NO blueprint block: `pullbackOpenImmersionUnitIso`, `pullbackPreimageιIso` — confirm
and recommend where they slot. Report bidirectionally (Lean→bp and bp→Lean).

## Output
must-fix / major / minor. Report to task_results.
