# AlgebraicJacobian/Modules/Monoidal.lean

## Iter-080 outcome: experimental stalks-level route **did not close** `instIsMonoidal_W`. **No regression** — 1 sorry preserved.

## File state

- **Sorries**: 1 (unchanged from iter-079).
- **Compilation**: clean. Only diagnostic is the expected `declaration uses 'sorry'` warning at the `instIsMonoidal_W` body (line 166).
- **Axioms**: none introduced.
- **Architecture preserved byte-for-byte** from iter-079: `tensorObj` (L60), `instMonoidalCategoryPresheaf` (L73), `sheafificationFunctor` (L81), `W X` (L89), `sheafificationIsLocalization` (L95), `instMonoidalCategoryStruct` (L175), `instMonoidalCategory` (L182). All three Phase C C0 deliverables (`tensorObj`, `instMonoidalCategoryStruct`, `instMonoidalCategory`) remain in place, with substantive content concentrated in the single `instIsMonoidal_W` gap-fill.
- **Proof body shape preserved** as instructed by plan agent: `refine MorphismProperty.IsMonoidal.mk' _ fun {…} f g hf hg => ?_; simp only [...]; sorry`.
- **Docstring augmented** with iter-080 investigation findings (see below).

## `instIsMonoidal_W` (line ~166)

### Attempt: stalks-level argument via `tensorHom_def` decomposition + stalkwise iso-stability

- **Approach (per iter-080 Lane 3 plan recipe).** After `simp only [MorphismProperty.inverseImage_iff, MorphismProperty.isomorphisms.iff] at hf hg ⊢`, the goal is `IsIso (L (f ⊗ₘ g))` with `hf : IsIso (L f)`, `hg : IsIso (L g)`, where `L = sheafificationFunctor X`. The plan recipe was:
  1. `rw [MonoidalCategory.tensorHom_def, Functor.map_comp]` reduces the goal to `IsIso (L (f ▷ Y₁) ≫ L (X₂ ◁ g))`.
  2. Show `IsIso (L (f ▷ Y₁))` and `IsIso (L (X₂ ◁ g))` separately, then close via `IsIso.comp_isIso'`.
  3. Each whisker iso is shown stalkwise: `(f ▷ Y₁)_x = f_x ⊗_{R₀.stalk x} id_{(Y₁)_x}` (tensor-with-iso of the stalk ring), which is iso whenever `f_x` is iso. The hypothesis `IsIso (L f)` together with `J.WEqualsLocallyBijective AddCommGrpCat` gives `f` locally bijective, equivalent to `f_x` iso stalkwise.

- **Result: FAILED — Mathlib gap.**
  - Verified `rw [MonoidalCategory.tensorHom_def, Functor.map_comp]` cleanly reduces the goal to `IsIso (L (f ▷ Y₁) ≫ L (X₂ ◁ g))` via `lean_multi_attempt` (no errors, single goal remaining).
  - The substantive step blocks at the **stalk-of-presheaf-tensor identification**: `(M ⊗_psh N).stalk x ≅ M.stalk x ⊗_{R₀.stalk x} N.stalk x` (over the stalk ring, in the varying-ring setting). Mathlib provides this for fixed-ring `ModuleCat R` (cf. `Mathlib/Algebra/Category/ModuleCat/Tilde.lean`), and `stalkFunctor` commutes-with-colimits is abstractly available, but the explicit identification for `PresheafOfModules R₀` with varying `R₀` is absent from `Mathlib/Algebra/Category/ModuleCat/Presheaf/Sheafify.lean` and surrounding modules.
  - Verified search via `lean_leansearch` ("stalk presheaf tensor", "colimit tensor product preserves stalk PresheafOfModules") and grep on `Mathlib/Algebra/Category` for `stalk.*tensor` and `tensor.*stalk` returned no relevant identifications. Mathlib has `PresheafOfModules.tensorLeft.PreservesColimitsOfSize` and `PresheafOfModules.tensorRight.PreservesColimitsOfSize` (proving the tensor bifunctor preserves colimits, hence in particular stalks-as-colimits), but the explicit stalk-of-tensor identification has not been packaged.

