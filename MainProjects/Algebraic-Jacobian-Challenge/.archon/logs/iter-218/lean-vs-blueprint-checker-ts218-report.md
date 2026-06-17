# Lean ↔ Blueprint Check Report

## Slug
ts218

## Iteration
218

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (1449 lines)
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (2309 lines)

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (def:scheme_modules_tensorobj)
- **Lean target exists**: yes (line 991)
- **Signature matches**: yes — `{X : Scheme.{u}} (M N : X.Modules) : X.Modules`; blueprint says "M, N ∈ Scheme.Modules X → M ⊗_X N ∈ Scheme.Modules X"
- **Proof follows sketch**: yes — sheafification of `PresheafOfModules.Monoidal.tensorObj`, exactly as described; no sorry
- **notes**: `\leanok` present on statement; body is substantive and axiom-clean

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` (lem:scheme_modules_tensorobj_functoriality)
- **Lean target exists**: yes (line 1006)
- **Signature matches**: yes — `{M M' N N' : X.Modules} (f : M ⟶ M') (g : N ⟶ N') : tensorObj M N ⟶ tensorObj M' N'`
- **Proof follows sketch**: yes — inherits from `PresheafOfModules.Monoidal.tensorObj` under sheafification; no sorry
- **notes**: `\leanok` present; body substantive

### `\lean{PresheafOfModules.restrictScalarsLaxMonoidal}` (lem:restrictscalars_laxmonoidal)
- **Lean target exists**: yes (line 336), with helpers `restrictScalarsLaxε` (line 303), `restrictScalarsLaxμ` (line 319)
- **Signature matches**: yes — `(α : R ⋙ forget₂ CommRingCat RingCat ⟶ S ⋙ forget₂ CommRingCat RingCat) : (PresheafOfModules.restrictScalars α).LaxMonoidal`; blueprint says "the presheaf-of-modules restriction-of-scalars functor is lax monoidal"
- **Proof follows sketch**: yes — sectionwise lift of `ModuleCat.instLaxMonoidalRestrictScalars`, six coherence fields each delegated sectionwise; no sorry
- **notes**: `\leanok` present; blueprint correctly marks this off the critical path

### `\lean{restrictScalarsRingIsoTensorEquiv}` (lem:restrictscalars_ringiso_tensorequiv)
- **Lean target exists**: yes (line 115)
- **Signature matches**: yes — `(e : R ≃+* S) (A B : Type u) [AddCommGroup A] [Module S A] [AddCommGroup B] [Module S B] : TensorProduct R A B ≃ₗ[R] TensorProduct S A B`; blueprint says "the canonical map a ⊗_R b ↦ a ⊗_S b is an R-linear equivalence"
- **Proof follows sketch**: yes — explicitly constructs forward and backward linear maps and verifies two-sided inverse; no sorry
- **notes**: `\leanok` present; helper simp lemma `restrictScalarsRingIsoTensorEquiv_apply_tmul` (line 197) is unlisted in blueprint (fine, it's a simp helper)

### `\lean{restrictScalars_isIso_μ, restrictScalars_isIso_ε, restrictScalarsMonoidalOfRingEquiv, restrictScalars_isIso_μ_of_bijective, restrictScalars_isIso_ε_of_bijective}` (lem:restrictscalars_ringiso_strongmonoidal)
- **Lean target exists**: yes — all 5 at lines 219, 237, 252, 266, 275
- **Signature matches**: yes for all 5; blueprint precisely describes each (isIso of lax tensorator, isIso of lax unit, packaged Monoidal, bijective forms)
- **Proof follows sketch**: yes for all 5; no sorry in any body
- **notes**: Blueprint block **missing `\leanok`** on statement — all 5 declarations are sorry-free in Lean but `\leanok` absent from blueprint. Minor sync issue (sync_leanok should add it on next run).

### `\lean{PresheafOfModules.pushforwardNatTrans, PresheafOfModules.pushforwardCongr, PresheafOfModules.pushforwardPushforwardAdj, PresheafOfModules.isIso_of_isIso_app, PresheafOfModules.restrictScalarsMonoidalOfBijective}` (lem:presheaf_pushforward_adj_substrate)
- **Lean target exists**: yes — all 5 at lines 840, 871, 908, 940, 958
- **Signature matches**: yes for all 5; blueprint precisely describes the H1 pushforward adjunction and H2 strong-monoidal restriction
- **Proof follows sketch**: yes for all 5; no sorry in any body
- **notes**: Blueprint block **missing `\leanok`** on statement — newly pinned this iter, sync_leanok not yet run. Also missing `\leanok` on proof. Minor sync issue; all 5 declarations are sorry-free. Helper lemmas `pushforwardNatTrans_app_app_apply`, `pushforwardCongr_hom_app_app`, `pushforwardCongr_inv_app_app` are unlisted (fine, they're simp helpers).

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso}` (lem:tensorobj_restrict_iso)
- **Lean target exists**: yes (line 1257)
- **Signature matches**: yes — `{X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f] (M N : X.Modules) : (tensorObj M N).restrict f ≅ tensorObj (M.restrict f) (N.restrict f)`; blueprint says "the canonical comparison (M ⊗_X N)|_f → M|_f ⊗_U N|_f is an isomorphism"
- **Proof follows sketch**: yes — four-step composite (restrictFunctorIsoPullback → sheafificationCompPullback → mapIso → H1∘H2 closure); body is sorry-free and axiom-clean (iter-217); no sorry
- **notes**: `\leanok` present on statement; helper `restrictIsoUnitOfLE` (line 1205) correctly unreferenced (private helper); proof matches blueprint's H1/H2 description precisely

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_isLocallyTrivial}` (lem:tensorobj_preserves_locally_trivial)
- **Lean target exists**: yes (line 1347)
- **Signature matches**: yes — `(hM : LineBundle.IsLocallyTrivial M) (hN : LineBundle.IsLocallyTrivial N) : LineBundle.IsLocallyTrivial (tensorObj M N)`
- **Proof follows sketch**: yes — pick common cover, refine trivialisations via `restrictIsoUnitOfLE`, chain `tensorObj_restrict_iso ≪≫ tensorObjIsoOfIso ≪≫ tensorObj_unit_iso`; no sorry
- **notes**: `\leanok` present; uses `tensorObj_restrict_iso` correctly

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso}` (lem:tensorobj_assoc_iso)
- **Lean target exists**: yes (line 1150)
- **Signature matches**: yes — `(hM : LineBundle.IsLocallyTrivial M) (hN : ...) (hP : ...) : tensorObj (tensorObj M N) P ≅ tensorObj M (tensorObj N P)`
- **Proof follows sketch**: **no — PROOF DIVERGES FROM BLUEPRINT**. Blueprint (lines 1427–1493) says the associator is built "by gluing canonical local isomorphisms through `tensorObj_restrict_iso`, with **no recourse to any whiskering or stalk apparatus**." The Lean proof (lines 1165–1193) instead uses `W_whiskerRight_of_W` and `W_whiskerLeft_of_W` (whiskering apparatus) together with `isIso_sheafification_map_of_W`. These whiskering lemmas call `isLocallyInjective_whiskerLeft_of_W` (line 600), which has a `sorry` body. Consequently, `tensorObj_assoc_iso` **transitively depends on a sorry** — it is NOT sorry-free despite having no literal `sorry` keyword in its own body.
- **notes**: `\leanok` on statement only (correctly indicates proof not closed). Blueprint proof prose is wrong about the mathematical route used. The sorry-free alternative (`tensorObj_restrict_iso`-based gluing as the blueprint describes) is available since `tensorObj_restrict_iso` is axiom-clean — the proof just needs to be rewritten along the blueprint route. The `IsLocallyTrivial` hypotheses are vestigial in both routes.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_left_unitor, AlgebraicGeometry.Scheme.Modules.tensorObj_right_unitor}` (lem:tensorobj_unit_iso)
- **Lean target exists**: yes — both at lines 1080, 1090
- **Signature matches**: yes — `tensorObj (SheafOfModules.unit X.ringCatSheaf) M ≅ M` and `tensorObj M (SheafOfModules.unit X.ringCatSheaf) ≅ M`; blueprint says "O_X ⊗_X M ≅ M" and "M ⊗_X O_X ≅ M"
- **Proof follows sketch**: yes — cheap `mapIso` pattern on presheaf unitors composed with sheafification counit; no sorry
- **notes**: Blueprint block **missing `\leanok`** on statement. Both declarations are sorry-free in Lean. Helper `tensorObj_unit_iso` (line 1067, the O_X ⊗ O_X ≅ O_X isomorphism) is an internal helper not blueprint-pinned — correctly so, it's consumed by `tensorObj_isLocallyTrivial`.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_braiding}` (lem:tensorobj_comm_iso)
- **Lean target exists**: yes (line 1100)
- **Signature matches**: yes — `tensorObj M N ≅ tensorObj N M`
- **Proof follows sketch**: yes — cheap `mapIso` of presheaf braiding; no sorry
- **notes**: `\leanok` present; clean

