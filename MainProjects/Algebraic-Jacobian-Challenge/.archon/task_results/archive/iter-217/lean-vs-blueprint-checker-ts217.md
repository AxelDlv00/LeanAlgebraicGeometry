# Lean ↔ Blueprint Check Report

## Slug
ts217

## Iteration
217

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (1425 lines)
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (2247 lines)

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (`def:scheme_modules_tensorobj`)
- **Lean target exists**: yes (line 992)
- **Signature matches**: yes — `(M N : X.Modules) : X.Modules`, matching blueprint prose
- **Proof follows sketch**: yes — sheafification of `PresheafOfModules.Monoidal.tensorObj M.val N.val`, exactly as described
- **Notes**: Statement `\leanok` in blueprint consistent with real body. ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` (`lem:scheme_modules_tensorobj_functoriality`)
- **Lean target exists**: yes (line 1008)
- **Signature matches**: yes
- **Proof follows sketch**: yes — inherits from `PresheafOfModules.Monoidal.tensorHom` under sheafification
- **Notes**: Statement and proof `\leanok` in blueprint both consistent. ✓

### `\lean{PresheafOfModules.restrictScalarsLaxMonoidal}` (`lem:restrictscalars_laxmonoidal`)
- **Lean target exists**: yes (line 336, as `noncomputable instance`)
- **Signature matches**: yes — lax monoidal structure on `restrictScalars α` for a `CommRingCat` morphism `α`
- **Proof follows sketch**: yes — sectionwise assembly from `ModuleCat.restrictScalars (α.app Z).hom` lax structure, matching the blueprint's "sectionwise lift" description
- **Notes**: Statement and proof `\leanok` consistent. The blueprint NOTE (`% NOTE: this ... is NOT used by lem:tensorobj_restrict_iso`) is accurate; the Lean file comment echoes it. ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso}` (`lem:tensorobj_restrict_iso`)
- **Lean target exists**: yes (line 1259), **CLOSED this iter**
- **Signature matches**: yes — `(f : Y ⟶ X) [IsOpenImmersion f] (M N : X.Modules) : (tensorObj M N).restrict f ≅ tensorObj (M.restrict f) (N.restrict f)`
- **Proof follows sketch**: **YES — exact 4-step match**:
  - Step 1: `restrictFunctorIsoPullback f` ✓ (line 1264)
  - Step 2: `SheafOfModules.sheafificationCompPullback f.toRingCatSheafHom` ✓ (line 1276)
  - Step 3: `sheafification.mapIso ?_` ✓ (line 1285)
  - Step 4a (H1): `pushforwardPushforwardAdj` → `leftAdjointUniq` ✓ (lines 1309–1313)
  - Step 4b (H2): `restrictScalarsMonoidalOfBijective` → `Functor.Monoidal.μIso` ✓ (lines 1330–1336)
- **Notes**: Statement and proof `\leanok` in blueprint are correctly placed (not inside `\uses{}`). Proof is axiom-clean. Gotcha note in Lean (inline adjunction rather than `have`/`set` to keep `adj.unit` transparent) is not in the blueprint; could be a minor enhancement to the proof notes.

### `\lean{restrictScalarsRingIsoTensorEquiv}` (`lem:restrictscalars_ringiso_tensorequiv`)
- **Lean target exists**: yes (line 115)
- **Signature matches**: yes — `(e : R ≃+* S) (A B : Type u) ... : TensorProduct R A B ≃ₗ[R] TensorProduct S A B`
- **Proof follows sketch**: yes — forward and additive-only inverse, matches blueprint's description of the forward R-linear map and additive inverse
- **Notes**: Blueprint statement has `\leanok` (correct, no sorry). Blueprint proof block lacks `\leanok` — `sync_leanok` should add it (real proof present). Minor. ✓

