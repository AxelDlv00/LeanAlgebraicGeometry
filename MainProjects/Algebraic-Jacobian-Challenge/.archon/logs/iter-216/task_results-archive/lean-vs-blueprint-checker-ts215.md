# Lean ↔ Blueprint Check Report

## Slug
ts215

## Iteration
215

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (1171 lines)
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (1837 lines)

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (chapter: `def:scheme_modules_tensorobj`)
- **Lean target exists**: yes (line 743)
- **Signature matches**: yes — `{X : Scheme.{u}} (M N : X.Modules) : X.Modules`, matches blueprint's "for M, N ∈ Scheme.Modules X, define M ⊗_X N ∈ Scheme.Modules X"
- **Proof follows sketch**: yes — body is `sheafification.obj (PresheafOfModules.Monoidal.tensorObj M.val N.val)`, matching blueprint's "presheaf-of-modules tensor product composed with sheafification on the small Zariski site"
- **notes**: No sorry. Body is substantive. `\leanok` marker correct.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` (chapter: `lem:scheme_modules_tensorobj_functoriality`)
- **Lean target exists**: yes (line 759)
- **Signature matches**: yes — `(f : M ⟶ M') (g : N ⟶ N') : tensorObj M N ⟶ tensorObj M' N'`
- **Proof follows sketch**: yes — inherits morphism action from `PresheafOfModules.Monoidal.tensorHom` under sheafification, matching blueprint
- **notes**: No sorry. `\leanok` correct.

### `\lean{PresheafOfModules.restrictScalarsLaxMonoidal}` (chapter: `lem:restrictscalars_laxmonoidal`)
- **Lean target exists**: yes (line 250)
- **Signature matches**: yes — instance for `(restrictScalars α).LaxMonoidal` over `CommRingCat`-valued presheaves, with helpers `restrictScalarsLaxε` (line 217) and `restrictScalarsLaxμ` (line 233)
- **Proof follows sketch**: yes — sectionwise lift of `ModuleCat.restrictScalars (α.app X).LaxMonoidal`, as described in blueprint; all six axioms (μ_natural_left, μ_natural_right, associativity, left_unitality, right_unitality) assembled sectionwise
- **notes**: `\leanok` correct. Off critical path per blueprint `% NOTE:` annotation.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso}` (chapter: `lem:tensorobj_restrict_iso`)
- **Lean target exists**: yes (line 1004)
- **Signature matches**: yes — `{X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f] (M N : X.Modules) : (tensorObj M N).restrict f ≅ tensorObj (M.restrict f) (N.restrict f)`; matches blueprint's open-immersion restriction-compatibility statement for arbitrary M, N
- **Proof follows sketch**: partial — Steps 1–3 (reduce to pullback, move pullback inside sheafification, strip outer sheafification) are implemented; Step 4 (presheaf-level residual) is `sorry` at line 1082. Blueprint proof says "Step 3 is the genuine residual" which matches. However, the inline comment at lines 1065–1073 says "iter-215 UPDATE: the H2 'REAL bottom gap' is now CLOSED in this file, axiom-clean, as `restrictScalarsRingIsoTensorEquiv`", but the blueprint still describes H2 as absent. See **Major finding #1** below.
- **notes**: `\leanok` on statement is correct (sorry present). One open sorry at line 1082. Blueprint Step 3 is now partially stale regarding H2.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_isLocallyTrivial}` (chapter: `lem:tensorobj_preserves_locally_trivial`)
- **Lean target exists**: yes (line 1095, named `tensorObj_isLocallyTrivial`)
- **Signature matches**: yes — `(hM : LineBundle.IsLocallyTrivial M) (hN : LineBundle.IsLocallyTrivial N) : LineBundle.IsLocallyTrivial (tensorObj M N)`
- **Proof follows sketch**: yes — picks a common affine open, refines both trivialisations via `restrictIsoUnitOfLE`, then uses `tensorObj_restrict_iso` + `tensorObjIsoOfIso` + `tensorObj_unit_iso`; matches blueprint's three-step gluing argument
- **notes**: Proof body is substantive but depends on `tensorObj_restrict_iso` (which has a sorry). `\leanok` correct.

### `\lean{PresheafOfModules.W_whiskerLeft_of_flat, PresheafOfModules.W_whiskerRight_of_flat}` (chapter: `lem:flat_whisker_localizer`)
- **Lean target exists**: yes (lines 435 and 451)
- **Signature matches**: yes — `[∀ X, Module.Flat (R.obj X) (F.obj X)]` sectionwise flatness, `hg : J.W ((toPresheaf _).map g)`, conclusion `J.W ((toPresheaf _).map (F ◁ g))` (resp. `g ▷ F`)
- **Proof follows sketch**: yes — splits into local surjectivity (`isLocallySurjective_whiskerLeft`) and local injectivity (`isLocallyInjective_whiskerLeft_of_flat`); right variant uses braiding conjugation; matches blueprint proof
- **notes**: Both proofs are fully closed (no sorry). Blueprint block lacks `\leanok` marker — **minor sync gap** (sync_leanok should pick this up). Also: `isLocallyInjective_whiskerLeft_of_flat` (line 358) is an internal helper not separately pinned in blueprint; acceptable.

### `\lean{PresheafOfModules.isIso_sheafification_map_of_W}` (chapter: `lem:isiso_sheafification_map_of_W`)
- **Lean target exists**: yes (line 591)
- **Signature matches**: yes — `(hf : J.W ((PresheafOfModules.toPresheaf R₀).map f)) : IsIso ((PresheafOfModules.sheafification α).map f)`, with hypotheses `[Presheaf.IsLocallyInjective J α]`, `[Presheaf.IsLocallySurjective J α]`, `[J.WEqualsLocallyBijective AddCommGrpCat]`, `[CategoryTheory.HasWeakSheafify J AddCommGrpCat]`
- **Proof follows sketch**: yes — one-line application of `inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms`; matches blueprint's "thin wrapper" description
- **notes**: Fully proved. `\leanok` correct.

### `\lean{PresheafOfModules.stalkLinearMap, PresheafOfModules.stalkLinearMap_germ, PresheafOfModules.stalkLinearMap_bijective_of_isIso, PresheafOfModules.stalkLinearEquivOfIsIso}` (chapter: `lem:stalk_linear_map`)
- **Lean target exists**: yes (lines 638, 679, 700, 713)
- **Signature matches**: yes — all four match blueprint's four-declaration package:
  - `stalkLinearMap` is `(↑(stalk M.presheaf x) : Type u) →ₗ[↑(R.stalk x)] (↑(stalk N.presheaf x) : Type u)` ✅
  - `stalkLinearMap_germ` characterises on germs ✅
  - `stalkLinearMap_bijective_of_isIso` gives bijectivity from Ab-stalk iso ✅
  - `stalkLinearEquivOfIsIso` bundles the linear equivalence ✅
- **Proof follows sketch**: yes — `stalkLinearMap` uses `germ_res_apply` + `germ_smul` to verify R.stalk x-linearity sectionwise; `stalkLinearMap_bijective_of_isIso` uses `ConcreteCategory.bijective_of_isIso`; all match blueprint's description
- **notes**: All four fully proved (no sorry). Blueprint block lacks `\leanok` — **minor sync gap**. These are the "(d.1)-partial implementation" per blueprint.

### `\lean{PresheafOfModules.isLocallyInjective_whiskerLeft_of_W}` (chapter: `lem:islocallyinjective_whisker_of_W`)
- **Lean target exists**: yes (line 514)
- **Signature matches**: yes — `[J.WEqualsLocallyBijective Ab.{u}]`, `(F : PresheafOfModules.{u} (R ⋙ forget₂ _ _))`, `(hg : J.W ((toPresheaf _).map g))`, conclusion `IsLocallyInjective J (F ◁ g)`; matches blueprint
- **Proof follows sketch**: N/A — body is `sorry`; blueprint proof provides PRIMARY (locally-trivial) and FALLBACK (stalkwise) routes; comments in Lean (lines 519–546) identify the two residual gaps (d.1-bridge and d.2) accurately. No excuse-comment; comments describe substantive residual work.
- **notes**: `\leanok` on statement is correct (sorry present). This is one of the four open sorries.

### `\lean{PresheafOfModules.W_whiskerLeft_of_W, PresheafOfModules.W_whiskerRight_of_W}` (chapter: `lem:whisker_of_W`)
- **Lean target exists**: yes (lines 554, 567)
- **Signature matches**: yes — `(hg : J.W ((toPresheaf _).map g)) : J.W ((toPresheaf _).map (F ◁ g))` and right variant
- **Proof follows sketch**: yes — left variant uses `isLocallyInjective_whiskerLeft_of_W` (sorry) + `isLocallySurjective_whiskerLeft`; right variant conjugates by braiding; matches blueprint
- **notes**: Proofs are complete up to the sorry in `isLocallyInjective_whiskerLeft_of_W`. Blueprint block lacks `\leanok` — **minor sync gap**.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso}` (chapter: `lem:tensorobj_assoc_iso`)
- **Lean target exists**: yes (line 903)
- **Signature matches**: yes — `(hM : LineBundle.IsLocallyTrivial M) (hN : LineBundle.IsLocallyTrivial N) (hP : LineBundle.IsLocallyTrivial P) : tensorObj (tensorObj M N) P ≅ tensorObj M (tensorObj N P)`. Includes `IsLocallyTrivial` hypotheses that blueprint notes are vestigial.
- **Proof follows sketch**: **partial mismatch** — blueprint proof (lines 1107–1124) says the proof should go via `lem:jw_ismonoidal` and `Localization.Monoidal.LocalizedMonoidal` ("The required isomorphism is the associator α_{M,N,P} of that monoidal structure... no hand-assembled composite is needed"). The Lean proof is the explicit three-step ROUTE (d) composite (applying `W_whiskerRight_of_W`, `isIso_sheafification_map_of_W`, `mapIso` of the presheaf associator, `W_whiskerLeft_of_W`). The mathematical conclusion is the same; the proof route diverges from the blueprint sketch. Blueprint's `% NOTE:` acknowledges the Lean pin uses `IsLocallyTrivial` hypotheses, but the proof-route divergence is not annotated. See **Major finding #3**.
- **notes**: No sorry; fully proved via the hand-assembled route. `\leanok` correct.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_left_unitor, AlgebraicGeometry.Scheme.Modules.tensorObj_right_unitor}` (chapter: `lem:tensorobj_unit_iso`)
- **Lean target exists**: yes (lines 833, 843)
- **Signature matches**: yes — `(M : X.Modules) : tensorObj (SheafOfModules.unit X.ringCatSheaf) M ≅ M` and `M ≅ M` with unit on right
- **Proof follows sketch**: yes — `mapIso` of presheaf-level left/right unitors composed with sheafification counit; matches blueprint's "cheap mapIso pattern"
- **notes**: Both fully proved. Blueprint block lacks `\leanok` — **minor sync gap**. Also `tensorObj_unit_iso` (line 820, sheaf `⊗` itself ≅ itself) exists in Lean but is not separately pinned in blueprint; acceptable as an internal helper consumed by `tensorObj_isLocallyTrivial`.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_braiding}` (chapter: `lem:tensorobj_comm_iso`)
- **Lean target exists**: yes (line 853)
- **Signature matches**: yes — `(M N : X.Modules) : tensorObj M N ≅ tensorObj N M`
- **Proof follows sketch**: yes — `mapIso` of presheaf-level braiding; matches blueprint
- **notes**: Fully proved. `\leanok` correct.

