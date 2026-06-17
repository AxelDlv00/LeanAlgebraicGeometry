# Lean ↔ Blueprint Check Report

## Slug
openimm-iter065

## Iteration
065

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (sections `lem:open_immersion_pushforward_comp` through `lem:modules_isoSpec_ext_transport`)

---

## Per-declaration

### `\lean{AlgebraicGeometry.sliceReverseRingMap}` (chapter: `lem:slice_reverse_ring_map`)
- **Lean target exists**: yes — `sliceReverseRingMap` at line 588
- **Signature matches**: yes — type matches the blueprint's stated domain/codomain along the correction-carrying inverse `eqv.inverse`
- **Proof follows sketch**: **partial** — the blueprint proof describes a 2-part codomain bridge:
  - Part (a) via `sheafPushforwardContinuousComp'` (composition law for pushforward-continuous functors)
  - Part (b) an explicit object-relabel isomorphism along `unitIso.inv`

  The actual Lean proof body is `sliceStructureSheafHom φ.symm (φ.inv ⁻¹ᵁ Ui)` — a single definitional alias with no explicit bridge composition. The Lean file's comment at lines 594–602 explains: "both `sheafPushforwardContinuousComp` and `Over.mapForget` are definitional, so the 'codomain bridge' of the blueprint reduces to the identity and is absorbed here by defeq." The blueprint proof is **stale and over-complicated**: it describes a construction that was entirely absorbed by definitional equality.
- **notes**: blueprint `\leanok` marker is correct. The statement is sound. Only the proof sketch is misleading.

---

### `\lean{AlgebraicGeometry.pushforwardSliceAdjunctionH1}` (chapter: `lem:pushforward_slice_adjunction_h1`)
- **Lean target exists**: yes — `pushforwardSliceAdjunctionH1` at line 630
- **Signature matches**: yes
- **Proof follows sketch**: yes — proof reduces the counit square to `Scheme.Hom.comp_app` + `congr_app φ.hom_inv_id`, matching the blueprint's "naturality collapses to an equality of equality-transport isomorphisms along `φ.hom⁻¹(φ.inv⁻¹ Uᵢ) = Uᵢ`, true by proof-irrelevance"
- **notes**: `\leanok` marker correct. The iter-065 NOTE in `lem:pushforward_slice_two_adjunction` saying "H1 remains sorry" is now stale (see Red Flags below).

---

### `\lean{AlgebraicGeometry.pushforwardSliceAdjunctionH2}` (chapter: `lem:pushforward_slice_adjunction_h2`)
- **Lean target exists**: yes — `pushforwardSliceAdjunctionH2` at line 661
- **Signature matches**: yes
- **Proof follows sketch**: yes — same shape as H1, matching the blueprint's "identical to H1" description
- **notes**: `\leanok` marker correct. Stale NOTE applies (see Red Flags).

---

### `\lean{AlgebraicGeometry.pushforwardSliceTwoAdjunction}` (chapter: `lem:pushforward_slice_two_adjunction`)
- **Lean target exists**: yes — `pushforwardSliceTwoAdjunction` at line 697
- **Signature matches**: yes
- **Proof follows sketch**: yes — feeds `SheafOfModules.pushforwardPushforwardAdj` the slice equivalence's adjunction together with H1/H2 and the continuity instances, matching the blueprint exactly
- **notes**: The blueprint's `% NOTE (review iter-064)` comment reads "H1/H2 remain sorry and are blocked on the keystone phi'' being concrete." This is **stale** as of iter-065.

---

### `\lean{AlgebraicGeometry.pushforwardSlicePullbackIso}` (chapter: `lem:pushforward_slice_pullback_iso`)
- **Lean target exists**: yes — `pushforwardSlicePullbackIso` at line 719
- **Signature matches**: yes
- **Proof follows sketch**: yes — Step 1 (`leftAdjointUniq`) + Step 2 (`Iso.refl _`, rfl-clean section identity). Matches blueprint exactly.
- **notes**: The blueprint's `% NOTE (review iter-064)` comment "RESIDUAL = the `≪≫ sorry` Step-2...which is rfl-clean once phi'' is concrete" is **stale** as of iter-065 (Step 2 is `Iso.refl _`, sorry-free).

---