### `\lean{restrictScalars_isIso_μ, restrictScalars_isIso_ε, restrictScalarsMonoidalOfRingEquiv, restrictScalars_isIso_μ_of_bijective, restrictScalars_isIso_ε_of_bijective}` (`lem:restrictscalars_ringiso_strongmonoidal`)
- **Lean target exists**: all 5 exist (lines 219, 237, 253, 266, 273)
- **Signature matches**: yes for all 5
- **Proof follows sketch**: yes — (1)/(2) repackage `restrictScalarsRingIsoTensorEquiv`; (3) uses `Functor.Monoidal.ofLaxMonoidal`; bijective-form variants reduce to the ring-equiv forms via `RingEquiv.ofBijective`
- **Notes**: Blueprint has neither statement nor proof `\leanok` for this block. `sync_leanok` should add both. This is not a defect — the markers are managed deterministically and will propagate. Minor.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_isLocallyTrivial}` (`lem:tensorobj_preserves_locally_trivial`)
- **Lean target exists**: yes (line 1349)
- **Signature matches**: yes
- **Proof follows sketch**: yes — pick common affine cover, apply `tensorObj_restrict_iso` + `tensorObjIsoOfIso` + `tensorObj_unit_iso`. Blueprint proof description matches exactly.
- **Notes**: Statement and proof `\leanok` both consistent. ✓

### `\lean{PresheafOfModules.W_whiskerLeft_of_flat, PresheafOfModules.W_whiskerRight_of_flat}` (`lem:flat_whisker_localizer`)
- **Lean target exists**: both exist (lines 521, 537)
- **Signature matches**: yes — `[∀ X, Module.Flat (R.obj X) (F.obj X)]` sectionwise flatness hypothesis present
- **Proof follows sketch**: yes — `W_iff_isLocallyBijective` split; surjectivity from `isLocallySurjective_whiskerLeft`; injectivity from `isLocallyInjective_whiskerLeft_of_flat`; right variant by braiding conjugation
- **Notes**: Blueprint correctly labels this lemma as "Superseded route — off path." No `\leanok` in blueprint (expected for off-path material). Lean has real proofs. ✓

### `\lean{PresheafOfModules.isIso_sheafification_map_of_W}` (`lem:isiso_sheafification_map_of_W`)
- **Lean target exists**: yes (line 677)
- **Signature matches**: yes
- **Proof follows sketch**: yes — one-morphism reading of `inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms`. Matches blueprint's "closed thin wrapper" description.
- **Notes**: Statement and proof `\leanok` consistent. ✓

### `\lean{PresheafOfModules.stalkLinearMap, stalkLinearMap_germ, stalkLinearMap_bijective_of_isIso, stalkLinearEquivOfIsIso}` (`lem:stalk_linear_map`)
- **Lean target exists**: all 4 exist (lines 724, 765, 786, 799)
- **Signature matches**: yes for all 4
- **Proof follows sketch**: yes — germ/scalar compatibility proof uses `germ_res_apply` + `germ_smul` + `stalkFunctor_map_germ_apply`, matching the blueprint's "filtered colimit" description
- **Notes**: Blueprint has statement `\leanok` only; proof `\leanok` absent. Real proofs are in the Lean file — `sync_leanok` should add the proof marker. Off-path (route-e stalk infrastructure), but axiom-clean. ✓

### `\lean{PresheafOfModules.isLocallyInjective_whiskerLeft_of_W}` (`lem:islocallyinjective_whisker_of_W`)
- **Lean target exists**: yes (line 600)
- **Signature matches**: yes
- **Proof follows sketch**: N/A — body is `sorry`; blueprint statement `\leanok` correct (sorry is present per marker vocabulary)
- **Notes**: Blueprint labels this block "Superseded route — off path, not to be formalized" and says "Lean declarations are being removed," but both the `\lean{}` pin and `\leanok` statement marker remain in the blueprint, and the declaration remains in the Lean file. This prose/marker inconsistency is a **major** finding (see below).

### `\lean{PresheafOfModules.W_whiskerLeft_of_W, PresheafOfModules.W_whiskerRight_of_W}` (`lem:whisker_of_W`)
- **Lean target exists**: both exist (lines 640, 653)
- **Signature matches**: yes — flatness-free, arbitrary `F`
- **Proof follows sketch**: yes — `W_iff_isLocallyBijective` split; surjectivity from `isLocallySurjective_whiskerLeft`; injectivity delegates to `isLocallyInjective_whiskerLeft_of_W` (the sorry'd residual); right variant by braiding
- **Notes**: Blueprint has statement `\leanok` (correct — sorry propagates from `isLocallyInjective_whiskerLeft_of_W`). Off-path per blueprint prose.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso}` (`lem:tensorobj_assoc_iso`)
- **Lean target exists**: yes (line 1152)
- **Signature matches**: yes — `(hM hN hP : LineBundle.IsLocallyTrivial ...)` hypotheses retained per blueprint note
- **Proof follows sketch**: yes — blueprint's 3-step: W_whiskerRight_of_W (step 1) + mapIso of associator (step 2) + W_whiskerLeft_of_W (step 3), using `isIso_sheafification_map_of_W` as the bridge. **The Lean currently uses ROUTE (d) `W_whisker{Left,Right}_of_W` (not the older flat variants)**, matching the iter-212 pivot described in the Lean comment. The blueprint proof text under "Current realization" describes this route as using `W_whiskerRight_of_W` / `W_whiskerLeft_of_W`, which matches.
- **Notes**: Body is `sorry` (depends on `isLocallyInjective_whiskerLeft_of_W` sorry). Statement `\leanok` consistent. **The `\leanok` in the proof block is INSIDE `\uses{...}` — confirmed malformed** (see Red Flags).

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_left_unitor, tensorObj_right_unitor}` (`lem:tensorobj_unit_iso`)
- **Lean target exists**: both exist (lines 1082, 1092)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `sheafification.mapIso` of presheaf-level left/right unitors, composed with sheafification counit; "cheap mapIso pattern" as described
- **Notes**: Blueprint has NO `\leanok` markers (neither statement nor proof), but the Lean bodies are real. `sync_leanok` should add both markers. Minor — not a defect in either file.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_braiding}` (`lem:tensorobj_comm_iso`)
- **Lean target exists**: yes (line 1102)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `sheafification.mapIso (BraidedCategory.braiding ...)`, the "cheap mapIso pattern"
- **Notes**: Statement and proof `\leanok` consistent. ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse}` (`lem:tensorobj_inverse_invertible`)
- **Lean target exists**: yes (line 1375)
- **Signature matches**: yes — takes `(hL : LineBundle.IsLocallyTrivial L)` and returns `∃ Linv, IsLocallyTrivial Linv ∧ Nonempty (tensorObj L Linv ≅ ...)`
- **Proof follows sketch**: N/A — body is `sorry`; open obligation
- **Notes**: Blueprint statement `\leanok` consistent (sorry present). Proof `\leanok` absent (correct). On the critical path under the PRIMARY group-law route.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjOnProduct}` (`lem:tensorobj_lift_onproduct`)
- **Lean target exists**: yes (line 1387)
- **Signature matches**: yes
- **Proof follows sketch**: yes — directly applies `tensorObj_isLocallyTrivial`, exactly as blueprint says
- **Notes**: Statement and proof `\leanok` consistent. ✓