### `\lean{AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse}` (lem:tensorobj_inverse_invertible)
- **Lean target exists**: yes (line 1390)
- **Signature matches**: yes — `(hL : LineBundle.IsLocallyTrivial L) : ∃ Linv : X.Modules, LineBundle.IsLocallyTrivial Linv ∧ Nonempty (tensorObj L Linv ≅ SheafOfModules.unit X.ringCatSheaf)`
- **Proof follows sketch**: **not applicable / BLUEPRINT ADEQUACY FAILURE** — see red flags section
- **notes**: `\leanok` on statement only (correctly indicates `sorry` body exists). Lean body is `sorry` with explicit "iter-218 INCOMPLETE gate (INFRASTRUCTURE MISSING)" docstring (lines 1373–1388).

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible}` (def:scheme_modules_isinvertible)
- **Lean target exists**: yes (line 1019)
- **Signature matches**: yes — `∃ N : X.Modules, Nonempty (tensorObj M N ≅ SheafOfModules.unit X.ringCatSheaf)`
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` present; clean

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjIsoclassCommMonoid}` (lem:tensorobj_isoclass_commgroup)
- **Lean target exists**: **no** — declaration not present in the Lean file (1449 lines total)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint correctly has no `\leanok`; the `\lean{}` pin names the intended declaration. Not yet formalized — expected, no error.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjOnProduct}` (lem:tensorobj_lift_onproduct)
- **Lean target exists**: yes (line 1407)
- **Signature matches**: yes — takes two `LineBundle.OnProduct πC πT` elements, returns one; body calls `tensorObj_isLocallyTrivial`; no sorry
- **Proof follows sketch**: yes
- **notes**: `\leanok` present on statement

