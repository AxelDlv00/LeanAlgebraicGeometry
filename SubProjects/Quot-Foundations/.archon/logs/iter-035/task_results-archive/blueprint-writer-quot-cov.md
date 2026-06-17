# Blueprint Writer Report

## Slug
quot-cov

## Status
COMPLETE — all six prover-created declarations now have 1-to-1 blueprint blocks, wired into the DAG.

## Target chapter
blueprint/src/chapters/Picard_QuotScheme.tex

## Changes Made
Added six declaration blocks (no `\leanok` — left to `sync_leanok`) in the gap1 P1-prep section,
placed immediately after `def:presentation_pullback_iota_of_quasicoherentData` and before the
basic-open keystone `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent` (their consumer). All are
project-bespoke `Scheme.Modules` infra, so no `% SOURCE`/`% SOURCE QUOTE` — short internal proof only.

- **Added definition** `\label{def:presentation_pullback_iota_restrict}` /
  `\lean{…presentationPullbackιRestrict}` — global presentation on a cover member `Z` restricts to a
  presentation on any open `W ⊆ Z`. `\uses{def:presentation_pullback_iota_of_quasicoherentData,
  def:over_restrict_presentation, lem:presentation_map_mathlib}`. Proof: one `Presentation.map` slice
  then `overRestrictPresentation`.
- **Added definition** `\label{def:opens_map_equiv_of_iso}` / `\lean{…opensMapEquivOfIso}` — the
  inverse-image opens functor of a scheme iso is an equivalence. No project-label `\uses` (Mathlib
  `Opens.mapComp`/`mapId`/`mapIso`, `Scheme.Hom.comp_base` have no anchor — named in prose + `% NOTE`).
  Not isolated: consumed by blocks 3 and 4.
- **Added lemma** `\label{lem:opens_map_final_of_scheme_iso}` / `\lean{…opensMap_final_of_schemeIso}`
  — that functor is `Final`. `\uses{def:opens_map_equiv_of_iso}`. Proof: an equivalence is final.
- **Added definition** `\label{def:pullback_scheme_iso_unit_iso}` / `\lean{…pullbackSchemeIsoUnitIso}`
  — pullback by a scheme iso preserves the unit module. `\uses{def:opens_map_equiv_of_iso,
  lem:opens_map_final_of_scheme_iso}`. Mathlib `pullbackObjUnitToUnit` named in prose + `% NOTE` (no
  anchor). Proof: comparison is iso once the site functor is final.
- **Added definition** `\label{def:presentation_pullback_of_scheme_iso}` /
  `\lean{…presentationPullbackOfSchemeIso}` — transport a presentation across pullback by a scheme iso.
  `\uses{def:pullback_scheme_iso_unit_iso, lem:presentation_map_mathlib, lem:modules_pullback_mathlib}`.
  Proof: `Presentation.map` along the colimit-preserving `pullback φ.inv` (`leftAdjoint_preservesColimits`).
- **Added lemma** `\label{lem:isIso_fromTildeΓ_presentationPullback}` /
  `\lean{…isIso_fromTildeΓ_presentationPullback}` — **general keystone**: `M` restricts to a tilde on
  every affine open `W` of a cover member. `\uses{def:presentation_pullback_iota_restrict,
  def:presentation_pullback_of_scheme_iso, lem:isIso_fromTildeΓ_of_presentation_mathlib}`. Mathlib
  `IsAffineOpen.isoSpec` named in prose + `% NOTE`. The block (statement prose + `% NOTE`) states it is
  STRICTLY MORE GENERAL than `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent` and is the form the
  gap1 descent (D, `lem:section_localization_descent`) consumes per affine cover member.

- **Fixed dependencies** `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent` — added
  `lem:isIso_fromTildeΓ_presentationPullback` to both its statement `\uses{}` and proof `\uses{}` (the
  basic-open case is the affine instance `W = (q.X i).ι ⁻¹ᵁ D(r)` of the general lemma).

## Cross-references introduced
- `\uses{lem:isIso_fromTildeΓ_presentationPullback}` in `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent`
  — new label, defined in same chapter (this round). Verified present via leandag.
- All `\uses` targets confirmed against the chapter: existing labels used are the ACTUAL ones —
  `def:over_restrict_presentation` (a `def:`, not `lem:`), `def:presentation_pullback_iota_of_quasicoherentData`
  (not `lem:presentationPullbackιOfQuasicoherentData`), `lem:isIso_fromTildeΓ_of_presentation_mathlib`
  (the `_mathlib` anchor, not bare `lem:isIso_fromTildeΓ_of_presentation`), `lem:presentation_map_mathlib`,
  `lem:modules_pullback_mathlib`.

## leandag verification
`leandag build --json`: `unknown_uses: []` (no broken refs), all six new nodes matched to their Lean
declarations (no longer in `unmatched_lean`), and none of the six are isolated. `lean_aux_nodes`
dropped accordingly (the six were the isolated aux nodes the directive targeted).

## References consulted
None — all six blocks are project-bespoke `Scheme.Modules` infrastructure (Mathlib presentation/
pullback bookkeeping); per the directive no external SOURCE QUOTE is required.

## Macros needed (if any)
None — used only existing macros (`\Spec`, `\iota`, `\cref`, etc.).

## Notes for Plan Agent
- Four Mathlib results the new blocks lean on have NO blueprint anchor: `Opens.mapComp`/`mapId`/
  `mapIso` + `Scheme.Hom.comp_base` (block 2), `SheafOfModules.pullbackObjUnitToUnit` (block 4), and
  `IsAffineOpen.isoSpec` (block 6). Per the constraint I did NOT invent labels — each is named in prose
  and flagged with a `% NOTE`. If you want these visible as DAG nodes, dispatch a follow-up to author
  `\mathlibok` anchors for them.
- These four are why blocks 2 and 4 carry only project-label `\uses` to their immediate dependents;
  the Mathlib-side edges are intentionally prose-only until anchors exist.

## Strategy-modifying findings
None.