### `\lean{AlgebraicGeometry.LineBundle.OnProduct.pullback_tensorObj_iso}` (`lem:pullback_compatible_with_tensorobj`)
- **Lean target exists**: no — declaration absent from Lean file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Notes**: Blueprint has no `\leanok` on statement; unformalized, expected. The `\leanok` in the proof block is INSIDE `\uses{...}` — **confirmed malformed** (see Red Flags).

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible}` (`def:scheme_modules_isinvertible`)
- **Lean target exists**: yes (line 1021)
- **Signature matches**: yes — `∃ N : X.Modules, Nonempty (tensorObj M N ≅ SheafOfModules.unit X.ringCatSheaf)`
- **Proof follows sketch**: yes — the Prop-valued existential carries the inverse witness, as described
- **Notes**: Blueprint statement `\leanok` consistent. ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjIsoclassCommMonoid}` (`lem:tensorobj_isoclass_commgroup`)
- **Lean target exists**: no — not in this Lean file
- **Signature matches**: N/A
- **Notes**: Blueprint has no `\leanok`; unformalized, expected. No concern.

### `\lean{AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj}` (`thm:rel_pic_addcommgroup_via_tensorobj`)
- **Lean target exists**: yes (line 1415)
- **Signature matches**: yes
- **Proof follows sketch**: N/A — body is `sorry`; open obligation
- **Notes**: Blueprint statement block has `\leanok` (correct — sorry present). The apparent proof `\leanok` at tex ~L2044 is INSIDE `\uses{...}` — **confirmed malformed** (see Red Flags). So the proof is correctly unmarked.

