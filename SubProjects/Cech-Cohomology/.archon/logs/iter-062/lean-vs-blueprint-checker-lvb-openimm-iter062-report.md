# Lean ↔ Blueprint Check Report

## Slug
lvb-openimm-iter062

## Iteration
062

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (consolidating chapter; `% archon:covers AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean` at line 16)

---

## Per-declaration

### `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_comp, ..., AlgebraicGeometry.isAffineHom_of_affine_separated}` (`lem:open_immersion_pushforward_comp`)

- **Lean targets exist**: yes for all three (`higherDirectImage_openImmersion_acyclic`, `higherDirectImage_openImmersion_comp`, `isAffineHom_of_affine_separated`)
- **Signature matches**: yes — `higherDirectImage_openImmersion_acyclic` is `theorem`/`IsZero (higherDirectImage j q H)`, `higherDirectImage_openImmersion_comp` returns `higherDirectImage f k (...) ≅ higherDirectImage (j ≫ f) k H`, `isAffineHom_of_affine_separated` is the private helper
- **Proof follows sketch**: **partial / no** for the two main declarations:
  - `higherDirectImage_openImmersion_acyclic`: proof is nearly complete but has `sorry` at the `hqc` case (line 670) — the per-slice quasi-coherence of `Φ H`. Blueprint's proof path (steps 1–3) is followed faithfully up to that point.
  - `higherDirectImage_openImmersion_comp`: body is entirely `sorry` (line 736). Blueprint has a complete two-step proof sketch.
- **Notes**:
  - `isAffineHom_of_affine_separated` is axiom-clean; fine.
  - The `hqc sorry` in `higherDirectImage_openImmersion_acyclic` is the direct consequence of `pushforwardSlicePullbackIso` not existing yet (see red flags below).

---

### `\lean{AlgebraicGeometry.pushforwardSectionsFunctor, AlgebraicGeometry.pushforwardSectionsFunctor_additive}` (`lem:pushforward_sections_functor`)

- **Lean targets exist**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes (additive composite, 5-fold chain defeats inferInstance — Lean uses explicit chain as described in blueprint docstring)
- **Notes**: no `\leanok` on blueprint block yet (awaiting `sync_leanok`)

---

### `\lean{AlgebraicGeometry.toPresheafOfModules_additive}` (`lem:toPresheafOfModules_additive`)

- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes — `forget ⋙ restrictScalars 𝟙`, composite of additive functors
- **Notes**: `\leanok` present ✓

---

### `\lean{AlgebraicGeometry.sectionsFunctor_additive}` (`lem:sectionsFunctor_additive`)

- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **Notes**: `\leanok` present ✓

---

### `\lean{AlgebraicGeometry.sectionsFunctorCorepIso}` (`lem:sectionsFunctorCorepIso`)

- **Lean target exists**: yes
- **Signature matches**: yes — `sectionsFunctor V ≅ preadditiveCoyoneda.obj (op (jShriekOU V))`
- **Proof follows sketch**: yes
- **Notes**: `\leanok` present ✓

---

### `\lean{AlgebraicGeometry.rightDerivedNatIso}` (`lem:rightDerivedNatIso`)

- **Lean target exists**: yes
- **Signature matches**: yes — `F ≅ G → F.rightDerived n ≅ G.rightDerived n`
- **Proof follows sketch**: yes — assembled from `NatTrans.rightDerived` on hom/inv, composition, identity
- **Notes**: `\leanok` present ✓

---

### `\lean{AlgebraicGeometry.modulesIsoSpecExtTransport, ..., AlgebraicGeometry.Scheme.Modules.pushforwardExtAddEquiv}` (`lem:modules_isoSpec_ext_transport`)

- **Lean targets exist**: yes — `pushforwardEquivOfIso`, `pushforwardEquivOfIso_functor_additive`, `pushforwardExtAddEquiv`, `modulesIsoSpecExtTransport` all present and axiom-clean
- **Signature matches**: yes for all four — `pushforwardEquivOfIso φ : X.Modules ≌ Y.Modules`, `pushforwardExtAddEquiv` yields `Ext A B n ≃+ Ext (Φ A) (Φ B) n`, `modulesIsoSpecExtTransport` specialises to `isoSpec`
- **Proof follows sketch**: yes
- **Notes**: no `\leanok` on blueprint block (will be added by `sync_leanok`); the block's `\uses` chain includes `lem:pushforward_iso_preserves_qcoh` (not yet built) which suppresses `\leanok` — informational only since the declared Lean targets are themselves sorry-free

