# Lean ↔ Blueprint Check Report

## Slug
snap-iter063

## Iteration
063

## Files audited
- Lean: `AlgebraicJacobian/Picard/SectionGradedRing.lean`
- Blueprint: `blueprint/src/chapters/Picard_SectionGradedRing.tex`

---

## Per-declaration

### `\lean{PresheafOfModules.monoidalCategory}` (`lem:presheafModule_monoidal_mathlib`)
- **Lean target exists**: yes (Mathlib; `\mathlibok`)
- **Signature matches**: yes
- **Proof follows sketch**: N/A (Mathlib-backed)
- **notes**: Correctly tagged `\mathlibok`.

### `\lean{PresheafOfModules.sheafification}` (`lem:presheafModule_sheafification_mathlib`)
- **Lean target exists**: yes (Mathlib; `\mathlibok`)
- **Signature matches**: yes
- **Proof follows sketch**: N/A
- **notes**: Correctly tagged `\mathlibok`.

### `\lean{SheafOfModules.unit}` (`lem:moduleUnit_mathlib`)
- **Lean target exists**: yes (Mathlib; `\mathlibok`)
- **Signature matches**: yes
- **Proof follows sketch**: N/A
- **notes**: Correctly tagged `\mathlibok`.

### `\lean{AlgebraicGeometry.Scheme.Modules.MonoidalPresheaf}` (`def:monoidalPresheaf`)
- **Lean target exists**: yes — `private abbrev MonoidalPresheaf` at line 79
- **Signature matches**: yes — `Type _` defined as `PresheafOfModules (X.sheaf.obj ⋙ forget₂ CommRingCat RingCat)`, matching blueprint prose
- **Proof follows sketch**: N/A (abbreviation, no proof body)
- **notes**: Declaration is `private`. The `\leanok` marker is present in the blueprint; `sync_leanok` cannot verify private declarations by qualified name and may strip this marker each iter. See **Private declarations** section below.

### `\lean{AlgebraicGeometry.Scheme.Modules.sheafification}` (`def:schemeModuleSheafification`)
- **Lean target exists**: yes — `noncomputable def sheafification` at line 70
- **Signature matches**: yes — `X.PresheafOfModules ⥤ X.Modules`, applied `PresheafOfModules.sheafification` to `𝟙 X.ringCatSheaf.obj`
- **Proof follows sketch**: yes
- **notes**: Public, sorry-free. ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.unitModule}` (`def:unitModule`)
- **Lean target exists**: yes — `private noncomputable abbrev unitModule` at line 94
- **Signature matches**: yes — `X.Modules` as `SheafOfModules.unit X.ringCatSheaf`
- **Proof follows sketch**: N/A (abbreviation)
- **notes**: `private`. Same `sync_leanok` concern as `MonoidalPresheaf`.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (`def:sheafTensorObj`)
- **Lean target exists**: yes — `noncomputable def tensorObj` at line 86
- **Signature matches**: yes — `F G : X.Modules → X.Modules`, sheafification of presheaf tensor
- **Proof follows sketch**: yes (matches Stacks Tag 01CA construction exactly)
- **notes**: Public, sorry-free. ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorPow}` (`def:sheafTensorPow`)
- **Lean target exists**: yes — `noncomputable def tensorPow` at line 100 (recursion)
- **Signature matches**: yes — `L : X.Modules → ℕ → X.Modules`, base `unitModule X`, successor `tensorObj`
- **Proof follows sketch**: yes
- **notes**: Public, sorry-free. ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorPow_zero}` / `tensorPow_succ` (`lem:tensorPow_zero`, `lem:tensorPow_succ`)
- **Lean target exists**: yes — `@[simp] private lemma tensorPow_zero/succ` at lines 104–107
- **Signature matches**: yes
- **Proof follows sketch**: yes (both are `rfl`)
- **notes**: Both `private`. Blueprint marks them `\leanok`; `sync_leanok` concern applies (see below).

### `\lean{AlgebraicGeometry.Scheme.Modules.moduleTensorPow}` (`def:sheafModuleTwist`)
- **Lean target exists**: yes — `noncomputable def moduleTensorPow` at line 112
- **Signature matches**: yes — `F ⊗ L^{⊗m}`
- **Proof follows sketch**: yes
- **notes**: Public, sorry-free. ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.moduleTensorPow_zero}` (`lem:moduleTensorPow_zero`)
- **Lean target exists**: yes — `@[simp] private lemma moduleTensorPow_zero` at line 115
- **Signature matches**: yes
- **Proof follows sketch**: yes (rfl)
- **notes**: `private`. `sync_leanok` concern applies.

