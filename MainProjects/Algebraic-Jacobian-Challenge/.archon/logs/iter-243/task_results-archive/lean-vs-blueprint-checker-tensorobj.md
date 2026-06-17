# Lean ↔ Blueprint Check Report

## Slug
tensorobj

## Iteration
242

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration (declarations in TensorObjSubstrate.lean covered by `\lean{...}` blocks)

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (chapter: `def:scheme_modules_tensorobj`)
- **Lean target exists**: yes (L138)
- **Signature matches**: yes — `{X : Scheme.{u}} (M N : X.Modules) : X.Modules`, sheafification of presheaf tensor ✓
- **Proof follows sketch**: yes — sheafification of `PresheafOfModules.Monoidal.tensorObj` on small Zariski site ✓
- **notes**: `\leanok` present in blueprint statement block. No sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` (chapter: `lem:scheme_modules_tensorobj_functoriality`)
- **Lean target exists**: yes (L153)
- **Signature matches**: yes — `(f : M ⟶ M') (g : N ⟶ N') : tensorObj M N ⟶ tensorObj M' N'` ✓
- **Proof follows sketch**: yes — inherits morphism action from presheaf monoidal tensor under sheafification ✓
- **notes**: `\leanok` present. No sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible}` (chapter: `def:scheme_modules_isinvertible`)
- **Lean target exists**: yes (L166)
- **Signature matches**: yes — `{X : Scheme.{u}} (M : X.Modules) : Prop := ∃ N, Nonempty (tensorObj M N ≅ SheafOfModules.unit X.ringCatSheaf)` ✓
- **Proof follows sketch**: N/A (Prop definition)
- **notes**: `\leanok` present in blueprint. Matches blueprint's `∃ N, Nonempty(M ⊗_X N ≅ 𝒪_X)` exactly.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso}` (chapter: `lem:tensorobj_restrict_iso`)
- **Lean target exists**: yes (L446)
- **Signature matches**: yes — `(f : Y ⟶ X) [IsOpenImmersion f] (M N : X.Modules) : (tensorObj M N).restrict f ≅ tensorObj (M.restrict f) (N.restrict f)` ✓
- **Proof follows sketch**: yes — 4-step proof (Step 1: restrictFunctorIsoPullback; Step 2: sheafificationCompPullback; Step 3: strip sheafification; Step 4: H1 via pushforwardPushforwardAdj + leftAdjointUniq, H2 via restrictScalarsMonoidalOfBijective + μIso) matches blueprint's described decomposition ✓
- **notes**: `\leanok` present. No sorry. Axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_isLocallyTrivial}` (chapter: `lem:tensorobj_preserves_locally_trivial`)
- **Lean target exists**: yes (L536)
- **Signature matches**: yes — `(hM : LineBundle.IsLocallyTrivial M) (hN : LineBundle.IsLocallyTrivial N) : LineBundle.IsLocallyTrivial (tensorObj M N)` ✓
- **Proof follows sketch**: yes — picks common affine cover, uses restrictIsoUnitOfLE, tensorObj_restrict_iso, tensorObjIsoOfIso, tensorObj_unit_iso ✓
- **notes**: `\leanok` present. No sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso}` (chapter: `lem:tensorobj_assoc_iso`)
- **Lean target exists**: yes (L341)
- **Signature matches**: yes — unconditional `{M N P : X.Modules} : tensorObj (tensorObj M N) P ≅ tensorObj M (tensorObj N P)`, no `IsLocallyTrivial` or `IsInvertible` hypothesis ✓
- **Proof follows sketch**: yes — uses `W_whiskerRight/Left_of_W` + `isIso_sheafification_map_of_W` + presheaf associator, matching blueprint 3-step sheafification transport ✓
- **notes**: `\leanok` present. No direct sorry in body; sorry-transitive through `isLocallyInjective_whiskerLeft_of_W` in Vestigial.lean (known pre-existing, outside TensorObjSubstrate.lean).

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_left_unitor, AlgebraicGeometry.Scheme.Modules.tensorObj_right_unitor}` (chapter: `lem:tensorobj_unit_iso`)
- **Lean target exists**: yes — `tensorObj_left_unitor` (L269), `tensorObj_right_unitor` (L279)
- **Signature matches**: yes — `(M : X.Modules) : tensorObj (SheafOfModules.unit ...) M ≅ M` and right variant ✓
- **Proof follows sketch**: yes — both use `sheafification.mapIso (presheaf unitor) ≪≫ (asIso adj.counit).app M`, matching blueprint's "cheap mapIso pattern" ✓
- **notes**: Blueprint statement block is **missing `\leanok`** even though both declarations are fully defined without sorry. This is a `sync_leanok` gap, not a content issue; will be corrected automatically.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_braiding}` (chapter: `lem:tensorobj_comm_iso`)
- **Lean target exists**: yes (L289)
- **Signature matches**: yes — `(M N : X.Modules) : tensorObj M N ≅ tensorObj N M` ✓
- **Proof follows sketch**: yes — `sheafification.mapIso (BraidedCategory.braiding ...)` ✓
- **notes**: `\leanok` present. No sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse}` (chapter: `lem:tensorobj_inverse_invertible`)
- **Lean target exists**: yes (L693)
- **Signature matches**: yes — `(hL : LineBundle.IsLocallyTrivial L) : ∃ Linv : X.Modules, LineBundle.IsLocallyTrivial Linv ∧ Nonempty (tensorObj L Linv ≅ SheafOfModules.unit ...)` ✓
- **Proof follows sketch**: N/A (body is `:= sorry`)
- **notes**: **Pre-existing known sorry** per directive; not re-reported as new issue. Blueprint proof block notes this as "Infrastructure-blocked." `\leanok` present on statement only (declaration exists).

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjOnProduct}` (chapter: `lem:tensorobj_lift_onproduct`)
- **Lean target exists**: yes (L725)
- **Signature matches**: yes — `(L L' : LineBundle.OnProduct πC πT) : LineBundle.OnProduct πC πT` ✓
- **Proof follows sketch**: yes — applies `tensorObj_isLocallyTrivial` directly ✓
- **notes**: `\leanok` present. No sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.unitToPushforwardObjUnit_comp}` (chapter: `lem:unitToPushforwardObjUnit_comp`)
- **Lean target exists**: yes (L882)
- **Signature matches**: yes — composition coherence of pushforward unit comparison, holds by `rfl` sectionwise ✓
- **Proof follows sketch**: yes — `ext; rfl`-chain ✓
- **notes**: `\leanok` present. No sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_comp}` (chapter: `lem:pullbackObjUnitToUnit_comp`)
- **Lean target exists**: yes (L923)
- **Signature matches**: yes — `pbu(h≫f) = (pullbackComp h f).inv.app (...) ≫ (pullback h).map (pbu f) ≫ pbu h` ✓
- **Proof follows sketch**: yes — adjunction-mate transport from `unitToPushforwardObjUnit_comp` via `conjugateEquiv_pullbackComp_inv` + `unit_conjugateEquiv` ✓
- **notes**: `\leanok` present. No sorry. Proof uses `erw` for defeq-but-not-syntactic `SheafOfModules` compositions as expected from blueprint's note.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackUnitIso}` (chapter: `lem:pullback_unit_iso`)
- **Lean target exists**: yes (L1066)
- **Signature matches**: yes — `(f : Y ⟶ X) : (Scheme.Modules.pullback f).obj (SheafOfModules.unit X.ringCatSheaf) ≅ SheafOfModules.unit Y.ringCatSheaf` ✓
- **Proof follows sketch**: yes — uses `final_of_representablyFlat` unconditionally for `(Opens.map f.base).Final`, then `pullbackObjUnitToUnitIso` ✓
- **notes**: `\leanok` present. No sorry. Axiom-clean. Lean file confirms iter-241 finding that chart-chase is unnecessary (one-liner via `final_of_representablyFlat`); blueprint proof matches this description.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorIso}` (chapter: `lem:pullback_tensor_iso`)
- **Lean target exists**: **no** — declaration absent from `TensorObjSubstrate.lean`
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Correctly has no `\leanok` in blueprint. Blocked on Mathlib-absent concrete inverse-image model (not yet built). The directive confirms this was NOT closed this iter. See Red Flags §1 for blueprint staleness.

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible.pullback}` (chapter: `lem:isinvertible_pullback`)
- **Lean target exists**: **no** — declaration absent from `TensorObjSubstrate.lean`
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Correctly has no `\leanok` in blueprint. Blocked on `pullbackTensorIso`. The directive confirms this was NOT closed this iter. Blueprint description of the obstacle remains accurate.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso_invertible}` (chapter: `lem:tensorobj_assoc_iso_invertible`)
- **Lean target exists**: yes (L742)
- **Signature matches**: yes — `(_hM : IsInvertible M) (_hN : IsInvertible N) (_hP : IsInvertible P) : tensorObj (tensorObj M N) P ≅ tensorObj M (tensorObj N P)` ✓
- **Proof follows sketch**: yes — immediate specialization of `tensorObj_assoc_iso` ✓
- **notes**: `\leanok` present. No direct sorry (sorry-transitive through `tensorObj_assoc_iso`, known pre-existing).

### `\lean{AlgebraicGeometry.Scheme.Modules.PicGroup}` (chapter: `def:pic_carrier`)
- **Lean target exists**: yes (L800)
- **Signature matches**: yes — `(X : Scheme.{u}) : Type _ := Quotient (picSetoid X)`, quotient of ⊗-invertible modules by isomorphism ✓
- **Proof follows sketch**: N/A (type definition)
- **notes**: `\leanok` present. `picSetoid` at L793 equips the predicate with the correct isomorphism setoid.

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible.tensorObj}` (chapter: `lem:isinvertible_tensor`)
- **Lean target exists**: yes (L764)
- **Signature matches**: yes — `(hM : IsInvertible M) (hM' : IsInvertible M') : IsInvertible (Scheme.Modules.tensorObj M M')` ✓
- **Proof follows sketch**: yes — uses `tensorObj_middleFour` (private helper) + `tensorObjIsoOfIso e e'` + `tensorObj_unit_iso` ✓
- **notes**: `\leanok` present. No sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.isInvertible_unit}` (chapter: `lem:isinvertible_unit`)
- **Lean target exists**: yes (L774)
- **Signature matches**: yes — `IsInvertible (SheafOfModules.unit X.ringCatSheaf)` ✓
- **Proof follows sketch**: yes — witness `𝒪_X`, iso `tensorObj_unit_iso` ✓
- **notes**: `\leanok` present. No sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible.inverse_unique}` (chapter: `lem:isinvertible_inverse_welldef`)
- **Lean target exists**: yes (L781)
- **Signature matches**: yes — `(e : tensorObj M N ≅ ...) (e' : tensorObj M N' ≅ ...) : Nonempty (N ≅ N')` ✓
- **Proof follows sketch**: yes — inverse-of-inverse chain via `tensorObj_right_unitor`, `tensorObjIsoOfIso`, `tensorObj_assoc_iso.symm`, braiding, left unitor ✓
- **notes**: `\leanok` present. No sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.picCommGroup}` (chapter: `thm:pic_commgroup`)
- **Lean target exists**: yes (L834)
- **Signature matches**: yes — `noncomputable instance picCommGroup (X : Scheme.{u}) : CommGroup (PicGroup X)` ✓
- **Proof follows sketch**: yes — each axiom discharged by single existence-of-isomorphism: `mul_assoc ← tensorObj_assoc_iso`, `one_mul ← tensorObj_left_unitor`, `mul_one ← tensorObj_right_unitor`, `inv_mul_cancel ← witness iso via braiding`, `mul_comm ← tensorObj_braiding` ✓
- **notes**: `\leanok` present. No sorry in the direct body. Axiom-clean modulo the transitive `tensorObj_assoc_iso` residual.

### `\lean{AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj}` (chapter: `thm:rel_pic_addcommgroup_via_tensorobj`)
- **Lean target exists**: yes (L1224)
- **Signature matches**: yes — `(πC : C ⟶ S) (πT : T ⟶ S) : AddCommGroup (Quotient (RelPicPresheaf.preimage_subgroup πC πT))` ✓
- **Proof follows sketch**: N/A (body is `:= sorry`)
- **notes**: **Pre-existing known sorry** per directive; not re-reported as new issue. Blueprint has `\leanok` on statement. Consumer pin is correct; body awaits close of `exists_tensorObj_inverse` and bridges.

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_of_isIso_restrict}` (chapter: `lem:isIso_of_isIso_restrict`)
- **Lean target exists**: yes (L567)
- **Signature matches**: yes — stalkwise iso criterion, matches blueprint ✓
- **Proof follows sketch**: yes — uses `restrictStalkNatIso`, `NatIso.isIso_map_iff`, `isIso_of_stalkFunctor_map_iso` ✓
- **notes**: `\leanok` present (based on blueprint line ~4369 context). No sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.homMk}` (chapter: `lem:homMk`)
- **Lean target exists**: yes (L608)
- **Signature matches**: yes — wraps `PresheafOfModules.homMk` at Scheme.Modules level ✓
- **Proof follows sketch**: yes ✓
- **notes**: `\leanok` present. No sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.dual}` (chapter: within `sec:tensorobj_dual_infra`)
- **Lean target exists**: yes (L194)
- **Signature matches**: yes — `(M : X.Modules) : X.Modules`, sheafification of `PresheafOfModules.dual M.val` ✓
- **Proof follows sketch**: N/A (def)
- **notes**: `\leanok` present in blueprint. No sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.dualIsoOfIso}` (chapter: within `sec:tensorobj_dual_infra`)
- **Lean target exists**: yes (L205)
- **Signature matches**: yes — `(e : M ≅ M') : dual M' ≅ dual M` ✓
- **Proof follows sketch**: yes — `sheafification.mapIso (PresheafOfModules.dualIsoOfIso ...)` ✓
- **notes**: `\leanok` present. No sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjIsoclassCommMonoid}` (chapter: `lem:tensorobj_isoclass_commgroup`)
- **Lean target exists**: **no** — declaration absent from all covered Lean files; the carrier-pivot replaced this with `picCommGroup` / `thm:pic_commgroup`
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint has NO `\leanok` for this block (consistent: never formalized). The locally-trivial-carrier group law was superseded by the invertibility-carrier `picCommGroup`. The blueprint retains this block for historical record; the `\uses` reference to it in `thm:rel_pic_addcommgroup_via_tensorobj` is marked "DEFERRED" in the blueprint itself (see blueprint comment line 3337). This is a known deferred cleanup, not a new finding.

---

## Red flags

### Placeholder / suspect bodies
_(None new to report — two known pre-existing sorries excluded per directive.)_

- `Scheme.Modules.exists_tensorObj_inverse` at line 715: `:= sorry` — **pre-existing, excluded per directive**.
- `Scheme.PicSharp.addCommGroup_via_tensorObj` at line 1227: `:= sorry` — **pre-existing, excluded per directive**.

### Excuse-comments
None of the fully-implemented declarations have excuse-comments in the sense of "TODO replace with real def" or "wrong but works for now." The long docstrings in TensorObjSubstrate.lean explain *why* the sorry bodies exist (infrastructure missing), not that a wrong implementation was left in place. These are appropriate historical notes, not red flags.

### Axioms / Classical.choice on non-trivial claims
No `axiom` declarations in `TensorObjSubstrate.lean`. The `Classical.choice a.2` in `picInv` (L817) is structurally appropriate: it selects the membership witness of an `IsInvertible` predicate (an existential Prop), exactly as the blueprint describes. Blueprint does NOT authorize any `axiom`.

---

## Unreferenced declarations (informational)

The following declarations in `TensorObjSubstrate.lean` are NOT `\lean{...}`-pinned in the blueprint. All are helpers; the substantive ones are noted:

| Declaration | Line | Assessment |
|---|---|---|
| `Scheme.Modules.tensorObjIsoOfIso` | L240 | Helper for tensorObj_isLocallyTrivial; acceptable helper |
| `Scheme.Modules.tensorObj_unit_iso` | L256 | Helper (𝒪⊗𝒪≅𝒪); acceptable but could be pinned |
| `Scheme.Modules.restrictIsoUnitOfLE` | L394 | Helper for tensorObj_isLocallyTrivial; acceptable |
| `Scheme.Modules.tensorObj_middleFour` | L751 | **private**; helper for IsInvertible.tensorObj |
| `Scheme.Modules.picSetoid` | L793 | Helper for PicGroup def; acceptable |
| `Scheme.Modules.picMul` | L805 | Helper for picCommGroup; acceptable |
| `Scheme.Modules.picInv` | L814 | Helper for picCommGroup; acceptable |
| `Scheme.Modules.toPresheaf_map_homMk` | L616 | simp lemma helper for homMk |
| `Scheme.Modules.isIso_pbu_of_final` | L1041 | **private**; TC-isolation helper for pullbackUnitIso |
| `Scheme.Modules.pullbackObjUnitToUnitIso` | L1049 | Bundled iso form of pbu; packaging helper |
| `Scheme.Modules.pullbackObjUnitToUnitIso_hom` | L1056 | simp lemma |
| `Scheme.Modules.sheafifyTensorUnitIso` | L1084 | **private**; helper for pullbackTensorIso build |
| **`presheafPushforwardLaxMonoidal`** | L1137 | **Substantive new instance — SEE MAJOR FINDING below** |
| **`presheafPullbackOplaxMonoidal`** | L1159 | **Substantive new instance — SEE MAJOR FINDING below** |

---

## Blueprint adequacy for this file

**Coverage**: 23/25 substantive Lean declarations in TensorObjSubstrate.lean have a corresponding `\lean{...}` block in the chapter. The 2 uncovered substantive declarations are `presheafPushforwardLaxMonoidal` and `presheafPullbackOplaxMonoidal` (new this iter).

**Proof-sketch depth**: **under-specified** for `lem:pullback_tensor_iso` — see major finding below. Adequate for all other declared blocks.

**Hint precision**: **partial** — `lem:tensorobj_isoclass_commgroup` pins `tensorObjIsoclassCommMonoid` which no longer exists (carrier-pivot deletion); this is a known stale pin flagged in the blueprint's own comment.

**Generality**: matches need

---

### MAJOR FINDING 1: `presheafPushforwardLaxMonoidal` and `presheafPullbackOplaxMonoidal` are unpin­ned in the blueprint

**Severity**: **major**

Two substantive infrastructure instances were added this iteration to `TensorObjSubstrate.lean`:

1. `presheafPushforwardLaxMonoidal` (L1137–1147): noncomputable instance establishing that `PresheafOfModules.pushforward φ` is lax monoidal for a CommRingCat-level presheaf ring morphism φ. Full proof body; no sorry.

2. `presheafPullbackOplaxMonoidal` (L1159–1166): noncomputable instance establishing that `PresheafOfModules.pullback φ` is oplax monoidal with canonical comparison δ, built via `(pullbackPushforwardAdjunction φ).leftAdjointOplaxMonoidal`. Full proof body; no sorry.

Neither is currently pinned by any `\lean{...}` block in the blueprint. These declarations are reusable prerequisites for `pullbackTensorIso` (and are described narratively in the Phase-2 status comment at L1168–1194 of the Lean file).

**Recommended chapter-side action**: Add a new blueprint block (or extend the existing `lem:presheaf_pushforward_adj_substrate` block) pinning these two instances. Suggested label: `lem:presheaf_pullback_oplax_monoidal`. The block should note these are at the presheaf level (not the SheafOfModules level) and serve as the reusable Phase-2 prerequisites toward `pullbackTensorIso`.

---

### MAJOR FINDING 2: Blueprint proof sketch for `lem:pullback_tensor_iso` is stale regarding `pushforward.LaxMonoidal`

**Severity**: **major**

The blueprint proof sketch for `lem:pullback_tensor_iso` (lines ~2718–2728) states:

> "The bundled doctrinal adjunction `Adjunction.leftAdjointOplaxMonoidal` is present at the pinned commit, but it is **not usable here**: it requires `MonoidalCategory(SheafOfModules)` instances (the project carries `⊗_X` as a bespoke sheafified tensor with no such instance and **no `pushforward.LaxMonoidal`**), and in any case it would yield only an oplax comparison map, not the required isomorphism."

The claim "**no `pushforward.LaxMonoidal`**" is now **refuted** by iter-242 work:
- `presheafPushforwardLaxMonoidal` builds `(PresheafOfModules.pushforward φ).LaxMonoidal` at the presheaf level.
- `presheafPullbackOplaxMonoidal` uses `leftAdjointOplaxMonoidal` to build the oplax structure — precisely the "not usable here" shortcut the blueprint says is unavailable.

The conclusion remains correct (the oplax map alone doesn't suffice to prove `δ` is an iso, as noted in the Lean file's Phase-2 comment: no "oplax ⇒ preserves invertibles" lemma), but the stated reason is wrong. The real remaining obstacle is the **Mathlib-absent concrete inverse-image model** (`PresheafOfModules.extendScalars` + left-Kan-extension topological inverse image).

**Recommended chapter-side action**: Update the proof sketch for `lem:pullback_tensor_iso` to:
1. Acknowledge that `presheafPushforwardLaxMonoidal` IS now built (presheaf-level `pushforward.LaxMonoidal`).
2. Acknowledge that `presheafPullbackOplaxMonoidal` IS now built (abstract pullback is oplax monoidal with comparison `δ`).
3. Clarify that the remaining obstacle is: δ is not automatically an iso (Γ(ℙ¹, 𝒪(1))=0 counterexample), and proving iso-ness requires a concrete model of the pullback — specifically `PresheafOfModules.extendScalars` + left-Kan-extension inverse image, which are Mathlib-absent at the pinned commit.

---

### MINOR FINDING 1: `lem:tensorobj_unit_iso` blueprint statement block missing `\leanok`

**Severity**: **minor**

The blueprint statement block for `lem:tensorobj_unit_iso` (lines ~1554–1557) does not carry `\leanok`, though both pinned declarations `tensorObj_left_unitor` (L269) and `tensorObj_right_unitor` (L279) are fully defined in the Lean file with no sorry. This is a `sync_leanok` gap that will be corrected automatically.

---

### MINOR FINDING 2: `lem:tensorobj_isoclass_commgroup` pins a deleted declaration

**Severity**: **minor** (known, flagged in blueprint's own comments)

The blueprint block `lem:tensorobj_isoclass_commgroup` (line ~2364) pins `AlgebraicGeometry.Scheme.Modules.tensorObjIsoclassCommMonoid`, which no longer exists in any covered Lean file. The locally-trivial carrier group was superseded by the invertibility-carrier `picCommGroup` / `thm:pic_commgroup` in iter-238. The blueprint correctly has no `\leanok` on this block. The `thm:rel_pic_addcommgroup_via_tensorobj`'s `\uses` references it with a `% NOTE (carrier pivot, deferred)` comment acknowledging the staleness.

No action needed this iter (pre-existing known situation explicitly deferred in blueprint comments).

---

## Severity summary

| Finding | Severity |
|---|---|
| `presheafPushforwardLaxMonoidal` / `presheafPullbackOplaxMonoidal` have no `\lean{...}` pin | **major** |
| `lem:pullback_tensor_iso` proof sketch stale re: "no `pushforward.LaxMonoidal`" | **major** |
| `lem:tensorobj_unit_iso` statement block missing `\leanok` (sync_leanok gap) | minor |
| `lem:tensorobj_isoclass_commgroup` pins deleted declaration (known, deferred) | minor |

**Overall verdict**: The Lean file is in good shape relative to the blueprint for all implemented declarations — signatures match, proofs follow sketches, and all sorries are correctly described as infrastructure-blocked pre-existing placeholders. Two major blueprint-side issues require action: (1) the two new presheaf-level lax/oplax monoidal instances need `\lean{...}` pins added, and (2) the proof sketch for `lem:pullback_tensor_iso` should be updated to reflect that `pushforward.LaxMonoidal` is now available at the presheaf level while the true obstacle is the concrete inverse-image model.