---

### `\lean{AlgebraicGeometry.isZero_coyoneda_rightDerived_of_forall_ext_eq_zero, AlgebraicGeometry.preadditiveCoyoneda_mapHomologicalComplex_d_apply}` (`lem:isZero_coyoneda_rightDerived_of_forall_ext_eq_zero`)

- **Lean targets exist**: yes — both axiom-clean
- **Signature matches**: yes
- **Proof follows sketch**: yes — choose injective resolution, use `isoRightDerivedObj`, `extMk_eq_zero_iff`
- **Notes**: no `\leanok` on blueprint block (will be added by `sync_leanok`)

---

### `\lean{AlgebraicGeometry.enoughInjectives_of_hasInjectiveResolutions}` (`lem:enoughInjectives_of_hasInjectiveResolutions`)

- **Lean target exists**: yes — axiom-clean
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **Notes**: `\leanok` present ✓

---

### `\lean{AlgebraicGeometry.subsingleton_ext_of_iso_fst}` (`lem:subsingleton_ext_of_iso_fst`)

- **Lean target exists**: yes — axiom-clean
- **Signature matches**: yes — `φ : A ≅ B → [Subsingleton (Ext B Y q)] → Subsingleton (Ext A Y q)`
- **Proof follows sketch**: yes
- **Notes**: `\leanok` present ✓

---

### `\lean{AlgebraicGeometry.ext_jShriekOU_eq_zero_of_specIso}` (`lem:ext_jShriekOU_eq_zero_of_specIso`)

- **Lean target exists**: yes — axiom-clean
- **Signature matches**: yes — takes `hjt` (iso of `jShriekOU V` transport) and `hqc` (quasi-coherence) as explicit hypotheses, matching the blueprint's "suppose ..." conditions
- **Proof follows sketch**: yes
- **Notes**: `\leanok` present ✓

---

### `\lean{AlgebraicGeometry.jShriekOU_transport_along_iso, AlgebraicGeometry.sectionsCorep, AlgebraicGeometry.sectionsCorepPushforward}` (`lem:jshriek_transport_along_iso`)

- **Lean targets exist**: yes — all three axiom-clean (`sectionsCorep` and `sectionsCorepPushforward` are `private`)
- **Signature matches**: yes — `Φ.functor.obj (jShriekOU V) ≅ jShriekOU (φ.inv ⁻¹ᵁ V)`
- **Proof follows sketch**: yes — corepresentability transport via `CorepresentableBy.uniqueUpToIso`
- **Notes**: no `\leanok` on blueprint block (will be added by `sync_leanok`)

---

### `\lean{AlgebraicGeometry.pushforward_iso_qcoh_of_slice_qcoh, AlgebraicGeometry.coversTop_preimage_of_iso}` (`lem:pushforward_iso_qcoh_of_slice_qcoh`)

- **Lean targets exist**: yes — axiom-clean (`coversTop_preimage_of_iso` is `private`)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `IsQuasicoherent.of_coversTop` + cover-transport
- **Notes**: no `\leanok` on blueprint block (will be added by `sync_leanok`)

---

### `\lean{AlgebraicGeometry.sliceStructureSheafHom}` (`lem:slice_structureSheaf_hom`)

- **Lean target exists**: yes — axiom-clean
- **Signature matches**: yes — `(X.ringCatSheaf.over Ui) ⟶ (Over.post ...).sheafPushforwardContinuous ... (Y.ringCatSheaf.over Vᵢ)`
- **Proof follows sketch**: yes — over-pullback of `φ.inv.toRingCatSheafHom`, Beck–Chevalley rfl
- **Notes**:
  - `\leanok` is present on the block ✓
  - **STALE `% NOTE:`**: Line 9804 says `% NOTE: build target. The Lean declaration does not exist yet.` — this is now false; `sliceStructureSheafHom` exists axiom-clean. Needs removal.
  - The Lean instances `opensMapInvBase_isEquivalence`, `overPost_slice_isContinuous`, `sliceStructureSheafHom_pre_isRightAdjoint`, `sliceStructureSheafHom_isRightAdjoint` are not listed in `\lean{...}` for this block; they are auxiliary support. The `IsRightAdjoint` instance is semantically part of the blueprint statement ("carrying the instance … IsRightAdjoint") but not added to `\lean{...}`.

