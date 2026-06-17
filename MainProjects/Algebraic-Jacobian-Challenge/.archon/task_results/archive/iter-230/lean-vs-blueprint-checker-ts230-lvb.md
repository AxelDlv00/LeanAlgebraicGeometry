# Lean ↔ Blueprint Check Report

## Slug
ts230-lvb

## Iteration
230

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (2376 lines)
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (3230 lines)

---

## Per-declaration (all `\lean{...}`-pinned blocks)

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (`def:scheme_modules_tensorobj`)
- **Lean target exists**: yes (line 1631)
- **Signature matches**: yes — `{X : Scheme.{u}} (M N : X.Modules) : X.Modules`
- **Proof follows sketch**: yes — sheafification of `PresheafOfModules.Monoidal.tensorObj`, matching the blueprint description
- **notes**: axiom-clean, no sorry

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` (`lem:scheme_modules_tensorobj_functoriality`)
- **Lean target exists**: yes (line 1646)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean

### `\lean{PresheafOfModules.restrictScalarsLaxMonoidal}` (`lem:restrictscalars_laxmonoidal`)
- **Lean target exists**: yes (line 395), with helpers `restrictScalarsLaxε` (line 362) and `restrictScalarsLaxμ` (line 378)
- **Signature matches**: yes — instance over CommRingCat-valued presheaves
- **Proof follows sketch**: yes — sectionwise lift of `ModuleCat.instLaxMonoidalRestrictScalars`
- **notes**: axiom-clean

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso}` (`lem:tensorobj_restrict_iso`)
- **Lean target exists**: yes (line 1941)
- **Signature matches**: yes — `{X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f] (M N : X.Modules) : (tensorObj M N).restrict f ≅ tensorObj (M.restrict f) (N.restrict f)`
- **Proof follows sketch**: yes — 4-step composite (Steps 1–4, H1+H2) exactly as blueprint describes
- **notes**: **CLOSED axiom-clean** (iter-217, the single substrate linchpin); no sorry

### `\lean{restrictScalarsRingIsoTensorEquiv}` (`lem:restrictscalars_ringiso_tensorequiv`)
- **Lean target exists**: yes (line 124)
- **Signature matches**: yes
- **Proof follows sketch**: yes — explicit `LinearEquiv.ofLinear` construction
- **notes**: axiom-clean

### `\lean{restrictScalars_isIso_μ}`, `\lean{restrictScalars_isIso_ε}`, `\lean{restrictScalarsMonoidalOfRingEquiv}`, `\lean{restrictScalars_isIso_μ_of_bijective}`, `\lean{restrictScalars_isIso_ε_of_bijective}` (`lem:restrictscalars_ringiso_strongmonoidal`)
- **Lean targets exist**: all five present at lines 228, 246, 262, 275, 284
- **Signatures match**: yes
- **Proof follows sketch**: yes
- **notes**: all axiom-clean

### `\lean{PresheafOfModules.pushforwardNatTrans}`, `\lean{PresheafOfModules.pushforwardCongr}`, `\lean{PresheafOfModules.pushforwardPushforwardAdj}`, `\lean{PresheafOfModules.isIso_of_isIso_app}`, `\lean{PresheafOfModules.restrictScalarsMonoidalOfBijective}` (`lem:presheaf_pushforward_adj_substrate`)
- **Lean targets exist**: all five present at lines 899, 930, 967, 999, 1017
- **Signatures match**: yes
- **Proof follows sketch**: yes
- **notes**: all axiom-clean; the H1+H2 linchpin components

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_isLocallyTrivial}` (`lem:tensorobj_preserves_locally_trivial`)
- **Lean target exists**: yes (line 2031)
- **Signature matches**: yes
- **Proof follows sketch**: yes — common-affine-open argument via `restrictIsoUnitOfLE` + `tensorObj_restrict_iso` + `tensorObjIsoOfIso` + `tensorObj_unit_iso`
- **notes**: axiom-clean

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso}` (`lem:tensorobj_assoc_iso`)
- **Lean target exists**: yes (line 1834)
- **Signature matches**: yes — carries `IsLocallyTrivial` hypotheses matching blueprint annotation
- **Proof follows sketch**: partial — uses route-(d) whiskering composite (`W_whiskerRight/Left_of_W` + `isIso_sheafification_map_of_W`), as the proof body explicitly notes the direct-gluing re-route is deferred; the blueprint proof body acknowledges this mismatch ("Status: route mismatch, deferred")
- **notes**: **sorry-transitive** through `isLocallyInjective_whiskerLeft_of_W` (line 691); blueprint correctly documents this

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_left_unitor}`, `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_right_unitor}` (`lem:tensorobj_unit_iso`)
- **Lean targets exist**: yes (lines 1762, 1772)
- **Signatures match**: yes
- **Proof follows sketch**: yes — cheap `mapIso` pattern
- **notes**: axiom-clean; `\leanok` absent from statement block in blueprint (sync_leanok should add it)

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_braiding}` (`lem:tensorobj_comm_iso`)
- **Lean target exists**: yes (line 1782)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean

### `\lean{AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse}` (`lem:tensorobj_inverse_invertible`)
- **Lean target exists**: yes (line 2188)
- **Signature matches**: yes — with `IsLocallyTrivial` hypothesis (matching blueprint)
- **Proof follows sketch**: N/A — body is `:= sorry`, blueprint correctly marks as infrastructure-blocked
- **notes**: blueprint correctly has `\leanok` on statement block (sorry present); no false claim

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjOnProduct}` (`lem:tensorobj_lift_onproduct`)
- **Lean target exists**: yes (line 2220)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean

### `\lean{AlgebraicGeometry.LineBundle.OnProduct.pullback_tensorObj_iso}` (`lem:pullback_compatible_with_tensorobj`)
- **Lean target exists**: **no** — not found in the Lean file
- **notes**: open obligation; blueprint correctly has no `\leanok` on this block; not a bug

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible}` (`def:scheme_modules_isinvertible`)
- **Lean target exists**: yes (line 1659)
- **Signature matches**: yes
- **notes**: axiom-clean

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjIsoclassCommMonoid}` (`lem:tensorobj_isoclass_commgroup`)
- **Lean target exists**: **no** — not found in the Lean file
- **notes**: open obligation; blueprint correctly has no `\leanok`; not a bug

### `\lean{AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj}` (`thm:rel_pic_addcommgroup_via_tensorobj`)
- **Lean target exists**: yes (line 2253)
- **Signature matches**: yes
- **Proof follows sketch**: N/A — body is `:= sorry`, as documented
- **notes**: open obligation

### `\lean{PresheafOfModules.InternalHom.homModule}` and related slice-internal-hom infrastructure
- (`PresheafOfModules.InternalHom.homModule` line 1141, `internalHomObjModule` line 1183, `internalHom` line 1353, `restrictionMap` line 1196, `PresheafOfModules.dual` line 1406, `PresheafOfModules.internalHomEval` line 1507)
- **Lean targets exist**: all yes
- **Signatures match**: yes for all
- **Proof follows sketch**: yes
- **notes**: all axiom-clean (iter-224 closed `internalHomEval` naturality)

### `\lean{AlgebraicGeometry.Scheme.Modules.dual}` (`lem:internal_hom_isSheaf`)
- **Lean target exists**: yes (line 1687)
- **Signature matches**: yes — sheafification of `PresheafOfModules.dual`
- **Proof follows sketch**: yes — exact dual analogue of `tensorObj`
- **notes**: axiom-clean

### `\lean{restrictScalarsRingIsoDualEquiv}` (`lem:restrictscalars_ringiso_dualequiv`)
- **Lean target exists**: yes (line 306)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean

### `\lean{PresheafOfModules.dualPrecompEquiv}` (`def:presheaf_dual_precomp_equiv`)
- **Lean target exists**: yes (line 1558)
- **Signature matches**: yes
- **notes**: axiom-clean

### `\lean{PresheafOfModules.dualIsoOfIso}` (`def:presheaf_dual_iso_of_iso`)
- **Lean target exists**: yes (line 1603)
- **Signature matches**: yes
- **notes**: axiom-clean

### `\lean{AlgebraicGeometry.Scheme.Modules.dualIsoOfIso}` (`def:scheme_modules_dual_iso_of_iso`)
- **Lean target exists**: yes (line 1698)
- **Signature matches**: yes
- **notes**: axiom-clean

### `\lean{AlgebraicGeometry.Scheme.Modules.overSliceSheafEquiv}` (`lem:open_immersion_slice_sheaf_equiv`)
- **Lean target exists**: yes (line 2366)
- **Signature matches**: yes — `(A : Type w) [Category.{v} A] : Sheaf ((Opens.grothendieckTopology X).over U) A ≌ Sheaf (Opens.grothendieckTopology ↥U) A`
- **Proof follows sketch**: yes — uses `Equivalence.sheafCongr` + `overEquivInverseIsDenseSubsite`
- **notes**: axiom-clean (iter-229); **however, see CRITICAL FINDING below**

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial}` (`lem:dual_isLocallyTrivial`)
- **Lean target exists**: **no** — not in the Lean file (open obligation)
- **notes**: Blueprint does not have `\leanok`; not a Lean error. **BUT SEE CRITICAL FINDING below regarding the blueprint proof sketch.**

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_of_isIso_restrict}` (`lem:isiso_of_isiso_restrict`)
- **Lean target exists**: yes (line 2062)
- **Signature matches**: yes
- **Proof follows sketch**: yes — stalkwise iso criterion via `restrictStalkNatIso`
- **notes**: axiom-clean (iter-226)

### `\lean{AlgebraicGeometry.Scheme.Modules.homMk}` (`def:scheme_modules_homMk`)
- **Lean target exists**: yes (line 2103) with simp companion `toPresheaf_map_homMk` (line 2111)
- **Signature matches**: yes
- **notes**: axiom-clean; `toPresheaf_map_homMk` mentioned in blueprint prose but has no `\lean{...}` pin (minor gap)

### `\lean{AlgebraicGeometry.Scheme.Modules.homOfLocalCompat}` (`lem:sheafofmodules_hom_of_local_compat`)
- **Lean target exists**: **no** — not in the Lean file (open obligation)
- **notes**: Blueprint correctly has no `\leanok`. See secondary note below.

---

## Red flags

### ⚠️ CRITICAL — Blueprint proof sketch falsified by iter-230 probe: `lem:dual_isLocallyTrivial`

**Location**: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`, lines 2954–3028, `\begin{proof}` for `lem:dual_isLocallyTrivial`