### `\lean{AlgebraicGeometry.pushforward_iso_preserves_qcoh}` (chapter: `lem:pushforward_iso_preserves_qcoh`)
- **Lean target exists**: yes — `pushforward_iso_preserves_qcoh` at line 737
- **Signature matches**: yes
- **Proof follows sketch**: yes — extracts `qcd`, invokes `pushforward_iso_qcoh_of_slice_qcoh` to reduce to per-member, uses `pullback ψ_r` colimit preservation + `pushforwardSlicePullbackIso` transport, matching the blueprint's per-member transport description exactly
- **notes**: `\leanok` marker correct. This is the `hqc` leaf that closes the acyclicity cascade.

---

### `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_acyclic}` (chapter: `lem:open_immersion_pushforward_comp`)
- **Lean target exists**: yes — `higherDirectImage_openImmersion_acyclic` at line 826
- **Signature matches**: yes
- **Proof follows sketch**: yes — full chain: `higherDirectImage_iso_sheafify_presheafHomology` → `toSheaf` faithfulness → `sheafificationCompToSheaf` → presheaf homology locally zero (via `isZero_presheafToSheaf_of_sections_locally_zero`) via affine-opens basis → `isoRightDerivedObj` → `rightDerivedNatIso sectionsFunctorCorepIso` → `isZero_coyoneda_rightDerived_of_forall_ext_eq_zero` → `ext_jShriekOU_eq_zero_of_specIso` with `hV'/hjt/hqc`. Matches the blueprint proof sketch faithfully.
- **notes**: **Sorry-free as of iter-065** (axiom-clean). However, this declaration is pinned under `lem:open_immersion_pushforward_comp` alongside `higherDirectImage_openImmersion_comp` (4 sorries); the combined block therefore lacks `\leanok` and the iter-065 milestone is invisible in the blueprint dependency graph. See Red Flags.

---

### `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_comp}` (chapter: `lem:open_immersion_pushforward_comp`)
- **Lean target exists**: yes — `higherDirectImage_openImmersion_comp` at line 942
- **Signature matches**: yes (pinned declaration, frozen signature)
- **Proof follows sketch**: **partial** — mathematical skeleton is in place; 4 honest gaps remain:
  - `hacyc` (line 974): `f_*`-acyclicity of `j_* Iⁿ`, a NEW vanishing result. Blueprint says "same Serre-vanishing argument on `U ∩ f⁻¹V`" but does not distinguish this from `higherDirectImage_openImmersion_acyclic` (`j_*`-acyclicity). The Lean comment (line 970) clarifies it is "a genuinely new vanishing result (not an instance of `_acyclic`)". Blueprint is under-specified for this gap.
  - `eRes` (line 979): pushforward of the augmentation. Blueprint describes this in passing ("chose injective resolution, apply j_* degreewise") but omits that `pushforward j` must be finite-limit-preserving to push the augmentation.
  - `hexact` (line 982): blueprint adequate ("j_*-acyclicity of each Iⁿ", direct use of `higherDirectImage_openImmersion_acyclic`)
  - `transport` (line 985): blueprint adequate (`pushforwardComp j f` + `isoRightDerivedObj`)
- **notes**: All 4 sorries are properly commented as honest gaps; none are concealed placeholders. No excuse-comments. This is a STRETCH goal per the directive.

---

### `\lean{AlgebraicGeometry.modulesIsoSpecExtTransport, ..., AlgebraicGeometry.Scheme.Modules.pushforwardExtAddEquiv}` (chapter: `lem:modules_isoSpec_ext_transport`)
- **Lean target exists**: yes — all 4 declarations (`pushforwardEquivOfIso` line 204, `pushforwardEquivOfIso_functor_additive` line 213, `pushforwardExtAddEquiv` line 223, `modulesIsoSpecExtTransport` line 241) present
- **Signature matches**: yes — types match blueprint's stated isomorphism
- **Proof follows sketch**: yes — `AddEquiv.ofBijective` on `mapExt_bijective_of_preservesInjectiveObjects`, matching blueprint
- **notes**: The `\begin{lemma}` block at line 10702 **lacks `\leanok`** despite all 4 Lean declarations being present without `sorry`. This marker appears to have been missed by `sync_leanok` (possibly pre-dating the deterministic sync infrastructure). **Needs `\leanok` added** — though the rule says `sync_leanok` owns this, so it should be forced via a sync re-run rather than manual edit.

---

### `\lean{AlgebraicGeometry.jShriekOU_transport_along_iso, ...}` (chapter: `lem:jshriek_transport_along_iso`)
- **Lean target exists**: yes — `jShriekOU_transport_along_iso` line 391, plus private helpers `sectionsCorep` and `sectionsCorepPushforward`
- **Signature matches**: yes
- **Proof follows sketch**: yes — corepresentability transport via `CorepresentableBy.uniqueUpToIso`, matching blueprint exactly
- **notes**: ✓

