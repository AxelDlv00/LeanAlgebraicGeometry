# Blueprint Writer Report

## Slug
quot-routef

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_QuotScheme.tex

## Changes Made

### Task 1 — G1-core rewritten to Route F (`lem:qcoh_affine_section_localization`)
- **Revised** the proof body of `lem:qcoh_affine_section_localization`: replaced the four-step
  Route-E cover-refine → local-tilde → **flat-equalizer** descent with the Route-F three-field
  `IsLocalizedModule (powers f)` assembly, mirroring `isLocalization_basicOpen_of_qcqs`.
  - *Shared core (step 1)* called out explicitly as the only manual ingredient also present in the
    equalizer route (extract a finite basic-open tilde cover from `M.QuasicoherentData`; transport
    presentation across `D(g) ≅ Spec R_g`). Noted that Route F sheds the equalizer object and the
    "gₐ generate the unit ideal" obligation.
  - *map_units* via `lem:isUnit_res_basicOpen_mathlib`.
  - *surj* / *exists_of_eq* via `lem:compact_open_induction_mathlib`; base case = affine tilde
    localization (`lem:isIso_fromTildeΓ_of_presentation_mathlib` + `lem:isLocalizedModule_tilde_restrict`);
    inductive step = sheaf Mayer–Vietoris (`lem:isLimitPullbackCone_mathlib`) + unique gluing
    (`lem:existsUnique_gluing_mathlib`).
  - **Updated the proof `\uses{}`** to the Route-F ingredient set (dropped the implicit
    flat-equalizer dependency; the only `\uses` before was `lem:isLocalization_basicOpen_mathlib`,
    retained for the `Γ(Spec R, D(g)) = R_g` step).
  - Statement, `% SOURCE`/`% SOURCE QUOTE` (Stacks 01HA), and `\textit{Source: …}` lines KEPT
    verbatim. The pre-proof `% SOURCE QUOTE PROOF:` meta-comment (which described the now-removed
    flat-localization argument and was a paraphrase, not a verbatim quote) was replaced by a
    `% NOTE:` recording that the proof is the Archon-original Route-F realization (qcqs template),
    so no proof-quote is claimed.
  - Named `isLocalization_basicOpen_of_qcqs` as the structure-sheaf template (anchor + prose).

### Task 2 — coverage-debt blocks for the 4 iter-026 Lean decls + gap1 rewire
New subsection **"G1-assemble: from per-basic-open section localization to the $\widetilde{(-)}$-counit"**
placed immediately after gap1 (`lem:qcoh_affine_isIso_fromTildeΓ`). Added:
- **Added lemma** `lem:bijective_comp_of_localizations` →
  `\lean{AlgebraicGeometry.bijective_comp_of_localizations}` (private). Proof sketch: Y.
- **Added lemma** `lem:isIso_sheaf_of_isIso_app_basicOpen` →
  `\lean{AlgebraicGeometry.isIso_sheaf_of_isIso_app_basicOpen}` (private). Proof sketch: Y.
- **Added lemma** `lem:isIso_fromTildeΓ_of_isLocalizedModule_restrict` (the new **reduction / node 1**)
  → `\lean{AlgebraicGeometry.isIso_fromTildeΓ_of_isLocalizedModule_restrict}`. Proof sketch: Y.
  `\uses{lem:isIso_sheaf_of_isIso_app_basicOpen, lem:bijective_comp_of_localizations,
  lem:isLocalizedModule_tilde_restrict}`.
- **Added lemma** `lem:isIso_fromTildeΓ_iff_isLocalizedModule_restrict` (node 2, iff) →
  `\lean{AlgebraicGeometry.isIso_fromTildeΓ_iff_isLocalizedModule_restrict}`. Proof sketch: Y.
  `\uses` node 1 (reverse) + existing `lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ` (forward).
- **Revised** `lem:qcoh_affine_isIso_fromTildeΓ` (gap1): statement `\uses{}` and proof `\uses{}`
  both updated from `{…, lem:isLocalizedModule_tilde_restrict}` to
  `{lem:qcoh_affine_section_localization, lem:isIso_fromTildeΓ_of_isLocalizedModule_restrict}`, and
  the proof body rewritten to "feed G1-core as the `H` family into the G1-assemble reduction".
  gap1's `\lean{}` was **NOT** re-pointed (per directive — the checker rejected that; signatures differ).

### Task 3 — `\mathlibok` Mathlib-dependency anchors (Route-F + G1-assemble ingredients)
All `\lean{}` targets verified against the local Mathlib checkout before marking `\mathlibok`.
- `lem:isLocalization_basicOpen_of_qcqs_mathlib` → `AlgebraicGeometry.isLocalization_basicOpen_of_qcqs`
- `lem:isLocalizedModule_constructor_mathlib` → `IsLocalizedModule` (the 3-field predicate)
- `lem:isUnit_res_basicOpen_mathlib` → `AlgebraicGeometry.RingedSpace.isUnit_res_basicOpen`
- `lem:isIso_fromTildeΓ_of_presentation_mathlib` → `AlgebraicGeometry.isIso_fromTildeΓ_of_presentation`
  (the affine tilde instance `Tilde.lean:115` is anonymous, so it is folded into this anchor's prose
  and is already wrapped by `lem:isLocalizedModule_tilde_restrict`)
