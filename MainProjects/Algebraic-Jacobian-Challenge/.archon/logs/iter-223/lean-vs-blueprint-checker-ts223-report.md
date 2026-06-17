# Lean ↔ Blueprint Check Report

## Slug
ts223

## Iteration
223

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (1981 lines)
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (2813 lines)

---

## Focused check: `internalHomEval` (`lem:internal_hom_eval`)

**Question 1 — Blueprint does NOT overclaim?**

The blueprint statement block at line 2610 carries `\leanok` (declaration exists) — correct, because `noncomputable def internalHomEval` exists at Lean line 1463 with a sorry in the `naturality` field. The blueprint proof block does NOT carry `\leanok` — correct, because that sorry is open. A `% NOTE:` at lines 2614–2619 explicitly acknowledges the split:

> "The per-open building block is already built as the declaration `PresheafOfModules.internalHomEvalApp`… The remaining obligation for the full morphism `internalHomEval` is exactly the naturality/assembly step over the restriction maps."

This constitutes the required per-object / assembly split acknowledgment. ✓

The blueprint prose in the proof block (lines 2652–2673) describes the full intended mathematical argument (evaluate-restrict commutation identity = naturality square), and does NOT claim the proof is closed. The 6-step worked reduction recorded verbatim in the Lean sorry-comment (lines 1484–1497) matches the blueprint's prose description. ✓

**Question 2 — `\lean{...}` pin names the actually-built declaration?**

`\lean{PresheafOfModules.internalHomEval}` at blueprint line 2613 resolves to the Lean declaration at line 1463. ✓

The per-object building block `PresheafOfModules.internalHomEvalApp` (axiom-clean, line 1408) is mentioned only in prose inside the `% NOTE:` — it has no dedicated `\lean{...}` block. See Major finding #4 below.

**Question 3 — Statement faithful?**

Blueprint: `ev_M : M ⊗_R M^∨ → R`, `s ⊗ φ ↦ φ(s)`.

Lean:
```lean
noncomputable def internalHomEval
    (M : PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)) :
    PresheafOfModules.Monoidal.tensorObj M (dual M) ⟶
      𝟙_ (PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat))
```

`dual M = internalHom M (𝟙_)` matches `M^∨ = ℋom(M, R)` (the `𝟙_` IS the structure presheaf R in the presheaf monoidal category). Statement is faithful. ✓

**Minor wording note:** The `% NOTE:` says `internalHomEval` is "the correct future target name" — but the declaration already exists. Wording implies aspirational; should read "is the correct target name." MINOR.

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (chapter: `def:scheme_modules_tensorobj`)
- **Lean target exists**: yes — `noncomputable def tensorObj`, line 1522
- **Signature matches**: yes — `M N : X.Modules → X.Modules` via `sheafification.obj (tensorObj M.val N.val)`
- **Proof follows sketch**: yes — sheafification of presheaf tensor, as described
- **notes**: both `\leanok` markers (statement + proof) present and correct; axiom-clean

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` (`lem:scheme_modules_tensorobj_functoriality`)
- **Lean target exists**: yes — `noncomputable def tensorObj_functoriality`, line 1537
- **Signature matches**: yes — `(f : M ⟶ M') (g : N ⟶ N') → tensorObj M N ⟶ tensorObj M' N'`
- **Proof follows sketch**: yes — inherits from presheaf tensorHom under sheafification
- **notes**: both `\leanok` present; axiom-clean

### `\lean{PresheafOfModules.restrictScalarsLaxMonoidal}` (`lem:restrictscalars_laxmonoidal`)
- **Lean target exists**: yes — `noncomputable instance restrictScalarsLaxMonoidal`, line 348
- **Signature matches**: yes — `(restrictScalars α).LaxMonoidal` for CommRingCat α
- **Proof follows sketch**: yes — sectionwise from `ModuleCat.instLaxMonoidalRestrictScalars`
- **notes**: both `\leanok` present; axiom-clean; helpers `restrictScalarsLaxε`, `restrictScalarsLaxμ` present but not separately pinned (acceptable as helpers)

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso}` (`lem:tensorobj_restrict_iso`)
- **Lean target exists**: yes — `noncomputable def tensorObj_restrict_iso`, line 1788
- **Signature matches**: yes — `(tensorObj M N).restrict f ≅ tensorObj (M.restrict f) (N.restrict f)` for open immersion `f`
- **Proof follows sketch**: yes — 4-step blueprint proof exactly realized: Step 1 `restrictFunctorIsoPullback`, Step 2 `sheafificationCompPullback`, Step 3 presheaf-level reduction, Step 4 H1 (pushforwardPushforwardAdj via leftAdjointUniq) ∘ H2 (restrictScalarsMonoidalOfBijective)
- **notes**: both `\leanok` present; axiom-clean (iter-217 linchpin closure)