---

### `\lean{AlgebraicGeometry.pushforward_iso_qcoh_of_slice_qcoh, AlgebraicGeometry.coversTop_preimage_of_iso}` (chapter: `lem:pushforward_iso_qcoh_of_slice_qcoh`)
- **Lean target exists**: yes — both present at lines 403, 425
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: ✓

---

### `\lean{AlgebraicGeometry.sliceStructureSheafHom, ...}` (chapter: `lem:slice_structureSheaf_hom`)
- **Lean target exists**: yes — all 5 declarations present
- **Signature matches**: yes
- **Proof follows sketch**: yes (instances/definitions, not proofs)
- **notes**: ✓

---

### `\lean{AlgebraicGeometry.opensMapHomBase_isEquivalence, ..., AlgebraicGeometry.sliceOversEquiv_inverse_isContinuous}` (chapter: `lem:slice_overs_equiv_continuity`)
- **Lean target exists**: yes — all 6 declarations present at lines 524–580
- **Signature matches**: yes
- **Proof follows sketch**: yes — forward continuity via `CoverPreserving.overPost`; inverse via explicit `@Functor.isContinuous_comp` chain with `Over.map unitIso.inv` correction
- **notes**: ✓

---

### `\lean{AlgebraicGeometry.isZero_coyoneda_rightDerived_of_forall_ext_eq_zero, ...}` (chapter: `lem:isZero_coyoneda_rightDerived_of_forall_ext_eq_zero`)
- **Lean target exists**: yes — line 274
- **Signature matches**: yes
- **Proof follows sketch**: yes — `isoRightDerivedObj` + `extMk_eq_zero_iff`, matching blueprint
- **notes**: ✓

---

### `\lean{AlgebraicGeometry.subsingleton_ext_of_iso_fst}` (chapter: `lem:subsingleton_ext_of_iso_fst`)
- **Lean target exists**: yes — line 310
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: ✓

---

### `\lean{AlgebraicGeometry.enoughInjectives_of_hasInjectiveResolutions}` (chapter: `lem:enoughInjectives_of_hasInjectiveResolutions`)
- **Lean target exists**: yes — line 299
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: ✓

---

### `\lean{AlgebraicGeometry.ext_jShriekOU_eq_zero_of_specIso}` (chapter: `lem:ext_jShriekOU_eq_zero_of_specIso`)
- **Lean target exists**: yes — line 332
- **Signature matches**: yes
- **Proof follows sketch**: yes — `enoughInjectives_of_hasInjectiveResolutions` → `EnoughInjectives.of_equivalence` → `affine_serre_vanishing_general_open` → `subsingleton_ext_of_iso_fst` → `pushforwardExtAddEquiv` injectivity
- **notes**: ✓

---

### `\lean{AlgebraicGeometry.sectionsFunctorCorepIso}` (chapter: `lem:sectionsFunctorCorepIso`)
- **Lean target exists**: yes — line 160
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: ✓

---

### `\lean{AlgebraicGeometry.rightDerivedNatIso}` (chapter: `lem:rightDerivedNatIso`)
- **Lean target exists**: yes — line 178
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: ✓

---

### `\lean{AlgebraicGeometry.pushforwardSectionsFunctor, AlgebraicGeometry.pushforwardSectionsFunctor_additive}` (chapter: `lem:pushforward_sections_functor`)
- **Lean target exists**: yes — lines 797, 804
- **Signature matches**: yes
- **Proof follows sketch**: N/A (definition + instance)
- **notes**: ✓

---

## Red flags

### Stale NOTE comments (actively misleading)

- **`blueprint/src/chapters/.../Cohomology_CechHigherDirectImage.tex:10492–10493`**: In `lem:pushforward_slice_two_adjunction`: `% NOTE (review iter-064): ... It consumes the two leaves H1/H2 (lem:pushforward_slice_adjunction_h1/h2), which remain sorry and are blocked on the keystone phi'' (lem:slice_reverse_ring_map) being concrete.` — **stale as of iter-065**: H1/H2 are closed, φ'' is concrete.

