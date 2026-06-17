# Lean ↔ blueprint check — QuotScheme (iter-042)

Verify one Lean file against its blueprint chapter, bidirectionally.

- Lean file: `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean`
- Blueprint chapter: `/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_QuotScheme.tex`

This iter the prover:
- Closed **G1-core** `Scheme.Modules.isLocalizedModule_basicOpen_of_isQuasicoherent` (line ~2433), which the blueprint already pins via `\lean{...}` at `lem:qcoh_affine_section_localization`. Confirm the `\lean{...}` target name matches the landed decl.
- Added 4 NEW helper decls with NO blueprint block yet (these are expected coverage debt, list them but they are not must-fix): `restrictₗ`, `restrictBasicOpenₗ`, `fromSpec_image_top_section_coherence`, `section_localization_hfr_aux_general`.
- Left **gap2** `Scheme.Modules.isLocalizedModule_basicOpen` (`lem:qcoh_section_localization_basicOpen`) ABSENT (no sorry, no decl) — the blueprint block exists and `\lean{...}`-pins a not-yet-existing decl. Confirm: does the blueprint chapter's `lem:qcoh_section_localization_basicOpen` block adequately describe what remains (the two pieces: QC-preserved-under-pullback-along-fromSpec, and the eqToHom bridge), or is it too thin/misaligned to guide the iter-043 prover?

Report bidirectionally:
1. Lean → blueprint: any landed decl whose `\lean{...}` pin is wrong/missing; any fake/placeholder statement.
2. Blueprint → Lean: any block too thin to have guided this iter's formalization, or that pins a decl name that does not exist.

Flag severity (must-fix-this-iter / major / minor).
