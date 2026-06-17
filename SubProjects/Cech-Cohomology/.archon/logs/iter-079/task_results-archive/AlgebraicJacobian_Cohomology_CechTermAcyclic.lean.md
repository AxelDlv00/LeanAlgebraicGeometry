# AlgebraicJacobian/Cohomology/CechTermAcyclic.lean

(iter-077, DEEP lane — continuation of this lane's earlier context window.
**FILE COMPLETE: 0 sorries, `lake env lean` exit 0 with ZERO errors, all key decls
kernel-only axiom-clean** — see Summary at the bottom.)

## Baseline finding (start of this context window)

The file as left by the prior context window had the two assigned proofs *written* but the file
did **not** compile (baseline `lake env lean` against the existing oleans):

1. `higherDirectImage_affineHom_acyclic` — typeclass timeout (1,000,000 heartbeats) synthesizing
   `Localization.HasSmallLocalizedHom …` at the `isZero_coyoneda_rightDerived_of_forall_ext_eq_zero`
   step. **Fix:** `attribute [local instance] hasExtModules` (the exact pattern of
   `OpenImmersionPushforward.lean:111`).
2. `cechTerm_pushforward_acyclic` — `pushPull_sigma_iso` was an **unknown identifier**: the
   on-disk `CechAugmentedResolution.olean` is *stale* (Jun 11, predates that file's import of
   `CechSectionIdentification`), so the σ-product decomposition was not in scope. **Fix:** direct
   `import AlgebraicJacobian.Cohomology.CechSectionIdentificationBase` (its olean is fresh).
3. The single `sorry` (per-slice quasi-coherence transport in `isQuasicoherent_pullback_opens`).

## isQuasicoherent_pullback_opens (the assigned sorry)
### Attempt 1 (this window)
- **Approach:** Full general-opens port of the `QcohRestrictBasicOpen.lean` Route-B restrict–over
  bridge (B2–B4), which is generic in the open. New chain (all in this file, ~330 LOC):
  `opens_ι_image_overEquivalence_functor` → continuity instances (`_opens` forms) →
  `overOpensForgetIso`/`overOpensRingHom`/`overOpensForgetInvIso`/`overOpensRingInvHom` →
  engine `modulesOverOpensEquivalence` (via `pushforwardPushforwardEquivalence`) →
  `overOpensIsoRestrict` → `presentationOverOpens` (B2 port, `Over.iteratedSliceEquiv`) →
  unit comparisons `overOpensInverseUnitIso`/`overOpensFunctorUnitIso` →
  `presentationRestrictOfOver` → `presentationRestrictSliceOfOver` (per-slice: image open
  `Wx := V.ι ''ᵁ (V.ι ⁻¹ᵁ A)`, scheme iso via `IsOpenImmersion.isoOfRangeEq`, transport across
  `restrictFunctor φ.hom` with `restrictIsoUnitIso`, then back through the V-side engine) →
  rewired theorem body (`of_coversTop` on `F.restrict V.ι`, final transport along
  `restrictFunctorIsoPullback` via `ObjectProperty.prop_of_iso`).
- **Result:** the whole bridge was developed and verified GREEN in **isolation** against pure
  Mathlib (scratch file `import Mathlib` only — compiles with zero errors), then ported back.