### `\lean{PresheafOfModules.pushforwardNatTrans, pushforwardCongr, pushforwardPushforwardAdj, isIso_of_isIso_app, restrictScalarsMonoidalOfBijective}` (`lem:presheaf_pushforward_adj_substrate`)
- **Lean targets exist**: all 5 — lines 852, 883, 920, 952, 970
- **Signatures match**: yes — all 5 are correct presheaf-level declarations matching the blueprint descriptions
- **Proof follows sketch**: yes — `pushforwardPushforwardAdj` de-sheafifies the sheaf-level adjunction; `restrictScalarsMonoidalOfBijective` uses `restrictScalars_isIso_μ_of_bijective` and `isIso_of_isIso_app`
- **notes**: **MAJOR** — NO `\leanok` in the statement block despite all 5 declarations being axiom-clean. This appears to be a `sync_leanok` gap with multi-declaration `\lean{...}` blocks. The proof block also lacks `\leanok`. See Major finding #1.

### `\lean{restrictScalarsRingIsoTensorEquiv}` (`lem:restrictscalars_ringiso_tensorequiv`)
- **Lean target exists**: yes — `noncomputable def restrictScalarsRingIsoTensorEquiv`, line 127 (global namespace)
- **Signature matches**: yes — `TensorProduct R A B ≃ₗ[R] TensorProduct S A B` for ring iso `e : R ≃+* S`
- **Proof follows sketch**: yes — forward via `TensorProduct.lift`, inverse via additive lift then verified `R`-linear; both inverses checked
- **notes**: both `\leanok` present; axiom-clean. Blueprint correctly notes the inverse is only additive (not S-linear)

### `\lean{restrictScalars_isIso_μ, restrictScalars_isIso_ε, restrictScalarsMonoidalOfRingEquiv, restrictScalars_isIso_μ_of_bijective, restrictScalars_isIso_ε_of_bijective}` (`lem:restrictscalars_ringiso_strongmonoidal`)
- **Lean targets exist**: all 5 — lines 231, 249, 264, 278, 287
- **Signatures match**: yes — match blueprint's three items and bijective variants
- **Proof follows sketch**: yes — (1) use `restrictScalarsRingIsoTensorEquiv`; (2) `ModuleCat.restrictScalars_η`; (3) `Functor.Monoidal.ofLaxMonoidal`; bijective forms reduce to ring-equivalence via `RingEquiv.ofBijective`
- **notes**: **MAJOR** — NO `\leanok` in statement or proof block despite all 5 being axiom-clean. See Major finding #2.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_isLocallyTrivial}` (`lem:tensorobj_preserves_locally_trivial`)
- **Lean target exists**: yes — `lemma tensorObj_isLocallyTrivial`, line 1878
- **Signature matches**: yes — `IsLocallyTrivial M → IsLocallyTrivial N → IsLocallyTrivial (tensorObj M N)`
- **Proof follows sketch**: yes — common affine open, refine via `restrictIsoUnitOfLE`, transport through `tensorObj_restrict_iso` + `tensorObjIsoOfIso` + `tensorObj_unit_iso`
- **notes**: both `\leanok` present; axiom-clean

### `\lean{PresheafOfModules.isIso_sheafification_map_of_W}` (`lem:isiso_sheafification_map_of_W`)
- **Lean target exists**: yes — `lemma isIso_sheafification_map_of_W`, line 689
- **Signature matches**: yes — `J.W (toPresheaf.map f) → IsIso (sheafification α |>.map f)`
- **Proof follows sketch**: yes — one-morphism reading of `inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms`
- **notes**: both `\leanok` present (in superseded route section); axiom-clean

