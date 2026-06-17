# lean-vs-blueprint-checker directive — iter-028 — QuotScheme

Bidirectionally verify ONE Lean file against ONE blueprint chapter.

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_QuotScheme.tex

## Context for this check
The G1-core lane (Route F) was the objective. The prover added two axiom-clean helpers —
`AlgebraicGeometry.isLocalizedModule_basicOpen_of_presentation` and
`AlgebraicGeometry.map_units_restrict_basicOpen` — but did NOT build the full G1-core
`isLocalizedModule_basicOpen_of_isQuasicoherent`, reporting that it reduces to ONE irreducible
ingredient `isIso_fromTildeΓ_of_isQuasicoherent` (the `QCoh(Spec R) ≃ Mod R` essential-image
gap), and that the chapter's "3-field constructor" decomposition is over-stated because
`surj`/`exists_of_eq` are already delivered in-file by `isLocalizedModule_restrict_of_isIso_fromTildeΓ`.

Check:
- Do the two new helpers have (or lack) corresponding blueprint blocks? (They are currently
  unmatched `lean_aux` nodes — confirm and name the suggested labels.)
- Does the chapter's G1-core / Route-F prose match what the Lean file actually reduces the
  problem to (the single `isIso_fromTildeΓ_of_isQuasicoherent` ingredient)? Flag the
  over-stated 3-field decomposition if the chapter still asserts it.
- Are the chapter's `\mathlibok` anchors (`isIso_fromTildeΓ_of_presentation`,
  `tilde.isUnit_algebraMap_end_basicOpen`, etc.) consistent with how the Lean actually uses them?

Report Lean→blueprint and blueprint→Lean findings with severity.