### `\lean{AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse}` (chapter: `lem:tensorobj_inverse_invertible`)
- **Lean target exists**: yes (line 1121)
- **Signature matches**: yes — `(hL : LineBundle.IsLocallyTrivial L) : ∃ Linv : X.Modules, LineBundle.IsLocallyTrivial Linv ∧ Nonempty (tensorObj L Linv ≅ SheafOfModules.unit X.ringCatSheaf)`; matches blueprint's "the dual L^{-1} is again a line bundle with a contraction isomorphism"
- **Proof follows sketch**: N/A — body is `sorry`. Blueprint proof sketch (locally-free dual on a trivialising cover) is adequate.
- **notes**: `\leanok` correct. One of the four open sorries. No excuse-comment.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjOnProduct}` (chapter: `lem:tensorobj_lift_onproduct`)
- **Lean target exists**: yes (line 1133)
- **Signature matches**: yes — returns `LineBundle.OnProduct πC πT` from two `LineBundle.OnProduct` inputs via `tensorObj` + `tensorObj_isLocallyTrivial`
- **Proof follows sketch**: yes — applies `tensorObj_isLocallyTrivial` directly, as blueprint says
- **notes**: Fully substantive (no sorry). `\leanok` correct.

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible}` (chapter: `def:scheme_modules_isinvertible`)
- **Lean target exists**: yes (line 772)
- **Signature matches**: yes — `(M : X.Modules) : Prop := ∃ N : X.Modules, Nonempty (tensorObj M N ≅ SheafOfModules.unit X.ringCatSheaf)`
- **Proof follows sketch**: yes — existential predicate, no sorry
- **notes**: `\leanok` correct.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjIsoclassCommMonoid}` (chapter: `lem:tensorobj_isoclass_commgroup`)
- **Lean target exists**: **no** — no declaration with this name anywhere in `TensorObjSubstrate.lean`. The name only appears as a comment in the docstring of `tensorObj_assoc_iso` (line 864). Blueprint has no `\leanok` on this block, consistent with it being unformalized.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: This declaration is on the critical path for `addCommGroup_via_tensorObj`. Its absence is expected (not yet formalized) and the blueprint correctly omits `\leanok`. However, see **Major finding #4** — the blueprint proof for `addCommGroup_via_tensorObj` depends directly on this unformalized engine.

### `\lean{AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj}` (chapter: `thm:rel_pic_addcommgroup_via_tensorobj`)
- **Lean target exists**: yes (line 1161)
- **Signature matches**: yes — `(πC : C ⟶ S) (πT : T ⟶ S) : AddCommGroup (Quotient (RelPicPresheaf.preimage_subgroup πC πT))`
- **Proof follows sketch**: N/A — body is `sorry`. Blueprint proof is detailed (units-group construction from `tensorObjIsoclassCommMonoid`). The proof cannot land until `tensorObjIsoclassCommMonoid` exists.
- **notes**: `\leanok` correct. One of the four open sorries. No excuse-comment.

---

## Red flags

### Placeholder / suspect bodies
- `AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso` at line 1082: `sorry` at Step 4 (presheaf-level residual). This is expected; blueprint has `\leanok` only for the statement block. **Not a red flag** — the sorry is substantively bounded by Steps 1–3 above it.
- `PresheafOfModules.isLocallyInjective_whiskerLeft_of_W` at line 546: `sorry`. Expected; `\leanok` on statement. **Not a red flag** — comments precisely identify (d.1-bridge) and (d.2) as the residuals.
- `AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse` at line 1125: `sorry`. Expected. **Not a red flag.**
- `AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj` at line 1164: `sorry`. Expected. **Not a red flag.**

### Excuse-comments
None found. The inline comments on all four sorries are substantive engineering notes (identifying missing Mathlib ingredients), not excuse-comments.

### Axioms / Classical.choice on non-trivial claims
None. The new `restrictScalarsRingIsoTensorEquiv` uses `LinearEquiv.ofLinear`, `TensorProduct.lift`, `TensorProduct.liftAddHom` — all standard Mathlib, no axioms.

---

## Unreferenced declarations (informational)

The following Lean declarations have no `\lean{...}` blueprint reference:

| Declaration | Lines | Assessment |
|---|---|---|
| `restrictScalarsRingIsoTensorEquiv` | 115–193 | **SUBSTANTIVE — must be pinned.** The H2 "REAL bottom gap" of `tensorObj_restrict_iso`. Closes the strong-monoidal upgrade of `restrictScalars` along a ring iso. Directly referenced in the Step 4 comment of `tensorObj_restrict_iso`. Blueprint is stale regarding its existence. |
| `restrictScalarsLaxε` | 217–228 | Helper for `restrictScalarsLaxMonoidal`. Acceptable as un-pinned sub-helper. |
| `restrictScalarsLaxμ` | 233–245 | Helper for `restrictScalarsLaxMonoidal`. Acceptable. |
| `toPresheaf_whiskerLeft_app_tmul` | 304–311 | Sectionwise computation lemma. Acceptable helper. |
| `toPresheaf_whiskerLeft_app_apply` | 314–320 | Sectionwise computation lemma. Acceptable helper. |
| `isLocallySurjective_whiskerLeft` | 325–350 | Surjectivity half of `lem:flat_whisker_localizer`; used in both flat and W whisker proofs. Blueprint mentions it by name in the proof of `lem:whisker_of_W` but does not pin it separately. Acceptable helper. |
| `isLocallyInjective_whiskerLeft_of_flat` | 358–424 | Injectivity half of `W_whiskerLeft_of_flat`. Blueprint proof of `lem:flat_whisker_localizer` describes the argument but the pin is on `W_whiskerLeft_of_flat`. Acceptable internal decomposition. |
| `W_whiskerRight_of_W` | 567–579 | Pinned under `lem:whisker_of_W`'s `\lean{..., PresheafOfModules.W_whiskerRight_of_W}`. ✅ (already covered) |
| `isIso_sheafification_map_of_W` (in `FlatWhisker` namespace) | 591–601 | Pinned under `lem:isiso_sheafification_map_of_W`. ✅ |
| `restrictIsoUnitOfLE` | 958–980 | Internal helper for `tensorObj_isLocallyTrivial`. Acceptable. |
| `tensorObjIsoOfIso` | 804–810 | Internal helper for `tensorObj_isLocallyTrivial`. Acceptable. |
| `tensorObj_unit_iso` | 820–826 | Structural lemma `tensorObj 𝒪_X 𝒪_X ≅ 𝒪_X`; used by `tensorObj_isLocallyTrivial`. Not a separate blueprint block but described in the `tensorObj_unit_iso` text. Minor omission; acceptable. |

The **critical un-pinned declaration is `restrictScalarsRingIsoTensorEquiv`** — it is substantive, axiom-clean, and its existence changes the status of `tensorObj_restrict_iso`'s residual from "two absent ingredients" to "one absent ingredient (H1)".

---

## Blueprint adequacy for this file

- **Coverage**: 18/22 blueprint-pinned `\lean{...}` declarations exist in the Lean file (the exceptions being `tensorObjIsoclassCommMonoid`, which is intentionally unformalized, and `lem:jw_ismonoidal`/`lem:pullback_compatible_with_tensorobj` which have no `\lean{...}` pin). Coverage is adequate for the iter-215 state.
- **Proof-sketch depth**: **adequate** for three of the four open sorries (`isLocallyInjective_whiskerLeft_of_W`, `exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`). For `tensorObj_restrict_iso`, the proof sketch at Step 3 is **partially stale**: it still says "two Mathlib-absent presheaf-level ingredients (H1 and H2)" when H2 is now closed axiom-clean in the Lean file as `restrictScalarsRingIsoTensorEquiv`. A prover reading only the blueprint cannot tell H2 is done.
- **Hint precision**: **loose** for `lem:tensorobj_assoc_iso` — blueprint proof says to use `LocalizedMonoidal` API, but the actual Lean proof is a hand-assembled three-step composite via `W_whisker{Left,Right}_of_W`. The blueprint `% NOTE:` on the statement acknowledges the vestigial `IsLocallyTrivial` hypotheses but does not annotate the proof-route divergence.
- **Generality**: matches need.
- **Recommended chapter-side actions**:
  1. Add a new `\begin{lemma}...\end{lemma}` block (or helper-sub-block inside `lem:tensorobj_restrict_iso` Step 3) pinning `restrictScalarsRingIsoTensorEquiv` with `\lean{restrictScalarsRingIsoTensorEquiv}`. Statement: "For a ring isomorphism `e : R ≃+* S` and S-modules A, B, base change along `e` commutes with `⊗`: the canonical map `a ⊗ₜ[R] b ↦ a ⊗ₜ[S] b` is an R-linear equivalence `A ⊗[R] B ≃ₗ[R] A ⊗[S] B`."
  2. Update `lem:tensorobj_restrict_iso` Step 3 to note H2 is now closed (by `restrictScalarsRingIsoTensorEquiv`) and only H1 (presheaf-level `pushforward β ≅ pullback φ` adjunction) remains.
  3. Update `lem:tensorobj_assoc_iso` proof sketch (or add a `% NOTE:`) to say the Lean proof is the hand-assembled ROUTE (d) three-step composite (via `W_whiskerRight_of_W`, `isIso_sheafification_map_of_W`, `mapIso` of the presheaf associator, `W_whiskerLeft_of_W`), not the `LocalizedMonoidal` API route. The `IsLocallyTrivial` hypotheses are retained in the Lean pin to avoid unprotecting the declaration but are not proof ingredients.
  4. (sync_leanok) Add `\leanok` to `lem:flat_whisker_localizer`, `lem:stalk_linear_map`, `lem:whisker_of_W`, `lem:tensorobj_unit_iso` — all have fully proved Lean bodies. (These are sync_leanok's job, noted for completeness.)

---

## Severity summary

### must-fix-this-iter
None. All four open sorries have correct `\leanok`-only statement blocks (skeleton scaffold). No wrong signatures, no axioms, no excuse-comments, no weakened-wrong definitions.

### major
1. **`restrictScalarsRingIsoTensorEquiv` has no blueprint pin.** The declaration closes the H2 gap (strong-monoidal `restrictScalars` along a ring iso) documented as absent in `lem:tensorobj_restrict_iso` Step 3. The blueprint still describes H2 as "genuinely Mathlib-absent" and lists it as an open residual. Blueprint needs a new block / `\lean{...}` pin and an updated Step 3 description. This is the principal Lean → Blueprint inadequacy this iter.
2. **`lem:tensorobj_assoc_iso` proof-route mismatch.** Blueprint proof says the associator is obtained from `LocalizedMonoidal` API (via `lem:jw_ismonoidal`). The Lean proof is a hand-assembled three-step ROUTE (d) composite using `W_whisker{Right,Left}_of_W` and `isIso_sheafification_map_of_W` directly — no `LocalizedMonoidal` invoked. Mathematical content matches; proof route does not. Blueprint should annotate the actual Lean route.
3. **`tensorObjIsoclassCommMonoid` is pinned in blueprint but absent from Lean.** No `\leanok` is set (consistent with being unformalized), but this is the load-bearing group-law engine for `addCommGroup_via_tensorObj` and its absence means the consumer sorry cannot land without first creating it. The blueprint proof of `lem:tensorobj_isoclass_commgroup` adequately describes the construction, but the planning agent should note this dependency in the next iter objectives.

### minor
4. `lem:flat_whisker_localizer` (both `W_whiskerLeft_of_flat`, `W_whiskerRight_of_flat`): no `\leanok` in blueprint, though Lean proofs are complete. sync_leanok should fix.
5. `lem:stalk_linear_map` (all four declarations): no `\leanok` in blueprint, Lean proofs are complete. sync_leanok should fix.
6. `lem:whisker_of_W` (`W_whiskerLeft_of_W`, `W_whiskerRight_of_W`): no `\leanok` in blueprint. sync_leanok.
7. `lem:tensorobj_unit_iso` (`tensorObj_left_unitor`, `tensorObj_right_unitor`): no `\leanok`. sync_leanok.
8. `lem:pullback_compatible_with_tensorobj` has no `\lean{...}` pin (intentional — off critical path for iter-215).

---

**Overall verdict**: The Lean file is substantively faithful to the blueprint for all four open sorries and all pinned declarations; the main gap is that the new axiom-clean helper `restrictScalarsRingIsoTensorEquiv` (the H2 "REAL bottom gap" closure) has no blueprint pin and the blueprint's Step 3 of `lem:tensorobj_restrict_iso` remains stale regarding H2 — 19 declarations checked, 2 major findings (missing pin, proof-route mismatch), 4 minor sync gaps.
