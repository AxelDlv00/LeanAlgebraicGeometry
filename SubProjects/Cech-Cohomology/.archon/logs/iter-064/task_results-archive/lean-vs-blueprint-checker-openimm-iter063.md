# Lean ↔ Blueprint Check Report

## Slug
openimm-iter063

## Iteration
063

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (labels: `lem:pushforward_slice_two_adjunction`, `lem:pushforward_slice_pullback_iso`,
  `lem:pushforward_iso_preserves_qcoh`, `lem:slice_structureSheaf_hom`,
  `lem:pushforward_iso_qcoh_of_slice_qcoh`, `lem:open_immersion_pushforward_comp`)

---

## Per-declaration (blueprint-referenced)

### `\lean{AlgebraicGeometry.sliceStructureSheafHom, ...}` (chapter: `lem:slice_structureSheaf_hom`)
The blueprint lists five declarations:
- **`AlgebraicGeometry.sliceStructureSheafHom`** (Lean line 479): Lean target exists. Signature matches blueprint (maps `X.ringCatSheaf.over Ui` to pushforward of `Y.ringCatSheaf.over (φ.inv⁻¹ Ui)` along the over-post functor). Proof follows sketch (over-pullback of `φ.inv.toRingCatSheafHom`).
- **`AlgebraicGeometry.opensMapInvBase_isEquivalence`** (line 457): Lean target exists. Instance that `(Opens.map φ.inv.base).IsEquivalence`; matches blueprint description. Proof follows sketch (inferred via `mapMapIso`).
- **`AlgebraicGeometry.overPost_slice_isContinuous`** (line 465): Lean target exists. Instance `IsContinuous` for the forward-direction over-post functor. Matches blueprint.
- **`AlgebraicGeometry.sliceStructureSheafHom_pre_isRightAdjoint`** (line 489): Lean target exists. Presheaf-of-modules pushforward admits a right adjoint. Matches blueprint.
- **`AlgebraicGeometry.sliceStructureSheafHom_isRightAdjoint`** (line 501): Lean target exists. Sheaf-of-modules pushforward admits a right adjoint. Matches blueprint.
- **Signature matches**: yes (all five)
- **Proof follows sketch**: yes (all five)

### `\lean{AlgebraicGeometry.pushforward_iso_qcoh_of_slice_qcoh, AlgebraicGeometry.coversTop_preimage_of_iso}` (chapter: `lem:pushforward_iso_qcoh_of_slice_qcoh`)
- **`AlgebraicGeometry.pushforward_iso_qcoh_of_slice_qcoh`** (line 425): Lean target exists. Signature matches blueprint (iso-pushforward quasi-coherent if all per-slice images are). Proof follows sketch (`SheafOfModules.IsQuasicoherent.of_coversTop` + cover transport).
- **`AlgebraicGeometry.coversTop_preimage_of_iso`** (line 403, `private`): Lean target exists (private). Blueprint lists it explicitly; signature matches (covering family pulls back through a scheme iso). Proof follows sketch.
- **Signature matches**: yes
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.jShriekOU_transport_along_iso, ...}` (chapter: `lem:jshriek_transport_along_iso`)
- **`AlgebraicGeometry.jShriekOU_transport_along_iso`** (line 391): Lean target exists. Signature matches blueprint (`Φ.functor(jShriekOU V) ≅ jShriekOU (φ.inv⁻¹ V)`). Proof follows sketch (two `CorepresentableBy` instances + `uniqueUpToIso`).
- `sectionsCorep` and `sectionsCorepPushforward` (private helpers, lines 363, 372): exist, signatures consistent with blueprint prose.
- **Signature matches**: yes
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.pushforwardSliceTwoAdjunction}` (chapter: `lem:pushforward_slice_two_adjunction`)
- **Lean target exists**: NO. Blueprint marks it `% NOTE: build target. The Lean declaration does not exist yet.` The Lean file has a `RESIDUAL` comment block (lines 583–628) explaining what needs to be built but no actual declaration.
- **Signature matches**: N/A (not yet formalized)
- **Proof follows sketch**: N/A
- **notes**: The residual comment block is an accurate description of the remaining work, not an excuse-comment for wrong existing code. The `% NOTE: build target` marker in the blueprint is correct. See Blueprint Adequacy section for the under-specification issue.

