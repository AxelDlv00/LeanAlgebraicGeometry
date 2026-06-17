# Blueprint Writer Report

## Slug
decompose-iter064

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### PART A — decomposed `lem:pushPull_coprod_prod`
Added six new named blocks before `lem:pushPull_coprod_prod` (after `lem:pushPull_binary_leg_coherence`),
kept the coprod_prod STATEMENT + `\lean{}` target, and rewrote its proof to cite them:

- **Added lemma** `lem:pushPullCoprodLegIso` / `\lean{AlgebraicGeometry.pushPullCoprodLegIso}` — coverage
  block for the pre-existing aux leg-iso (the per-leg `idiso` of the binary chain). `\uses{def:push_pull_obj,
  lem:restrictFunctorIsoPullback_mathlib}`. Already built in Lean (matched by leandag).
- **Added lemma** `lem:sigmaOptionIso` / `\lean{CategoryTheory.sigmaOptionIso}` — `Option`-split of an indexed
  coproduct. Already built this iter (matched). `\uses{}` empty (pure category theory).
- **Added lemma** `lem:pushPullObjCongr` / `\lean{AlgebraicGeometry.pushPullObjCongr}` — push–pull transports
  along a slice iso (contravariant; hom uses `e.inv`). Build target. `\uses{def:push_pull_obj, def:push_pull_map}`.
- **Added lemma** `lem:over_sigmaOptionIso` / `\lean{AlgebraicGeometry.overSigmaOptionIso}` — Over-X lift of
  `sigmaOptionIso` via `Over.isoMk` with descent-map compatibility. Build target. `\uses{lem:sigmaOptionIso}`.
- **Added lemma** `lem:piOptionIso` / `\lean{AlgebraicGeometry.piOptionIso}` — product dual of `sigmaOptionIso`.
  Build target. `\uses{}` empty.
- **Added lemma** `lem:pushPull_coprod_prod_empty` / `\lean{AlgebraicGeometry.pushPull_coprod_prod_empty}` —
  empty-index base case (both sides terminal / zero presheaf, reflected via `isIso_modules_of_toPresheaf`).
  Build target. `\uses{def:push_pull_obj, lem:isIso_modules_of_toPresheaf}`.
- **Revised** `lem:pushPull_coprod_prod` — kept statement + `\lean{}`; rewrote the proof as an
  `induction_empty_option` finite-index induction (empty base → reindex via `Pi/Sigma.whiskerEquiv` keeping the
  canonical `Pi.lift` framing → `Option`-adjoin step chaining `pushPullObjCongr ∘ over_sigmaOptionIso ∘
  pushPull_binary_coprod_prod ∘ piOptionIso.symm`). Expanded statement+proof `\uses` to the full sub-lemma list.
- **Fixed dependencies** `lem:pushPull_binary_leg_coherence` — added `lem:pushPullCoprodLegIso` to its
  statement+proof `\uses` (it is the `idiso₀`/`idiso₁` the coherence lemma consumes), so the new coverage
  block is not isolated.

### PART B — decomposed `lem:pushforward_slice_two_adjunction` + CORRECTED φ''
Added 4 Mathlib anchors + 4 new named sub-lemmas before `lem:pushforward_slice_two_adjunction`; corrected the
φ'' definition; rewrote the proof:

- **Added Mathlib anchors** (`\mathlibok`): `lem:opens_mapMapIso_mathlib`
  (`TopologicalSpace.Opens.mapMapIso`), `lem:instIsContinuousOverMapOver_mathlib`
  (`CategoryTheory.GrothendieckTopology.instIsContinuousOverMapOver`), `lem:functor_isContinuous_comp_mathlib`
  (`CategoryTheory.Functor.isContinuous_comp`), `lem:coverPreserving_overPost_mathlib`
  (`CategoryTheory.CoverPreserving.overPost`). All four are genuinely used in compiled
  `OpenImmersionPushforward.lean` (so they exist in Mathlib). `CategoryTheory.Over.postEquiv` anchor
  (`lem:over_postEquiv_mathlib`) already existed — reused for the inverse-correction description.
- **Added lemma** `lem:slice_overs_equiv_continuity` — coverage/anchor block bundling the 6 already-built
  slice-equivalence helpers (`\lean{}` lists all 6: `opensMapHomBase_isEquivalence, opensEquivOfIso,
  sliceOversEquiv, sliceOversEquiv_functor_isContinuous, overPost_slice_inverse_isContinuous,
  sliceOversEquiv_inverse_isContinuous`). Proof sketch via `mapMapIso` defeq + `CoverPreserving.overPost` +
  `isContinuous_comp` + `instIsContinuousOverMapOver`, read through `Over.postEquiv_inverse`.
