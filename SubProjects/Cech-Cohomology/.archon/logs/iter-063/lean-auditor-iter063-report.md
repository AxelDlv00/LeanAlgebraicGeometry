# Lean Audit Report

## Slug
iter063

## Iteration
063

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/CechSectionIdentification.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 4 flagged (linter-style; none mathematical)
- **excuse-comments**: 0
- **notes**:

  **Focus declarations — all genuine:**

  - `CategoryTheory.sigmaOptionIso` (line 396): `Iso` record with explicit `hom`/`inv`. Both `hom_inv_id` and `inv_hom_id` are proved via `Sigma.hom_ext`/`coprod.hom_ext` with case-splits on `none`/`some`. No Subsingleton or coherence shortcut. **Genuine.**

  - `AlgebraicGeometry.pushPull_binary_leg_coherence` (private, line 823): After `subst wC`, the `pushPullCoprodLegIso` term's `eqToIso (congrArg ... rfl)` collapses to `Iso.refl _` via `eqToIso_refl`. The first `simp only [...]` block eliminates all transport identity. The remaining goal (verified via `lean_goal` at line 844) has the same `eqToHom ⋯` proof term on both sides; after `simp only [Functor.map_comp, Category.assoc]`, both sides normalize to the identical composition chain, and `rfl` closes a syntactically-equal goal. This is **not** a thin-category coherence collapse — the two sides compute the same map via `Functor.map_comp` normalization. **Genuine.** The 800 000-heartbeat bump is explained in the comments at lines 816–817 (though the linter wants the comment placed after rather than before the `set_option`).

  - `AlgebraicGeometry.pushPull_binary_coprod_prod` (line 855): Uses `isIso_coprodDecompMap` (already proved), `PreservesLimitPair.iso`, and explicit `prod.lift` rewrites (`lift_map`, `comp_lift`). The sub-proof `hcmp` uses `rfl` after unfolding `coprodDecompMap` and applying `lift_fst/snd`; both sides reduce to `prod.lift A B = prod.lift A B`. `asIso (prod.lift ...)` wraps a genuinely-iso map. **Genuine.**

  **Remaining sorries — all honest goal types:**

  - `pushPull_sigma_iso` (line 946): goal `pushPullObj F (...) ≅ ∏ᶜ fun σ => pushPullObj F (Over.mk (coverInterOpen 𝒰 σ).ι)` — genuine hard iso, the Stub-2 new-infra leaf.
  - `pushPull_eval_prod_iso` (line 1033): goal is a sections-level product iso — genuine, depends on Stub 2.
  - `cechSection_complex_iso` (line 1097): goal `D ≅ (sectionCechComplexV 𝒰 F V).augment ε hε` — genuine complex iso.
  - `cechSection_contractible` (line 1164): goal `Homotopy (𝟙 ...) 0` — genuine homotopy goal.

  **Stale/outdated comments:**

  - Lines 695–729: The large embedded planning block (opened `-- **Status (iter-062)**`) contains the subsection `-- **Remaining for L2 `pushPull_binary_coprod_prod` (NOT just the leaf — the `q_*`-assembly).**`. This is stale: `pushPull_binary_coprod_prod` is proved at lines 855–903. A reader of this file will incorrectly infer that the L2 assembly is unproved. (**Major** — see below.)

  - Lines 582–610: Planner-strategy comment for `cechBackbone_left_sigma` lists `Scheme.pullback_openCover_iSup` as a "Key Mathlib anchor", but the actual proof (line 633–636) uses `FinitaryPreExtensive.widePullback_coproduct_iso`. Minor documentation mismatch in a proved declaration.

  - Lines 954–983: Planner-strategy comment for `pushPull_leg_sections` (proved at lines 984–1004). The comment is now historical noise.

  **Bad practices (linter-level, not mathematical):**

  - Line 246: bare `simp` (not `simp only`) in `pcd_hom_fst` — fires `linter.flexible` warning.
  - Line 268: bare `simp` in `pcd_hom_snd` — same.
  - Lines 296, 765, 771, 894: `show` tactic used to change goal form; linter wants `change`. Very minor.
  - Lines 366, 818: `set_option maxHeartbeat …` fires "add comment explaining reason" linter warning. Explanatory comments exist but are positioned *before* rather than *after* the directive (linter expects them after).