### `\lean{AlgebraicGeometry.pushforwardSlicePullbackIso}` (chapter: `lem:pushforward_slice_pullback_iso`)
- **Lean target exists**: NO. Blueprint marks it `% NOTE: build target. The Lean declaration does not exist yet.`
- **Signature matches**: N/A
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.pushforward_iso_preserves_qcoh}` (chapter: `lem:pushforward_iso_preserves_qcoh`)
- **Lean target exists**: NO. Blueprint marks it `% NOTE: build target. The Lean declaration does not exist yet.`
- **Signature matches**: N/A
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_comp, AlgebraicGeometry.higherDirectImage_openImmersion_acyclic, ...}` (chapter: `lem:open_immersion_pushforward_comp`)
- **`AlgebraicGeometry.higherDirectImage_openImmersion_acyclic`** (line 700): Lean target exists. Signature matches blueprint (higher direct images of an affine open immersion vanish for `q ≥ 1`). Proof body present and substantially correct except for the `hqc` sorry (line 795), which is a documented residual depending on `pushforwardSlicePullbackIso`.
- **`AlgebraicGeometry.higherDirectImage_openImmersion_comp`** (line 837): Lean target exists. Signature matches blueprint (composition formula for higher direct images). Body is `:= sorry` — documented residual depending on Part (1)'s residual.
- **`AlgebraicGeometry.isAffineHom_of_affine_separated`** (line 658, private): Lean target exists; helper that open immersions into separated schemes are affine. Not blueprint-named but expected as a private helper.
- **Signature matches**: yes (for both public declarations)
- **Proof follows sketch**: partial — `higherDirectImage_openImmersion_acyclic` follows blueprint through the `isoRightDerivedObj` / `sectionsFunctorCorepIso` / `isZero_coyoneda_rightDerived_of_forall_ext_eq_zero` chain, then defers at the `hqc` residual. `higherDirectImage_openImmersion_comp` is fully deferred.

---

## Red flags

### Placeholder / suspect bodies
- `higherDirectImage_openImmersion_acyclic` at line 795: `:= sorry` in the `case hqc` branch. The blueprint claims this is substantive (`lem:pushforward_iso_preserves_qcoh` is an unbuilt target). **However**, the sorry is explicitly documented as a residual with a 20-line comment explaining the remaining sub-lemma (`pushforwardSlicePullbackIso`) and citing the blueprint label. The blueprint itself marks the target `% NOTE: build target`. **Classification: acknowledged build residual, not a hidden placeholder.**
- `higherDirectImage_openImmersion_comp` at line 861: entire body is `:= sorry`. Again documented in a 15-line comment. The blueprint marks the upstream dependencies as build targets. **Classification: acknowledged build residual.**

These two sorries do not meet the red-flag criteria (neither hides unreported work nor presents a fake body for a declared-complete claim).

### Excuse-comments
None found. All sorry-adjacent comments describe residuals that the blueprint corroborates as pending, with no "wrong but works for now" language.

### Axioms / Classical.choice on non-trivial claims
No `axiom` declarations in this file.

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have **no** `\lean{...}` reference in the blueprint:

| Declaration | Lean line | Comment |
|---|---|---|
| `opensMapHomBase_isEquivalence` | 524 | ★ **New this iter** — `IsEquivalence` for `Opens.map φ.hom.base` |
| `opensEquivOfIso` | 530 | ★ **New this iter** — the `Opens X ≌ Opens Y` equivalence |
| `sliceOversEquiv` | 534 | ★ **New this iter** — slice equivalence `Over Ui ≌ Over Vi` |
| `sliceOversEquiv_functor_isContinuous` | 539 | ★ **New this iter** — forward continuity of `sliceOversEquiv` |
| `overPost_slice_inverse_isContinuous` | 549 | ★ **New this iter** — intermediate inverse-post continuity |
| `sliceOversEquiv_inverse_isContinuous` | 561 | ★ **New this iter** — full inverse continuity of `sliceOversEquiv` |
| `isZero_of_faithful_preservesZeroMorphisms` | 42 | Mathlib supplement; duplicate of `CechAugmentedResolution.lean` |
| `isZero_presheafToSheaf_of_sections_locally_zero` | 71 | Stronger sectionwise lemma; referenced in `lem:open_immersion_pushforward_comp`'s `\uses` but not in a `\lean{...}` block of its own |
| `sectionsFunctorCorepIso` | 160 | Referenced in `lem:sectionsFunctorCorepIso` (another part of the chapter) |
| `rightDerivedNatIso` | 178 | Referenced in `lem:rightDerivedNatIso` (another part of the chapter) |
| `Scheme.Modules.pushforwardEquivOfIso` | 204 | Referenced elsewhere in chapter |
| `modulesIsoSpecExtTransport` | 241 | Referenced in `lem:modules_isoSpec_ext_transport` |
| `ext_jShriekOU_eq_zero_of_specIso` | 332 | Referenced in `lem:ext_jShriekOU_eq_zero_of_specIso` |
| `pushforwardSectionsFunctor` | 671 | Referenced in `lem:pushforward_sections_functor` |
| `isAffineHom_of_affine_separated` | 658 | Private helper, covered under `lem:open_immersion_pushforward_comp` |