### `\lean{AlgebraicGeometry.Scheme.Modules.sheafificationCounitIso}` (`def:sheafificationCounitIso`)
- **Lean target exists**: yes — `private noncomputable def sheafificationCounitIso` at line 131
- **Signature matches**: yes — counit iso `sheafification.obj (toPresheafOfModules.obj G) ≅ G`
- **Proof follows sketch**: yes
- **notes**: `private`. `sync_leanok` concern applies.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjUnitIso}` (`def:tensorObjUnitIso`)
- **Lean target exists**: yes — `private noncomputable def tensorObjUnitIso` at line 140
- **Signature matches**: yes — `unitModule X ⊗ G ≅ G`, left unitor
- **Proof follows sketch**: yes (presheaf left unitor ≪≫ counit iso)
- **notes**: `private`. `sync_leanok` concern applies.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjRightUnitor}` (`def:tensorObjRightUnitor`)
- **Lean target exists**: yes — `private noncomputable def tensorObjRightUnitor` at line 151
- **Signature matches**: yes — `G ⊗ unitModule X ≅ G`, right unitor
- **Proof follows sketch**: yes
- **notes**: `private`. `sync_leanok` concern applies.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorBraiding}` (`def:tensorBraiding`)
- **Lean target exists**: yes — `private noncomputable def tensorBraiding` at line 164
- **Signature matches**: yes — `F ⊗ G ≅ G ⊗ F`, braiding
- **Proof follows sketch**: yes
- **notes**: `private`. `sync_leanok` concern applies.

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_sheafification_map_iff}` (`lem:isIso_sheafification_map_iff`)
- **Lean target exists**: yes — `lemma isIso_sheafification_map_iff` at line 218
- **Signature matches**: yes — `IsIso (sheafification.map f) ↔ (opensTopology X).W ((toPresheaf _).map f)`
- **Proof follows sketch**: yes — localization criterion, proved via `inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms`
- **notes**: Public, sorry-free. ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.localIso_toPresheaf_map_unit}` (`lem:localIso_toPresheaf_map_unit`)
- **Lean target exists**: yes — `lemma localIso_toPresheaf_map_unit` at line 243
- **Signature matches**: yes — `(opensTopology X).W` of `toPresheaf.map (sheafificationAdjunction.unit.app P)`
- **Proof follows sketch**: yes — via `toPresheaf_map_sheafificationAdjunction_unit_app` + `W_toSheafify`
- **notes**: Public, sorry-free. ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_sheafification_map_unit}` (`lem:isIso_sheafification_map_unit`)
- **Lean target exists**: yes — `lemma isIso_sheafification_map_unit` at line 255
- **Signature matches**: yes — `IsIso (sheafification.map (unit.app P))`
- **Proof follows sketch**: yes — `(isIso_sheafification_map_iff _).mpr (localIso_toPresheaf_map_unit P)`
- **notes**: Public, sorry-free. ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.relTensorDomainPresheaf}` (`def:relTensorDomainPresheaf`)
- **Lean target exists**: yes — `noncomputable def relTensorDomainPresheaf` at line 484
- **Signature matches**: yes — `P Q : X.PresheafOfModules → (Opens X)ᵒᵖ ⥤ Ab`, `obj U = P(U) ⊗_ℤ Q(U)`
- **Proof follows sketch**: yes — functoriality by `⊗`-induction
- **notes**: Public, sorry-free. ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.relTensorTriplePresheaf}` (`def:relTensorTriplePresheaf`)
- **Lean target exists**: yes — `noncomputable def relTensorTriplePresheaf` at line 515
- **Signature matches**: yes — `obj U = P(U) ⊗_ℤ (𝒪_X(U) ⊗_ℤ Q(U))`, middle factor restricts via ring map
- **Proof follows sketch**: yes
- **notes**: Public, sorry-free. ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.relTensorActL}` (`def:relTensorActL`)
- **Lean target exists**: yes — `noncomputable def relTensorActL` at line 552
- **Signature matches**: yes — natural transformation `relTensorTriplePresheaf P Q ⟶ relTensorDomainPresheaf P Q`, objectwise `actLmap`, `m ⊗ (s ⊗ n) ↦ (s • m) ⊗ n`
- **Proof follows sketch**: yes — naturality from `PresheafOfModules.map_smul` via `objRestrict` bridge, `⊗`-induction
- **notes**: Public, sorry-free. ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.relTensorActR}` (`def:relTensorActR`)
- **Lean target exists**: yes — `noncomputable def relTensorActR` at line 594
- **Signature matches**: yes — parallel to `relTensorActL`, `m ⊗ (s ⊗ n) ↦ m ⊗ (s • n)`
- **Proof follows sketch**: yes
- **notes**: Public, sorry-free. ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.relTensorProj}` (`def:relTensorProj`)
- **Lean target exists**: yes — `noncomputable def relTensorProj` at line 632
- **Signature matches**: yes — `relTensorDomainPresheaf P Q ⟶ (toPresheaf _).obj (P ⊗_p Q)`, objectwise `projL`, `m ⊗ n ↦ m ⊗_R n`
- **Proof follows sketch**: yes — naturality on elementary tensors is `rfl`; transport via `LinearMap.congr_fun`
- **notes**: Public, sorry-free. ✓

### 22-name `\lean{...}` block on `lem:relativeTensor_objectwise_coequalizer`
- **Lean target exists**: yes — all 22 declarations present in `namespace RelativeTensorCoequalizer` (lines 287–421)
- **Signature matches**: yes — checked all 22:
  - `actN`/`actM` (lines 287, 293): `ℤ`-linear scalar action maps ✓
  - `actLmap`/`actRmap` (lines 303, 299): `ℤ`-linear action maps on triple tensor ✓
  - `projL` (line 317): quotient map `M ⊗_ℤ N → M ⊗_S N` ✓
  - `projL_surjective`/`projL_comp_act` (lines 329, 339): correctness lemmas ✓
  - `aL`/`aR`/`piMor` (lines 352, 356, 360): Ab-category morphisms ✓
  - `piMor_epi`/`coeq_condition`/`cofork` (lines 366, 370, 374): cofork data ✓
  - `descHom`/`descMor`/`descFac` (lines 380, 399, 404): universal property ✓
  - `isColimitCofork` (line 418): colimit witness ✓
  - `actLmap_tmul`/`actRmap_tmul`/`projL_tmul`/`piMor_apply`/`descHom_tmul` (lines 308, 312, 325, 364, 395): simp lemmas ✓
- **Proof follows sketch**: yes — construction matches blueprint proof of `lem:relativeTensor_objectwise_coequalizer` exactly (liftAddHom for existence, epi-cancellation of `piMor` for uniqueness)
- **notes**: **SYNC ISSUE (ongoing, documented)**: `sync_leanok` cannot evaluate multi-name `\lean{}` fields and strips `\leanok` from this block each iter. The review manually re-applies `\leanok`. All 22 names are sorry-free and match the multi-name pin. This is a workflow limitation, not a correctness failure.

### `\lean{AlgebraicGeometry.Scheme.Modules.relativeTensorCoequalizerIso}` (`lem:relativeTensor_as_coequalizer`)
- **Lean target exists**: yes — `noncomputable def relativeTensorCoequalizerIso` at line 702
- **Signature matches**: yes — `Limits.IsColimit (Limits.Cofork.ofπ (relTensorProj P Q) (relTensorActL_proj_eq P Q))`, the presheaf-level coequalizer for the relative tensor
- **Proof follows sketch**: yes — `evaluationJointlyReflectsColimits` (Step 2 in blueprint) + `isColimitMapCoconeCoforkEquiv` + `isColimitCofork` at each `U` (Steps 1 and 3); the apex identification is implicit via `relTensorProj`'s codomain
- **notes**: **This is the iter-063 closure target** (2 embedded sorries → 0). The proof body is complete and sorry-free. ✓

### `\lean{TensorProduct.liftAddHom}` (`lem:tensorProduct_liftAddHom_mathlib`)
- **Lean target exists**: yes (Mathlib; `\mathlibok`)
- **Signature matches**: yes
- **Proof follows sketch**: N/A
- **notes**: Correctly tagged `\mathlibok`.

### `\lean{CategoryTheory.Limits.evaluationJointlyReflectsColimits}` (`lem:evaluationJointlyReflectsColimits_mathlib`)
- **Lean target exists**: yes (Mathlib; `\mathlibok`) — NOTE: blueprint's inline comment (line 683 of Lean file) flags that leansearch only found `evaluationJointlyReflectsLimits`; the colimit version `evaluationJointlyReflectsColimits` was verified in use.
- **Signature matches**: yes
- **Proof follows sketch**: N/A
- **notes**: Correctly tagged `\mathlibok`. The inline note in the handoff comment about leansearch finding only the limits version is a historical note; the declaration is correctly used at line 704.

### `\lean{PresheafOfModules.Monoidal.tensorObj_obj}` (`lem:presheaf_tensorObj_obj_mathlib`)
- **Lean target exists**: yes (Mathlib; `\mathlibok`)
- **Signature matches**: yes
- **Proof follows sketch**: N/A
- **notes**: Correctly tagged `\mathlibok`.

### `\lean{AlgebraicGeometry.Scheme.Modules.sectionsMul}` (`def:sectionMul`)
- **Lean target exists**: yes — `noncomputable def sectionsMul` at line 188
- **Signature matches**: yes — global-sections multiplication `(P ⊗_p Q)(⊤) ⟶ (tensorObj F G).val.obj (op ⊤)`, the lax-monoidal unit
- **Proof follows sketch**: yes — sheafification unit at top open
- **notes**: Public, sorry-free. ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_sheafification_whiskerRight_unit}` (`lem:isIso_sheafification_whiskerRight_unit`)
- **Lean target exists**: **no** — declaration absent from Lean file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Future work; correctly has no `\leanok` in the blueprint. Handoff comment (lines 847–962) documents the three blocked routes and the single remaining gap (`J.W (toPresheaf.map (η_P ▷ Q))`).

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjAssoc}` (`cor:sheafTensorObjAssoc`)
- **Lean target exists**: **no** — absent
- **Signature matches**: N/A
- **notes**: Future work; blocked on `isIso_sheafification_whiskerRight_unit`. Correctly no `\leanok`.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorPowAdd}` (`lem:sheafTensorPow_add`)
- **Lean target exists**: **no** — absent
- **notes**: Future work; blocked on `tensorObjAssoc`. Correctly no `\leanok`.

