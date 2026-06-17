# Lean ↔ Blueprint Check Report

## Slug
ts226

## Iteration
226

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

> **Chapter correction**: The directive named `Picard_QuotScheme.tex` as the blueprint chapter, but
> that file carries `% archon:covers AlgebraicJacobian/Picard/QuotScheme.lean` — it is the chapter
> for `QuotScheme.lean`, not `TensorObjSubstrate.lean`. No chapter carries
> `% archon:covers AlgebraicJacobian/Picard/TensorObjSubstrate.lean`; `Picard_TensorObjSubstrate.tex`
> is identified from the Lean file's own header (`## References` block: "Blueprint:
> `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`"). All checks below are against that file.

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (`def:scheme_modules_tensorobj`)
- **Lean target exists**: yes (line 1524)
- **Signature matches**: yes — `(M N : X.Modules) : X.Modules`, lifting `PresheafOfModules.Monoidal.tensorObj` through sheafification
- **Proof follows sketch**: yes — the blueprint's "Equivalently: underlying presheaf tensor composed with sheafification" is exactly the body
- **notes**: axiom-clean, no sorry

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` (`lem:scheme_modules_tensorobj_functoriality`)
- **Lean target exists**: yes (line 1539)
- **Signature matches**: yes — `{M M' N N' : X.Modules} (f : M ⟶ M') (g : N ⟶ N') : tensorObj M N ⟶ tensorObj M' N'`
- **Proof follows sketch**: yes — bifunctoriality from `PresheafOfModules.Monoidal` under sheafification
- **notes**: axiom-clean, no sorry

### `\lean{PresheafOfModules.restrictScalarsLaxMonoidal}` (`lem:restrictscalars_laxmonoidal`)
- **Lean target exists**: yes (line 345, as `noncomputable instance`)
- **Signature matches**: yes — instance for `(PresheafOfModules.restrictScalars α).LaxMonoidal`; note the blueprint calls this a `lemma` while Lean registers it as an `instance`, which is standard practice
- **Proof follows sketch**: yes — sectionwise lift from `ModuleCat.instLaxMonoidalRestrictScalars`
- **notes**: axiom-clean; off the critical path as documented in both blueprint and Lean

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso}` (`lem:tensorobj_restrict_iso`)
- **Lean target exists**: yes (line 1822)
- **Signature matches**: yes — `(f : Y ⟶ X) [IsOpenImmersion f] (M N : X.Modules) : (tensorObj M N).restrict f ≅ tensorObj (M.restrict f) (N.restrict f)`; matches the blueprint's "canonical comparison morphism is an isomorphism, no local-freeness required"
- **Proof follows sketch**: yes — exact 4-step proof described in the blueprint (Step 1: `restrictFunctorIsoPullback`; Step 2: `sheafificationCompPullback`; Step 3: strip sheafification; Step 4: H1 + H2 closure)
- **notes**: axiom-clean, closed iter-217; single substrate linchpin

### `\lean{PresheafOfModules.pushforwardNatTrans, PresheafOfModules.pushforwardCongr, PresheafOfModules.pushforwardPushforwardAdj, PresheafOfModules.isIso_of_isIso_app, PresheafOfModules.restrictScalarsMonoidalOfBijective}` (`lem:presheaf_pushforward_adj_substrate`)
- **Lean target exists**: yes — all 5 exist (lines 849, 880, 917, 949, 967 respectively)
- **Signature matches**: yes for all 5; the blueprint's H1/H2 description matches the Lean docstrings precisely
- **Proof follows sketch**: yes
- **notes**: all axiom-clean; these are the H1+H2 ingredients of `tensorObj_restrict_iso`

### `\lean{restrictScalarsRingIsoTensorEquiv}` (`lem:restrictscalars_ringiso_tensorequiv`)
- **Lean target exists**: yes (line 124; namespace-less at the file level in `RestrictScalarsRingIsoTensor` section)
- **Signature matches**: yes — `(e : R ≃+* S) (A B : Type u) [...] : TensorProduct R A B ≃ₗ[R] TensorProduct S A B`; matches "base change along a ring iso commutes with ⊗"
- **Proof follows sketch**: yes
- **notes**: axiom-clean; the blueprint's `\lean{}` tag has no namespace prefix, but the declaration is at top-level — consistent

