# lean-vs-blueprint-checker — QuotScheme (iter-033)

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_QuotScheme.tex

This iter added 4 axiom-clean gap1-P1 infrastructure decls
(`isIso_unitToPushforwardObjUnit_of_isIso'`, `overRestrictUnitIso`, `overRestrictPresentation`,
`presentationPullbackιOfQuasicoherentData`) but did NOT build the assigned target
`isIso_fromTildeΓ_restrict_basicOpen` (pinned by lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent;
an existing `% NOTE` already says it does not exist). Check: (a) the 4 new decls are faithful infra
for P1 and not placeholders; (b) the `% NOTE` on the unbuilt target is still accurate; (c) which new
decls need blueprint coverage entries; (d) the 4 file-level `sorry` (lines 126/165/201/228) are the
unchanged protected stubs, not regressions.
