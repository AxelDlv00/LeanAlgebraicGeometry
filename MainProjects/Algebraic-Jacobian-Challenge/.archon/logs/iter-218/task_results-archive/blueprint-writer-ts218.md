# Blueprint Writer Report

## Slug
ts218

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made

### Task 1 — repaired two malformed `\uses{...}` blocks
- **Proof of `lem:tensorobj_assoc_iso`** — `\uses` reflowed to contain ONLY labels:
  `\uses{def:scheme_modules_tensorobj, lem:tensorobj_restrict_iso}`. The stray
  `\leanok` token and the two whiskering labels (`lem:whisker_of_W`,
  `lem:islocallyinjective_whisker_of_W`) are dropped (the latter per the re-route in
  Task 3). (Handled jointly with the Task-3 proof rewrite.)
- **Proof of `thm:rel_pic_addcommgroup_via_tensorobj`** — `\uses` reflowed to a single
  well-formed list of the six existing labels (`lem:tensorobj_lift_onproduct,
  lem:pullback_compatible_with_tensorobj, def:scheme_modules_isinvertible,
  lem:tensorobj_isoclass_commgroup, thm:relative_pic_quotient_well_defined,
  lem:rel_pic_sharp_groupoid`); the mis-inserted `\leanok` token after the first comma
  removed. No proof-level `\leanok` remains (proof body is a `sorry`).

**Confirmation:** a multiline grep for `\uses{...\n \leanok` over the whole file
returns NO matches — both `\uses{}` arguments now contain only comma-separated labels.