- **`blueprint/src/chapters/.../Cohomology_CechHigherDirectImage.tex:10551–10552`**: In `lem:pushforward_slice_pullback_iso`: `% NOTE (review iter-064): BUILT — ... RESIDUAL = the \`≪≫ sorry\` Step-2 section identity ... which is rfl-clean once phi'' (lem:slice_reverse_ring_map) is concrete.` — **stale as of iter-065**: Step 2 is `Iso.refl _`, the residual is closed.

### Blueprint proof sketch over-complicated vs actual Lean proof

- **`blueprint/src/chapters/.../Cohomology_CechHigherDirectImage.tex:10408–10444`** (`lem:slice_reverse_ring_map` proof): The blueprint proof describes constructing φ'' in two parts — (a) identifying the pushforward-continuous codomain via `sheafPushforwardContinuousComp'` and (b) composing with an explicit object-relabel isomorphism along `unitIso.inv`. The **actual Lean proof** (`sliceReverseRingMap`, line 588–602 in the Lean file) is simply `sliceStructureSheafHom φ.symm (φ.inv ⁻¹ᵁ Ui)` — a single defeq retyping. Neither `sheafPushforwardContinuousComp'` nor any explicit isomorphism appears. Both composition laws (`sheafPushforwardContinuousComp` and `Over.mapForget`) turned out definitional, absorbing the entire bridge. The blueprint proof description is misleading for future readers and should be updated to document the actual defeq argument.

### Missing `\leanok` marker

- **`blueprint/src/chapters/.../Cohomology_CechHigherDirectImage.tex:10700`** (`lem:modules_isoSpec_ext_transport`): `\begin{lemma}` without `\leanok` despite all 4 Lean declarations (`pushforwardEquivOfIso`, `pushforwardEquivOfIso_functor_additive`, `pushforwardExtAddEquiv`, `modulesIsoSpecExtTransport`) being present in the Lean file without `sorry`. The proof block also lacks `\leanok`. This marker is owned by `sync_leanok`; the planner should verify whether `sync_leanok` ran after this file was last built, and force a re-run if not.

---

## Unreferenced declarations (informational)

The following declarations are in the Lean file but not directly pinned by a `\lean{...}` tag. All are acceptable helpers:

- `CategoryTheory.Functor.isZero_of_faithful_preservesZeroMorphisms` (line 42): file-local Mathlib supplement; a copy also lives in `CechAugmentedResolution.lean`. The comment explains the duplication. Not a blueprint target; acceptable helper.
- `CategoryTheory.GrothendieckTopology.isZero_presheafToSheaf_of_sections_locally_zero` (line 71): pinned at `lem:isZero_presheafToSheaf_of_sections_locally_zero`. ✓ referenced.
- `jShriekOU_homEquiv_nat` (line 126): private helper. Acceptable.
- `toPresheafOfModules_additive` (line 141): local instance. Acceptable.
- `sectionsFunctor_additive` (line 148): local instance. Acceptable.
- `sectionsCorep` (line 363): private, pinned indirectly via `lem:jshriek_transport_along_iso`. ✓
- `sectionsCorepPushforward` (line 372): private, same. ✓
- `pushforwardSectionsFunctor_additive` (line 804): local instance. Acceptable.
- `preadditiveCoyoneda_mapHomologicalComplex_d_apply` (line 263): private lemma, helper for `isZero_coyoneda_rightDerived_of_forall_ext_eq_zero`. Acceptable.
- `isAffineHom_of_affine_separated` (line 784): private. Pinned by `lem:open_immersion_pushforward_comp` (`\lean{..., isAffineHom_of_affine_separated}`). ✓

**Notable missing coverage**: `higherDirectImage_openImmersion_acyclic` is pinned under `lem:open_immersion_pushforward_comp` jointly with `higherDirectImage_openImmersion_comp`. Because the latter still has 4 sorries, the block lacks `\leanok`, hiding the fact that the former is fully sorry-free. This is the most consequential unreferenced-milestone issue in the file (see below).

---

## Blueprint adequacy for this file

- **Coverage**: All substantive declarations have corresponding `\lean{...}` blocks in the blueprint. Coverage is excellent. The only concern is that `higherDirectImage_openImmersion_acyclic` — now a completed milestone — is co-pinned with an in-progress declaration and cannot achieve independent `\leanok`.