### `lem:islocallyinjective_whisker_of_W` (superseded route section)
- **Lean target exists**: yes — `lemma isLocallyInjective_whiskerLeft_of_W`, line 612; body is `:= by sorry`
- **Signature matches**: yes — `J.W (toPresheaf.map g) → IsLocallyInjective J (F ◁ g)`
- **Proof follows sketch**: N/A — proof has a typed sorry (mathlib-absent ingredients d.1-bridge and d.2)
- **notes**: statement `\leanok` present (correct per convention: declaration exists); proof block lacks `\leanok` (correct). The extensive sorry-comment at lines 619–644 accurately documents the residual (d.1-bridge: J.W ↔ stalkwise-iso on Opens X; d.2: stalk ⊗ commutation over varying ring).

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso}` (`lem:tensorobj_assoc_iso`)
- **Lean target exists**: yes — `noncomputable def tensorObj_assoc_iso`, line 1681
- **Signature matches**: yes — `(tensorObj (tensorObj M N) P ≅ tensorObj M (tensorObj N P))` under `IsLocallyTrivial` hypotheses
- **Proof follows sketch**: partial — current Lean proof uses route-(d) whiskering composite (as documented in blueprint's "Status: route mismatch, deferred" note), NOT the direct-gluing route described as the intended target
- **notes**: statement `\leanok` present (correct); proof `\leanok` absent (correct — transitively sorry via `isLocallyInjective_whiskerLeft_of_W`). Blueprint proof section explicitly documents this mismatch.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_left_unitor, AlgebraicGeometry.Scheme.Modules.tensorObj_right_unitor}` (`lem:tensorobj_unit_iso`)
- **Lean targets exist**: both — lines 1611 and 1621
- **Signatures match**: yes — `𝒪_X ⊗ M ≅ M` and `M ⊗ 𝒪_X ≅ M` respectively, via `mapIso` of presheaf unitors composed with sheafification counit
- **Proof follows sketch**: yes — cheap `mapIso` pattern as described
- **notes**: **MAJOR** — NO `\leanok` in statement block despite both declarations being axiom-clean. There is also an unpinned helper `tensorObj_unit_iso` (line 1598, `𝒪_X ⊗ 𝒪_X ≅ 𝒪_X`) that is confusingly named relative to the blueprint lemma label. See Major finding #3.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_braiding}` (`lem:tensorobj_comm_iso`)
- **Lean target exists**: yes — `noncomputable def tensorObj_braiding`, line 1631
- **Signature matches**: yes — `tensorObj M N ≅ tensorObj N M` via braiding of presheaf monoidal category
- **Proof follows sketch**: yes — cheap `mapIso` pattern
- **notes**: both `\leanok` present; axiom-clean

### `\lean{AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse}` (`lem:tensorobj_inverse_invertible`)
- **Lean target exists**: yes — `lemma exists_tensorObj_inverse`, line 1921; body is `:= sorry`
- **Signature matches**: yes — `IsLocallyTrivial L → ∃ Linv, IsLocallyTrivial Linv ∧ Nonempty (tensorObj L Linv ≅ 𝒪_X)`
- **Proof follows sketch**: N/A — proof is a typed sorry; blueprint proof says "Infrastructure-blocked"
- **notes**: statement `\leanok` present (correct); proof `\leanok` absent (correct). Blueprint's "Infrastructure-blocked" note accurately records that `Linv := ℋom(L,𝒪_X)` cannot be named without a sheaf-level dual. No excuse-comment.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjOnProduct}` (`lem:tensorobj_lift_onproduct`)
- **Lean target exists**: yes — `noncomputable def tensorObjOnProduct`, line 1938
- **Signature matches**: yes — takes two `LineBundle.OnProduct πC πT` values and returns their tensor as another
- **Proof follows sketch**: yes — applies `tensorObj_isLocallyTrivial`
- **notes**: both `\leanok` present; axiom-clean

