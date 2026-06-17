# Blueprint Writer Report

## Slug
ts-etabridge

## Status
COMPLETE — D2′ unit-square telescope promoted into named atomic lemma blocks.

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made

### (A) Two landed-supplement blocks pinned
- **Added lemma** `\label{lem:presheaf_unit_comp_map_eta}` /
  `\lean{AlgebraicGeometry.Scheme.Modules.presheafUnit_comp_map_eta}` — presheaf-side unit mate
  identity `presheafAdj.unit ≫ pushforward.map(η F) = ε(pushforward φ')`. Proof sketch: Mathlib's
  `Adjunction.unit_app_unit_comp_map_η` at `pullbackPushforwardAdjunction φ'`, fired by the
  project's `Adjunction.IsMonoidal`-compatible lax/oplax instances.
  `\uses{lem:presheaf_pushforward_laxmonoidal, lem:presheaf_pullback_oplaxmonoidal}`. Verified this
  decl exists axiom-clean in `TensorObjSubstrate.lean:1495`.
- **Added lemma** `\label{lem:isiso_sheafifyeta_of_unitsquare}` /
  `\lean{AlgebraicGeometry.Scheme.Modules.isIso_sheafifyEta_of_unitSquare}` — from the unit square,
  `IsIso (a_Y.map (η F))`. Proof sketch: rearrange the square, chain the three isos
  (`pullbackObjUnitToUnit φ` iso for every `f` via `Opens.map f.base` Final, plus `pullbackValIso`,
  `sheafifyUnitIso`). `\uses{lem:pullback_unit_iso}`. Verified decl at `TensorObjSubstrate.lean:1518`
  (statement matches the file's `hsq` square exactly).

### (B) Unit-square telescope (new atomic targets)
- **Added subsection** "The unit square (D2′): a mate-calculus telescope" with local notation
  preamble (`φ, φ', a_X, a_Y, η F, ε, sheafCounit_•`).
- **Added top-level lemma** `\label{lem:eta_bridge_unit_square}` /
  `\lean{AlgebraicGeometry.Scheme.Modules.pullbackEtaUnitSquare}` (proposed name — not yet in Lean)
  stating the unit square. Proof = transpose across `pullbackPushforwardAdjunction φ` to the
  pushforward-side identity (∗∗), then the **7 numbered atomic steps** (distribute / unit-naturality
  / homEquiv-factor / leftAdjointUniq-transport / comp_unit_app / presheaf-mate / ε-reconcile).
- **Added standalone lemma (step 3 ★)** `\label{lem:comp_homequiv_factor_sheafify_pullback}` /
  `\lean{...compHomEquivFactor}` (proposed) — `(adj₁.comp adj₂).homEquiv g = adj₁.homEquiv(adj₂.homEquiv g)`,
  specialised to the unit square's `A`. `\uses{lem:presheaf_pushforward_laxmonoidal}`.
- **Added standalone lemma (step 4 ★)** `\label{lem:leftadjointuniq_app_unit_eta}` /
  `\lean{...leftAdjointUniqUnitEta}` (proposed) — `A.homEquiv g = B.unit.app 𝟙ᵖ` via
  `homEquiv_leftAdjointUniq_hom_app A B 𝟙ᵖ`, then `comp_unit_app` expansion of `B.unit`.
  `\uses{lem:comp_homequiv_factor_sheafify_pullback}`.
- **Added standalone lemma (step 7 ★)** `\label{lem:epsilon_presheaf_to_sheaf_unit}` /
  `\lean{...epsilonPresheafToSheafUnit}` (proposed) — `ε(pushforward φ) = unitToPushforwardObjUnit φ`,
  reconciling presheaf-level `ε_pre` with sheaf-level `ε_sheaf`.
  `\uses{lem:presheaf_pushforward_laxmonoidal, lem:unitToPushforwardObjUnit_comp}`.
- Step 5 (`comp_unit_app`) folded inline into step 4 (named, no separate block — it carries no
  separable content). Step 6 consumes `lem:presheaf_unit_comp_map_eta`.

### Revised
- **Revised** proof of `lem:pullback_tensor_iso_unit` — now: δ-wrapping reduces to
  `IsIso(a_Y.map η)`; by `lem:isiso_sheafifyeta_of_unitsquare` it suffices to prove the unit square
  `lem:eta_bridge_unit_square`; chaining those plus `lem:pullback_unit_iso` closes D2′. Updated its
  `\uses{}` to `{lem:pullback_tensor_map, lem:isiso_pullbacktensormap_of_sheafifydelta,
  lem:isiso_sheafifyeta_of_unitsquare, lem:eta_bridge_unit_square}`.

## Cross-references introduced
All `\uses{}` targets verified present in this chapter:
- `lem:presheaf_pushforward_laxmonoidal` (L2716), `lem:presheaf_pullback_oplaxmonoidal` (L2754),
  `lem:pullback_unit_iso` (L3242), `lem:pullbackObjUnitToUnit_comp` (L3190),
  `lem:unitToPushforwardObjUnit_comp` (L3150), `lem:isiso_pullbacktensormap_of_sheafifydelta` (L3093),
  `lem:pullback_tensor_map`.
- New intra-section labels all defined in the same edit: `lem:presheaf_unit_comp_map_eta`,
  `lem:isiso_sheafifyeta_of_unitsquare`, `lem:eta_bridge_unit_square`,
  `lem:comp_homequiv_factor_sheafify_pullback`, `lem:leftadjointuniq_app_unit_eta`,
  `lem:epsilon_presheaf_to_sheaf_unit`.

## References consulted
None — project-bespoke categorical mate-calculus; no external source per directive. No `% SOURCE`
lines added. Grounded the prose against the Lean file `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
(the landed `presheafUnit_comp_map_eta`, `isIso_sheafifyEta_of_unitSquare`, `sheafifyUnitIso`,
`pullbackValIso`, and the iter-246 handoff note at L1439–1469) to keep statements decl-accurate.

## Macros needed (if any)
None — used only existing `\Scheme`, `\rhd`, `\mathbin{;}`, `\mathtt`, `\cref`, `\tag`, `equation`,
`enumerate`, `itemize` (all already in use in this chapter / blueprint preamble).

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- The three ★ lemmas and `lem:eta_bridge_unit_square` carry `\lean{}` pins to **proposed** Lean names
  (`compHomEquivFactor`, `leftAdjointUniqUnitEta`, `epsilonPresheafToSheafUnit`, `pullbackEtaUnitSquare`)
  that do **not yet exist** in `TensorObjSubstrate.lean`. They are forward-pins for the fine-grained
  prover to create. `sync_leanok` will leave them unmarked until the decls land — expected.
- The two (A) blocks (`presheafUnit_comp_map_eta`, `isIso_sheafifyEta_of_unitSquare`) pin to decls
  that already exist axiom-clean, so `sync_leanok` should `\leanok` them this iter.
- Step-2 unit-naturality head (the `sheafCounit_X.inv` pull-through) is left as an inline numbered
  claim rather than a standalone lemma; if the prover finds it non-mechanical it is a natural
  candidate for a future `\label` split, but the directive listed only steps 3/4/7 as load-bearing.

## Strategy-modifying findings
None — the chapter content is consistent with the strategy; this is a pure granularity refactor of an
already-blueprinted proof obligation.