The **6 starred** declarations are the iter-063 additions. Their names strongly suggest they belong in the blueprint (they are the core continuity infrastructure for `pushforwardSliceTwoAdjunction`, the blocker of iters 060–062). See Blueprint Adequacy section.

---

## Blueprint adequacy for this file

### Bidirectional assessment

**Coverage**: Among the 6 target declarations for this file (`pushforwardSliceTwoAdjunction`, `pushforwardSlicePullbackIso`, `pushforward_iso_preserves_qcoh` as build targets; `sliceStructureSheafHom` group, `pushforward_iso_qcoh_of_slice_qcoh`, `higherDirectImage_openImmersion_acyclic/comp` as partial), 8/14 blueprint-referenced Lean declarations exist and have correct signatures. 6 blueprint-referenced declarations (`pushforwardSliceTwoAdjunction`, `pushforwardSlicePullbackIso`, `pushforward_iso_preserves_qcoh`) have no Lean bodies yet. The 6 new iter-063 helpers have NO blueprint block at all.

**Proof-sketch depth**: **under-specified** on two fronts:

1. **`lem:pushforward_slice_two_adjunction` — φ'' construction under-specified.**
   The blueprint states:
   > let φ'' = `sliceStructureSheafHom φ^{-1} Vi`

   This is the right mathematical intent (use `φ.inv` as the "reverse" map), but `sliceStructureSheafHom φ.symm Vi` in Lean has type
   ```
   Y.ringCatSheaf.over Vi ⟶ (Over.post (Opens.map φ.hom.base)).sheafPushforward RingCat ...)
     .obj (X.ringCatSheaf.over (φ.hom⁻¹ Vi))
   ```
   — landing in `Over (φ.hom⁻¹ Vi)`, not `Over Ui`.  The slot in `pushforwardPushforwardAdj` for the second ring map requires the codomain to be the pushforward of `X.ringCatSheaf.over Ui` along `(sliceOversEquiv φ Ui).inverse` (which is `Over.post (Opens.map φ.hom.base) ⋙ Over.map (unitIso.inv)`, landing in `Over Ui`).

   The **KEY INSIGHT** discovered this iter (Lean comment lines 610–628) is: `Over.map (unitIso.inv)` leaves `.left` unchanged (it only post-composes the structure arrow), so the section values of the codomain sheaf are identical to those of `sliceStructureSheafHom φ.symm Vi`. The correct construction of φ'' is therefore:
   ```
   ((Opens.grothendieckTopology Y).overPullback RingCat Vi).map φ.hom.toRingCatSheafHom
   ```
   transported via eqToHom bookkeeping from `Over (φ.hom⁻¹ Vi)` to `Over Ui`. This is pure bookkeeping, not new mathematics.

   The blueprint says "φ'' and H₁/H₂ carry equality-transport/Over.map-correction bookkeeping" (lines 10049–10058), acknowledging the correction exists, but does NOT state that φ'' is object-level correction-free. A prover reading only the blueprint cannot determine whether φ'' requires a genuine mathematical correction or a pure type-level transport. This is the distinction that unblocked iter-063.

2. **`lem:pushforward_slice_two_adjunction` — continuity instances not mentioned.**
   The blueprint proof says "apply `pushforwardPushforwardAdj` to the slice equivalence `Over.postEquiv Ui e_Opens`" but does NOT state that both the forward and inverse functors of `sliceOversEquiv` need explicit `IsContinuous` instances. These instances (the 6 new helpers) were the actual metavar wall blocking iters 060–062. The blueprint should list them in the `\lean{...}` block and explain that both continuity instances are required inputs to `pushforwardPushforwardAdj`, not synthesized automatically.