### `\lean{AlgebraicGeometry.LineBundle.OnProduct.pullback_tensorObj_iso}` (`lem:pullback_compatible_with_tensorobj`)
- **Lean target exists**: NO — not in this Lean file; may be in `LineBundlePullback.lean` or unformalized
- **Signature matches**: N/A
- **notes**: no `\leanok` on the blueprint block (aspirational pin). Not a red flag.

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible}` (`def:scheme_modules_isinvertible`)
- **Lean target exists**: yes — `def IsInvertible`, line 1550
- **Signature matches**: yes — `∃ N, Nonempty (tensorObj M N ≅ SheafOfModules.unit X.ringCatSheaf)`
- **Proof follows sketch**: N/A (definition)
- **notes**: both `\leanok` present; no sorry (Prop definition)

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjIsoclassCommMonoid}` (`lem:tensorobj_isoclass_commgroup`)
- **Lean target exists**: NO — not in the Lean file; appears only in comments/docstrings
- **Signature matches**: N/A
- **notes**: no `\leanok` on the blueprint block (aspirational pin). Not a red flag — blueprint correctly does not claim this is formalized.

### `\lean{AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj}` (`thm:rel_pic_addcommgroup_via_tensorobj`)
- **Lean target exists**: yes — `noncomputable def addCommGroup_via_tensorObj`, line 1971; body is `:= sorry`
- **Signature matches**: yes — `AddCommGroup (Quotient (RelPicPresheaf.preimage_subgroup πC πT))`
- **Proof follows sketch**: N/A — body is typed sorry (consumer sorry; blocked on `exists_tensorObj_inverse` and `tensorObjIsoclassCommMonoid`)
- **notes**: statement `\leanok` present (correct per convention); proof `\leanok` absent (correct)

### `\lean{PresheafOfModules.InternalHom.homModule}` (`def:presheaf_internal_hom_value`)
- **Lean target exists**: yes — `noncomputable def homModule`, line 1094
- **Signature matches**: yes — `Module (R.obj (op T)) (M ⟶ N)` with `f • φ := φ ≫ globalSMul hT N f`
- **Proof follows sketch**: yes — action axioms reduce to `globalSMul_{one,zero,add,mul}` and bilinearity of composition
- **notes**: both `\leanok` present; axiom-clean

### `\lean{PresheafOfModules.InternalHom.internalHomObjModule}` (`def:presheaf_internal_hom_slice_value`)
- **Lean target exists**: yes — `noncomputable def internalHomObjModule`, line 1136
- **Signature matches**: yes — `Module (R.obj (op U)) (restr U M ⟶ restr U N)` via `Over.mkIdTerminal`
- **Proof follows sketch**: yes — direct application of `homModule` to the slice category
- **notes**: both `\leanok` present; axiom-clean

### `\lean{PresheafOfModules.InternalHom.internalHom}` (`def:presheaf_internal_hom`)
- **Lean target exists**: yes — `noncomputable def internalHom`, line 1306
- **Signature matches**: yes — `PresheafOfModules (R₀ ⋙ forget₂ CommRingCat RingCat)` assembled from `internalHomPresheaf` + `internalHomObjModule` + `restrictionMap_smul` via `ofPresheaf`
- **Proof follows sketch**: yes — three-piece assembly (value modules, restriction maps, semilinearity) matches blueprint's (a)+(b)+(c) description
- **notes**: both `\leanok` present; axiom-clean; restricted to single-universe base (matches blueprint universe note)

### `\lean{PresheafOfModules.InternalHom.restrictionMap}` (`lem:presheaf_internal_hom_restriction`)
- **Lean target exists**: yes — `noncomputable def restrictionMap`, line 1149
- **Signature matches**: yes — further-restriction map `(restr U M ⟶ restr U N) → (restr V M ⟶ restr V N)` for `g : V ⟶ U`
- **Proof follows sketch**: yes — semilinearity via `restrictionMap_globalSMul` + `termRingMap_naturality`
- **notes**: both `\leanok` present; axiom-clean; helpers `restrictionMap_{add,zero,id,comp,comp_hom,globalSMul,AddHom,smul}` + `restrictionMapAddHom` + `internalHomPresheaf` present as unreferenced helpers (acceptable)

