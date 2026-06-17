# Blueprint Writer Report

## Slug
quot-cov

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_QuotScheme.tex

## Changes Made
- **Added definition** `\definition`/`\label{def:over_restrict_unit_iso}`/`\lean{AlgebraicGeometry.Scheme.Modules.overRestrictUnitIso}` — the step-3 slice equivalence functor sends the over-site unit (structure-sheaf) module to the unit module of the open subscheme. `\uses{def:over_restrict_equiv}`.
  - Proof sketch added: Y — pushforward `homMk(𝟙)` form of `unitToPushforwardObjUnit`, iso because the identity ring comparison is iso (auxiliary `isIso_unitToPushforwardObjUnit_of_isIso'` mentioned in prose only, no block, no `\lean{}` pin per directive).
- **Added definition** `\definition`/`\label{def:over_restrict_presentation}`/`\lean{AlgebraicGeometry.Scheme.Modules.overRestrictPresentation}` — transport of a slice presentation `(M.over U)` to a presentation of the geometric pullback `(U.ι^* M)`. `\uses{def:over_restrict_unit_iso, lem:over_restrict_pullback_iso, lem:presentation_map_mathlib}`.
  - Proof sketch added: Y — `Presentation.map` along `(overRestrictEquiv U).functor` (using `def:over_restrict_unit_iso` for the unit), then `Presentation.ofIsIso` across the pullback packaging iso `lem:over_restrict_pullback_iso`.
- **Added definition** `\definition`/`\label{def:presentation_pullback_iota_of_quasicoherentData}`/`\lean{AlgebraicGeometry.Scheme.Modules.presentationPullbackιOfQuasicoherentData}` — per-cover-member geometric presentation `((q.X i).ι^* M).Presentation` from quasi-coherence data. `\uses{def:over_restrict_presentation, lem:quasicoherentData_bind_mathlib}`.
  - Proof sketch added: Y — feed `q.presentation i` to `def:over_restrict_presentation` at `U = q.X i`.
- **Fixed dependencies** `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent` — appended `def:over_restrict_presentation, def:presentation_pullback_iota_of_quasicoherentData` to the **proof block** `\uses{}` (no existing entry removed; the keystone STATEMENT and prose untouched per directive).

All three blocks were inserted immediately before `% --- (P1) Per-element local-tilde transport ---`, under a `% --- (P1 prep) ...` header. No `% SOURCE` lines (project-bespoke, per directive). No `\leanok` added.

## Cross-references introduced
- `def:over_restrict_unit_iso` → `\uses{def:over_restrict_equiv}` (exists, this chapter, line ~3027). ✓
- `def:over_restrict_presentation` → `\uses{def:over_restrict_unit_iso (new), lem:over_restrict_pullback_iso (line ~3195), lem:presentation_map_mathlib (line ~2805)}`. ✓
- `def:presentation_pullback_iota_of_quasicoherentData` → `\uses{def:over_restrict_presentation (new), lem:quasicoherentData_bind_mathlib (line ~2820)}`. ✓
- `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent` proof → appended `\uses{def:over_restrict_presentation, def:presentation_pullback_iota_of_quasicoherentData}`. ✓

## leandag verification
- `leandag build --json`: `unknown_uses: []` (all new `\uses{}` resolve); `unmatched_lean` does not list any of the three new `\lean{}` targets — all three matched their real Lean decls (`overRestrictUnitIso`, `overRestrictPresentation`, `presentationPullbackιOfQuasicoherentData`).
- `lean_aux_nodes` dropped 13 → 10: the three previously-isolated prover helper decls now carry blueprint blocks.
- All three new nodes confirmed present in the DAG and **connected** (non-isolated). The only isolated node remaining in this chapter is the pre-existing `lem:anni...` (annihilator lemma), outside this directive's scope.

## References consulted
None — all three blocks are project-bespoke gap1-C/P1 infrastructure with no external source (per directive; no citation blocks written).

## Macros needed (if any)
None. All commands used (`\mathrm`, `\mathbf{1}`, `\iota`, `\cref`) already in use in the chapter.

## Notes for Plan Agent
- The directive's "add the first two as `\uses{}` of the P1 keystone proof block" was resolved against the explicit label list it gives (`def:over_restrict_presentation, def:presentation_pullback_iota_of_quasicoherentData`) — i.e. Blocks 2 and 3, which are the presentation-transport helpers the keystone proof actually consumes. Block 1 (`def:over_restrict_unit_iso`) is reached transitively via Block 2, so it is not added directly to the keystone's `\uses{}`.
- Pre-existing isolated node `lem:anni...` (annihilator) in this chapter remains isolated — not in scope here; flag for a future coverage pass if it is a live decl missing an edge.

## Strategy-modifying findings
None.