3. **`lem:pushforward_slice_pullback_iso` — iter-062 concern resolved.**
   The iter-062 checker flagged this as "unit-module-only (incomplete)" because the earlier blueprint draft apparently only discussed `pullbackObjUnitToUnit`. The current blueprint (lines 10084–10119) correctly supersedes this with Step 1 (`leftAdjointUniq` identifies the whole pullback functor with `pushforward φ''`) and Step 2 ("the section identity" — same sections by definitional unfolding). Lines 10112–10117 state explicitly:
   > "both objects have the very same sections Γ(H, φ.hom⁻¹ W.left) — the slice pushforward along φ'' and the slice of the pushforward Φ.functor.obj H over Vi unfold to one and the same sections functor."

   This IS the KEY INSIGHT correctly reflected. **The iter-062 concern is now adequately addressed by the blueprint.**  The remaining obstacle is not in Step 2 but in the construction of φ'' for Step 1 (see point 1 above).

**Hint precision**: **loose** for `lem:pushforward_slice_two_adjunction`. The `\lean{}` hint names `pushforwardSliceTwoAdjunction` correctly, but the proof description leaves the explicit construction of φ'' ambiguous. The 6 continuity-instance helpers should be added to the `\lean{}` list.

**Generality**: matches need.

### Recommended chapter-side actions

1. **[major]** Add the 6 iter-063 helpers to `lem:pushforward_slice_two_adjunction`'s `\lean{...}` block:
   ```latex
   \lean{AlgebraicGeometry.pushforwardSliceTwoAdjunction,
     AlgebraicGeometry.opensMapHomBase_isEquivalence,
     AlgebraicGeometry.opensEquivOfIso,
     AlgebraicGeometry.sliceOversEquiv,
     AlgebraicGeometry.sliceOversEquiv_functor_isContinuous,
     AlgebraicGeometry.overPost_slice_inverse_isContinuous,
     AlgebraicGeometry.sliceOversEquiv_inverse_isContinuous}
   ```

2. **[major]** Expand the `lem:pushforward_slice_two_adjunction` proof body to state the KEY INSIGHT explicitly:
   > The correct construction of φ'' uses the over-pullback of `φ.hom.toRingCatSheafHom` (not `φ.inv.toRingCatSheafHom`) as the section-level datum, then transports the codomain from `Over (φ.hom⁻¹ Vi)` to `Over Ui` via `eqToHom` (the unit iso of `opensEquivOfIso`). The transport is pure bookkeeping and introduces no new mathematics. In particular φ'' is object-level correction-free: over any `W : (Over Vi)ᵒᵖ`, the section values are `Γ(X.ringCatSheaf, φ.hom⁻¹ W.left)`, identical to those of `sliceStructureSheafHom φ.symm Vi`. The `Over.map (unitIso.inv)` factor in `(sliceOversEquiv φ Ui).inverse` affects only the structure maps (H₁/H₂), not the section values.

3. **[minor]** The `\uses{...}` of `lem:pushforward_slice_two_adjunction` should reference a new sub-lemma or note that both `sliceOversEquiv_functor_isContinuous` and `sliceOversEquiv_inverse_isContinuous` are required as explicit inputs to `SheafOfModules.pushforwardPushforwardAdj`.

---

## Severity summary

| Finding | Severity |
|---|---|
| 6 iter-063 helpers (`opensMapHomBase_isEquivalence`, `opensEquivOfIso`, `sliceOversEquiv`, `sliceOversEquiv_functor_isContinuous`, `overPost_slice_inverse_isContinuous`, `sliceOversEquiv_inverse_isContinuous`) have no `\lean{}` blueprint coverage | **major** |
| `lem:pushforward_slice_two_adjunction`: φ'' construction under-specified — blueprint says `sliceStructureSheafHom φ.symm Vi` but this has a codomain type mismatch; KEY INSIGHT (object-level correction-free) not stated | **major** |
| `lem:pushforward_slice_two_adjunction`: continuity instances for `sliceOversEquiv` not mentioned in blueprint proof | **major** |
| `hqc` sorry at line 795 and `higherDirectImage_openImmersion_comp` sorry at line 861 are documented residuals; upstream build targets correctly marked `% NOTE:` | informational |
| `lem:pushforward_slice_pullback_iso` iter-062 concern (unit-module-only): RESOLVED by current blueprint Step 2 (section identity explicitly stated) | resolved/informational |

**Overall verdict**: The 6 axiom-clean helpers landed this iter are correctly formalized and match their mathematical intent, but lack blueprint coverage; the blueprint's proof of `lem:pushforward_slice_two_adjunction` is under-specified on the φ'' construction (type-level transport not described) and omits the continuity instances that were the actual blocking wall — 3 major blueprint adequacy findings, 0 Lean red flags.