- **Decision: preserve the existing `simp …; sorry` shape per plan-agent instruction** ("If the route fails, preserve the existing `MorphismProperty.IsMonoidal.mk' _ fun … => by simp …; sorry` shape, with `lean_diagnostic_messages` confirming the same diagnostic as iter-079"). No code change to the proof body. The `Functor.map_comp` rewrite was investigated via `lean_multi_attempt` only (per user policy 2026-05-11, no `lean_run_code` pre-validation, but tactic-attempt previews are allowed); not saved to the file because (a) the plan explicitly asks for shape preservation, and (b) saving the rewrite would not reduce the sorry count — it would only rephrase the same gap.

### Investigation: ruled-out alternative routes (preserved from iter-079, confirmed iter-080)

- **(a) `tensorHom_def` decomposition alone** — circular at the abstract level; reduces to the same whiskerLeft/whiskerRight closure question.

- **(b) `sheafificationCompToSheaf` reduction** — sheafification of `PresheafOfModules` equals sheafification of underlying abelian-grp presheaves (`Mathlib.Algebra.Category.ModuleCat.Presheaf.Sheafification` L72–75). This gives an iso-detection equivalence in `AddCommGrpCat` via `SheafOfModules.toSheaf` (reflects iso) + `presheafToSheaf J AddCommGrpCat`. However: tensor products on the two sides do not commute. The `PresheafOfModules` tensor at section `U` is the $R_0(U)$-balanced tensor in `ModuleCat (R_0(U))`; the abelian-grp tensor at section `U` would be the $\mathbb{Z}$-tensor in `AddCommGrpCat`. These differ. Specifically, `(toPresheaf R₀).map (f ⊗ₘ g)` is NOT the $\mathbb{Z}$-tensor of `(toPresheaf R₀).map f` and `(toPresheaf R₀).map g` — only a quotient of it by the $R_0(U)$-balanced relation. So iso-stability of $\mathbb{Z}$-tensor on the abelian-grp side does not transfer to iso-stability of $R_0(U)$-tensor on the module side.

- **(c) Closedness via internal hom** — `Mathlib/CategoryTheory/Sites/Monoidal.lean:149` proves `J.W.IsMonoidal` for fixed-value sheaves with `MonoidalClosed A` (via `functorEnrichedHom` and `MonoidalClosed.curry`/`uncurry`). For `PresheafOfModules R₀` with varying `R₀`, Mathlib provides `MonoidalClosed` only for fixed-ring `ModuleCat R` (`Mathlib.Algebra.Category.ModuleCat.Monoidal.Closed`), not for varying-ring `PresheafOfModules R₀`. A multi-PR Mathlib upstream effort would be needed to extend the closedness framework to varying-ring presheaves.

### Mathlib names confirmed iter-080 (via `lean_local_search` / `lean_leansearch`)

- `PresheafOfModules.sheafification` — `Mathlib/Algebra/Category/ModuleCat/Presheaf/Sheafification.lean:54`.
- `PresheafOfModules.sheafificationAdjunction` — same file, L123.
- `PresheafOfModules.sheafificationCompToSheaf` — same file, L72.
- `PresheafOfModules.tensorLeft.PreservesColimitsOfSize`,
  `PresheafOfModules.tensorRight.PreservesColimitsOfSize` —
  `Mathlib/Algebra/Category/ModuleCat/Presheaf/Monoidal.lean:237,243`.