---

### AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean

- **outdated comments**: 0 (the `RESIDUAL` block at lines 582–628 is accurate and current)
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 2 flagged
- **excuse-comments**: 0
- **notes**:

  **Focus declarations — all genuine:**

  - `opensMapHomBase_isEquivalence` (line 524): `inferInstanceAs (Opens.mapMapIso ...).functor.IsEquivalence`. Mirror of `opensMapInvBase_isEquivalence` (line 457) with `φ` for `φ.symm`. **Genuine.**

  - `opensEquivOfIso` (line 530): pure definition `Opens.mapMapIso (Scheme.forgetToTop.mapIso φ).symm`. Its functor is defeq `Opens.map φ.inv.base` and inverse defeq `Opens.map φ.hom.base` as stated in the comment. **Genuine.**

  - `sliceOversEquiv` (line 534): `Over.postEquiv Ui (opensEquivOfIso φ)`. The codomain `φ.inv ⁻¹ᵁ Ui` matches `(opensEquivOfIso φ).functor.obj Ui` because `opensEquivOfIso.functor = Opens.map φ.inv.base`. **Genuine.**

  - `sliceOversEquiv_functor_isContinuous` (line 539): delegates to `overPost_slice_isContinuous φ Ui`. Valid iff `(sliceOversEquiv φ Ui).functor` is defeq `Over.post (Opens.map φ.inv.base)`, which holds because `Over.postEquiv` has functor `Over.post eqv.functor`. **Genuine.**

  - `overPost_slice_inverse_isContinuous` (line 549): symmetric to `overPost_slice_isContinuous`, using `coverPreserving_opens_map φ.hom.base` (inverse direction). **Genuine.**

  - `sliceOversEquiv_inverse_isContinuous` (line 561): builds `key` via `@Functor.isContinuous_comp` with 9 explicit arguments, then `rw [sliceOversEquiv, Over.postEquiv_inverse]; exact key`. The explicit arguments are needed because the 5-fold composite defeats instance search; this is a documented project pattern. **Genuine.**

  **Remaining sorries — both honest goal types:**

  - `higherDirectImage_openImmersion_acyclic`, `hqc` case (line 795, confirmed via `lean_goal`): goal is `(SheafOfModules.over ((pushforwardEquivOfIso U.isoSpec).functor.obj H) (U.isoSpec.inv ⁻¹ᵁ qcd.X i)).IsQuasicoherent` — a genuine quasi-coherence instance depending on `pushforwardSlicePullbackIso`. **Honest.**

  - `higherDirectImage_openImmersion_comp` (line 861, confirmed via `lean_goal`): goal is `higherDirectImage f k ((pushforward j).obj H) ≅ higherDirectImage (j ≫ f) k H` — a full body sorry on a non-trivial composition formula. **Honest.**

  **Intra-project code duplication:**

  - Lines 40–50: `CategoryTheory.Functor.isZero_of_faithful_preservesZeroMorphisms` is explicitly documented as "A copy of the same lemma in `CechAugmentedResolution.lean`; reproduced here because that sibling file is not in this file's import chain." Both carry the same fully-qualified name `CategoryTheory.Functor.isZero_of_faithful_preservesZeroMorphisms`. Any consumer that transitively imports both files will encounter a name conflict. This is an intra-project parallel API; the comment documents the intention, but the duplication creates maintenance burden. (**Major** — see below.)

  **Bad practices (linter-level):**

  - Line 472: `set_option linter.style.longLine false in` for `sliceStructureSheafHom` type signature. Necessary given the deeply-nested type; minor.
  - Lines 414, 493: `set_option synthInstance.maxHeartbeats` and `maxHeartbeats` bumps fire the "add comment" linter warning; comments ARE present at lines 413 and 495–496, but the linter requires them after the `set_option`.

  **Minor comment inaccuracy:**

  - Line 726 (inside `hSec` of `higherDirectImage_openImmersion_acyclic`): inline comment reads "Q.obj (op W) ≅ Hᵠ(Γ(W, f_* I•))" — but the morphism in scope is `j : U ⟶ X`, not `f`. Should read `j_*`. (`f` appears in the outer composition-formula theorem; the two were conflated here.)

