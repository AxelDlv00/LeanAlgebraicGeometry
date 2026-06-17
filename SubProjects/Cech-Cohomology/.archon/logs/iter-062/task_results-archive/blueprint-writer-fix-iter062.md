# Blueprint Writer Report

## Slug
fix-iter062

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### FIX 1 — `lem:slice_structureSheaf_hom` (must-fix #1)
- **Revised** `lem:slice_structureSheaf_hom` — rewrote the STATEMENT to pin the exact Lean type of
  `ψ_r`. It now names the continuous opens-equivalence functor `F : Opens U_i → Opens V_i` (with
  `F.IsContinuous J K` and `F.Final`), states the two structure sheaves as
  `𝒪_{U_i} : Sheaf J RingCat` / `𝒪_{V_i} : Sheaf K RingCat`, types `ψ_r` as
  `𝒪_{U_i} ⟶ (F.sheafPushforwardContinuous RingCat J K).obj 𝒪_{V_i}`, and records the carried instance
  `(SheafOfModules.pushforward ψ_r).IsRightAdjoint`. Dropped the vague "over the slice (over-category)
  picture" phrasing.
  - Proof sketch rewritten: `F`/structure sheaves come from `φ` restricted to `U_i`; `ψ_r` is
    `φ.hom`'s structure-sheaf comparison (`Scheme.Hom.toRingCatSheafHom`) read along `F`, transported
    via the Beck–Chevalley identity `Over.post F ⋙ Over.forget = Over.forget ⋙ F` (rfl); the
    right-adjointness instance follows from `F` being an equivalence.
- **Added Mathlib anchor** `\label{lem:sheafOfModules_pullback_mathlib}` /
  `\lean{SheafOfModules.pullback, SheafOfModules.instIsLeftAdjointPullback}` / `\mathlibok` — the
  continuous-functor pullback functor and its left-adjointness (colimit preservation).
- **Added Mathlib anchor** `\label{lem:sheafPushforwardContinuous_mathlib}` /
  `\lean{CategoryTheory.Functor.sheafPushforwardContinuous}` / `\mathlibok` — the receiving object of
  `ψ_r`'s type.
- **Added Mathlib anchor** `\label{lem:scheme_hom_toRingCatSheafHom_mathlib}` /
  `\lean{AlgebraicGeometry.Scheme.Hom.toRingCatSheafHom}` / `\mathlibok` — the `Scheme.Hom`→ring-sheaf-hom
  step (no pre-existing blueprint node, so authored as the directive instructed).
- **Added Mathlib anchor** `\label{lem:over_post_forget_mathlib}` /
  `\lean{CategoryTheory.Over.post_forget_eq_forget_comp}` / `\mathlibok` — the Beck–Chevalley
  slice-forget identity.

### FIX 2 — `lem:pushforward_slice_pullback_iso` (must-fix #2)
- **Revised** `lem:pushforward_slice_pullback_iso` — LHS made concrete:
  `(pullback ψ_r).obj (H.over U_i) ≅ (Φ.functor.obj H).over V_i`, with `Φ = pushforwardEquivOfIso φ`.
  Removed the vague "H.over W transported" wording (the `pullback ψ_r` functor IS the transport, and
  `H.over U_i` already lies in its domain `SheafOfModules 𝒪_{U_i}`).
  - Proof sketch rewritten to assemble from (a) `pullbackObjUnitToUnit ψ_r`, an iso since `F` is final
    (`instIsIsoPullbackObjUnitToUnitOfFinal`), and (b) the opens-equivalence object identity
    `F.obj U_i = V_i`, stated as **`rfl` on the underlying opens** (image functor sends `W` to
    `φ.inv ⁻¹ᵁ W` definitionally — no `eqToIso` needed). The bare "holds definitionally" claim is gone.
- **Added Mathlib anchor** `\label{lem:pullbackObjUnitToUnit_mathlib}` /
  `\lean{SheafOfModules.pullbackObjUnitToUnit, SheafOfModules.instIsIsoPullbackObjUnitToUnitOfFinal}` /
  `\mathlibok` — the pullback-unit comparison map and its iso-when-final instance.