**The claim**: After Steps 1–3 + H1 (which typecheck verbatim from the tensor, as correctly noted), the proof body states (lines 3002–3010):

> "The residual is instead discharged by the shared slice-site sheaf equivalence `lem:open_immersion_slice_sheaf_equiv`. Under that equivalence the slice internal hom computed over `Over V` inside `Opens X` corresponds to the slice internal hom computed over `Opens U~`; because `Opens X` is a thin poset, the comparison is precisely the poset-thin reindexing of `overEquivalence U`…"

**Why this is wrong**: The iter-230 probe empirically verified (Lean file, lines 2118–2162, section "iter-230 C-wiring diagnostic") that after Steps 1–3 + H1, the residual lives at the **PresheafOfModules level** — specifically:

```
(PresheafOfModules.pushforward β).obj (PresheafOfModules.dual M.val)
    ≅  PresheafOfModules.dual ((PresheafOfModules.pushforward β).obj M.val)
```

`overSliceSheafEquiv` has type:
```
Sheaf ((Opens.grothendieckTopology X).over U) A ≌ Sheaf (Opens.grothendieckTopology ↥U) A
```

This is a **Sheaf-category** equivalence (fixed value-category `A`). The residual is a **PresheafOfModules** isomorphism over a **varying ring**. Three distinct mismatches make `overSliceSheafEquiv` inapplicable here:

