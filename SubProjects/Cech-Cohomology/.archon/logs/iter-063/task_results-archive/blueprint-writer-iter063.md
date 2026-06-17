# Blueprint Writer Report

## Slug
iter063

## Status
COMPLETE — all three tasks executed; DAG re-verified (no unknown_uses, no conflicts).

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### TASK 1 (Route B, MUST-FIX) — replaced the WRONG `pullbackObjUnitToUnit` proof with the `leftAdjointUniq` route
- **Revised proof** `lem:pushforward_slice_pullback_iso` — deleted the (mathematically wrong)
  unit/free-module argument. New proof is a two-step assembly:
  - Step 1: `pullback ψ_r ≅ pushforward φ''` by uniqueness of left adjoints
    (`leftAdjointUniq (pullbackPushforwardAdjunction ψ_r) adjA`), both functors being left adjoint to
    `pushforward ψ_r`.
  - Step 2: the `rfl`-clean section identity `pushforward φ'' (H.over Uᵢ) ≅ (Φ H).over Vᵢ` via
    `pushforward_obj_obj` (both sides = `Γ(H, φ.hom⁻¹ W.left)`).
  - The prose explicitly states that `pullbackObjUnitToUnit` is NOT the general-H route.
- **Added sub-lemma** `lem:pushforward_slice_two_adjunction`
  (`\lean{AlgebraicGeometry.pushforwardSliceTwoAdjunction}`, build target) — the two-pushforward
  adjunction `pushforward φ'' ⊣ pushforward ψ_r`. Its proof **surfaces the genuine coherence work as
  the substantive content**: the `Over.postEquiv` inverse carries an
  `Over.post(Opens.map φ.hom.base) ∘ Over.map(unitIso.inv)` correction because
  `φ.hom⁻¹(φ.inv⁻¹ Uᵢ) = Uᵢ` is NOT `rfl`, so `φ''`, `H₁`, `H₂` carry `eqToHom`/`Over.map`-correction
  bookkeeping. This is the previously-hidden ~100–150 LOC coherence assembly, now a named target.
- **Added 4 Mathlib anchors** (all `\mathlibok`, `\lean{}` verified against Mathlib via loogle/grep):
  - `lem:leftAdjointUniq_mathlib` → `CategoryTheory.Adjunction.leftAdjointUniq`
  - `lem:pushforwardPushforwardAdj_mathlib` → `SheafOfModules.pushforwardPushforwardAdj`
  - `lem:over_postEquiv_mathlib` → `CategoryTheory.Over.postEquiv` (anchor text states the
    `inverse = Over.post F.inverse ∘ Over.map(unitIso.inv.app X)` correction — confirmed via
    `Over.postEquiv_inverse`)
  - `lem:pullbackPushforwardAdjunction_mathlib` → `SheafOfModules.pullbackPushforwardAdjunction`
- **Fixed dependencies** — statement+proof `\uses{}` of `lem:pushforward_slice_pullback_iso` now
  `{slice_structureSheaf_hom, sheafOfModules_pullback_mathlib, pushforward_slice_two_adjunction,
  leftAdjointUniq_mathlib, pullbackPushforwardAdjunction_mathlib, pushforward_obj_obj_mathlib}`;
  **dropped** `lem:pullbackObjUnitToUnit_mathlib` per directive (no longer the route).

### TASK 2 (Route A) — expanded/decomposed `lem:pushPull_binary_coprod_prod`
- **Revised proof** — rewritten from the sections-only sketch to the full `q_*`-coherence assembly:
  - The comparison is now framed as the **canonical** `prod.lift (pushPullMap F overInl)
    (pushPullMap F overInr)`, with the proof noting this framing is mandatory (downstream Stub 4/5
    require the `.hom` to be this `prod.lift`).
  - `IsIso` proved by matching against the reference chain `q_*M → q_*(P⨯Q) → q_*P ⨯ q_*Q →
    pushPullObj F Y₀ ⨯ Y₁` (coprodDecompMap iso · PreservesLimitPair.iso · prod.mapIso idiso₀ idiso₁),
    with the KEY DEFEQ (pushforwardComp identity-on-objects → idiso₀ codomain transport mostly `rfl`)
    stated. Legs matched via `prod.hom_ext`.
  - The disjoint-union leaf (now the named decl `isIso_coprodDecompMap`) keeps the Mathlib-anchored
    sections argument (`isProductOfDisjoint` / `coprodPresheafObjIso`).