---

## Red Flags

### Placeholder / suspect bodies

- `PresheafOfModules.isLocallyInjective_whiskerLeft_of_W` (line 600): `:= sorry`. Blueprint labels this lemma "Superseded route — off path, not to be formalized" and states "its Lean declarations are being removed," but the declaration persists. The sorry body is consistent with the statement `\leanok` marker (marker vocabulary allows sorry). However the ongoing presence contradicts the prose — this is a prose/pin inconsistency (see Major findings), not a placeholder-on-substantive-claim issue.

- `AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso` (line 1152): `:= sorry`, transitively gated on `isLocallyInjective_whiskerLeft_of_W`. Legitimately open; blueprint correctly marks only the statement `\leanok`.

- `AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse` (line 1375): `:= sorry`. Legitimately open (dual/inverse construction pending).

- `AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj` (line 1415): `:= sorry`. Legitimately open; consumer of the above.

### Excuse-comments
None found. The Lean `-- ROUTE (d)...`, `-- iter-N...`, and `-- RESIDUAL...` comments are correctly status-documenting, not excuse-comments for wrong code.

### Axioms / Classical.choice on non-trivial claims
None. All closed declarations are axiom-clean.

---

## Blueprint-Doctor Confirmed Issues

### Issue 1 — `\leanok` inside `\uses{...}` at blueprint tex ~L1376–1379 (CONFIRMED)

In the proof block of `lem:tensorobj_assoc_iso`:

```latex
\begin{proof}
  \uses{def:scheme_modules_tensorobj, lem:tensorobj_restrict_iso,
  \leanok
        lem:whisker_of_W, lem:islocallyinjective_whisker_of_W}
```

The `\leanok` token appears **between** `lem:tensorobj_restrict_iso,` and `lem:whisker_of_W` inside the `\uses{...}` argument. This breaks the dependency edges for `lem:whisker_of_W` and `lem:islocallyinjective_whisker_of_W` in the proof of `lem:tensorobj_assoc_iso`. These labels will not be recognized as `\uses` targets by blueprint tooling.

**Must-fix-this-iter** (broken dependency graph, proof `\leanok` appears to be misplaced here — the actual proof is a `sorry`, so this `\leanok` is erroneous).

### Issue 2 — `\leanok` inside `\uses{...}` at blueprint tex ~L2043–2046 (CONFIRMED)

In the proof block of `thm:rel_pic_addcommgroup_via_tensorobj`:

```latex
\begin{proof}
  \uses{lem:tensorobj_lift_onproduct,
  \leanok
        lem:pullback_compatible_with_tensorobj,
        def:scheme_modules_isinvertible,
        lem:tensorobj_isoclass_commgroup,
        thm:relative_pic_quotient_well_defined,
        lem:rel_pic_sharp_groupoid}
```

The `\leanok` appears after the first comma inside the `\uses{...}` block. This breaks the dependency edges for **all** of:
- `lem:pullback_compatible_with_tensorobj`
- `def:scheme_modules_isinvertible`
- `lem:tensorobj_isoclass_commgroup`
- `thm:relative_pic_quotient_well_defined`
- `lem:rel_pic_sharp_groupoid`

The proof body is `sorry`, so this proof `\leanok` is also factually wrong.

**Must-fix-this-iter** (broken dependency graph, spurious proof `\leanok` on a sorry body).

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have no `\lean{...}` pin in the blueprint chapter. The five **new this-iter** declarations are the most important:

### New this-iter — need blueprint pins (major)

| Declaration | Lean line | Status |
|-------------|-----------|--------|
| `PresheafOfModules.pushforwardNatTrans` | 840 | Mentioned in `lem:tensorobj_restrict_iso` proof prose ("must be built from presheaf-level `pushforwardNatTrans` and `pushforwardCongr`") but no `\lean{...}` pin |
| `PresheafOfModules.pushforwardCongr` | 871 | Same — mentioned in prose, no pin |
| `PresheafOfModules.pushforwardPushforwardAdj` | 905 | Mentioned in prose as "presheaf analogue of the sheaf-level `pushforwardPushforwardAdj`", no pin |
| `PresheafOfModules.restrictScalarsMonoidalOfBijective` | 958 | Mentioned in H2 step of `lem:tensorobj_restrict_iso` proof prose (`restrictScalarsMonoidalOfBijective`), no `\lean{...}` pin |
| `PresheafOfModules.isIso_of_isIso_app` | 940 | Not mentioned in blueprint at all; the sole helper enabling `restrictScalarsMonoidalOfBijective` to lift sectionwise isomorphisms to the presheaf level |