1. **Level mismatch**: Step 3 already stripped the outer sheafification (via `mapIso`), leaving a purely presheaf-level goal. `overSliceSheafEquiv` operates on sheaves, not presheaves of modules.
2. **Value-category mismatch**: `overSliceSheafEquiv` is parametric in a fixed value-category `A`. The dual's value module `internalHomObjModule` at `V` is `Hom(M|_V ⟶ R|_V)`, which carries an `R(V)`-module structure over the **varying** ring — not a fixed-A Sheaf object.
3. **Slice granularity mismatch**: The dual uses the per-open-`V` slice `restr V = pushforward₀ (Over.forget V)`, a fine per-point slicing. `overSliceSheafEquiv` works over the whole-`U` slice site `(gt X).over U`, which does not see this per-`V` structure.

**Consequence**: A prover following the blueprint proof sketch for `lem:dual_isLocallyTrivial` would attempt to apply `overSliceSheafEquiv` to close the post-H1 presheaf residual and find it categorically impossible — the types don't align and no coercion bridges them. The Lean file documents precisely this outcome (OUTCOME (ii): "This residual CANNOT be discharged by the shared root `overSliceSheafEquiv`").

**What the blueprint should say instead**: The `% NOTE` block at lines 2913–2936 already records the historical correction. The actual proof body has not been updated to match what OUTCOME (ii) shows is actually needed — a new presheaf+module-level slice comparison:
```
Hom_{Over_X(fV)}(restr(fV) A, restr(fV) 𝟙_X)  ≅  Hom_{Over_Y V}(restr V ((pushforward β)A), restr V 𝟙_Y)
```
natural in V and R_Y(V)-linear, induced by the slice equivalence `Over_Y V ≌ Over_X(fV)` (the per-V shadow of `Opens.overEquivalence`, valid because `f.opensFunctor` is fully faithful). This is a genuine new build, **not** reducible to the existing Sheaf-level `overSliceSheafEquiv`.

### Placeholder bodies

- `isLocallyInjective_whiskerLeft_of_W` at line 691: body is `:= sorry`. Blueprint marks statement block `\leanok` (correctly: "at least a sorry present"); proof block has no `\leanok` (correct: open obligation). No discrepancy with the blueprint's marking.
- `exists_tensorObj_inverse` at line 2210: `:= sorry`. Blueprint correctly marks statement block `\leanok`; proof body explicitly states "Infrastructure-blocked." Consistent.
- `addCommGroup_via_tensorObj` at line 2256: `:= sorry`. Open obligation.

### Excuse-comments (acceptable — documented open obligations, not active-code comments)

The comment blocks in the Lean file (e.g., lines 2118–2162 "iter-230 C-wiring diagnostic") are diagnostic notes recording probe outcomes, not excusing wrong production code. They are within a section that explicitly states "The diagnostic def is intentionally NOT committed." These are appropriate engineering documentation.

---

## Unreferenced declarations (informational)

The following substantive declarations in the Lean file have no `\lean{...}` blueprint pin but are helpers for pinned declarations:

- `restrictIsoUnitOfLE` (line 1889): helper for `tensorObj_isLocallyTrivial`; standalone axiom-clean utility
- `tensorObjIsoOfIso` (line 1733): functor-of-isos for tensorObj; helper for `tensorObj_isLocallyTrivial`
- `overEquivInverseIsDenseSubsite` (line 2340): instance supporting `overSliceSheafEquiv`
- `overEquiv_image_cover_iff` (private, line 2311): internal helper
- `restr_map_homMk` (private, line 1491): internal helper for `internalHomEval` naturality
- `hom_app_heq` (private, line 1220): internal helper
- Various `globalSMul` helpers (lines 1108–1130): supporting `homModule`
- `evalLin`, `evalLin_add`, `evalLin_smul` (lines 1414–1446): supporting `internalHomEvalApp`
- `internalHomEvalApp`, `internalHomEvalApp_tmul` (lines 1455–1482): supporting `internalHomEval`
- `restrictionMap*` helpers (lines 1204–1328): supporting `internalHom`
- `termRingMap`, `termRingMap_naturality`, `termRingMap_terminal` (lines 1069, 1076, 1378)
- `toPresheaf_map_homMk` (line 2111): `@[simp]` companion of `homMk`, mentioned in blueprint prose for `def:scheme_modules_homMk` but not given a `\lean{...}` pin — minor gap