### `\lean{AlgebraicGeometry.Scheme.Modules.sectionsMul_assoc_unit}` (`lem:sectionMul_coherent`)
- **Lean target exists**: **no** — absent
- **notes**: Future work; blocked on `tensorPowAdd`. Correctly no `\leanok`.

### `\lean{AlgebraicGeometry.sectionGradedRing_gcommSemiring}` (`lem:sectionGradedRing_gcommSemiring`)
- **Lean target exists**: **no** — absent
- **notes**: Future work. Correctly no `\leanok`.

### `\lean{AlgebraicGeometry.sectionGradedModule_gmodule}` (`lem:sectionGradedModule_gmodule`)
- **Lean target exists**: **no** — absent
- **notes**: Future work. Correctly no `\leanok`.

---

## Red flags

No red flags found. Specifically:
- **0 sorry** in actual Lean code (grep confirms: the single `sorry` mention at line 856 is inside a block comment, not a proof obligation).
- No `:= True`, `:= rfl` on non-trivial claims.
- No excuse-comments on existing declarations (the `/- ... -/` handoff blocks are attached to absent future declarations, not to present ones).
- No `axiom` declarations.

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have no `\lean{}` blueprint pin:

| Declaration | Location | Assessment |
|---|---|---|
| `relTensorActL_proj_eq` | line 672 | **Coverage debt** (see directive check (c)): this `lemma` is the cofork-condition helper used as an argument to `relativeTensorCoequalizerIso`; it was added this iter as infrastructure for closing `relativeTensorCoequalizerIso`. It is not `private` and its statement (`relTensorActL ≫ relTensorProj = relTensorActR ≫ relTensorProj`) is mathematically meaningful (it IS the cofork condition of `lem:relativeTensor_as_coequalizer`). A `\lean{}` pin under `def:relTensorProj` or `lem:relativeTensor_as_coequalizer` would be appropriate. |
| `objRestrict`, `objRestrict_apply`, `objRestrict_id`, `objRestrict_comp` | lines 448–475 | `private` infrastructure for the syntactic-carrier fix; no pin needed. |
| `opensTopology` | line 205 | `private abbrev`; no pin needed. |

