# Audit directive — QuotScheme.lean (iter-042)

Audit the following Lean file as Lean (no strategy bias):

- `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean`

This iter added 5 new non-private declarations near the end of the file (lines ~2251–2470):

- `Scheme.Modules.restrictₗ` (~2251)
- `Scheme.Modules.restrictBasicOpenₗ` (~2267)
- `Scheme.Modules.fromSpec_image_top_section_coherence` (~2288)
- `Scheme.Modules.section_localization_hfr_aux_general` (~2321)
- `Scheme.Modules.isLocalizedModule_basicOpen_of_isQuasicoherent` (~2433)

Focus areas:
- Honesty of these 5 decls (no vacuous statements, no `sorry`, no trivially-true-by-typo signatures, no defeq abuse via mismatched `letI`/`show` ascriptions that make the statement weaker than intended).
- The `letI : Module … := Module.compHom …` + `show … from restrictₗ M i` idiom used in the conclusion of `section_localization_hfr_aux_general` and in the statement of `isLocalizedModule_basicOpen` — confirm the in-scope module instance is the intended one and not a different/weaker structure.
- Any outdated comments, dead-end proof fragments, or orphaned helpers introduced this iter.
- The 4 pre-existing protected `sorry` stubs at lines 126/165/201/228 are OUT OF SCOPE (frozen iter-176 scaffold) — do not flag them as new.
- The `% NOTE`/docstring "opaque" word at line ~2025 is prose, not a declaration.

Report a per-file checklist plus a flagged-issues block with severity (critical/major/minor).