### `\lean{AlgebraicGeometry.LineBundle.OnProduct.pullback_tensorObj_iso}` (lem:pullback_compatible_with_tensorobj)
- **Lean target exists**: **no** — declaration not present in the Lean file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint correctly has no `\leanok`; the `\lean{}` pin names the intended declaration. Not yet formalized — expected, no error.

### `\lean{AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj}` (thm:rel_pic_addcommgroup_via_tensorobj)
- **Lean target exists**: yes (line 1440)
- **Signature matches**: yes — `AddCommGroup (Quotient (RelPicPresheaf.preimage_subgroup πC πT))`
- **Proof follows sketch**: not applicable — body is `sorry`
- **notes**: `\leanok` on statement only (correctly indicates sorry body). No `\leanok` on proof. The `@[implicit_reducible]` attribute is correctly retained per the iter-218 note in the Lean docstring.

---

## Superseded declarations check

The blueprint marks 6 lemma blocks as `% SUPERSEDED route ... Lean declaration removed in iter-218`:
- `lem:flat_whisker_localizer` — no `\lean{}` pin ✅
- `lem:isiso_sheafification_map_of_W` — has `\leanok` but **no** `\lean{}` pin ✅
- `lem:stalk_linear_map` — no `\lean{}` pin ✅
- `lem:islocallyinjective_whisker_of_W` — has `\leanok` but **no** `\lean{}` pin ✅
- `lem:whisker_of_W` — no `\lean{}` pin ✅
- `lem:jw_ismonoidal` — no `\lean{}` pin ✅