- **Key insights / dead-end warnings for future lanes:**
  - `P.map e.inverse (.refl _)` (the B4 pattern) **no longer elaborates** on the current Mathlib
    pin: `engine.inverse.obj (unit over) ≡ unit sub` is NOT defeq (`with_unfolding_all rfl`
    fails). `QcohRestrictBasicOpen.lean`'s olean is cached; that file will likely need the same
    honest unit isos when next rebuilt from source. The honest construction:
    `Adjunction.leftAdjointUniq (engine adjunction) (pullbackPushforwardAdjunction φ)` +
    `asIso (pullbackObjUnitToUnit φ)` (iso since the over-site equivalence functor is Final).
  - **Elaboration-order trap:** `SheafOfModules.pushforward (overOpensRingInvHom W)` alone fails
    instance synthesis with an all-metavariable goal `IsContinuous ?m ?m ?m`; pin the site
    functor explicitly: `pushforward.{u} (F := (Opens.overEquivalence W).inverse) (…)`.
  - **Discrimination-tree trap:** instance search for `IsIso (pullbackObjUnitToUnit φ)` FAILS when
    the goal's category is displayed as `(↑W).Modules` (head `Scheme.Modules`, non-reducible) —
    the Mathlib instance is keyed at `SheafOfModules`. Establish the instance in a `haveI` whose
    statement never mentions `Scheme.Modules`, then pass it with `@asIso _ _ _ _ _ hIso`.
  - Thin-category coherence goals closed with explicit `congrArg … (Subsingleton.elim _ (𝟙 _))`
    + `map_id` (kernel-safe form), NOT bare `ext`.

## higherDirectImage_affineHom_acyclic
### Attempt (this window)
- **Approach:** `attribute [local instance] hasExtModules` before the section (re-activating the
  file-local instance from `AbsoluteCohomology.lean`, same as `OpenImmersionPushforward.lean`).
- **Result:** (pending final build)

## cechTerm_pushforward_acyclic / rightAcyclic_finite_prod
- `rightAcyclic_finite_prod` compiled already in the baseline (no errors at it).
- `cechTerm_pushforward_acyclic`: unknown-identifier fixed by the direct
  `CechSectionIdentificationBase` import. **(pending final build)**

## Cross-file seam (PLANNER ACTION)
`CechToHigherDirectImage.lean:207` calls `cechTerm_pushforward_acyclic f 𝒰 h𝒰 F hF n` — this does
NOT match the (mathematically forced) signature here, which additionally requires
`[S.IsSeparated]` and the explicit
`hres : ∀ σ : Fin (p+1) → 𝒰.I₀, HasInjectiveResolutions (coverInterOpen 𝒰 σ).toScheme.Modules`
(same Mathlib gap as the frozen target's `[HasInjectiveResolutions X.Modules]`; see this file's
module docstring for the doubled-origin counterexample forcing `[S.IsSeparated]`). The assembly
lane / planner must thread both through `cech_computes_higherDirectImage_of_affineCover`.

## Stale-olean hazard (review-build gate)
`CechAugmentedResolution.olean` (Jun 11) is stale w.r.t. its source (modified Jun 13 01:06, now
imports CechSectionIdentification); `CechSectionIdentificationLeg.olean` is MISSING (Leg source
modified Jun 12 23:23). My verification necessarily rides on the stale oleans (established
build-wall workflow); the review-build gate will rebuild the chain from source.

## Needs blueprint entry
All in `AlgebraicJacobian/Cohomology/CechTermAcyclic.lean` (suggest bundling the small ones into
one or two blocks via multi-name `\lean{}`):
- `opens_ι_image_overEquivalence_functor` (private) — image identity for `Opens.overEquivalence`.
- `overEquivalence_functor_isContinuous_opens`, `overEquivalence_inverse_isContinuous_opens` —
  continuity instances phrased on the `toScheme` carrier (general-opens port).
- `overOpensForgetIso`, `overOpensRingHom`, `overOpensForgetInvIso`, `overOpensRingInvHom` —
  structure-sheaf comparison data of the bridge. Uses: `Opens.overEquivalence` continuity
  instances (QcohRestrictBasicOpen).
- `modulesOverOpensEquivalence` — the bridge engine (general-opens port of
  `modulesOverBasicOpenEquivalence`). Uses: `SheafOfModules.pushforwardPushforwardEquivalence`.
- `overOpensIsoRestrict` — bridge object iso to `M.restrict W.ι`.
- `pushforward_overOpensRingHom_isRightAdjoint`, `pushforward_overOpensRingInvHom_isRightAdjoint`
  — right-adjointness of the engine legs (enables `pullback`).