---

## Must-fix-this-iter

None. No excuse-comments, no weakened sorry types, no suspect bodies on load-bearing claims.

---

## Major

- `CechSectionIdentification.lean:695–729` — Stale embedded planning block: the sub-heading "**Remaining for L2 `pushPull_binary_coprod_prod` (NOT just the leaf — the `q_*`-assembly).**" (and the following ~20 lines of work description) remains in the file after `pushPull_binary_coprod_prod` was proved this iter (lines 855–903). Future readers will incorrectly believe the L2 assembly is unfinished. The whole block starting at `-- **Remaining for L2 …**` through the `-- Then pushPull_coprod_prod…` sentence (approx. lines 703–729) should be pruned or rewritten as a "done" record.

- `OpenImmersionPushforward.lean:40–50` — `CategoryTheory.Functor.isZero_of_faithful_preservesZeroMorphisms` is explicitly duplicated from `CechAugmentedResolution.lean` (comment at line 41). Both carry the identical fully-qualified Lean name. Any future file that imports both `OpenImmersionPushforward` and `CechAugmentedResolution` (directly or transitively) will face a Lean redeclaration error. The fix is to extract it to a shared helper file imported by both.

---

## Minor

- `CechSectionIdentification.lean:582–610` — Planner-strategy comment for `cechBackbone_left_sigma` lists `Scheme.pullback_openCover_iSup` as a key anchor; the actual proof uses `widePullback_coproduct_iso`. Minor documentation drift for a proved declaration.

- `CechSectionIdentification.lean:954–983` — Planner-strategy comment for `pushPull_leg_sections` is now historical (the declaration is proved). Could be removed.

- `CechSectionIdentification.lean:246,268` — Bare `simp` (not `simp only`) in `pcd_hom_fst`/`pcd_hom_snd`; fires `linter.flexible`. Suggest `simp only [...]` with pinned lemma set.

- `CechSectionIdentification.lean:296,765,771,894` — `show` tactic used to change goal form; linter recommends `change`. Very minor style issue.

- `CechSectionIdentification.lean:366,818` — Heartbeat-bump comments are positioned before the `set_option … in` directive rather than after; the linter fires "add a comment" even though comments exist. Cosmetic fix only.

- `OpenImmersionPushforward.lean:726` — Comment uses `f_*` where `j_*` is meant (inside `hSec` of `higherDirectImage_openImmersion_acyclic`).

- `OpenImmersionPushforward.lean:414,493` — Same heartbeat-comment placement issue as in CSI (comment exists but before, not after, the directive).

---

## Excuse-comments (always called out separately)

None found in either file.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2
- **minor**: 7
- **excuse-comments**: 0

Overall verdict: Both files compile clean (errors: 0; sorry-warnings only on the expected Stub-2/4/5/6 and hqc/comp declarations). All focus declarations from iter-063 are genuine — `pushPull_binary_coprod_prod`, `pushPull_binary_leg_coherence` (the `rfl` closes a syntactically-equal goal after correct `Functor.map_comp` normalization, not a thin-category collapse), `sigmaOptionIso`, and all six `sliceOversEquiv`/`opensEquivOfIso` declarations. Remaining sorries have honest, non-weakened goal types. The two major findings are a stale planning comment that misrepresents `pushPull_binary_coprod_prod` as unproved, and an intra-project `isZero_of_faithful_preservesZeroMorphisms` duplication that will cause a name-conflict error if both files are ever jointly imported.