**No dangling `\lean{}` pins on superseded blocks.** This part of the directive check passes.

However, **the "removed in iter-218" claim is inaccurate**: the corresponding Lean declarations are still present in the file:
- `isLocallyInjective_whiskerLeft_of_W` (line 600) — **sorry body** — still in file
- `W_whiskerLeft_of_W` (line 640), `W_whiskerRight_of_W` (line 651) — still in file and **actively called by `tensorObj_assoc_iso`**
- `isIso_sheafification_map_of_W` (line 677) — still in file and called by `tensorObj_assoc_iso`
- `stalkLinearMap` (line 724), `stalkLinearMap_germ` (line 765), `stalkLinearMap_bijective_of_isIso` (line 786), `stalkLinearEquivOfIsIso` (line 799) — still in file
- Flat-whiskering helpers: `isLocallySurjective_whiskerLeft`, `isLocallyInjective_whiskerLeft_of_flat`, `W_whiskerLeft_of_flat`, `W_whiskerRight_of_flat` — still in file

---

## Red flags

### Placeholder / suspect bodies

- `AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse` at line 1390: body is `:= sorry`. Blueprint `lem:tensorobj_inverse_invertible` has `\leanok` on statement only (correct), but the PROOF PROSE (lines 1606–1659) describes the full construction as executable — it sets `L^{-1} := ℋom_{𝒪_X}(L, 𝒪_X)`, claims Step 1 constructs the dual via internal-hom commuting with restriction, then Step 2–3 build the evaluation. **All three steps are blocked at Step 1**: there is no `MonoidalClosed (PresheafOfModules R)`, no `MonoidalClosed (SheafOfModules R)`, no object-level descent for `SheafOfModules` at `b80f227`. The Lean docstring (lines 1373–1388) explicitly labels this "INCOMPLETE gate (INFRASTRUCTURE MISSING)" and explains the precise missing primitive — but the blueprint proof prose says nothing about this gap.

- `AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj` at line 1440: body is `:= sorry`. Blueprint statement has `\leanok` (correct), proof has no `\leanok` (correct). This sorry is downstream of `exists_tensorObj_inverse` being sorry; status is consistent.

### Transitive sorry dependency (proof-approach divergence)

- `AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso` at line 1150: The Lean body has no literal `sorry`, but calls `W_whiskerRight_of_W` (line 1181) and `W_whiskerLeft_of_W` (line 1184), which call `isLocallyInjective_whiskerLeft_of_W` (line 648 → line 600), whose body is `sorry`. Therefore `tensorObj_assoc_iso` is NOT axiom-clean — it transitively depends on a sorry through the whiskering chain. The blueprint proof prose at lines 1425–1493 says the associator is built "by gluing canonical local isomorphisms through `lem:tensorobj_restrict_iso`, with no recourse to any whiskering or stalk apparatus." This description does NOT match the Lean proof.

### Sorry-laden declarations still in use

- `PresheafOfModules.isLocallyInjective_whiskerLeft_of_W` (line 600): body is `sorry`. Blueprint marks this SUPERSEDED and says "Lean declaration removed in iter-218." It was NOT removed and is actively called by `tensorObj_assoc_iso` (via `W_whiskerLeft/Right_of_W`).

---

## Unreferenced declarations (informational)

The following declarations exist in the Lean file but have no `\lean{}` blueprint reference. Most are helpers:

| Declaration | Line | Status |
|---|---|---|
| `restrictScalarsRingIsoTensorEquiv_apply_tmul` | 197 | `@[simp]` helper for `restrictScalarsRingIsoTensorEquiv`; appropriate |
| `restrictScalarsLaxε` | 303 | Helper for `restrictScalarsLaxMonoidal`; appropriate |
| `restrictScalarsLaxμ` | 319 | Helper for `restrictScalarsLaxMonoidal`; appropriate |
| `toPresheaf_whiskerLeft_app_tmul` | 390 | Helper for flat-whiskering; superseded context |
| `toPresheaf_whiskerLeft_app_apply` | 400 | Helper for flat-whiskering; superseded context |
| `isLocallySurjective_whiskerLeft` | 411 | `lem:flat_whisker_localizer` (superseded, no pin) |
| `isLocallyInjective_whiskerLeft_of_flat` | 444 | `lem:flat_whisker_localizer` (superseded, no pin) |
| `W_whiskerLeft_of_flat` | 521 | `lem:flat_whisker_localizer` (superseded, no pin) |
| `W_whiskerRight_of_flat` | 537 | `lem:flat_whisker_localizer` (superseded, no pin) |
| `isLocallyInjective_whiskerLeft_of_W` | 600 | `lem:islocallyinjective_whisker_of_W` (superseded, **sorry body**, still called) |
| `W_whiskerLeft_of_W` | 640 | `lem:whisker_of_W` (superseded, still called by `tensorObj_assoc_iso`) |
| `W_whiskerRight_of_W` | 651 | `lem:whisker_of_W` (superseded, still called by `tensorObj_assoc_iso`) |
| `isIso_sheafification_map_of_W` | 677 | `lem:isiso_sheafification_map_of_W` (superseded, still called by `tensorObj_assoc_iso`) |
| `stalkLinearMap` | 724 | `lem:stalk_linear_map` (superseded, no pin) |
| `stalkLinearMap_germ` | 765 | `lem:stalk_linear_map` (superseded, no pin) |
| `stalkLinearMap_bijective_of_isIso` | 786 | `lem:stalk_linear_map` (superseded, no pin) |
| `stalkLinearEquivOfIsIso` | 799 | `lem:stalk_linear_map` (superseded, no pin) |
| `pushforwardNatTrans_app_app_apply` | 854 | `@[simp]` helper; appropriate |
| `pushforwardCongr_hom_app_app` | 879 | `@[simp]` helper; appropriate |
| `pushforwardCongr_inv_app_app` | 883 | `@[simp]` helper; appropriate |
| `tensorObjIsoOfIso` | 1051 | Internal helper for `tensorObj_isLocallyTrivial`; appropriate |
| `tensorObj_unit_iso` | 1067 | Internal helper (O_X ⊗ O_X ≅ O_X); called by `tensorObj_isLocallyTrivial` |
| `restrictIsoUnitOfLE` | 1205 | Internal helper for `tensorObj_isLocallyTrivial`; appropriate |

---

## Blueprint adequacy for this file

- **Coverage**: 14 pinned `\lean{}` blocks (some multi-declaration), covering all substantive Lean declarations except the superseded route. 2 pinned declarations (`tensorObjIsoclassCommMonoid`, `pullback_tensorObj_iso`) are not yet in the Lean file — blueprint correctly shows no `\leanok` for them. Superseded declarations correctly unpinned. Coverage is adequate for the formalized portion.

- **Proof-sketch depth**: **under-specified** for one critical lemma; adequate for the rest.
  - `lem:tensorobj_inverse_invertible` (lines 1606–1659): The proof prose sets `L^{-1} := ℋom_{𝒪_X}(L, 𝒪_X)` and describes three constructive steps, none of which acknowledges that the internal-hom/dual object does not exist in Mathlib at the pinned commit. A prover following this sketch cannot formalize the lemma. The sketch needs a "BLOCKED" note cross-referencing the INCOMPLETE gate analysis in the Lean docstring.
  - `lem:tensorobj_assoc_iso` (lines 1425–1493): Blueprint describes gluing via `tensorObj_restrict_iso` with "no whiskering." This is the mathematically-correct route and the blueprint is adequate for the intended approach. However, the CURRENT Lean proof uses a different (whiskering) approach, so the blueprint and Lean are out of sync on the proof route.

- **Hint precision**: **precise** for all pinned declarations. All `\lean{}` names match the actual Lean declaration names, and the prose descriptions match the signatures.

- **Generality**: matches need — no narrowness or broadness issues found.