None of these are suspicious; all are documented helpers.

---

## Blueprint adequacy for this file

- **Coverage**: 26/30 `\lean{...}`-pinned declarations exist in Lean. The 4 missing ones (`dual_isLocallyTrivial`, `homOfLocalCompat`, `pullback_tensorObj_iso`, `tensorObjIsoclassCommMonoid`) are open proof obligations correctly marked as unformalized (no `\leanok`).
- **Proof-sketch depth**: **incorrect** for `lem:dual_isLocallyTrivial` (see critical finding above); adequate for all other unformalized declarations. For formalized declarations: adequate to very detailed.
- **Hint precision**: precise throughout.
- **Generality**: matches need.

**Recommended chapter-side actions**:

1. **(Must-fix-this-iter)** Update the `\begin{proof}` body of `lem:dual_isLocallyTrivial` (lines 2954–3028) to replace the claim that `overSliceSheafEquiv` closes the post-H1 presheaf residual with the OUTCOME (ii) findings from the iter-230 probe: the genuine new build required is a presheaf+module-level per-V slice comparison (see the "Precise decomposition" in the Lean file comment lines 2149–2158 for the exact statement). The `% NOTE` block at lines 2913–2936 should be reconciled with the updated proof body.

2. **(Informational)** Verify whether `lem:sheafofmodules_hom_of_local_compat`'s use of `overSliceSheafEquiv` for "section-direction slice" naturality (lines 3100, 3133) is sound. The A-engine uses `overSliceSheafEquiv` at the `Sheaf` (hom-into-sheaf) level, not at the `PresheafOfModules` level — this use MAY be valid (fixed-value-cat sheaf, not varying-ring module). The plan agent should confirm this distinction explicitly in the blueprint.

3. **(Minor)** Add `\lean{AlgebraicGeometry.Scheme.Modules.toPresheaf_map_homMk}` to `def:scheme_modules_homMk` since the blueprint prose already describes it.

4. **(Minor)** `lem:tensorobj_unit_iso` lacks `\leanok` on its statement block in the blueprint; both `tensorObj_left_unitor` and `tensorObj_right_unitor` are axiom-clean in Lean. Sync_leanok handles this automatically.

---

## Severity summary

| # | Finding | Severity |
|---|---------|----------|
| 1 | Blueprint `lem:dual_isLocallyTrivial` proof body falsely asserts `overSliceSheafEquiv` closes the post-H1 presheaf-level residual; iter-230 probe gives 3 concrete categorical mismatches showing this is impossible | **must-fix-this-iter** |
| 2 | 4 blueprint-pinned declarations absent from Lean (`dual_isLocallyTrivial`, `homOfLocalCompat`, `pullback_tensorObj_iso`, `tensorObjIsoclassCommMonoid`) — correctly marked unformalized, open obligations | **major** (informational) |
| 3 | `lem:sheafofmodules_hom_of_local_compat` invokes `overSliceSheafEquiv` for "localSection naturality"; needs explicit confirmation that this A-engine use is at the Sheaf-of-types level (valid) rather than PresheafOfModules level (invalid per OUTCOME (ii)) | **major** |
| 4 | `toPresheaf_map_homMk` mentioned in blueprint prose but lacks `\lean{...}` pin | **minor** |
| 5 | `lem:tensorobj_unit_iso` missing `\leanok` on statement block (sync_leanok will handle) | **minor** |

**Overall verdict**: The Lean file is faithful to the blueprint for all formalized declarations; the single critical failure is in the blueprint's proof sketch for `lem:dual_isLocallyTrivial`, which prescribes applying `overSliceSheafEquiv` to close the C-bridge — a path empirically confirmed impossible by the iter-230 probe (OUTCOME (ii)), documented in the Lean file at lines 2118–2162 but not yet corrected in the blueprint prose.