- **Proof-sketch depth**: **mostly adequate / under-specified for one gap**. The proofs for all the support lemmas (`sliceReverseRingMap`, H1, H2, `pushforwardSliceTwoAdjunction`, `pushforwardSlicePullbackIso`, `pushforward_iso_preserves_qcoh`, `higherDirectImage_openImmersion_acyclic`) all match the Lean proofs at the mathematical level. The only under-specification is in the `hacyc` gap of `higherDirectImage_openImmersion_comp` (part 2): the blueprint says "same Serre-vanishing argument" but doesn't signal that `hacyc` requires a genuinely NEW Lean declaration for `f_*`-acyclicity (not a call to `higherDirectImage_openImmersion_acyclic`). A future prover working from the blueprint alone might waste time trying to reuse the existing acyclic lemma for `hacyc`.

- **Hint precision**: **loose for `lem:slice_reverse_ring_map` proof**: the proof sketch describes a 2-step codomain-bridge construction that is absent from the Lean proof (absorbed by definitional equality). This is the main precision gap.

- **Generality**: matches need.

- **Recommended chapter-side actions** (for the blueprint-writing agent to address):

  1. **(must-fix)** Remove or replace the stale `% NOTE (review iter-064)` comments in `lem:pushforward_slice_two_adjunction` (lines 10492–10493) and `lem:pushforward_slice_pullback_iso` (lines 10551–10552). Replace with an iter-065 note confirming the entire `case hqc` cascade is closed.

  2. **(must-fix)** Update the proof sketch of `lem:slice_reverse_ring_map` (lines 10408–10444) to replace the 2-part codomain-bridge description with the actual argument: "Both `sheafPushforwardContinuousComp` and `Over.mapForget` are definitional, so the bridge is absorbed by defeq; φ'' is simply `sliceStructureSheafHom φ.symm Vᵢ` retyped along the (defeq) corrected-inverse codomain."

  3. **(major)** Split `higherDirectImage_openImmersion_acyclic` out of `lem:open_immersion_pushforward_comp` into its own `\begin{lemma}` block so that `sync_leanok` can independently mark it as `\leanok`. The combined block will regain `\leanok` only when `higherDirectImage_openImmersion_comp` is also sorry-free, losing the iter-065 milestone in the interim.

  4. **(major)** Investigate why `lem:modules_isoSpec_ext_transport` lacks `\leanok` and trigger a `sync_leanok` re-run. The 4 pinned declarations are present in the Lean file without `sorry`.

  5. **(minor)** Strengthen the blueprint's description of `hacyc` in the proof of `lem:open_immersion_pushforward_comp` part (2): explicitly note that `f_*`-acyclicity of `j_* Iⁿ` is a new Lean declaration (not a re-application of `higherDirectImage_openImmersion_acyclic`), whose proof strategy matches part (1) but with `G = pushforward f` replacing `G = Id` and affine target opens pulled from `S` rather than `X`.

---

## Severity summary

| Finding | Severity | Item |
|---------|----------|------|
| Stale iter-064 NOTE in `lem:pushforward_slice_two_adjunction` | **must-fix-this-iter** | Actively misleads future readers / provers about the current state of H1/H2 |
| Stale iter-064 NOTE in `lem:pushforward_slice_pullback_iso` | **must-fix-this-iter** | Same — says Step 2 sorry is open when it is closed |
| `lem:slice_reverse_ring_map` proof describes non-existent 2-part bridge | **major** | Proof sketch diverges from actual proof strategy (bridge was definitional) |
| `higherDirectImage_openImmersion_acyclic` co-pinned, milestone invisible | **major** | Sorry-free declaration permanently obscured until STRETCH goal closes |
| `lem:modules_isoSpec_ext_transport` missing `\leanok` | **major** | All 4 Lean declarations appear sorry-free; marker gap needs `sync_leanok` re-run |
| `hacyc` gap underspecified (f_*-acyclicity vs j_*-acyclicity distinction) | **minor** | Blueprint doesn't flag that `hacyc` needs a new decl, not reuse of `_acyclic` |
| `eRes` gap: finite-limit-preservation of `pushforward j` not mentioned | **minor** | Minor omission in proof detail |

**Overall verdict**: The Lean file is mathematically correct and the iter-065 milestone (`higherDirectImage_openImmersion_acyclic` fully sorry-free) is properly implemented; the must-fix items are entirely on the blueprint side — two stale NOTE comments that actively misdescribe the current proof state, and a proof sketch for φ'' that documents a 2-step construction the Lean code never uses.

**Declarations checked**: 22 `\lean{...}`-pinned Lean names across 14 blueprint blocks. **Red flags**: 5 (2 must-fix stale NOTEs, 1 major overspecified proof sketch, 1 major missing `\leanok`, 1 major co-pinning issue).