The first three (`pushforwardNatTrans`, `pushforwardCongr`, `pushforwardPushforwardAdj`) are de-sheafifications of named Mathlib declarations and are blueprint-PR-candidate material. They should be collected into a new `\lean{...}` block (e.g., within a new paragraph under `lem:tensorobj_restrict_iso` or as a standalone "presheaf-level H1 supplements" lemma). `restrictScalarsMonoidalOfBijective` is the presheaf-level H2 and should similarly be added. `isIso_of_isIso_app` is a pure helper.

Note: `restrictScalarsMonoidalOfBijective` (presheaf-level, bijective-form) is **distinct** from `restrictScalarsMonoidalOfRingEquiv` (module-level, ring-equiv form), which is already pinned in `lem:restrictscalars_ringiso_strongmonoidal`. Adding a `\lean{}` reference for the bijective presheaf form avoids confusion between the two.

### Existing helpers — not pinned (acceptable)

- `restrictScalarsRingIsoTensorEquiv_apply_tmul` (line 197) — `@[simp]` computation lemma, helper for the proof of `restrictScalars_isIso_μ`. Acceptable unlisted helper.
- `restrictScalarsLaxε`, `restrictScalarsLaxμ` (lines 303, 319) — component helpers for `restrictScalarsLaxMonoidal` instance. Acceptable.
- `toPresheaf_whiskerLeft_app_tmul`, `toPresheaf_whiskerLeft_app_apply` (lines 390, 400) — computation helpers for `isLocallyInjective_whiskerLeft_of_flat`. Acceptable.
- `isLocallySurjective_whiskerLeft` (line 411) — invoked internally by both `W_whiskerLeft_of_flat` and `W_whiskerLeft_of_W`; could merit a `\lean{}` mention but acceptable as a helper lemma.
- `tensorObjIsoOfIso` (line 1053) — helper for `tensorObj_isLocallyTrivial`. Acceptable.
- `tensorObj_unit_iso` (line 1069) — the "O ⊗ O ≅ O" specific lemma (distinct from the general left/right unitors). Used by `tensorObj_isLocallyTrivial` but not a top-level blueprint pin.
- `restrictIsoUnitOfLE` (line 1207) — trivialisation-refinement helper for `tensorObj_isLocallyTrivial`. Acceptable.

---

## Blueprint adequacy for this file

- **Coverage**: 18/21 `\lean{...}`-pinned declarations have a Lean body (real or sorry) in this file. 3 are unformalized (no `\leanok` in blueprint): `pullback_tensorObj_iso`, `tensorObjIsoclassCommMonoid`, and `pullback_compatible_with_tensorobj`'s block. The 5 new iter-217 declarations (`pushforwardNatTrans`, `pushforwardCongr`, `pushforwardPushforwardAdj`, `isIso_of_isIso_app`, `restrictScalarsMonoidalOfBijective`) are unreferenced.

- **Proof-sketch depth**: **adequate** for all closed declarations, with one exception: the proof notes for `lem:tensorobj_restrict_iso` mention `pushforwardNatTrans` and `pushforwardCongr` by name but describe them only as "building blocks" that "must be built," without specifying their signatures. Now that they exist, the proof prose should be updated to reference them with `\lean{...}` pins.

- **Hint precision**: **partially loose** for `lem:tensorobj_restrict_iso`. The H2 step names `restrictScalarsMonoidalOfBijective` in the Lean comment but the `\lean{}` block for `lem:restrictscalars_ringiso_strongmonoidal` only lists the module-level `restrictScalarsMonoidalOfRingEquiv`. A reader following the blueprint for H2 would look at the wrong level. Loose, but correctable with an additional `\lean{}` annotation.

- **Generality**: matches need for all declarations.