### Task 2 — pinned the 5 new iter-217 presheaf-level helpers
- **Added lemma** `\label{lem:presheaf_pushforward_adj_substrate}` titled "Presheaf-level
  pushforward adjunction and strong-monoidal restriction (H1/H2 substrate)", placed
  immediately after the `lem:tensorobj_restrict_iso` proof block. Carries
  `\lean{PresheafOfModules.pushforwardNatTrans, PresheafOfModules.pushforwardCongr,
  PresheafOfModules.pushforwardPushforwardAdj, PresheafOfModules.isIso_of_isIso_app,
  PresheafOfModules.restrictScalarsMonoidalOfBijective}` and
  `\uses{def:scheme_modules_tensorobj}`. Prose explains H1 (the three pushforward
  helpers de-sheafify Mathlib's sheaf-level `SheafOfModules.pushforward{NatTrans,Congr,
  PushforwardAdj}` and give `pushforward β ≅ pullback φ` via
  `Adjunction.leftAdjointUniq` against the existing `pullbackPushforwardAdjunction`)
  and H2 (`restrictScalarsMonoidalOfBijective`, built on `isIso_of_isIso_app`, is the
  presheaf-level strong-monoidal `restrictScalars` for a sectionwise-bijective base
  change). Explicitly disambiguates the presheaf/bijective form from the module-level
  ring-equiv form `restrictScalarsMonoidalOfRingEquiv` (already pinned in
  `lem:restrictscalars_ringiso_strongmonoidal`). No `\leanok`. No `% SOURCE` block
  (project-bespoke de-sheafifications; the Mathlib file is named in prose only, not as
  a fabricated verbatim quote).

**Confirmation:** all 5 pins present at the `\lean{...}` of the new block.

### Task 3 — associator re-route promoted to THE proof; whiskering/stalk apparatus unpinned + superseded
- **Rewrote proof of `lem:tensorobj_assoc_iso`** — deleted the "Current realization
  (via whiskering)" paragraph entirely; the former "Planned re-route" is now the proof
  proper (glue `((M⊗N)⊗P)|_U ≅ (M|_U⊗N|_U)⊗P|_U ≅ M|_U⊗(N|_U⊗P|_U) ≅ (M⊗(N⊗P))|_U`
  over a common cover, first/third arrows = `tensorObj_restrict_iso` twice, middle =
  canonical presheaf associator, global iso by Hom-is-a-sheaf gluing with overlap
  agreement from naturality). Updated the stale closing sentence (H1 is closed, so the
  apparatus is superseded rather than "planned for deletion"); kept the note that the
  group law consumes only the existence of the iso (no pentagon/triangle/naturality).
- **Unpinned + marked SUPERSEDED** (removed `\lean{...}`, prepended the one-line
  `% SUPERSEDED route ...` comment; statement prose and `\label{}` kept intact):
  - `lem:flat_whisker_localizer` (was `W_whiskerLeft_of_flat, W_whiskerRight_of_flat`)
  - `lem:isiso_sheafification_map_of_W` (was `isIso_sheafification_map_of_W`)
  - `lem:stalk_linear_map` (was `stalkLinearMap, stalkLinearMap_germ,
    stalkLinearMap_bijective_of_isIso, stalkLinearEquivOfIsIso`)
  - `lem:islocallyinjective_whisker_of_W` (was `isLocallyInjective_whiskerLeft_of_W`)
  - `lem:whisker_of_W` (was `W_whiskerLeft_of_W, W_whiskerRight_of_W`)
  - `lem:jw_ismonoidal` — had NO `\lean{}` pin already; only the `% SUPERSEDED` note
    added.

  Standalone `\leanok` markers on `lem:isiso_sheafification_map_of_W` and
  `lem:islocallyinjective_whisker_of_W` were left untouched (per scope; `sync_leanok`
  will reconcile them once the Lean decls are removed).

**Confirmation:** a grep for `\lean{...W_whiskerLeft_of_flat|isIso_sheafification_map_of_W|
stalkLinearMap|isLocallyInjective_whiskerLeft_of_W|W_whiskerLeft_of_W...}` returns NO
matches — no pin dangles. Cross-refs (`\cref`/`\uses`) to these labels elsewhere were
left intact since the blocks still exist as prose with their labels. This also resolves
the iter-217 prose/pin inconsistency on `lem:islocallyinjective_whisker_of_W`.

### Task 4 — enriched the `exists_tensorObj_inverse` proof
- **Revised proof of `lem:tensorobj_inverse_invertible`** — expanded from a 3-sentence
  sketch to a 3-step argument: (1) `L⁻¹ := Hom(L,O_X)` is a line bundle via
  `LineBundle.IsLocallyTrivial` and the trivialisation `L|_U ≅ O_U`; (2) the
  evaluation/contraction `ε_L : L ⊗ L⁻¹ → O_X` is a local iso, using
  `tensorObj_restrict_iso` to commute `⊗` past `(-)|_U` and `tensorObj_unit_iso`
  (`O_U ⊗ O_U ≅ O_U`); (3) glue — local contraction isos agree on overlaps by
  naturality, and "is-an-isomorphism" is local, giving the global
  `tensorObj L L⁻¹ ≅ unit`. Added `lem:tensorobj_restrict_iso, lem:tensorobj_unit_iso`
  to the proof `\uses`. The construction is mathematically sound (standard
  Stacks 01CR dual+contraction).

### Task 5 — prose hygiene
- No action needed: searched for "skeleton / scaffold / sorry-bodied / 4 sorry" and
  found no iter-202 "file-skeleton scaffold with 4 sorry-bodied declarations" statement.
  All "Skeleton" occurrences are the legitimate `\mathrm{Skeleton}(...)` math
  (`CommRing.Pic`). The intro/§ prose already reflects the closed state (tensorObj,
  functoriality, unitors, braiding, `tensorObj_restrict_iso` all available).

## Cross-references introduced
- `lem:presheaf_pushforward_adj_substrate` → `\cref{lem:tensorobj_restrict_iso}`,
  `\cref{lem:restrictscalars_ringiso_strongmonoidal}` (both exist in this chapter).
- Proof of `lem:tensorobj_inverse_invertible` → `\uses{lem:tensorobj_restrict_iso,
  lem:tensorobj_unit_iso}` (both exist in this chapter).

## References consulted
None opened this session. No new `% SOURCE`/`% SOURCE QUOTE` blocks were written — the
5 new helpers are project-bespoke de-sheafifications (no external citation), and the
enriched inverse proof reuses the already-present Stacks 01CR `% SOURCE QUOTE` on the
`lem:tensorobj_inverse_invertible` statement block (unchanged).

## Macros needed (if any)
None.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- `lem:jw_ismonoidal` never carried a `\lean{}` pin (its Lean `MonoidalCategory`
  instance was never realized), so for it only the `% SUPERSEDED` note was added.
- The standalone `\leanok` on the two unpinned blocks that still have it
  (`lem:isiso_sheafification_map_of_W`, `lem:islocallyinjective_whisker_of_W`) will be
  removed by `sync_leanok` once their Lean declarations are deleted this iter; left
  in place per the directive's marker scope.

## Strategy-modifying findings
None. The `exists_tensorObj_inverse` construction (dual `L⁻¹ = Hom(L,O_X)` + contraction
isomorphism, glued from local trivialisations) is mathematically sound.