- `overOpensInverseUnitIso`, `overOpensFunctorUnitIso` — unit comparisons
  (`Adjunction.leftAdjointUniq` + `pullbackObjUnitToUnit`).
- `presentationOverOpens` — B2 port: over-restriction of presentations along `W ≤ U`.
- `presentationRestrictOfOver` — presentation of `M.restrict W.ι` from an over-presentation.
- `pullbackObjUnitToUnit_isIso_of_isIso`, `restrictIsoUnitIso` — unit comparison for restriction
  along a scheme isomorphism (generalizes `pullbackObjUnitToUnit_isIso_basicOpen` /
  `restrictBasicOpenUnitIso`).
- `presentationRestrictSliceOfOver` — the per-slice presentation (the heart of the sorry).
- `isQuasicoherent_pullback_opens` — already referenced informally; needs its own block. Uses:
  all of the above + `SheafOfModules.IsQuasicoherent.of_coversTop`,
  `Scheme.Modules.restrictFunctorIsoPullback`.

## Summary
- **Sorry count: 1 → 0** (plus 3 baseline compile *errors* → 0). Verified by a full
  `lake env lean AlgebraicJacobian/Cohomology/CechTermAcyclic.lean` (exit 0, zero errors, zero
  `sorry` warnings) against the existing import oleans.
- **Sorry closed:** `isQuasicoherent_pullback_opens` (the per-slice quasi-coherence transport),
  via ~330 LOC of new general-opens restrict–over bridge infrastructure (17 new declarations,
  listed under *Needs blueprint entry*). The bridge was first verified green in **isolation**
  against pure Mathlib, then ported.
- **Compile errors fixed (both assigned theorems are now actually green, not just written):**
  `higherDirectImage_affineHom_acyclic` (HasExt synthesis timeout → `attribute [local instance]
  hasExtModules`) and `cechTerm_pushforward_acyclic` (unknown `pushPull_sigma_iso` → direct
  import of `CechSectionIdentificationBase`, dodging the stale `CechAugmentedResolution.olean`).
- **Axiom check (`#print axioms`, all kernel-only `[propext, Classical.choice, Quot.sound]`):**
  `rightAcyclic_finite_prod`, `higherDirectImage_affineHom_acyclic`,
  `isQuasicoherent_pullback_opens`, `presentationRestrictSliceOfOver`,
  `cechTerm_pushforward_acyclic`.
- **Adjacent sorries:** none remain in this file. Other files are other lanes.
- **Blueprint readiness:** `lem:rightAcyclic_finite_prod` and
  `lem:cech_term_pushforward_acyclic` are fully proved and ready for `\leanok`
  (left to `sync_leanok`). NOTE for the planner: `cechTerm_pushforward_acyclic`'s final
  signature carries `[S.IsSeparated]` + the explicit `hres` hypothesis (see *Cross-file seam*);
  the blueprint statement should be aligned.

## Why I stopped
`Real progress` — closed the 1 assigned remaining sorry (`isQuasicoherent_pullback_opens`) and
repaired the 3 baseline compile errors that were silently breaking both previously-written
assigned theorems (`higherDirectImage_affineHom_acyclic`, `cechTerm_pushforward_acyclic`).
Sorry count 1 → 0; error count 3 → 0; the file compiles end-to-end and every key declaration is
kernel-only axiom-clean. Nothing remains in this file's scope. The only open items are outside
my write domain: (a) the sibling `CechToHigherDirectImage.lean` must thread `[S.IsSeparated]` +
`hres` into its call of `cechTerm_pushforward_acyclic` (planner seam, documented above), and
(b) the frozen false-signature `cech_computes_higherDirectImage` (user-owned; TO_USER updated to
record that `[S.IsSeparated]` is also required in any amendment, with the doubled-origin
counterexample).