---

### `\lean{AlgebraicGeometry.pushforwardSlicePullbackIso}` (`lem:pushforward_slice_pullback_iso`)

- **Lean target exists**: **NO** — `pushforwardSlicePullbackIso` does not appear anywhere in `OpenImmersionPushforward.lean`
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Notes**: Blueprint `% NOTE: build target. The Lean declaration does not exist yet.` (line 9859) is accurate. This is the sole unbuilt piece causing the `hqc sorry` in `higherDirectImage_openImmersion_acyclic`.

---

### `\lean{AlgebraicGeometry.pushforward_iso_preserves_qcoh}` (`lem:pushforward_iso_preserves_qcoh`)

- **Lean target exists**: **NO** — `pushforward_iso_preserves_qcoh` does not appear in `OpenImmersionPushforward.lean`
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Notes**: Blueprint `% NOTE: build target. The Lean declaration does not exist yet.` (line 9891) is accurate.

---

### `\lean{CategoryTheory.GrothendieckTopology.isZero_presheafToSheaf_of_sections_locally_zero}` (`lem:isZero_presheafToSheaf_of_sections_locally_zero`)

- **Lean target exists**: yes — axiom-clean (namespace `CategoryTheory.GrothendieckTopology`, as expected)
- **Signature matches**: yes — `∀ U s, ∃ S ∈ J U, ∀ V g ∈ S, (Q.map g.op) s = 0 → IsZero (presheafToSheaf J Ab).obj Q`
- **Proof follows sketch**: yes — zero map `Q → Z`, local injectivity from `x - y`, local surjectivity free
- **Notes**: `\leanok` present ✓

---

## Red Flags

### Placeholder / suspect bodies

- **`AlgebraicGeometry.higherDirectImage_openImmersion_acyclic`** (line 670): `sorry` at the `hqc` case inside the proof of `higherDirectImage_openImmersion_acyclic`. The blueprint (`lem:open_immersion_pushforward_comp`) states this is a complete theorem. The sorry is the direct consequence of `pushforwardSlicePullbackIso` not existing; it is not a mathematical gap in the proof structure but a missing Lean declaration.

- **`AlgebraicGeometry.higherDirectImage_openImmersion_comp`** (line 736): body is entirely `sorry`. Blueprint claims a complete proof (acyclic-resolution comparison). Both residuals (resolution-exactness and acyclicity of `j_* Iⁿ` for `f_*`) are flagged as "handed off" in the Lean comment — they both depend on Part (1)'s sorry.

### Stale `% NOTE:` comments

- **`lem:slice_structureSheaf_hom`** (blueprint line 9804): `% NOTE: build target. The Lean declaration does not exist yet.` — **STALE**: `AlgebraicGeometry.sliceStructureSheafHom` now exists and is axiom-clean. Should be removed or replaced with a completion note.

### Blueprint adequacy failure (detailed below)

- **`lem:pushforward_slice_pullback_iso`**: the blueprint proof is mathematically incomplete; see Blueprint Adequacy section.

---

## Unreferenced Declarations (informational)

These declarations in `OpenImmersionPushforward.lean` have no standalone `\lean{...}` reference in the blueprint (or are referenced only as private helpers bundled into a parent `\lean{...}`):

- `CategoryTheory.Functor.isZero_of_faithful_preservesZeroMorphisms` — duplicated from `CechAugmentedResolution.lean` (explicitly noted in Lean comment). Blueprint has no dedicated block for it in this file's chapter coverage; it's plausibly a helper.
- `AlgebraicGeometry.jShriekOU_homEquiv_nat` — private, covered implicitly by `jShriekOU_homEquiv_naturality` listed under `lem:jshriek_corepr` at blueprint line 3146. Fine.
- `AlgebraicGeometry.opensMapInvBase_isEquivalence` (instance) — unlisted in `\lean{...}`; auxiliary to `lem:slice_structureSheaf_hom`
- `AlgebraicGeometry.overPost_slice_isContinuous` (instance) — unlisted; auxiliary to `lem:slice_structureSheaf_hom`. The blueprint text for `lem:slice_structureSheaf_hom` mentions continuity and finality of `F` as a consequence of `φ` being an iso, which is what this instance formalises.
- `AlgebraicGeometry.sliceStructureSheafHom_pre_isRightAdjoint` (instance) — unlisted; the `IsRightAdjoint` clause is mentioned in the blueprint text but not in `\lean{...}`
- `AlgebraicGeometry.sliceStructureSheafHom_isRightAdjoint` (instance) — same