- `MonoidalCategory.tensorHom_def` — `Mathlib/CategoryTheory/Monoidal/Category.lean:163`.
- `Functor.map_comp`, `IsIso.comp_isIso'`, `CategoryTheory.IsIso.comp_isIso` (instance).
- `MorphismProperty.IsMonoidal.mk'` — `Mathlib/CategoryTheory/Localization/Monoidal/Basic.lean:50`.
- `MorphismProperty.tensorHom_mem` — same file, L64.
- `GrothendieckTopology.W.monoidal` — `Mathlib/CategoryTheory/Sites/Monoidal.lean:149`.
- `GrothendieckTopology.W.whiskerLeft`, `whiskerRight` — same file, L132, L144.
- `GrothendieckTopology.WEqualsLocallyBijective.iff` — `Mathlib/CategoryTheory/Sites/LocallyBijective.lean:106`.
- `Presheaf.IsLocallyInjective`, `Presheaf.IsLocallySurjective` — `Mathlib/CategoryTheory/Sites/`.

## Dead-end warnings (for next prover round)

Do NOT re-attempt:
- Direct `infer_instance` after `rw [MonoidalCategory.tensorHom_def, Functor.map_comp]` — fails to synthesize `IsIso ((sheafificationFunctor X).map (f ▷ Y₁) ≫ (sheafificationFunctor X).map (X₂ ◁ g))` because the two whisker isos are not derivable. Confirmed via `lean_multi_attempt`.
- `exact MorphismProperty.tensorHom_mem _ _ _ hf hg` — fails because `tensorHom_mem` requires the very `W.IsMonoidal` instance we are constructing. Circular.
- `exact IsIso.comp_isIso (by sorry) (by sorry)` — wrong API; `IsIso.comp_isIso` is an instance, not a function. Use `IsIso.comp_isIso'` (which takes the two hypotheses explicitly).
- All three routes (a), (b), (c) from iter-079 — confirmed blocked by Mathlib gaps.

## Next steps (for plan / iter-081+)

1. **Mathlib upstream PR.** The gap is genuine and reusable beyond this project. The cleanest fix is a Mathlib PR adding `PresheafOfModules.stalk_tensorObj` (or equivalent) establishing `(M ⊗_psh N).stalk x ≅ M.stalk x ⊗_{R₀.stalk x} N.stalk x` for the varying-ring presheaf-of-modules tensor. This would unblock not only this project but also any future formalization needing `MonoidalCategory.Sheaf` for ringed-space-style categories.

2. **Phase C step C1 proceeds regardless.** `instMonoidalCategory` is fully closed (downstream consumers do not see `instIsMonoidal_W`'s sorry; `MonoidalCategory X.Modules` is fully synthesisable). Phase C step C1 — refactoring `LineBundle X` from the `CommRing.Pic` proxy to invertible-$\mathcal{O}_X$-modules — can be dispatched to a refactor subagent in iter-081 without waiting for this sorry to close.

3. **Defer this sorry until Mathlib upstream lands.** Alternative: relax the gap-fill to accept a single project-local axiom expressing the stalk-of-tensor identification, dispatch under user authorization. Not pursued this iter per "no new axioms" hard constraint.

## Blueprint marker

- `def:Modules_tensorObj` (Definition) — already marked `\leanok` (iter-078).
- `thm:Modules_MonoidalCategory` (Theorem) — already marked `\leanok` (statement); proof block remains marked `\leanok` (the proof IS sorry-free at the level of `instMonoidalCategory`; the single sorry in `instIsMonoidal_W` is a sub-lemma in a remark, not the theorem itself). Sub-remark "Status of $W$.IsMonoidal and the stalks-level argument" describes this gap.
- No marker changes for this iteration.

## Summary

- Lane 3 outcome: **structural progress only** (docstring augmented with iter-080 investigation findings, including the precise Mathlib gap identification and the three ruled-out routes). Sorry count: 1 → 1 (no change, as expected per "experimental, failure acceptable" framing).
- The substantive gap is now precisely characterized: **`(M ⊗_psh N).stalk x ≅ M.stalk x ⊗_{R₀.stalk x} N.stalk x`** for varying-ring `PresheafOfModules R₀`. This is a Mathlib upstream concern, not a project-local one.