---

## Blueprint adequacy for this file

- **Coverage**: 26/32 Lean declarations have a corresponding `\lean{}` block (the remaining 6 are helpers: `objRestrict`×4 + `opensTopology` + `relTensorActL_proj_eq`). The 6 future declarations (`isIso_sheafification_whiskerRight_unit`, `tensorObjAssoc`, `tensorPowAdd`, `sectionsMul_assoc_unit`, `sectionGradedRing_gcommSemiring`, `sectionGradedModule_gmodule`) correctly have `\lean{}` pins without `\leanok` — their absence from the Lean file is documented.

- **Proof-sketch depth**: **adequate** for all formalized blocks. The blueprint provides proof sketches for `lem:relativeTensor_objectwise_coequalizer` and `lem:relativeTensor_as_coequalizer` at sufficient depth for a prover to follow; the naturality argument for `relTensorActL`/`relTensorActR`/`relTensorProj` is correctly described (the `objRestrict` carrier-fix solution adopted this iter is consistent with the "next-iter handle (1)" described in the handoff comment). Future-work blocks (`isIso_sheafification_whiskerRight_unit` and downstream) have detailed handoff notes.

- **Hint precision**: **precise** for formalized blocks. The `\lean{}` names match the Lean declarations exactly (modulo the `private` accessibility issue noted below).