- **Recommended chapter-side actions** (for a blueprint-writing subagent):

  1. **(must-fix)** Remove the `\leanok` that is inside `\uses{...}` in the proof of `lem:tensorobj_assoc_iso` (tex ~L1377). Fix the `\uses{}` block to close properly before any `\leanok`.

  2. **(must-fix)** Remove the `\leanok` that is inside `\uses{...}` in the proof of `thm:rel_pic_addcommgroup_via_tensorobj` (tex ~L2044). Fix the `\uses{}` block; the proof body is `sorry` so no proof `\leanok` should be present.

  3. **(major)** Add a new lemma block (or subsection note) for the H1 presheaf-level adjunction helpers, with:
     ```latex
     \lean{PresheafOfModules.pushforwardNatTrans,
           PresheafOfModules.pushforwardCongr,
           PresheafOfModules.pushforwardPushforwardAdj}
     ```
     These are de-sheafifications of Mathlib's `SheafOfModules.pushforward{NatTrans,Congr,PushforwardAdj}` and are Mathlib-upstream-PR candidates.

  4. **(major)** Add `\lean{PresheafOfModules.restrictScalarsMonoidalOfBijective}` to the H2 description in `lem:tensorobj_restrict_iso` (or as a companion to `lem:restrictscalars_ringiso_strongmonoidal`), disambiguating it from the module-level `restrictScalarsMonoidalOfRingEquiv`.

  5. **(major)** Resolve the `lem:islocallyinjective_whisker_of_W` prose/pin inconsistency: the enclosing prose says "Lean declarations are being removed" but the `\lean{PresheafOfModules.isLocallyInjective_whiskerLeft_of_W}` pin and `\leanok` statement marker remain. Either (a) update the prose to say the declaration is retained for reference, or (b) if the declaration is truly being removed, remove the `\lean{}` pin and `\leanok` from the blueprint.

  6. **(minor)** Add `\lean{PresheafOfModules.isIso_of_isIso_app}` as an informational helper note near the H2 section.

  7. **(minor)** Add `\leanok` to the statement block of `lem:tensorobj_unit_iso` (for `tensorObj_left_unitor`, `tensorObj_right_unitor`) and to the proof block of `lem:restrictscalars_ringiso_tensorequiv` — `sync_leanok` should handle these automatically.

---

## Severity Summary

| # | Finding | Severity |
|---|---------|----------|
| 1 | `\leanok` inside `\uses{...}` in proof of `lem:tensorobj_assoc_iso` (~tex L1377): breaks `lem:whisker_of_W` and `lem:islocallyinjective_whisker_of_W` dependency edges; spurious proof marker on sorry body | **must-fix-this-iter** |
| 2 | `\leanok` inside `\uses{...}` in proof of `thm:rel_pic_addcommgroup_via_tensorobj` (~tex L2044): breaks 5 dependency edges; spurious proof marker on sorry body | **must-fix-this-iter** |
| 3 | Five new iter-217 declarations (`pushforwardNatTrans`, `pushforwardCongr`, `pushforwardPushforwardAdj`, `restrictScalarsMonoidalOfBijective`, `isIso_of_isIso_app`) have no `\lean{...}` pin in the blueprint | **major** |
| 4 | Blueprint prose for `lem:islocallyinjective_whisker_of_W` says "declarations are being removed" but the `\lean{}` pin, `\leanok` marker, and Lean declaration all remain; prose/pin inconsistency | **major** |
| 5 | `restrictScalarsMonoidalOfBijective` (presheaf-level) not distinguished from `restrictScalarsMonoidalOfRingEquiv` (module-level, already pinned) in blueprint | **minor** |
| 6 | `lem:tensorobj_unit_iso` blueprint lacks `\leanok` for real-bodied declarations; `lem:restrictscalars_ringiso_tensorequiv` proof lacks `\leanok`; both await `sync_leanok` | **minor** |

**Overall verdict**: The closed `tensorObj_restrict_iso` proof faithfully follows the blueprint's claimed 4-step route (H1 + H2) with no mathematical divergence; the chapter is otherwise adequate, but two must-fix broken `\leanok`-inside-`\uses{}` syntax errors corrupt the dependency graph, and the five new iter-217 helper declarations are blueprint-unreferenced.