### `\lean{PresheafOfModules.dual}` (`def:presheaf_dual`)
- **Lean target exists**: yes — `noncomputable def dual`, line 1359
- **Signature matches**: yes — `internalHom M (𝟙_ PresheafOfModules)` matching `ℋom(M, R)`
- **Proof follows sketch**: N/A (definition)
- **notes**: both `\leanok` present; axiom-clean

### `\lean{PresheafOfModules.internalHomEval}` (`lem:internal_hom_eval`)
- See focused check above. Statement `\leanok` present (correct); proof `\leanok` absent (correct). ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.dual}` (`lem:internal_hom_isSheaf`)
- **Lean target exists**: NO — `AlgebraicGeometry.Scheme.Modules.dual` is not defined in this file
- **notes**: no `\leanok` (aspirational pin). Not a red flag.

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial}` (`lem:dual_isLocallyTrivial`)
- **Lean target exists**: NO — not defined in this file
- **notes**: no `\leanok` (aspirational pin). Not a red flag.

---

## Red flags

### Placeholder / suspect bodies

- **`internalHomEval` at Lean line 1463**: `naturality` field is `:= by sorry`. This is a **typed sorry**, not a trivially-wrong body; the blueprint correctly does NOT have proof-block `\leanok`, and the extensive sorry-comment (lines 1473–1497) accurately documents the heartbeat bomb and the escalation to iter-224. The per-object `internalHomEvalApp` (line 1408) is axiom-clean. This is the expected documented state. **Not a red flag under "placeholder for a substantive claim"** — the blueprint honestly reflects the partial status.

- **`isLocallyInjective_whiskerLeft_of_W` at Lean line 612**: entire body `:= by sorry`. Blueprint statement `\leanok` is correct. No proof-block `\leanok`. Extensive documented residual (d.1-bridge + d.2). Documented. **Not a hidden placeholder.**

- **`exists_tensorObj_inverse` at Lean line 1921**: body `:= sorry`. Blueprint statement `\leanok` correct. Proof says "Infrastructure-blocked." **Not a hidden placeholder.**

- **`addCommGroup_via_tensorObj` at Lean line 1971**: body `:= sorry`. Blueprint statement `\leanok` correct. **Consumer sorry — depends on `exists_tensorObj_inverse`.**

### Excuse-comments
None found. All sorry-comments explain genuine mathematical/infrastructure blockers, not workarounds for wrong code.

### Stale file-header
- **Lines 71–77**: module docstring lists `AlgebraicGeometry.Scheme.Modules.monoidalCategory` (instance) as blueprint-pinned declaration #3 "Per blueprint `thm:scheme_modules_monoidal`". That declaration has been **deliberately removed** from the Lean file (per line 1560: "the earlier `monoidalCategory := sorry` instance… are removed here"), and no `thm:scheme_modules_monoidal` block exists in the blueprint. The file header is stale. See Major finding #5.

### Axioms / Classical.choice
No axiom declarations found.

---

## Unreferenced declarations (informational)

Declarations in the Lean file with no `\lean{...}` blueprint reference:

**Substantive (worth noting):**
- `PresheafOfModules.internalHomEvalApp` (line 1408): axiom-clean, the per-object evaluation building block. Mentioned only in the `% NOTE:` of `lem:internal_hom_eval`, not as a dedicated pin. **Should have a dedicated `\lean{...}` block.** (Major finding #4)
- `PresheafOfModules.stalkLinearMap` + `stalkLinearMap_germ` + `stalkLinearMap_bijective_of_isIso` + `stalkLinearEquivOfIsIso` (lines 736, 777, 798, 811): axiom-clean, described in the superseded-route text of `lem:stalk_linear_map` without a `\lean{...}` pin. Blueprint says this route "must NOT be formalized" — but the Lean file HAS these formalized. They exist and are axiom-clean; the blueprint's "not to be formalized" instruction is outdated.

**Helpers (acceptable):**
- `restrictScalarsRingIsoTensorEquiv_apply_tmul` (line 209): `@[simp]` helper, acceptable
- `restrictScalarsLaxε`, `restrictScalarsLaxμ` (lines 315, 331): helpers for `restrictScalarsLaxMonoidal`, mentioned in blueprint prose but not separately pinned
- `restrictScalars_isIso_μ_of_bijective`, `restrictScalars_isIso_ε_of_bijective` (lines 278, 287): pinned in `lem:restrictscalars_ringiso_strongmonoidal` — wait, these ARE pinned but the block lacks `\leanok` (see Major #2)
- `toPresheaf_whiskerLeft_app_tmul`, `toPresheaf_whiskerLeft_app_apply`, `isLocallySurjective_whiskerLeft`, `isLocallyInjective_whiskerLeft_of_flat`, `W_whiskerLeft_of_flat`, `W_whiskerRight_of_flat`, `W_whiskerLeft_of_W`, `W_whiskerRight_of_W` (lines 402–677): all referenced from superseded-route lemmas `lem:flat_whisker_localizer`/`lem:whisker_of_W`; no `\lean{...}` pins (acceptable as superseded)
- `restr`, `globalSMul` + helpers, `termRingMap`, `termRingMap_naturality`, `termRingMap_terminal`, `evalLin`, `evalLin_add`, `evalLin_smul`, `internalHomEvalApp_tmul`, `restr_map_homMk`, `restrictionMapAddHom`, `internalHomPresheaf`, `hom_app_heq`, `stalkLinearEquivOfIsIso` (many): helpers for the internal-hom construction; acceptable
- `tensorObjIsoOfIso`, `restrictIsoUnitOfLE`, `tensorObj_unit_iso` (the `𝒪_X ⊗ 𝒪_X ≅ 𝒪_X` helper, line 1598): last of these shares a similar name with the blueprint label `lem:tensorobj_unit_iso` but pinned declarations are the left/right unitors, not this helper — minor naming confusion
- `pushforwardNatTrans_app_app_apply`, `pushforwardCongr_hom_app_app`, `pushforwardCongr_inv_app_app`: `@[simp]` helpers for the H1 push-adj declarations

---

## Blueprint adequacy for this file

- **Coverage**: 24/27 blueprint `\lean{...}` blocks have corresponding declarations in the Lean file. Of the 3 absent:  `tensorObjIsoclassCommMonoid`, `Scheme.Modules.dual`, `dual_isLocallyTrivial` — all are correctly marked without `\leanok` (aspirational pins). Additionally, `pullback_tensorObj_iso` is absent but in a different file. 3 additional blocks (5+5+2 = 12 declarations) lack `\leanok` despite all declarations being axiom-clean (`lem:presheaf_pushforward_adj_substrate`, `lem:restrictscalars_ringiso_strongmonoidal`, `lem:tensorobj_unit_iso`).

- **Proof-sketch depth**: **adequate** for all axiom-clean declarations. The proofs of `tensorObj_restrict_iso` (4-step blueprint → 4-step Lean), `restrictScalarsRingIsoTensorEquiv` (inverse-construction strategy), `internalHom` assembly (3-piece), `internalHomEval` (6-step reduction documented in sorry-comment), and the associator (route mismatch documented) all have sufficient blueprint detail. The chapter is detailed enough to have guided the formalization.

- **Hint precision**: **mostly precise**. The `\lean{...}` hints use fully-qualified names and resolve correctly. The exception is `restrictScalarsRingIsoTensorEquiv` which is in the global namespace (correct — the declaration IS at the global level). One missing pin: `PresheafOfModules.internalHomEvalApp`.

- **Generality**: **matches need** — the chapter covers the exact level of generality the Lean file realizes.

- **Recommended chapter-side actions**:
  1. Add `\leanok` to the statement and proof blocks of `lem:presheaf_pushforward_adj_substrate` (all 5 declarations axiom-clean).
  2. Add `\leanok` to the statement and proof blocks of `lem:restrictscalars_ringiso_strongmonoidal` (all 5 declarations axiom-clean).
  3. Add `\leanok` to the statement and proof blocks of `lem:tensorobj_unit_iso` (both declarations axiom-clean).
  4. Add a dedicated `\begin{lemma}...\leanok...\lean{PresheafOfModules.internalHomEvalApp}...\end{lemma}` block under `sec:tensorobj_dual_infra`, or update the `% NOTE:` in `lem:internal_hom_eval` to include a `\lean{PresheafOfModules.internalHomEvalApp}` reference tag.
  5. Update the module docstring of `TensorObjSubstrate.lean` (lines 59–88) to remove the stale declaration #3 (`monoidalCategory`) and its `thm:scheme_modules_monoidal` reference.
  6. Update the "must NOT be formalized" instruction in the `lem:stalk_linear_map` superseded-route block, since those 4 declarations ARE now formalized in Lean and are axiom-clean.
  7. Fix minor wording: in the `% NOTE:` of `lem:internal_hom_eval`, change "is the correct future target name" to "is the current target declaration."

---

## Severity summary

### Major

1. **`lem:presheaf_pushforward_adj_substrate` missing `\leanok`**: all 5 pinned declarations (`pushforwardNatTrans`, `pushforwardCongr`, `pushforwardPushforwardAdj`, `isIso_of_isIso_app`, `restrictScalarsMonoidalOfBijective`) are axiom-clean in Lean but the blueprint block carries no `\leanok`. This appears to be a `sync_leanok` limitation with multi-declaration pins. Blueprint readers cannot see the axiom-clean status of these key H1/H2 substrate lemmas.

2. **`lem:restrictscalars_ringiso_strongmonoidal` missing `\leanok`**: same issue — all 5 pinned declarations axiom-clean in Lean (`restrictScalars_isIso_μ`, `restrictScalars_isIso_ε`, `restrictScalarsMonoidalOfRingEquiv`, bijective variants); no `\leanok` in blueprint.

3. **`lem:tensorobj_unit_iso` missing `\leanok`**: both `tensorObj_left_unitor` and `tensorObj_right_unitor` are axiom-clean in Lean; no `\leanok` in blueprint statement or proof blocks.

4. **Missing `\lean{PresheafOfModules.internalHomEvalApp}` pin**: `internalHomEvalApp` (line 1408) is an axiom-clean, substantive declaration — the completed per-object evaluation building block for `internalHomEval`. It is mentioned in prose only inside the `% NOTE:` of `lem:internal_hom_eval`, without a dedicated `\lean{...}` blueprint block or `\leanok`. For a construction of this size and complexity, the per-object step deserves its own blueprint entry with `\leanok`.

5. **Stale file-header docstring**: `TensorObjSubstrate.lean` lines 71–77 list `AlgebraicGeometry.Scheme.Modules.monoidalCategory` as blueprint declaration #3 "Per blueprint `thm:scheme_modules_monoidal`". This declaration was deliberately removed from the Lean file (per line 1560); no `thm:scheme_modules_monoidal` block exists in the blueprint. The file header is stale and misleading.

### Minor

1. **`% NOTE:` wording** in `lem:internal_hom_eval`: says `internalHomEval` is "the correct future target name" — but the declaration already exists. Should be updated.

2. **Superseded-route declarations formalized without blueprint tracking**: `stalkLinearMap`, `stalkLinearMap_germ`, `stalkLinearMap_bijective_of_isIso`, `stalkLinearEquivOfIsIso` (lines 736–816) are axiom-clean in Lean but the blueprint's `lem:stalk_linear_map` block says "must NOT be formalized" and has no `\lean{...}` pin. The blueprint instruction is outdated.

3. **Naming confusion**: `tensorObj_unit_iso` (line 1598, not separately pinned, meaning `𝒪_X ⊗ 𝒪_X ≅ 𝒪_X`) shares a similar name with the blueprint label `lem:tensorobj_unit_iso` (which pins `tensorObj_left_unitor` + `tensorObj_right_unitor`). The helper `tensorObj_unit_iso` is used in `tensorObj_isLocallyTrivial` at line 1891 and is not blueprinted, but the naming resemblance could confuse.

---

**Overall verdict**: The `internalHomEval` sorry is correctly handled — blueprint statement `\leanok` present (declaration exists), proof `\leanok` absent (naturality sorry), `% NOTE:` acknowledges the per-object/assembly split, and the `\lean{...}` pin names the actual declaration. No must-fix findings. Three major blueprint-marker gaps (missing `\leanok` on 12 axiom-clean declarations across 3 blocks), one missing substantive `\lean{...}` pin (`internalHomEvalApp`), and one stale file-header comment. — 27 blueprint blocks checked, 0 must-fix red flags, 5 major findings, 3 minor findings.