**Action recommended**: add `AlgebraicGeometry.sliceStructureSheafHom_isRightAdjoint` (and the two continuity instances) to `\lean{...}` for `lem:slice_structureSheaf_hom`, since the `IsRightAdjoint` obligation is explicitly described in the blueprint statement.

---

## Blueprint Adequacy for This File

### `lem:pushPull_binary_coprod_prod` (CSI — not in this Lean file, but assessed per directive)

- **Coverage**: the blueprint proof contains two explicit `% NOTE:` blocks describing the two Lean-level implementation obstacles: (a) the instance-trap with `toPresheaf` composite and the `SheafOfModules.evaluation V` fix, (b) the `Ab → ModuleCat` bridge via `isLimitOfReflects`. The helpers `isIso_prodLift_of_isLimit` and `coprodDecompMap` are bundled in `\lean{...}`.
- **Proof-sketch depth**: **adequate**. The two NOTE blocks give enough Lean-side detail (which API to use, the `~60–100 LOC` cone bookkeeping acknowledgement) for a prover to proceed. The mathematical argument is clear; the implementation deviations are preemptively documented.

### `lem:pushforward_slice_pullback_iso` (OpenImm — primary open node)

- **Proof-sketch depth**: **INADEQUATE — must-fix this iter**.
  - The blueprint proof (lines 9875–9886) says: "First, `pullbackObjUnitToUnit ψ_r` is an iso (F is final); it identifies `(pullback ψ_r).obj` of the slice with the pushforward over the image site. Second, `F.obj Uᵢ = Vᵢ` holds by `rfl`."
  - The Lean file comment (lines 656–669 in the `hqc` case) explicitly identifies this sketch as **incomplete**: `"The blueprint's pullbackObjUnitToUnit-only proof sketch is incomplete (that map handles only the unit, not general H)."` The comment proposes an alternative: `pullback ψ_r ≅ pushforward φ''` via `Adjunction.leftAdjointUniq` of `pullbackPushforwardAdjunction ψ_r` against a second adjunction, composed with a `pushforward φ'' (H.over Uᵢ) ≅ (Φ H).over Vᵢ` (section identity). The friction noted is `Over.postEquiv` inverse carries an `Over.map (unitIso.inv)` correction.
  - **The blueprint proof sketch does not cover general `H`**: `pullbackObjUnitToUnit` handles only the unit `𝟙`, not an arbitrary `H.over Uᵢ`. A prover following the blueprint sketch would get stuck. This is a blueprint adequacy failure that blocked this iter.

### `lem:slice_structureSheaf_hom`

- **Proof-sketch depth**: adequate — the definition is a single application of `overPullback ... (φ.inv.toRingCatSheafHom)` plus the Beck–Chevalley rfl identity. The sketch is correct and complete.
- **Stale `% NOTE:`**: line 9804 says the declaration does not exist yet; it now exists. The `\leanok` marker is present.

### `lem:pushforward_iso_preserves_qcoh`