- **Added lemma** `lem:slice_reverse_ring_map` / `\lean{AlgebraicGeometry.sliceReverseRingMap}` — the CORRECTED
  φ'' of the prover-verified type (codomain along `eqv.inverse`, the correction-carrying inverse), proved
  object-level correction-FREE: `((gt Y).overPullback RingCat Vᵢ).map φ.hom.toRingCatSheafHom` transported
  along the codomain iso via `sheafPushforwardContinuousComp`/`eqToHom`. `\uses{lem:slice_structureSheaf_hom,
  lem:slice_overs_equiv_continuity}`.
- **Added lemma** `lem:pushforward_slice_adjunction_h1` / `\lean{AlgebraicGeometry.pushforwardSliceAdjunctionH1}`
  — counit-naturality square H₁, reduces to `eqToHom = eqToHom` via mutual-inverse `toRingCatSheafHom`.
  `\uses{lem:slice_reverse_ring_map, lem:slice_structureSheaf_hom}`.
- **Added lemma** `lem:pushforward_slice_adjunction_h2` / `\lean{AlgebraicGeometry.pushforwardSliceAdjunctionH2}`
  — unit-triangle square H₂, same shape. `\uses{lem:slice_reverse_ring_map, lem:slice_structureSheaf_hom}`.
- **Revised** `lem:pushforward_slice_two_adjunction` — kept statement (adjunction) + `\lean{}`. CORRECTED the
  φ'' definition: was `φ'' = sliceStructureSheafHom φ⁻¹ Vᵢ` (provably wrong — wrong slice/landing), now φ'' is
  the reverse slice ring map of `lem:slice_reverse_ring_map` along the corrected
  `(sliceOversEquiv φ Uᵢ).inverse`. Rewrote the proof to feed `adj = (sliceOversEquiv φ Uᵢ).symm.toAdjunction`,
  φ'', ψ_r, H₁, H₂ to `pushforwardPushforwardAdj`. Updated statement+proof `\uses` to the full list.
- **Fixed dependencies** `lem:pushforward_slice_pullback_iso` — added `lem:slice_reverse_ring_map` to its
  statement+proof `\uses`, and corrected the in-proof φ'' reference (was the wrong
  `sliceStructureSheafHom φ⁻¹ Vᵢ`; now cites `lem:slice_reverse_ring_map`). Statement + conclusion unchanged.

## Cross-references introduced
All new `\uses{}` resolve to labels existing in the chapter after the edits. `leandag build --json` reports
`unknown_uses: []` (no broken refs). New build-target lean decls (overSigmaOptionIso, piOptionIso,
pushPullObjCongr, pushPull_coprod_prod_empty, sliceReverseRingMap, pushforwardSliceAdjunctionH1/H2) appear in
`unmatched_lean` as expected (not yet built). The already-built targets (`sigmaOptionIso`,
`pushPullCoprodLegIso`, all 6 continuity helpers) and the 4 new `\mathlibok` anchors are handled (matched /
mathlib_ok). The two isolated nodes leandag reports (`lem:pullbackObjUnitToUnit_mathlib`, the
`CechAcyclic.affine` lean_aux) both pre-date this edit and are out of scope.

## References consulted
None — both decomposed chains are Archon-original / project-bespoke categorical bookkeeping over Mathlib's
scheme-module API (per directive: no external source quote required). No citation blocks written; no
reference-retriever dispatched.

## Macros needed (if any)
None — all prose uses existing `\operatorname`/standard math; no new shared macros required.

## Notes for Plan Agent
- Verification done: `\begin{}/\end{}` balanced (lemma 235/235, proof 169/169, definition 32/32); `leandag`
  parses 289 blueprint nodes / 183 proof blocks with `unknown_uses: []` and zero conflicts.
- `% NOTE: build target` markers on `lem:pushPull_coprod_prod` and `lem:pushforward_slice_two_adjunction` were
  left in place per directive (review/sync own them). `lem:pushPull_binary_leg_coherence` had no NOTE marker to
  remove. The coprod_prod NOTE text is now stale (the 6-sub-lemma decomposition it forecasts has been authored).
- `lem:pushPull_sigma_iso` (item 7) left unchanged — its `\uses` already correctly points at
  `lem:pushPull_coprod_prod`; the optional `pushPullObjCongr`/`overSigmaDescIso` note was not needed to keep the
  edge accurate.

## Strategy-modifying findings
None.