### `\lean{restrictScalars_isIso_μ, restrictScalars_isIso_ε, restrictScalarsMonoidalOfRingEquiv, restrictScalars_isIso_μ_of_bijective, restrictScalars_isIso_ε_of_bijective}` (`lem:restrictscalars_ringiso_strongmonoidal`)
- **Lean target exists**: yes — all 5 exist (lines 228, 246, 262, 275, 284)
- **Signature matches**: yes for all 5; bijective-form variants match the blueprint's description
- **Proof follows sketch**: yes
- **notes**: all axiom-clean; ModuleCat-level H2 core

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_isLocallyTrivial}` (`lem:tensorobj_preserves_locally_trivial`)
- **Lean target exists**: yes (line 1912, as `lemma`)
- **Signature matches**: yes — `(hM : LineBundle.IsLocallyTrivial M) (hN : LineBundle.IsLocallyTrivial N) : LineBundle.IsLocallyTrivial (tensorObj M N)`
- **Proof follows sketch**: yes — pick common affine open, use `restrictIsoUnitOfLE` + `tensorObj_restrict_iso` + `tensorObjIsoOfIso` + `tensorObj_unit_iso`
- **notes**: axiom-clean, no sorry

### Superseded-route blocks (`lem:islocallyinjective_whisker_of_W`, `lem:flat_whisker_localizer`, `lem:isiso_sheafification_map_of_W`, `lem:stalk_linear_map`, `lem:whisker_of_W`, `lem:jw_ismonoidal`)
- **Lean target exists**: yes for all except `lem:jw_ismonoidal` (no corresponding Lean declaration; no `\lean{}` pin on that block)
- **Signature matches**: N/A — blueprint blocks are marked `% SUPERSEDED route` and have no `\lean{...}` tags (except `lem:islocallyinjective_whisker_of_W` which is `\leanok` without a pin)
- **notes**: `isLocallyInjective_whiskerLeft_of_W` has `:= sorry` (consistent with `\leanok`); `isIso_sheafification_map_of_W` is axiom-clean; stalk-linear-map declarations are all axiom-clean. Off the critical path as documented.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso}` (`lem:tensorobj_assoc_iso`)
- **Lean target exists**: yes (line 1715)
- **Signature matches**: yes — `(hM : LineBundle.IsLocallyTrivial M) (hN : ...) (hP : ...) : tensorObj (tensorObj M N) P ≅ tensorObj M (tensorObj N P)`. The blueprint notes locally-trivial hypotheses are vestigial but present; this matches exactly.
- **Proof follows sketch**: partial — the current Lean proof uses the ROUTE (d) whiskering composite (which is sorry-transitive via `isLocallyInjective_whiskerLeft_of_W`), NOT the intended direct-gluing blueprint route. The blueprint proof section explicitly says "Status (route mismatch, deferred)." Both blueprint and Lean agree this is a known deferred mismatch.
- **notes**: the declaration has no direct sorry but is sorry-transitive through `isLocallyInjective_whiskerLeft_of_W`. Blueprint documents this mismatch. Not a must-fix — the discrepancy is authorized in the blueprint text.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_left_unitor, AlgebraicGeometry.Scheme.Modules.tensorObj_right_unitor}` (`lem:tensorobj_unit_iso`)
- **Lean target exists**: yes — both at lines 1643 and 1653
- **Signature matches**: yes — left: `(M : X.Modules) : tensorObj (SheafOfModules.unit X.ringCatSheaf) M ≅ M`; right: symmetric
- **Proof follows sketch**: yes — cheap `mapIso` pattern as described
- **notes**: both axiom-clean, no sorry. **The blueprint block for `lem:tensorobj_unit_iso` lacks `\leanok`** even though both declarations are sorry-free. This is a `sync_leanok` gap.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_braiding}` (`lem:tensorobj_comm_iso`)
- **Lean target exists**: yes (line 1663)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `mapIso` of the presheaf braiding
- **notes**: axiom-clean, `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse}` (`lem:tensorobj_inverse_invertible`)
- **Lean target exists**: yes (line 2005)
- **Signature matches**: yes — `(hL : LineBundle.IsLocallyTrivial L) : ∃ Linv : X.Modules, LineBundle.IsLocallyTrivial Linv ∧ Nonempty (tensorObj L Linv ≅ SheafOfModules.unit X.ringCatSheaf)`. Blueprint states "dual L^{-1} is again a line bundle and L ⊗ L^{-1} ≅ O_X" — matches.
- **Proof follows sketch**: `:= sorry` (consistent with `\leanok`). The Lean docstring names two remaining bridges (A and C); blueprint describes the construction in detail.
- **notes**: sorry acknowledged; full decomposition in `informal/exists_tensorObj_inverse.md` per Lean comment

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjOnProduct}` (`lem:tensorobj_lift_onproduct`)
- **Lean target exists**: yes (line 2037, `noncomputable def`)
- **Signature matches**: yes — `(L L' : LineBundle.OnProduct πC πT) : LineBundle.OnProduct πC πT`
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry; `\leanok` present ✓

### `\lean{AlgebraicGeometry.LineBundle.OnProduct.pullback_tensorObj_iso}` (`lem:pullback_compatible_with_tensorobj`)
- **Lean target exists**: no — declaration `pullback_tensorObj_iso` is NOT present in `TensorObjSubstrate.lean`
- **Signature matches**: N/A
- **notes**: blueprint block has no `\leanok`, so this is an unformalized forward pin. Expected unformalized state.

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible}` (`def:scheme_modules_isinvertible`)
- **Lean target exists**: yes (line 1552, as `def`)
- **Signature matches**: yes
- **notes**: axiom-clean; `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjIsoclassCommMonoid}` (`lem:tensorobj_isoclass_commgroup`)
- **Lean target exists**: no — declaration NOT present in `TensorObjSubstrate.lean`
- **Signature matches**: N/A
- **notes**: blueprint block has no `\leanok`, so this is an unformalized forward pin. Expected unformalized state.

### `\lean{AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj}` (`thm:rel_pic_addcommgroup_via_tensorobj`)
- **Lean target exists**: yes (line 2070)
- **Signature matches**: yes
- **Proof follows sketch**: `:= sorry` (consistent with `\leanok`)
- **notes**: `\leanok` present ✓

### Dual infrastructure (`def:presheaf_internal_hom_value` through `lem:internal_hom_eval`)
- All `\lean{...}` pins in this block (7 declarations) resolve to existing sorry-free declarations in the Lean file (lines 1091–1500 range)
- Signatures match in all cases
- All `\leanok` markers present and consistent
- **notes**: all axiom-clean ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.dual}` (`lem:internal_hom_isSheaf`)
- **Lean target exists**: yes (line 1580 — the sheaf-level dual object)
- **Signature matches**: yes — the blueprint's statement "sheaf-level dual `dual M := Hom_{O_X}(M, O_X)`" matches the sheafification of `PresheafOfModules.dual`
- **notes**: axiom-clean; `\leanok` present ✓. Note: the blueprint block title "The internal hom is a sheaf; the sheaf-level dual" is broader than what the single `\lean{}` pin covers (only the dual object, not a separate `isSheaf` predicate) — minor documentation imprecision.

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial}` (`lem:dual_isLocallyTrivial`)
- **Lean target exists**: no — declaration NOT present in `TensorObjSubstrate.lean`
- **Signature matches**: N/A
- **notes**: blueprint block has no `\leanok` — unformalized forward pin. Expected unformalized state.

---

## Red flags

### Unreferenced substantive declarations

#### `AlgebraicGeometry.Scheme.Modules.isIso_of_isIso_restrict` (line 1943)
The new B-connector lemma added this iteration. Its signature:
```lean
lemma isIso_of_isIso_restrict {X : Scheme.{u}} {M N : X.Modules} (φ : M ⟶ N)
    (U : X → X.Opens) (hxU : ∀ x, x ∈ U x)
    (h : ∀ x, IsIso ((Scheme.Modules.restrictFunctor (U x).ι).map φ)) :
    IsIso φ