- **Generality**: **matches need** for formalized content.

- **Recommended chapter-side actions**:
  1. **(minor)** Add a `\lean{AlgebraicGeometry.Scheme.Modules.relTensorActL_proj_eq}` pin to either the `def:relTensorProj` or `lem:relativeTensor_as_coequalizer` block to close the coverage debt.
  2. **(minor)** Investigate whether `sync_leanok` can resolve `private` declaration names (e.g., `tensorPow_zero`, `sheafificationCounitIso`, `unitModule`, etc.). If not, consider whether these declarations should be made non-`private` (so `sync_leanok` can verify them) or whether the `\leanok` markers on their blocks should be maintained manually alongside the 22-name field. The current blueprint has `\leanok` on all of them, which is correct but may be fragile under automated sync.

---

## Special directive checks

### (a) `\lean{}` pins resolve
**All pins for formalized declarations resolve.** Private declarations (`MonoidalPresheaf`, `unitModule`, `sheafificationCounitIso`, `tensorObjUnitIso`, `tensorObjRightUnitor`, `tensorBraiding`, `tensorPow_zero`, `tensorPow_succ`, `moduleTensorPow_zero`) exist in the file with correct bodies — the `private` modifier does not invalidate the mathematical content but does affect external verifiability (see (b) below). All 22 declarations in the multi-name pin on `lem:relativeTensor_objectwise_coequalizer` resolve. The 6 absent future declarations correctly have no `\leanok`.