- **Added sub-lemma** `lem:pushPull_binary_leg_coherence`
  (`\lean{AlgebraicGeometry.pushPull_binary_leg_coherence}`, build target) — the per-leg coherence (★):
  `pushPullMap F overInl = (pushforward q).map u₀ ≫ idiso₀.hom`. Proof transcribes the math: unfold via
  `pushPullMap_eq_raw`/`rawPushPullMap_self_gen`, rewrite the unit via
  `unit_leftAdjointUniq_hom_app` (restrictFunctorIsoPullback = leftAdjointUniq), collapse to
  `eqToHom = eqToHom` by proof-irrelevance.
- **Added 1 Mathlib anchor** `lem:unit_leftAdjointUniq_mathlib` →
  `CategoryTheory.Adjunction.unit_leftAdjointUniq_hom_app` (`\mathlibok`, verified via grep).
- **Coverage debt** — added `AlgebraicGeometry.isIso_coprodDecompMap` and
  `AlgebraicGeometry.isIso_map_prodLift_of_isLimit` to the `\lean{}` list of
  `lem:pushPull_binary_coprod_prod` (joining the existing `isIso_prodLift_of_isLimit`,
  `coprodDecompMap`). Both confirmed present in `CechSectionIdentification.lean` (L636, L707).
- **Verified** downstream `lem:pushPull_coprod_prod` and `lem:pushPull_sigma_iso` still
  `\uses{lem:pushPull_binary_coprod_prod}` — unchanged, correct.

### TASK 3 (coverage debt, Route B)
- **Coverage debt** — added the four OpenImm instances to the `\lean{}` list of
  `lem:slice_structureSheaf_hom`: `opensMapInvBase_isEquivalence`, `overPost_slice_isContinuous`,
  `sliceStructureSheafHom_pre_isRightAdjoint`, `sliceStructureSheafHom_isRightAdjoint`. All confirmed
  present in `OpenImmersionPushforward.lean` (L457, L464, L488, L501).

## Cross-references introduced (all verified live via leandag)
- `lem:pushforward_slice_two_adjunction` ← `slice_structureSheaf_hom`, `pushforwardPushforwardAdj_mathlib`,
  `over_postEquiv_mathlib`; → `pushforward_slice_pullback_iso`.
- `lem:pushforward_slice_pullback_iso` ← `pushforward_slice_two_adjunction`, `leftAdjointUniq_mathlib`,
  `pullbackPushforwardAdjunction_mathlib`, `pushforward_obj_obj_mathlib`, `slice_structureSheaf_hom`,
  `sheafOfModules_pullback_mathlib`.
- `lem:pushPull_binary_leg_coherence` ← `def:push_pull_map`, `restrictFunctorIsoPullback_mathlib`,
  `unit_leftAdjointUniq_mathlib`; → `pushPull_binary_coprod_prod`.
- All edges confirmed present in `.leandag/dag.json`; `leandag build --json`: `unknown_uses: []`,
  `conflicts: []`.

## References consulted
- None for new external-source citation blocks. All blocks added/revised this round are either
  Archon-original build targets or Mathlib dependency anchors (no `% SOURCE:` quotes). The Route A
  disjoint-union facts continue to cite the existing Mathlib anchors
  (`lem:coprodPresheafObjIso_mathlib`, `lem:isProductOfDisjoint_mathlib`); no Stacks 02KE/02KG SOURCE
  quote was moved or added. Mathlib `\lean{}` targets were verified directly against the Mathlib
  source (loogle + grep in `.lake/packages/mathlib`), not from memory.

## Macros needed
- None. Used only standard LaTeX (`\dashv`, `\amalg`, `\simeq`, `\times`, `\xrightarrow{\,\sim\,}`,
  `\operatorname`), all already in use elsewhere in the chapter.

## Notes for Plan Agent
- **`lem:pullbackObjUnitToUnit_mathlib` is now isolated** (the directive instructed dropping it from
  the only route that used it; removal was not authorized so I left the block in place). It is a
  faithful Mathlib anchor (`SheafOfModules.pullbackObjUnitToUnit`), just no longer on any live route.
  Consider authorizing its removal next iter, or leave as a reference anchor.
- The other project-wide isolated node `lean:AlgebraicGeometry.CechAcyclic.affine` (a `lean_aux`,
  unmatched Lean decl) is pre-existing and unrelated to this round.
- The three new build-target `\lean{}` names (`pushforwardSliceTwoAdjunction`,
  `pushforward...SlicePullbackIso` already existed, `pushPull_binary_leg_coherence`) have no Lean decl
  yet — they are the named sub-targets the provers now build against, as the directive intended.

## Strategy-modifying findings
None. Both corrections are proof-decomposition/coverage fixes within the existing strategy; no
strategy-level assumption was contradicted.