- `lem:compact_open_induction_mathlib` → `AlgebraicGeometry.compact_open_induction_on`
- `lem:isLimitPullbackCone_mathlib` → `TopCat.Sheaf.isLimitPullbackCone`
- `lem:existsUnique_gluing_mathlib` → `TopCat.Sheaf.existsUnique_gluing` (`eq_of_locally_eq'` named in prose)
- `lem:isBasis_basic_opens_mathlib` → `PrimeSpectrum.isBasis_basic_opens`
- `lem:stalkFunctor_map_injective_of_isBasis_mathlib` → `TopCat.Presheaf.stalkFunctor_map_injective_of_isBasis`
- `lem:isIso_of_stalkFunctor_map_iso_mathlib` → `TopCat.Presheaf.isIso_of_stalkFunctor_map_iso`
- `lem:isLocalizedModule_linearEquiv_mathlib` → `IsLocalizedModule.linearEquiv`
- `lem:isLocalizedModule_linearMap_ext_mathlib` → `IsLocalizedModule.linearMap_ext`

`\mathlibok` marked ONLY on these 12 Mathlib anchors. No `\leanok` added anywhere.

## Important correction to the directive
The directive (and `analogies/g1core-affine-descent.md`) name the presentation lemma as
`AlgebraicGeometry.Modules.isIso_fromTildeΓ_of_presentation`. The actual fully-qualified name in the
local Mathlib checkout is **`AlgebraicGeometry.isIso_fromTildeΓ_of_presentation`** (declared directly
under `namespace AlgebraicGeometry` in `Mathlib/AlgebraicGeometry/Modules/Tilde.lean:398`; there is no
`Modules` namespace segment — `section IsQuasicoherent` is a `section`, not a namespace). I used the
verified name in the `\lean{}` so the `\mathlibok` anchor matches the real declaration.

## Cross-references introduced
- G1-core proof now `\uses` the 9 Route-F anchors/lemmas listed above — all defined in this chapter.
- `lem:isIso_fromTildeΓ_of_isLocalizedModule_restrict` `\uses` two new private-helper nodes +
  `lem:isLocalizedModule_tilde_restrict` (this chapter).
- `lem:isIso_fromTildeΓ_iff_isLocalizedModule_restrict` `\uses` node 1 +
  `lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ` (this chapter).
- gap1 now `\uses` G1-core + the new reduction node (this chapter).
- All verified with `leandag`: 0 unknown/broken uses, 0 isolated nodes in `Picard_QuotScheme`,
  lean-aux unmatched nodes = 0 (the 4 iter-026 decls are now matched). All 16 new labels resolve to
  their real Lean/Mathlib declarations in `.leandag/dag.json`.

## References consulted
No `references/**` files were opened: G1-core's external citation (Stacks 01HA `% SOURCE QUOTE`) was
KEPT as-is, the new bridge nodes are Archon-original Lean realizations (no external source quote
required), and the `\mathlibok` anchors cite Mathlib via `\lean{}` only (no prose source). Mathlib
declaration names/namespaces were verified directly against the local checkout under
`.lake/packages/mathlib/` (QuasiSeparated.lean, RingedSpace/Basic.lean, QuasiCompact.lean,
Modules/Tilde.lean, PairwiseIntersections.lean, UniqueGluing.lean) and against the project's own
compiled `AlgebraicJacobian/Picard/QuotScheme.lean`.

## Macros needed (if any)
None new. `\texorpdfstring` (used in the new `\subsection` title) is a standard hyperref macro
already available in the leanblueprint preamble.

## Reference-retriever dispatches (if any)
None — Route F was fully specified in `analogies/g1core-affine-descent.md`.

## Notes for Plan Agent
- The directive/analogy mis-name `isIso_fromTildeΓ_of_presentation` with an extra `Modules.` segment
  (see "Important correction" above). The blueprint now uses the verified name; if any `.lean`
  scaffolding or future directive references `AlgebraicGeometry.Modules.isIso_fromTildeΓ_of_presentation`
  it should be corrected to `AlgebraicGeometry.isIso_fromTildeΓ_of_presentation`.
- `lem:isIso_fromTildeΓ_iff_isLocalizedModule_restrict` (node 2) is currently not consumed by any
  downstream block (gap1 uses node 1 directly). It is not isolated (it has outgoing `\uses`), and it
  is the natural public characterization, so I left it in. If the keystone proof later wants the iff
  form, point it here.

## Strategy-modifying findings
None. Route F is provable as stated; the rewrite is a route-choice change internal to G1-core, not a
strategy-level change.