### (b) `\leanok` honest — file is 0-sorry
**Yes, confirmed.** `grep -n "sorry"` returns a single hit at line 856, inside a `/- ... -/` block comment ("left *absent* rather than backed by a `sorry`"). No proof obligation carries a `sorry`. All `\leanok`-marked declarations are sorry-free. The `relativeTensorCoequalizerIso` closure (2 sorries → 0) is verified.

**Caveat on `private` declarations**: Nine blueprint blocks carry `\leanok` pins to `private` declarations. If `sync_leanok` cannot look up `private` qualified names (e.g., `AlgebraicGeometry.Scheme.Modules.tensorBraiding`), these markers would be stripped each iter and would need manual re-application — the same situation as the 22-name field. Whether this is occurring is not visible from a read-only audit; it is flagged as a **major** concern that the project should clarify.

### (c) `relTensorActL_proj_eq` — no `\lean{}` pin (coverage debt)
**Confirmed.** `lemma relTensorActL_proj_eq` at line 672 has no `\lean{}` pin in the blueprint. It is the cofork-condition bridge added this iter so that `relativeTensorCoequalizerIso` could reference a named lemma rather than an inline proof. The lemma is not `private`, and its statement is part of the mathematical content of `lem:relativeTensor_as_coequalizer`. This is **minor coverage debt**: the blueprint should pin it (under `def:relTensorProj` or `lem:relativeTensor_as_coequalizer`) or the lemma should be made `private` if it is purely internal scaffolding.

### (d) 22-name multi-`\lean{}` pin on `lem:relativeTensor_objectwise_coequalizer`
**Confirmed ongoing workflow issue.** The `\lean{}` field on `lem:relativeTensor_objectwise_coequalizer` (blueprint lines 651–672) carries 22 comma-separated names. `sync_leanok` cannot parse multi-name fields and strips `\leanok` each iter; the review re-applies it manually. **All 22 declarations exist, are sorry-free, and their signatures match the blueprint statement.** The `\leanok` on the statement block (line 648) and proof block (line 691) is mathematically accurate. The manual re-application is necessary and correct given the current sync tooling.

---

## Severity summary

| Finding | Severity |
|---|---|
| `sync_leanok` cannot evaluate multi-name `\lean{}` field on `lem:relativeTensor_objectwise_coequalizer`; `\leanok` stripped each iter and must be manually re-applied | **major** (ongoing documented issue; not a new finding) |
| 9 private declarations have `\lean{}` pins; `sync_leanok` may strip their `\leanok` markers silently | **major** (project should clarify whether sync handles these) |
| `relTensorActL_proj_eq` (line 672) has no `\lean{}` blueprint pin | **minor** (coverage debt) |

No **must-fix-this-iter** findings. All formalized declarations are sorry-free with correct signatures.

**Overall verdict**: The Lean file is axiom-clean and 0-sorry after the iter-063 closure of `relativeTensorCoequalizerIso`; all `\lean{}` pins for formalized declarations resolve correctly. Two structural workflow concerns (multi-name field sync, private-declaration sync) are ongoing and documented; one minor coverage gap (`relTensorActL_proj_eq` unpinned) was added this iter.