### FIX 3 — `lem:pushforward_commutes_restriction` contradictory NOTE
- **Revised** `lem:pushforward_commutes_restriction` — resolved the build-target/superseded conflict.
  Removed the `\lean{AlgebraicGeometry.pushforward_commutes_restriction}` hint (replaced with a
  `% formerly planned:` comment) and the "build target" NOTE; kept only the "superseded /
  alternative-route" NOTE, expanded to name the replacement route
  (`lem:slice_structureSheaf_hom` + `lem:pushforward_slice_pullback_iso`) and to note it is on no live
  `\uses` chain. Statement/proof prose untouched; its `\uses` to the two Mathlib anchors remains, so it
  is not isolated.

## Cross-references introduced
- `lem:slice_structureSheaf_hom` `\uses{lem:sheafPushforwardContinuous_mathlib,
  lem:scheme_hom_toRingCatSheafHom_mathlib, lem:over_post_forget_mathlib,
  lem:pushforwardPushforwardEquivalence_mathlib, lem:overEquivalence_isContinuous}` — all targets exist
  (four new in this chapter, two pre-existing).
- `lem:pushforward_slice_pullback_iso` `\uses{lem:slice_structureSheaf_hom,
  lem:sheafOfModules_pullback_mathlib, lem:pullbackObjUnitToUnit_mathlib}` — all targets exist.
- leandag `build --json`: 0 `unknown_uses`, 0 `conflicts`. The single project-wide isolated node is a
  pre-existing `lean_aux` node (not in any chapter), unrelated to this edit. All five new anchors and
  both revised lemmas carry edges.

## Mathlib declarations verified (loogle + local search, this session)
All `\mathlibok` `\lean{}` targets were verified to exist in Mathlib before marking:
- `SheafOfModules.pullback` ✓, `SheafOfModules.instIsLeftAdjointPullback` ✓
- `SheafOfModules.pullbackObjUnitToUnit` ✓, `SheafOfModules.instIsIsoPullbackObjUnitToUnitOfFinal` ✓
- `CategoryTheory.Functor.sheafPushforwardContinuous` ✓ (appears in the verified signatures above)
- `CategoryTheory.Over.post_forget_eq_forget_comp` ✓ (Mathlib/CategoryTheory/Comma/Over/Basic.lean)
- `AlgebraicGeometry.Scheme.Hom.toRingCatSheafHom` ✓ (Mathlib/AlgebraicGeometry/Modules/Presheaf.lean)

## References consulted
None — all edits are Archon-original / Mathlib-anchor blocks. The one external `% SOURCE` block in the
region (`lem:pushforward_iso_preserves_qcoh`, Stacks Project) was NOT touched. No new citation blocks
written, so no `references/` files were opened.

## Macros needed (if any)
None. All commands used (`\operatorname`, `\mathrm`, `\cong`, `\Phi`, etc.) are standard / already in use
in the chapter.

## Notes for Plan Agent
- The two build-target lemmas (`AlgebraicGeometry.sliceStructureSheafHom`,
  `AlgebraicGeometry.pushforwardSlicePullbackIso`) remain unbuilt (`% NOTE: build target` retained, no
  `\leanok`). Their statements are now precise enough to formalize directly against the pinned Mathlib
  API.
- `lem:scheme_hom_toRingCatSheafHom_mathlib` (`Scheme.Hom.toRingCatSheafHom`) lives in
  `Mathlib/AlgebraicGeometry/Modules/Presheaf.lean` and is a `def` (not a `lemma`). It is the
  `\mathlibok` anchor for the structure-sheaf comparison step; the prover building `sliceStructureSheafHom`
  will likely want to read that file for the exact API (it returns the sheaf-of-rings morphism, but the
  precise namespace of the `RingCat`-sheaf target may need a thin adapter — flagged so the prover checks).
- The consumer `lem:pushforward_iso_preserves_qcoh` proof still uses the phrase "H.over W (transported
  across the opens-equivalence)" for `W = U_i`. Per directive this lemma was left as-is; the wording is
  now slightly redundant with the leaner leaf statements (the pullback functor IS the transport) but the
  mathematics is consistent. A future cleanup could align that phrasing, but it is out of scope here.

## Strategy-modifying findings
None.
