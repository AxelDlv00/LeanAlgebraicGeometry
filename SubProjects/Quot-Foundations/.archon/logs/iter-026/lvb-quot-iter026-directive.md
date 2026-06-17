# lean-vs-blueprint-checker — QuotScheme (iter-026)

Compare exactly one Lean file against its blueprint chapter, bidirectionally.

- Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean
- Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_QuotScheme.tex

This iter the prover added 5 axiom-clean declarations (no new sorry) building the
`G1-core ⟹ gap1 ⟹ keystone` bridge:
- `isIso_fromTildeΓ_of_isLocalizedModule_restrict` (public)
- `isIso_fromTildeΓ_iff_isLocalizedModule_restrict` (public)
- `isIso_sheaf_of_isIso_app_basicOpen` (private)
- `bijective_comp_of_localizations` (private)
The assigned keystone target `isLocalizedModule_basicOpen_of_isQuasicoherent` (G1-core) was
NOT built (genuine Stacks-01HA descent, deferred).

Verify:
- Do the new Lean declarations have corresponding blueprint blocks, or are they uncovered
  `lean_aux` nodes the chapter needs to add? (The prover flagged `lem:qcoh_affine_isIso_fromTildeΓ`
  may need its `\lean{}` re-pointed to `isIso_fromTildeΓ_of_isLocalizedModule_restrict`.)
- Is the chapter's G1-core → gap1 → keystone ordering honest (no circular `\uses`)?
- Any signature mismatch or fake/placeholder statement; is the blueprint adequate to guide a
  future G1-core prover (the 4-step cover-refine → flat-equalizer descent)?

Report to your task_results file.
