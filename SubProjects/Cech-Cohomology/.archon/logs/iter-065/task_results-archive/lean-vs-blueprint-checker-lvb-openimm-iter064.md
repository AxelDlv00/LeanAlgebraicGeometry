# Lean ↔ Blueprint Check Report

## Slug
lvb-openimm-iter064

## Iteration
064

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (open-immersion / Need#1 `hqc` material, lines ~9040–10580)

---

## Per-declaration

### `\lean{AlgebraicGeometry.sliceReverseRingMap}` (chapter: `lem:slice_reverse_ring_map`)
- **Lean target exists**: yes (line 588)
- **Signature matches**: yes — type reads `(Y.ringCatSheaf.over (φ.inv ⁻¹ᵁ Ui)) ⟶ ((sliceOversEquiv φ Ui).inverse.sheafPushforwardContinuous RingCat …).obj (X.ringCatSheaf.over Ui)`, matching the blueprint's `φ'' : (Y.ringCatSheaf.over Vᵢ) ⟶ (eqv.inverse.sheafPushforwardContinuous …).obj (X.ringCatSheaf.over Uᵢ)` exactly.
- **Proof follows sketch**: partial — the first factor `sliceStructureSheafHom φ.symm (φ.inv ⁻¹ᵁ Ui)` is correctly pinned (= over-pullback of `φ.hom.toRingCatSheafHom`, exactly as the blueprint says); the residual `≫ sorry` at line 607 is the 2-part codomain bridge.
- **notes**: The sorry is honest and correctly typed. The Lean comment at lines 594–606 accurately describes the 2-part residual: (a) `Functor.sheafPushforwardContinuousComp'` for the `eqv.inverse = Over.post ⋙ Over.map` decomposition, (b) the object-relabel iso `X.ringCatSheaf.over (φ.hom⁻¹ᵁ Vᵢ) ≅ (sheafPushforwardContinuous (Over.map (unitIso.inv.app Uᵢ))).obj (X.ringCatSheaf.over Uᵢ)`. This matches the blueprint's "transport along the codomain isomorphism induced by the `Over.map(unitIso.inv)` factor together with the relabelling". The blueprint's `\leanok` on the statement block is correct (sorry present).

### `\lean{AlgebraicGeometry.pushforwardSliceAdjunctionH1}` (chapter: `lem:pushforward_slice_adjunction_h1`)
- **Lean target exists**: yes (line 644)
- **Signature matches**: yes — `whiskerRight (NatTrans.op (sliceOversEquiv φ Ui).symm.toAdjunction.counit) (Sheaf.over X.ringCatSheaf Ui).obj = (sliceStructureSheafHom φ Ui).hom ≫ (sliceOversEquiv φ Ui).symm.inverse.op.whiskerLeft (sliceReverseRingMap φ Ui).hom`. This is exactly the H₁ counit-naturality square required by `SheafOfModules.pushforwardPushforwardAdj`.
- **Proof follows sketch**: N/A — body is `sorry` (line 649); blocked on concrete φ''. Blueprint proof says it reduces to a proof-irrelevant equality along `φ.hom⁻¹(φ.inv⁻¹ Uᵢ) = Uᵢ`; this claim is correct and not over-claiming.
- **notes**: The sorry is honest and correctly typed. The fact that `pushforwardSliceTwoAdjunction` compiles confirms the signature is type-correct as the 4th argument of `pushforwardPushforwardAdj`. Blueprint `\leanok` on statement block is correct.

### `\lean{AlgebraicGeometry.pushforwardSliceAdjunctionH2}` (chapter: `lem:pushforward_slice_adjunction_h2`)
- **Lean target exists**: yes (line 654)
- **Signature matches**: yes — unit triangle `(sliceReverseRingMap φ Ui).hom ≫ … (sliceOversEquiv φ Ui).symm.toAdjunction.unit … = 𝟙 …`. Matches the H₂ requirement of `pushforwardPushforwardAdj`.
- **Proof follows sketch**: N/A — body is `sorry` (line 660); same block as H₁. Blueprint proof ("identical in shape to H₁") is accurate.
- **notes**: Same status as H₁. Blueprint `\leanok` on statement correct. Not over-claiming.

### `\lean{AlgebraicGeometry.pushforwardSliceTwoAdjunction}` (chapter: `lem:pushforward_slice_two_adjunction`)
- **Lean target exists**: yes (line 665), **compiles** (body sorry-free inline; transitively sorry via H₁/H₂)
- **Signature matches**: yes — `SheafOfModules.pushforward (sliceReverseRingMap φ Ui) ⊣ SheafOfModules.pushforward (sliceStructureSheafHom φ Ui)`
- **Proof follows sketch**: yes — body assembles `SheafOfModules.pushforwardPushforwardAdj (sliceOversEquiv φ Ui).symm.toAdjunction (sliceReverseRingMap φ Ui) (sliceStructureSheafHom φ Ui) (H1) (H2)`, exactly as the blueprint prescribes.
- **notes**: Blueprint `\leanok` on statement correct. **Stale annotation**: the blueprint carries `% NOTE: build target. The Lean declaration does not exist yet.` (line ~10331) — this is now incorrect; the declaration exists and compiles. The proof block does not have `\leanok`, which is correct (transitively sorry via H₁/H₂).

### `\lean{AlgebraicGeometry.pushforwardSlicePullbackIso}` (chapter: `lem:pushforward_slice_pullback_iso`)
- **Lean target exists**: yes (line 687), partially built — body `(Adjunction.leftAdjointUniq …).app (H.over Ui) ≪≫ sorry` (line 692)
- **Signature matches**: yes — `(SheafOfModules.pullback (sliceStructureSheafHom φ Ui)).obj (H.over Ui) ≅ ((Scheme.Modules.pushforwardEquivOfIso φ).functor.obj H).over (φ.inv ⁻¹ᵁ Ui)`, matching the blueprint statement.
- **Proof follows sketch**: partial — Step 1 (leftAdjointUniq for the functor isomorphism `pullback ψ_r ≅ pushforward φ''`) is complete; Step 2 (section identity `(pushforward φ'').obj (H.over Uᵢ) ≅ (Φ H).over Vᵢ` via `Scheme.Modules.pushforward_obj_obj`) is the `sorry`. The blueprint says Step 2 is "direct definitional unfolding"; the Lean comment calls it "rfl-clean" via `pushforward_obj_obj` — consistent.
- **notes**: Sorry is honest and correctly typed. Blueprint `\leanok` on statement correct. **Stale annotation**: `% NOTE: build target. The Lean declaration does not exist yet.` (line ~10386) is now incorrect; the partial declaration exists.

### `\lean{AlgebraicGeometry.pushforward_iso_preserves_qcoh}` (chapter: `lem:pushforward_iso_preserves_qcoh`)
- **Lean target exists**: yes (line 705), **compiles** (body sorry-free inline; transitively sorry via `pushforwardSlicePullbackIso`)
- **Signature matches**: yes — `(φ : X ≅ Y) (H : X.Modules) (hH : H.IsQuasicoherent) : ((Scheme.Modules.pushforwardEquivOfIso φ).functor.obj H).IsQuasicoherent`
- **Proof follows sketch**: yes — obtains `qcd` from `hH.nonempty_quasicoherentData`, calls `pushforward_iso_qcoh_of_slice_qcoh`, transports presentation via `SheafOfModules.pullback ψ_r` and `pushforwardSlicePullbackIso`, concludes per-slice qcoh. Matches the blueprint's "cover → per-member transport → ofIsIso" proof structure.
- **notes**: Blueprint `\leanok` on statement correct. **Stale annotation**: `% NOTE: build target. The Lean declaration does not exist yet.` (line ~10448) is now incorrect; the declaration compiles. The proof block does not have `\leanok`, which is correct (transitively sorry).

### `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_acyclic}` (chapter: `lem:open_immersion_pushforward_comp`, part 1)
- **Lean target exists**: yes (line 794), **compiles with no inline sorry** — case `hqc` closed by `exact pushforward_iso_preserves_qcoh U.isoSpec H hH` (line 868)
- **Signature matches**: yes — `(j : U ⟶ X) [IsOpenImmersion j] [IsAffine U] [X.IsSeparated] (H : U.Modules) (hH : H.IsQuasicoherent) (q : ℕ) (hq : 0 < q) : IsZero (higherDirectImage j q H)`, matches blueprint.
- **Proof follows sketch**: yes — follows the presheaf → sheafification → locally-zero → affine-basis → Ext-vanishing → spectrum-transport chain described in the blueprint. The case `hqc` is now discharged (no longer sorry), making this the key closure of the iteration.
- **notes**: This is the primary closed declaration of iter-064. No `\leanok` on `lem:open_immersion_pushforward_comp` statement/proof block, which seems inconsistent given `higherDirectImage_openImmersion_comp` (grouped under the same `\lean{}` reference) has a full `sorry`. Likely a `sync_leanok` determination to wait until both co-named declarations are sorry-free.

### `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_comp}` (chapter: `lem:open_immersion_pushforward_comp`, part 2; pinned)
- **Lean target exists**: yes (line 910), full `sorry` body (line 934)
- **Signature matches**: yes — `(j : U ⟶ X) … (f : X ⟶ S) (H : U.Modules) (hH : H.IsQuasicoherent) (k : ℕ) : higherDirectImage f k ((pushforward j).obj H) ≅ higherDirectImage (j ≫ f) k H`. Pinned signature, frozen.
- **Proof follows sketch**: N/A — full `sorry`; the proof sketch in the Lean comment (lines 917–933) accurately describes the residual acyclic-resolution argument.
- **notes**: The blueprint proof sketch for part (2) is detailed enough to guide formalization once part (1) is sorry-free throughout.

### `\lean{AlgebraicGeometry.isAffineHom_of_affine_separated}` (chapter: `lem:open_immersion_pushforward_comp`)
- **Lean target exists**: yes (line 752, private)
- **Signature matches**: yes — inferred helper
- **notes**: Private, correctly used, no issue.

---

## Red flags

### Placeholder / suspect bodies

- `sliceReverseRingMap` (line 607): `sliceStructureSheafHom φ.symm (φ.inv ⁻¹ᵁ Ui) ≫ sorry` — **honest open leaf**; the first factor is pinned correctly; residual is the 2-part codomain bridge described in the Lean comment and blueprint. Not a fake placeholder.
- `pushforwardSliceAdjunctionH1` (line 649): `sorry` body — **honest open leaf**; blocked on φ'' concretization; correctly typed (signature verified by `pushforwardSliceTwoAdjunction` compiling).
- `pushforwardSliceAdjunctionH2` (line 660): `sorry` body — **honest open leaf**; same status as H₁.
- `pushforwardSlicePullbackIso` (line 692): `(leftAdjointUniq …).app (H.over Ui) ≪≫ sorry` — **honest partial body**; Step 1 complete, Step 2 (`pushforward_obj_obj` section identity) is the sorry.
- `higherDirectImage_openImmersion_comp` (line 934): full `sorry` — **honest open leaf**; the entire part (2) is deferred, as expected.

None of these are fake or structurally wrong. All are correctly typed; the `pushforwardSliceTwoAdjunction` compiling guarantees H₁/H₂ types are type-correct.

### Excuse-comments
None. All comments are accurate technical descriptions of the residual state, not excuses for wrong code.

### Axioms / Classical.choice on non-trivial claims
None introduced this iteration.

---

## Unreferenced declarations (informational)

Declarations in the Lean file with no direct `\lean{...}` pin, listed with status:

| Declaration | Blueprint coverage | Assessment |
|---|---|---|
| `isZero_of_faithful_preservesZeroMorphisms` | via `lem:open_immersion_pushforward_comp` uses-chain | helper, acceptable |
| `isZero_presheafToSheaf_of_sections_locally_zero` | `\lean{}` ref exists at `lem:isZero_presheafToSheaf_of_sections_locally_zero` | covered |
| `sectionsFunctorCorepIso`, `sectionsCorep`, `sectionsCorepPushforward` | `lem:sectionsFunctorCorepIso` / `lem:jshriek_transport_along_iso` refs | covered |
| `rightDerivedNatIso` | `lem:rightDerivedNatIso` ref | covered |
| `Scheme.Modules.pushforwardEquivOfIso`, `pushforwardExtAddEquiv`, `modulesIsoSpecExtTransport` | `lem:modules_isoSpec_ext_transport` ref | covered |
| `jShriekOU_transport_along_iso` | `lem:jshriek_transport_along_iso` ref | covered |
| `pushforward_iso_qcoh_of_slice_qcoh`, `coversTop_preimage_of_iso` | `lem:pushforward_iso_qcoh_of_slice_qcoh` ref | covered |
| `opensMapInvBase_isEquivalence`, `overPost_slice_isContinuous`, `opensMapHomBase_isEquivalence`, `opensEquivOfIso`, `sliceOversEquiv`, `sliceOversEquiv_functor_isContinuous`, `overPost_slice_inverse_isContinuous`, `sliceOversEquiv_inverse_isContinuous` | `lem:slice_structureSheaf_hom` / `lem:slice_overs_equiv_continuity` refs | covered |
| `sliceStructureSheafHom`, `sliceStructureSheafHom_pre_isRightAdjoint`, `sliceStructureSheafHom_isRightAdjoint` | `lem:slice_structureSheaf_hom` ref | covered |
| `pushforwardSectionsFunctor`, `pushforwardSectionsFunctor_additive` | `lem:pushforward_sections_functor` ref | covered |
| Various private helpers (`jShriekOU_homEquiv_nat`, `preadditiveCoyoneda_mapHomologicalComplex_d_apply`, `isAffineHom_of_affine_separated`) | used internally | acceptable |

All substantive declarations are blueprint-covered. The two `private` / instance declarations that have no `\lean{}` pin of their own are correctly absorbed by the parent lemma's `\lean{}` block.

---

## Blueprint adequacy for this file

- **Coverage**: all substantive Lean declarations map to a `\lean{...}` block in the chapter. No unreferenced substantive declarations. **Coverage: complete.**
- **Proof-sketch depth**: **adequate for all closed or partially-closed declarations**; one minor under-specification noted below for the φ'' codomain bridge (part b). For the fully sorry'd `higherDirectImage_openImmersion_comp`, the proof sketch in both Lean and blueprint is detailed enough to guide the eventual formalization.
- **Hint precision**: **precise** — all `\lean{...}` hints name the exact Lean declarations, namespaced correctly.
- **Generality**: **matches need** — the blueprint levels (slice ring maps, two-pushforward adjunction, pullback iso) exactly match what the formalization required.

### Blueprint adequacy findings

**1. Stale `% NOTE: build target` annotations (major)**

Three `% NOTE: build target. The Lean declaration does not exist yet.` comments are now stale:
- `lem:pushforward_slice_two_adjunction` (line ~10331): `pushforwardSliceTwoAdjunction` compiles.
- `lem:pushforward_slice_pullback_iso` (line ~10386): `pushforwardSlicePullbackIso` partially exists.
- `lem:pushforward_iso_preserves_qcoh` (line ~10448): `pushforward_iso_preserves_qcoh` compiles.

These should be removed or updated. The annotations are not actively misleading about mathematical content, but they are factually wrong about the Lean state.

**2. φ'' codomain bridge (b): blueprint under-specifies the object-relabel iso (minor)**

The blueprint proof of `lem:slice_reverse_ring_map` calls the transport "pure equality-transport bookkeeping... no new mathematics." The Lean comment estimates "~40–80 LOC" for part (b), the explicit isomorphism `X.ringCatSheaf.over (φ.hom⁻¹ᵁ Vᵢ) ≅ (sheafPushforwardContinuous (Over.map (unitIso.inv.app Uᵢ))).obj (X.ringCatSheaf.over Uᵢ)`. Calling this "no new mathematics" is technically accurate (it is a sheaf-level relabeling) but may be misleading about the formalization effort. A one-sentence addition naming `Functor.sheafPushforwardContinuousComp'` as part (a) and the explicit `X.ringCatSheaf.over` relabeling isomorphism as part (b) would help the prover close this leaf.

**3. H₁/H₂ blueprint proofs: correctly specified, not over-claiming (pass)**

The blueprint proofs for `lem:pushforward_slice_adjunction_h1` and `_h2` correctly state that, once φ'' is concrete, the squares reduce to `eqToHom = eqToHom` equalities along `φ.hom⁻¹(φ.inv⁻¹ Uᵢ) = Uᵢ`, closed by proof-irrelevance. This is accurate and not over-claiming.

**4. `lem:open_immersion_pushforward_comp`: no `\leanok` on statement block (informational)**

The lemma groups `higherDirectImage_openImmersion_comp` (full `sorry`) and `higherDirectImage_openImmersion_acyclic` (no inline sorry, but transitively sorry). The absence of `\leanok` is consistent with `sync_leanok` conservatively deferring until `_comp` is also sorry-free. No action needed on the blueprint side.

### Recommended chapter-side actions
- **Remove (or update) the three stale `% NOTE: build target. The Lean declaration does not exist yet.`** annotations from `lem:pushforward_slice_two_adjunction`, `lem:pushforward_slice_pullback_iso`, and `lem:pushforward_iso_preserves_qcoh`.
- **Expand φ'' proof** (`lem:slice_reverse_ring_map`) with a brief pointer to `Functor.sheafPushforwardContinuousComp'` (part a) and an explicit statement of the structure-sheaf-over object-relabel iso (part b), so the prover can close the `≫ sorry`.

---

## Severity summary

| Finding | Severity |
|---|---|
| 3 stale `% NOTE: build target. The Lean declaration does not exist yet.` in blueprint | **major** |
| φ'' codomain bridge (b) under-specified in blueprint proof | **minor** |
| 5 sorry terms in code (sliceReverseRingMap, H₁, H₂, pullbackIso, comp): all honest open leaves correctly typed and described | informational (expected state) |
| H₁/H₂ blueprint proofs: accurate, not over-claiming | pass |
| Blueprint `\lean{}` hints: all correct | pass |
| Signature matches: all correct | pass |

**No must-fix-this-iter findings.** All sorries are honest open leaves; no fake/placeholder bodies; no wrong signatures; no axioms; no excuse-comments.

**Overall verdict**: `OpenImmersionPushforward.lean` faithfully follows the blueprint — 8 substantive declarations checked, 2 red flags (both advisory: stale blueprint annotations and minor proof-sketch thinness for the φ'' codomain bridge). The iter-064 closures (`pushforwardSliceTwoAdjunction`, `pushforward_iso_preserves_qcoh`, case `hqc`) are correctly reflected; the 4 remaining open leaves are all properly typed and accurately described in both Lean and blueprint.