- **Proof-sketch depth**: adequate in principle — "extract quasi-coherence datum, transport member by member via `pullback ψ_r`". However, this lemma depends on `pushforwardSlicePullbackIso` (which doesn't exist), so the proof cannot be completed until that is built.
- **Blueprint `% NOTE:`**: still accurate (build target).

### Overall Blueprint Assessment

- **Coverage**: 13/15 blueprint blocks targeting this file are represented in Lean; 2 are missing (`pushforwardSlicePullbackIso`, `pushforward_iso_preserves_qcoh`).
- **Proof-sketch depth**: **under-specified** for `lem:pushforward_slice_pullback_iso` (critical proof gap documented in Lean comment); adequate for all other blocks.
- **Hint precision**: precise — all `\lean{...}` names match actual Lean declaration names where declarations exist.
- **Generality**: matches need.
- **Recommended chapter-side actions**:
  1. **Replace** the proof of `lem:pushforward_slice_pullback_iso` (lines 9875–9886) with the correct route: show `pullback ψ_r ≅ pushforward φ''` using `Adjunction.leftAdjointUniq` (comparing `pullbackPushforwardAdjunction ψ_r` with the pushforward-pushforward adjunction for the reverse ring map `φ''`, then transport across `pushforward φ'' (H.over Uᵢ) ≅ (Φ H).over Vᵢ` — a section identity). Note the `Over.postEquiv` inverse correction (`unitIso.inv`) for the open identity.
  2. **Remove** the stale `% NOTE: build target. The Lean declaration does not exist yet.` from `lem:slice_structureSheaf_hom` (line 9804).
  3. **Add** `AlgebraicGeometry.sliceStructureSheafHom_isRightAdjoint` (and optionally the two continuity instances) to `\lean{...}` of `lem:slice_structureSheaf_hom`, since the `IsRightAdjoint` obligation is explicitly described in the blueprint statement.

---

## Severity Summary

### Must-fix-this-iter

1. **`higherDirectImage_openImmersion_acyclic` has `sorry` at `hqc`** (line 670). Blueprint `lem:open_immersion_pushforward_comp` claims this is a complete theorem. The sorry blocks the whole chain (`higherDirectImage_openImmersion_comp`, `cechTerm_pushforward_acyclic`, and ultimately `cech_computes_higherDirectImage`).

2. **`higherDirectImage_openImmersion_comp` body is entirely `sorry`** (line 736). Blueprint `lem:open_immersion_pushforward_comp` claims a complete proof.

3. **`AlgebraicGeometry.pushforwardSlicePullbackIso` is missing from Lean** — blueprint `\lean{AlgebraicGeometry.pushforwardSlicePullbackIso}` (`lem:pushforward_slice_pullback_iso`) has no corresponding declaration. This is the root cause of the two `sorry` items above.

4. **`AlgebraicGeometry.pushforward_iso_preserves_qcoh` is missing from Lean** — blueprint `\lean{AlgebraicGeometry.pushforward_iso_preserves_qcoh}` (`lem:pushforward_iso_preserves_qcoh`) has no corresponding declaration; it is needed to close the `hqc` case.

5. **Blueprint proof of `lem:pushforward_slice_pullback_iso` is inadequate** — the published proof sketch (`pullbackObjUnitToUnit` + `rfl`) handles only the unit module, not general `H`. A prover following the blueprint verbatim cannot complete the theorem. This is an explicit blueprint adequacy failure confirmed by the Lean comment.

### Major

6. **Stale `% NOTE: build target. The Lean declaration does not exist yet.`** at `lem:slice_structureSheaf_hom` (blueprint line 9804) — `sliceStructureSheafHom` now exists axiom-clean. Should be removed.

7. **`\lean{...}` for `lem:slice_structureSheaf_hom` omits the `IsRightAdjoint` instances** — `sliceStructureSheafHom_isRightAdjoint` (and its prerequisite `sliceStructureSheafHom_pre_isRightAdjoint`) are mentioned in the blueprint statement text but absent from `\lean{...}`.

### Minor

8. Several blueprint blocks are missing `\leanok` for axiom-clean Lean declarations: `lem:jshriek_transport_along_iso`, `lem:pushforward_iso_qcoh_of_slice_qcoh`, `lem:pushforward_sections_functor`, `lem:modules_isoSpec_ext_transport`, `lem:isZero_coyoneda_rightDerived_of_forall_ext_eq_zero`. These will be resolved by `sync_leanok` and are not action items for provers.

---

**Overall verdict**: The infrastructure (specIso transport, `jShriekOU` transport, slice ψ_r ring map) is axiom-clean; the two missing Lean declarations (`pushforwardSlicePullbackIso` and `pushforward_iso_preserves_qcoh`) and the inadequate blueprint proof sketch for `lem:pushforward_slice_pullback_iso` are the single blocking cluster — 5 must-fix findings, 2 major, 1 minor, 31 declarations checked.