```
This declaration is **axiom-clean and sorry-free**. It is **not pinned** in any blueprint block. The "locally-iso ⇒ global iso" principle is mentioned only inline in:
- The proof of `lem:tensorobj_inverse_invertible` (Step 3: "As 'being an isomorphism' is local on X...")
- `rem:dual_discharges_inverse` (same inline phrasing)

No `\lean{...}` tag, no named block. The declaration is substantive infrastructure (not a trivial helper) and warrants blueprint coverage.

#### `AlgebraicGeometry.Scheme.Modules.restrictIsoUnitOfLE` (line 1771)
Helper for `tensorObj_isLocallyTrivial` — refines a trivialisation from `U` to `W ≤ U`. No blueprint pin. This is acceptably helper-level (not a standalone math statement), but its name suggests potential broader reuse. No required action.

---

## Unreferenced declarations (informational)

| Declaration | Line | Blueprint status | Assessment |
|---|---|---|---|
| `isIso_of_isIso_restrict` | 1943 | No block | **Substantive — should have blueprint block** (see Red Flags above) |
| `restrictIsoUnitOfLE` | 1771 | No block | Helper; acceptable without pin |
| `InternalHom.termRingMap` | 1019 | No block | Sub-helper for `homModule`; helper-level |
| `InternalHom.termRingMap_naturality` | 1026 | No block | Sub-helper; helper-level |
| `InternalHom.globalSMul` + helpers | 1040 | No block | Sub-helpers for `homModule`; acceptable |
| `InternalHom.restr` | 1121 | No block | Sub-helper; acceptable |
| `InternalHom.restrictionMapAddHom` | 1236 | No block | Sub-helper; acceptable |
| `InternalHom.internalHomPresheaf` | 1247 | No block | Sub-helper for `internalHom` assembly; acceptable |
| `InternalHom.restrictionMapAddHom`/`restrictionMap_{id,comp,comp_hom,globalSMul}` | various | No block | Sub-helpers; acceptable |
| `InternalHom.evalLin`, `evalLin_add`, `evalLin_smul` | 1364 | No block | Sub-helpers for `internalHomEval`; acceptable |
| `internalHomEvalApp` | 1405 | No block | Sub-helper for `internalHomEval`; acceptable |
| `restr_map_homMk` (private) | 1441 | No block | Private helper; acceptable |
| `InternalHom.termRingMap_terminal` | 1328 | No block | Sub-helper; acceptable |
| `tensorObjIsoOfIso` | 1614 | No block | Helper for `tensorObj_isLocallyTrivial`; acceptable |
| `tensorObj_unit_iso` | 1630 | No block | Blueprint notes `lem:tensorobj_unit_iso` but only pins `left_unitor` and `right_unitor`, not this unit-unit instance. Minor gap. |
| `stalkLinearEquivOfIsIso` | 1808 (approx) | Covered by `lem:stalk_linear_map` | Superseded route; listed there |

---

## Blueprint adequacy for this file

- **Coverage**: ~26 substantive Lean declarations have `\lean{...}` blueprint coverage (via pinned `\leanok` or forward-pin blocks). The B-connector `isIso_of_isIso_restrict` has none. Roughly 50+ helper declarations are acceptably uncovered. Coverage is **adequate except for `isIso_of_isIso_restrict`**.

- **Proof-sketch depth for `exists_tensorObj_inverse`**: **under-specified** for the A-bridge.
  
  The C-bridge (`lem:dual_isLocallyTrivial`) IS named in the blueprint with a proof sketch (section `sec:tensorobj_dual_infra`, lines ~2732–2773). The sketch is adequate: "internal hom commutes with open-immersion restriction ... under the trivialisation, (dual L)|_U ≅ O_U."
  
  The A-bridge — constructing the actual global morphism `tensorObj L (dual L) ⟶ O_X` by gluing local trivialising isomorphisms via the sheaf axiom — is described only inline in `rem:dual_discharges_inverse`: "glue the canonical local trivialising isos... to a global `tensorObj L (dual L) ⟶ O_X` via `CategoryTheory.Presheaf.IsSheaf.hom` / `sheafHomSectionsEquiv` + `PresheafOfModules.homMk`." There is **no named lemma block** for this descent step. A dedicated block (e.g. `lem:sheafofmodules_hom_of_local_sections`) would make this substep independently trackable and guide the prover for what is the genuinely novel infrastructure step.

  The B-connector is now closed (`isIso_of_isIso_restrict`, axiom-clean). Its mathematical content is described correctly in the proof of `lem:tensorobj_inverse_invertible` (Step 3) and `rem:dual_discharges_inverse`, but as an unnamed inline claim.

- **Hint precision**: **precise** where pinned. No `\lean{...}` hint points to the wrong Mathlib predicate or a misnamed declaration.

- **Generality**: **matches need**. No parallel API had to be written because the blueprint was too narrow.

- **Recommended chapter-side actions**:
  1. Add `% archon:covers AlgebraicJacobian/Picard/TensorObjSubstrate.lean` near the top of `Picard_TensorObjSubstrate.tex` (currently absent; other chapters have this annotation).
  2. Add a named lemma block for `isIso_of_isIso_restrict` in `sec:tensorobj_dual_infra` (between `rem:dual_discharges_inverse` and `rem:dual_via_stack`, or as a standalone subsection); suggested label `lem:isiso_of_isiso_restrict`. The statement: "a morphism of O_X-modules that restricts to an isomorphism on an open neighbourhood of every point is a global isomorphism; proved stalkwise via `restrictStalkNatIso` + `NatIso.isIso_map_iff` + `isIso_of_stalkFunctor_map_iso`."
  3. Add a named lemma block for the A-bridge (sheaf morphism descent step), e.g. `lem:sheafofmodules_hom_of_local_compat`, to make the descent sub-step trackable by `sync_leanok`.
  4. Add `\leanok` to `lem:tensorobj_unit_iso` (`sync_leanok` should handle this automatically if the annotation is missing from the last sync).

---

## Severity summary

| Finding | Severity |
|---|---|
| `Picard_TensorObjSubstrate.tex` missing `% archon:covers ...TensorObjSubstrate.lean` annotation | **major** |
| `isIso_of_isIso_restrict` (B-connector, axiom-clean) has no blueprint block | **major** |
| A-bridge (SheafOfModules morphism descent for `exists_tensorObj_inverse`) not a named blueprint block | **major** (blueprint under-specified for that sub-step) |
| `lem:tensorobj_unit_iso` block missing `\leanok` despite sorry-free Lean declarations | **minor** (sync_leanok gap) |
| `lem:internal_hom_isSheaf` blueprint pin covers only `Scheme.Modules.dual`, not a separate `isSheaf` predicate (minor prose/pin mismatch) | **minor** |
| `tensorObj_assoc_iso` uses route-(d) instead of planned direct-gluing route | not flagged — documented and authorized in the blueprint text itself |

**Overall verdict**: The file is correct and well-aligned with the blueprint on all formalized declarations; the main issue is the new B-connector (`isIso_of_isIso_restrict`) has no blueprint pin, the chapter lacks its `archon:covers` annotation, and the A-bridge descent step for `exists_tensorObj_inverse` is under-specified as an inline remark rather than a named block — 3 major findings, 0 must-fix-this-iter, 2 minor. — 26+ declarations checked, 3 major issues (no blocking red flags in existing formalized declarations)