- **Recommended chapter-side actions**:
  1. **[MUST-FIX]** Annotate the proof of `lem:tensorobj_inverse_invertible` (lines 1606–1659) with an explicit note that Step 1 (constructing `L^{-1} := ℋom_{𝒪_X}(L, 𝒪_X)`) is blocked by missing Mathlib infrastructure (no `MonoidalClosed (PresheafOfModules R)` / `SheafOfModules`, no object-level descent), cite the INCOMPLETE gate in the Lean docstring, and change the proof prose from present-constructive to "this is the mathematical route; the Lean body is `sorry` pending `informal/exists_tensorObj_inverse.md`."
  2. **[MAJOR]** Annotate `lem:tensorobj_assoc_iso`'s proof with a note that the **current Lean implementation** uses the whiskering route (Route D via `W_whiskerLeft/Right_of_W`), NOT the gluing route described in the blueprint, and that this results in a transitive sorry dependency. The blueprint proof as written describes what the proof SHOULD do once rewritten to follow the sorry-free gluing route via `tensorObj_restrict_iso`.
  3. **[MINOR]** Retract the "Lean declaration removed in iter-218" wording from the superseded `% SUPERSEDED` block comments, since the declarations remain and `tensorObj_assoc_iso` still depends on them.
  4. **[MINOR — sync]** Add `\leanok` to `lem:restrictscalars_ringiso_strongmonoidal`, `lem:presheaf_pushforward_adj_substrate`, and `lem:tensorobj_unit_iso` statement blocks (all sorry-free in Lean; will be auto-added by next sync_leanok run).

---

## Severity summary

### must-fix-this-iter

1. **Blueprint adequacy failure — `lem:tensorobj_inverse_invertible` proof assumes absent primitive.** The proof prose (lines 1606–1659) describes construction of `L^{-1} := ℋom_{𝒪_X}(L, 𝒪_X)` and the evaluation morphism as if these are constructible. Both are Mathlib-absent at `b80f227` (no `MonoidalClosed` on `PresheafOfModules`/`SheafOfModules`, no object-level descent for `SheafOfModules`). The Lean body is correctly `sorry` with an explicit "INFRASTRUCTURE MISSING" explanation, but the blueprint prose is silent on this gap — a prover following it would be misled into an impossible construction. The blueprint proof must be updated to flag the block as infrastructure-blocked.

### major

2. **`tensorObj_assoc_iso` proof diverges from blueprint sketch with transitive sorry.** Blueprint says the associator uses gluing via `tensorObj_restrict_iso` (no whiskering). The Lean proof (lines 1165–1193) uses `W_whiskerRight_of_W` / `W_whiskerLeft_of_W` → `isLocallyInjective_whiskerLeft_of_W` (sorry body). The sorry-free gluing route (as the blueprint describes) is available since `tensorObj_restrict_iso` is axiom-clean (iter-217). Actionable: rewrite `tensorObj_assoc_iso`'s proof to use the gluing approach, removing the transitive sorry dependency.

3. **Superseded declarations not removed despite blueprint claim.** Blueprint `% SUPERSEDED` comments say "Lean declaration removed in iter-218" but `isLocallyInjective_whiskerLeft_of_W` (sorry), `W_whiskerLeft_of_W`, `W_whiskerRight_of_W`, `isIso_sheafification_map_of_W`, and stalk-linear-map declarations remain in the Lean file. The first three are actively called by `tensorObj_assoc_iso`, blocking the cleanup. Blueprint wording is inaccurate.

### minor

4. **`lem:presheaf_pushforward_adj_substrate`** statement/proof missing `\leanok` (5 newly-pinned, sorry-free declarations — sync_leanok will add on next run).
5. **`lem:tensorobj_unit_iso`** missing `\leanok` on statement (`tensorObj_left_unitor`, `tensorObj_right_unitor` are sorry-free — sync_leanok will add).
6. **`lem:restrictscalars_ringiso_strongmonoidal`** missing `\leanok` on statement (all 5 declarations sorry-free — sync_leanok will add).

---

**Overall verdict**: The chapter is structurally sound for 10 of 14 pinned declaration groups (signatures correct, proofs follow or correctly represent sorry status); two must-fix issues require immediate attention — the blueprint proof for `lem:tensorobj_inverse_invertible` assumes Mathlib-absent infrastructure without acknowledging the gap, and `tensorObj_assoc_iso`'s Lean proof uses a sorry-dependent whiskering route instead of the sorry-free gluing route the blueprint describes. — **12 declaration groups checked, 2 must-fix, 3 major, 3 minor.**
