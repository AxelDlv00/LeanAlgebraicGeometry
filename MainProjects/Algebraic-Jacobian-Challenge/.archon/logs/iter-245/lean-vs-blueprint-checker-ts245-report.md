# Lean ↔ Blueprint Check Report

## Slug
ts245

## Iteration
245

## Files audited
- Lean: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (1413 lines)
- Blueprint: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (~5200 lines)

---

## Per-declaration (blueprint → Lean)

This section covers every `\lean{...}` block that pins a declaration whose
home is `TensorObjSubstrate.lean` (declarations in sub-files are excluded).

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (def:scheme_modules_tensorobj)
- **Lean target exists**: yes (line 140)
- **Signature matches**: yes — `{X : Scheme.{u}} (M N : X.Modules) : X.Modules`, lifting through `PresheafOfModules.sheafification`
- **Proof follows sketch**: yes — sheafification of `PresheafOfModules.Monoidal.tensorObj`
- **notes**: fully defined, no sorry

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` (lem:scheme_modules_tensorobj_functoriality)
- **Lean target exists**: yes (line 155)
- **Signature matches**: yes — `{M M' N N' : X.Modules} (f : M ⟶ M') (g : N ⟶ N') : tensorObj M N ⟶ tensorObj M' N'`
- **Proof follows sketch**: yes — `sheafification.map (tensorHom f.val g.val)`
- **notes**: fully defined, no sorry

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso}` (lem:tensorobj_restrict_iso)
- **Lean target exists**: yes (line 425)
- **Signature matches**: yes — `[IsOpenImmersion f] (M N : X.Modules) : (tensorObj M N).restrict f ≅ tensorObj (M.restrict f) (N.restrict f)`
- **Proof follows sketch**: yes — Steps 1-4 exactly as described (restrictFunctorIsoPullback, sheafificationCompPullback, strip, H1∘H2); axiom-clean
- **notes**: fully proven, no sorry

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_isLocallyTrivial}` (lem:tensorobj_preserves_locally_trivial)
- **Lean target exists**: yes (line 515)
- **Signature matches**: yes — `(hM : LineBundle.IsLocallyTrivial M) (hN : ...) : LineBundle.IsLocallyTrivial (tensorObj M N)`
- **Proof follows sketch**: yes — common affine open, `restrictIsoUnitOfLE`, `tensorObj_restrict_iso`, `tensorObjIsoOfIso`, `tensorObj_unit_iso`
- **notes**: fully proven, no sorry

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso}` (lem:tensorobj_assoc_iso)
- **Lean target exists**: yes (line 320)
- **Signature matches**: yes — unconditional, no flatness hypotheses, `{M N P : X.Modules} : tensorObj (tensorObj M N) P ≅ tensorObj M (tensorObj N P)`
- **Proof follows sketch**: yes — three-step composite (W-whisker, mapIso of associator, W-whisker)
- **notes**: axiom-clean; the earlier flatness route is correctly retired

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_left_unitor, AlgebraicGeometry.Scheme.Modules.tensorObj_right_unitor}` (lem:tensorobj_unit_iso)
- **Lean target exists**: yes (lines 271, 281)
- **Signature matches**: yes — `(M : X.Modules) : tensorObj (SheafOfModules.unit _) M ≅ M` and symmetric
- **Proof follows sketch**: yes — mapIso of presheaf-level unitor, composed with sheafification counit
- **notes**: fully proven, no sorry

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_braiding}` (lem:tensorobj_comm_iso)
- **Lean target exists**: yes (line 291)
- **Signature matches**: yes — `(M N : X.Modules) : tensorObj M N ≅ tensorObj N M`
- **Proof follows sketch**: yes — mapIso of `BraidedCategory.braiding`
- **notes**: fully proven, no sorry

### `\lean{AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse}` (lem:tensorobj_inverse_invertible)
- **Lean target exists**: yes (line 672)
- **Signature matches**: yes — `(hL : LineBundle.IsLocallyTrivial L) : ∃ Linv : X.Modules, IsLocallyTrivial Linv ∧ Nonempty (tensorObj L Linv ≅ SheafOfModules.unit _)`
- **Proof follows sketch**: N/A — body is `sorry`; no `\leanok` in blueprint block (correct)
- **notes**: two bridges remain (C: `dual_isLocallyTrivial`, A: `homOfLocalCompat`). Extensive work-in-progress comment explains the gap; NOT an excuse-comment (genuinely documents remaining work). See Red Flags section.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjOnProduct}` (lem:tensorobj_lift_onproduct)
- **Lean target exists**: yes (line 704)
- **Signature matches**: yes — `(L L' : LineBundle.OnProduct πC πT) : LineBundle.OnProduct πC πT`
- **Proof follows sketch**: yes — one-liner combining `tensorObj_isLocallyTrivial`
- **notes**: fully proven, no sorry

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible}` (def:scheme_modules_isinvertible)
- **Lean target exists**: yes (line 168)
- **Signature matches**: yes — `(M : X.Modules) : Prop := ∃ N, Nonempty (tensorObj M N ≅ SheafOfModules.unit _)`
- **Proof follows sketch**: N/A (Prop def)
- **notes**: correct

### `\lean{AlgebraicGeometry.Scheme.Modules.PicGroup, AlgebraicGeometry.Scheme.Modules.picCommGroup}` (def:pic_carrier / thm:pic_commgroup)
- **Lean targets exist**: yes — `PicGroup` (line 779), `picCommGroup` (line 813); also `picSetoid`, `picMul`, `picInv` supporting infrastructure (lines 772, 784, 793)
- **Signature matches**: yes — `PicGroup X : Type _`, `picCommGroup : CommGroup (PicGroup X)`
- **Proof follows sketch**: yes — group axioms built from `tensorObj_assoc_iso`, unitors, braiding; no pentagon/triangle required; fully proven
- **notes**: `\leanok` correctly present in blueprint; no sorry

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso_invertible}` (lem:tensorobj_assoc_iso_invertible)
- **Lean target exists**: yes (line 721)
- **Signature matches**: yes — specialized from unconditional `tensorObj_assoc_iso`
- **Proof follows sketch**: yes
- **notes**: `\leanok` present; no sorry

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible.tensorObj}` (lem:isinvertible_tensor)
- **Lean target exists**: yes (line 743)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `tensorObj_middleFour` assembles the four-factor iso
- **notes**: `\leanok` present; no sorry

### `\lean{AlgebraicGeometry.Scheme.Modules.isInvertible_unit}` (lem:isinvertible_unit)
- **Lean target exists**: yes (line 753)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present; no sorry

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible.inverse_unique}` (lem:isinvertible_inverse_welldef)
- **Lean target exists**: yes (line 760)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present; no sorry

### `\lean{AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj}` (thm:rel_pic_addcommgroup_via_tensorobj)
- **Lean target exists**: yes (line 1403)
- **Signature matches**: yes — `AddCommGroup (Quotient (RelPicPresheaf.preimage_subgroup πC πT))`
- **Proof follows sketch**: N/A — body is `sorry`; no `\leanok` in blueprint (correct)
- **notes**: closure target for the Lane RPF L235 residual; blocked on `exists_tensorObj_inverse`

### `\lean{AlgebraicGeometry.Scheme.Modules.presheafPushforwardLaxMonoidal}` (lem:presheaf_pushforward_laxmonoidal)
- **Lean target exists**: yes (line 1116)
- **Signature matches**: yes — `instance presheafPushforwardLaxMonoidal (φ : ...) : (PresheafOfModules.pushforward φ).LaxMonoidal`
- **Proof follows sketch**: yes — composite of strong-monoidal `pushforward₀OfCommRingCat` and lax `restrictScalars`
- **notes**: `\leanok` present in blueprint; no sorry

### `\lean{AlgebraicGeometry.Scheme.Modules.presheafPullbackOplaxMonoidal}` (lem:presheaf_pullback_oplaxmonoidal)
- **Lean target exists**: yes (line 1138)
- **Signature matches**: yes — `instance presheafPullbackOplaxMonoidal (φ) [...] : (PresheafOfModules.pullback φ).OplaxMonoidal`
- **Proof follows sketch**: yes — doctrinal `leftAdjointOplaxMonoidal`
- **notes**: `\leanok` present; no sorry

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap}` (lem:pullback_tensor_map)
- **Lean target exists**: yes (line 1199)
- **Signature matches**: yes — `(f : Y ⟶ X) (M N : X.Modules) : (pullback f).obj (tensorObj M N) ⟶ tensorObj ((pullback f).obj M) ((pullback f).obj N)`
- **Proof follows sketch**: yes — four-fold composite through sheafification
- **notes**: `\leanok` present; no sorry; map only (not asserted iso)

### `\lean{AlgebraicGeometry.Scheme.Modules.unitToPushforwardObjUnit_comp}` (lem:unitToPushforwardObjUnit_comp — inferred)
- **Lean target exists**: yes (line 861)
- **Signature matches**: yes — composition coherence for the pushforward unit comparison
- **Proof follows sketch**: yes — rfl after ext
- **notes**: `\leanok` present; no sorry

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_comp}` (lem:pullbackObjUnitToUnit_comp)
- **Lean target exists**: yes (line 902)
- **Signature matches**: yes — composition coherence for `pullbackObjUnitToUnit`; adj-mate transport from push-side
- **Proof follows sketch**: yes — uses `unit_conjugateEquiv`, `conjugateEquiv_pullbackComp_inv`, `Adj.comp_unit_app`
- **notes**: `\leanok` present; no sorry

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackUnitIso}` (lem:pullback_unit_iso)
- **Lean target exists**: yes (line 1045)
- **Signature matches**: yes — `(f : Y ⟶ X) : (pullback f).obj (SheafOfModules.unit X.ringCatSheaf) ≅ SheafOfModules.unit Y.ringCatSheaf`
- **Proof follows sketch**: yes — `(Opens.map f.base).Final` unconditionally via `final_of_representablyFlat`, no chart-chase needed
- **notes**: `\leanok` present; no sorry

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackLanDecomposition}` (lem:pullback_lan_decomposition)
- **Lean target exists**: yes (line 1291)
- **Signature matches**: yes — `(φ : S ⟶ F.op ⋙ R) : PresheafOfModules.pullback φ ≅ extendScalars φ ⋙ pullback0 F R`
- **Proof follows sketch**: yes — `leftAdjointCompIso` from the definitional factorisation
- **notes**: `\leanok` present; no sorry

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_natural}` (lem:pullback_tensor_map_natural — D1′)
- **Lean target exists**: **NO** — `pullbackTensorMap_natural` is absent from the Lean file; no declaration with this name exists anywhere in `TensorObjSubstrate.lean`
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: **Dangling `\lean{}` pin.** Blueprint block `lem:pullback_tensor_map_natural` (line 3218) is aspirational; no `\leanok`, so not falsely claiming done. Severity: **major**.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_unit_isIso}` (lem:pullback_tensor_iso_unit — D2′)
- **Lean target exists**: **NO** — confirmed absent; the prover explicitly did NOT add this declaration this iter (replaced by the reduction brick `isIso_pullbackTensorMap_of_isIso_sheafifyDelta`)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: **Dangling `\lean{}` pin. This is one of the three specific items in the directive.** Blueprint block `lem:pullback_tensor_iso_unit` (line 3259) was written this iter but the prover landed a more primitive reduction lemma (`isIso_pullbackTensorMap_of_isIso_sheafifyDelta`) instead of the full D2' result. No `\leanok` → not claiming done. The pin is stale but aspirational. Severity: **major**.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_restrict}` (lem:pullback_tensor_map_basechange — D3′)
- **Lean target exists**: **NO** — `pullbackTensorMap_restrict` absent from Lean file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: **Dangling `\lean{}` pin.** No `\leanok`; aspirational. Severity: **major**.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorIsoOfLocallyTrivial}` (lem:pullback_tensor_iso_loctriv — D4′)
- **Lean target exists**: **NO** — absent from Lean file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: **Dangling `\lean{}` pin.** No `\leanok`; aspirational. Severity: **major**.

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible.pullback}` (lem:isinvertible_pullback — corollary)
- **Lean target exists**: **NO** — absent from Lean file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: **Dangling `\lean{}` pin.** No `\leanok`; depends on D4′. Severity: **major**.

### `\lean{AlgebraicGeometry.LineBundle.OnProduct.pullback_tensorObj_iso}` (lem:pullback_compatible_with_tensorobj)
- **Lean target exists**: **NO** — `pullback_tensorObj_iso` is absent from this file (not in `TensorObjSubstrate.lean`; may be a planned `LineBundlePullback.lean` declaration)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: **Dangling `\lean{}` pin.** No `\leanok`; depends on D4′/`IsInvertible.pullback`. Severity: **major**.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorIso}` (lem:pullback_tensor_iso)
- **Lean target exists**: **NO** — absent; explicitly off the critical path (blueprint `% NOTE: ABANDONED general route`)
- **Signature matches**: N/A
- **notes**: Blueprint explicitly marks this as retained for the record only; not load-bearing. Severity: **minor** (aspirational, intentionally deferred).

### `\lean{AlgebraicGeometry.Scheme.Modules.pullback0TensorIso}` (lem:pullback0_tensor_iso)
- **Lean target exists**: **NO** — abandoned D3 route, explicitly off-path per blueprint NOTE
- **Signature matches**: N/A
- **notes**: Retained for record only. Severity: **minor**.

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible.isLocallyTrivial}` (lem:isinvertible_implies_locallytrivial)
- **Lean target exists**: **NO** in this file (explicitly off the critical path per blueprint NOTE)
- **Signature matches**: N/A
- **notes**: Blueprint marks this as not needed for `lem:isinvertible_pullback`; future ingredient for A.2.c. Severity: **minor**.

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_of_isIso_restrict}` (lem:isiso_of_isiso_restrict)
- **Lean target exists**: yes (line 546)
- **Signature matches**: yes — `(φ : M ⟶ N) (U : X → X.Opens) (hxU : ∀ x, x ∈ U x) (h : ∀ x, IsIso (...)) : IsIso φ`
- **Proof follows sketch**: yes — stalkwise iso criterion `TopCat.Presheaf.isIso_of_stalkFunctor_map_iso`
- **notes**: `\leanok` present; no sorry

### `\lean{AlgebraicGeometry.Scheme.Modules.homMk}` (lem:homMk)
- **Lean target exists**: yes (line 587)
- **Signature matches**: yes — wraps `PresheafOfModules.homMk` at scheme level with `hg` linearity
- **Proof follows sketch**: yes
- **notes**: `\leanok` present; no sorry

---

## Red Flags

### Placeholder / suspect bodies

- `exists_tensorObj_inverse` at line 694: body is `:= sorry`, and the blueprint block `lem:tensorobj_inverse_invertible` claims this is substantive. **However**: no `\leanok` in the blueprint (correct); the body comment is a detailed work-in-progress explanation (two genuine missing bridges C + A are named), NOT an excuse-comment. This sorry is correctly tracked and intentionally left by the project.

- `addCommGroup_via_tensorObj` at line 1406: body is `:= sorry`. Same status: no `\leanok`; the comment explains it depends on `exists_tensorObj_inverse`. Intentional.

These are **not** violations of the "no placeholder" rule because the blueprint correctly leaves them unmarked (`\leanok` absent); the sorries reflect accurately known incomplete work with detailed documentation of what remains.

### Excuse-comments

None. The body comments on `exists_tensorObj_inverse` (lines 676–693) are genuine mathematical documentation of remaining bridges (not "this is wrong but works for now"). They match the project's accepted workflow.

### Axioms / Classical.choice on non-trivial claims

- `picInv` (line 793) uses `Classical.choose a.2` to extract the tensor inverse from the existential `IsInvertible M`. This is intentional and matches the blueprint's proof sketch for `def:pic_carrier`; the `Classical.choice` is on a proof-irrelevant existential (the inverse witness), not on a substantive mathematical claim that could be wrong. Not a flag.
- No `axiom` declarations in this file.

---

## Unreferenced declarations (informational)

Declarations in `TensorObjSubstrate.lean` with no direct `\lean{...}` blueprint block:

| Declaration | Line | Status |
|---|---|---|
| `tensorObjIsoOfIso` | 242 | Helper for `tensorObj_isLocallyTrivial`; used in proof |
| `tensorObj_unit_iso` | 258 | Sub-piece of `tensorobj_unit_iso` blueprint proof; helper |
| `restrictIsoUnitOfLE` | 373 | Sub-step helper for `tensorObj_isLocallyTrivial` |
| `picSetoid`, `picMul`, `picInv` | 772, 784, 793 | Internal infrastructure for `picCommGroup` |
| `tensorObj_middleFour` | 730 (private) | Private helper for `IsInvertible.tensorObj` |
| `pullbackObjUnitToUnitIso`, `pullbackObjUnitToUnitIso_hom` | 1028, 1035 | Helper for `pullbackUnitIso`; the `@[simp]` accessor |
| `isIso_pbu_of_final` | 1020 (private) | Private helper for `pullbackUnitIso` |
| `sheafifyTensorUnitIso` | 1063 (private) | Private helper for `pullbackTensorMap` |
| `pullbackValIso` | 1182 | Sub-step helper for `pullbackTensorMap` |
| `pullback0`, `extendScalars` | 1260, 1268 | Carriers for D1; internal to `pullbackLanDecomposition` |
| `pullback0Adjunction`, `extendScalarsAdjunction` | 1274, 1280 | Helpers for `pullbackLanDecomposition` |
| `toPresheaf_map_homMk` | 595 | `@[simp]` accessor for `homMk` |
| **`isIso_pullbackTensorMap_of_isIso_sheafifyDelta`** | **1335** | **SUBSTANTIVE — see Blueprint Adequacy below** |
| `isIso_sheafify_tensorHom_pullbackValIso` | 1312 (private) | Private helper for the above |
| `dualIsoOfIso` | 207 | Helper for `dual_isLocallyTrivial`; no blueprint pin in this file |

Most of these are helpers. The critical outlier is `isIso_pullbackTensorMap_of_isIso_sheafifyDelta`.

---

## Blueprint adequacy for this file

### Coverage

- **Total `\lean{...}` blocks pointing into this file**: ~30 (counting all blueprint blocks whose target should live in `TensorObjSubstrate.lean`)
- **Targets that exist in Lean**: ~20 (formalized)
- **Targets that do NOT exist in Lean**: ~10 (aspirational pins, all lacking `\leanok`)
- **Substantive Lean declarations with NO blueprint block**: 1 (`isIso_pullbackTensorMap_of_isIso_sheafifyDelta`)

### Proof-sketch depth
**Adequate** for all formalized declarations. The implemented proofs (tensorObj_restrict_iso, tensorObj_assoc_iso, pullbackTensorMap, pullbackUnitIso, etc.) follow the blueprint sketches faithfully. The D1'-D4' blocks' proof sketches are also adequate in depth — they would guide a prover to the correct arguments. No case of a proof that went through significant reasoning the blueprint doesn't preview.

### Hint precision
**Precise** for formalized declarations. The only imprecise aspects are the aspirational D1'-D4' pins that point to future declarations — these are precision issues for the future, not current mismatches.

### Missing block for the landed reduction brick (MAJOR gap)

**`isIso_pullbackTensorMap_of_isIso_sheafifyDelta`** (Lean line 1335–1353) is a **non-sorry, axiom-clean, load-bearing reduction lemma** with no `\lean{...}` blueprint block. Its role: it reduces iso-ness of the full `pullbackTensorMap` composite to iso-ness of a single sheafified presheaf comparison `a_Y.map δ`. The Lean docstring explicitly describes it as "the shared entry point for D2'–D4'". This is not a trivial helper — it is the structural bottleneck isolating the genuine geometric content from the four surrounding infrastructure isos.

The current blueprint describes D2'-D4' as sub-lemmas that each reduce, via `isIso_pullbackTensorMap_of_isIso_sheafifyDelta`, to proving `IsIso (a_Y.map δ ...)`. But the reduction lemma itself has no blueprint block — a prover working from the blueprint alone would not know this intermediate result exists, what it says, or that it is already axiom-clean. This is a **blueprint-thinness gap**: the chapter lacks a block for a substantive landed result, reducing its value as a guide for the next iteration.

### Recommended chapter-side actions
1. **Add a `\begin{lemma}...\end{lemma}` block** for `isIso_pullbackTensorMap_of_isIso_sheafifyDelta` in section `sec:tensorobj_pullback_monoidality`, between the `pullbackTensorMap` block and the D1' block. The statement: "pullbackTensorMap f M N is an iso whenever the sheafified presheaf comparison `a_Y.map δ (pullback φ') M.val N.val` is an iso." Include `\lean{AlgebraicGeometry.Scheme.Modules.isIso_pullbackTensorMap_of_isIso_sheafifyDelta}` and a `\leanok` marker (the declaration is axiom-clean). Note that it is the shared entry point for D2'–D4'. Also add `\lean{...}` for the private helper `isIso_sheafify_tensorHom_pullbackValIso` optionally (or absorb in the proof sketch as a one-line helper).
2. **Update the D2' block** (`lem:pullback_tensor_iso_unit`) to reference `isIso_pullbackTensorMap_of_isIso_sheafifyDelta` explicitly in its `\uses{}` and proof sketch, clarifying that D2' proceeds by applying the reduction lemma first and then showing `IsIso (a_Y.map δ 𝟙_ 𝟙_)`.

---

## Directive-specific items

### Item 1: `\lean{pullbackTensorMap_unit_isIso}` pin integrity

Blueprint block `lem:pullback_tensor_iso_unit` (Picard_TensorObjSubstrate.tex, line 3259) pins:
```
\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_unit_isIso}
```

**Does the declaration exist in the Lean file?** **NO.** A grep for `pullbackTensorMap_unit_isIso` in `TensorObjSubstrate.lean` returns no matches. The prover's task result confirms: this declaration was NOT added this iter. The iter-245 prover landed `isIso_pullbackTensorMap_of_isIso_sheafifyDelta` (the reduction brick isolating the sole remaining content) instead of the full D2' result.

**Is this a dangling `\lean{}` pin?** **YES.** The pin points to a non-existent declaration.

**Should it be flagged?** **YES, severity: major.** The pin is aspirational (not `\leanok`, so `sync_leanok` will not falsely mark it done), but it is stale: the blueprint was rewritten this iter to describe the loc-triv route and the D2' block was added, yet the corresponding Lean declaration was not. A prover in the next iter reading `lem:pullback_tensor_iso_unit` and its `\lean{pullbackTensorMap_unit_isIso}` hint will know exactly what to build; that is good. However, the `\lean{}` pin is forward-aspirational and should be explicitly noted as such (e.g., with a `% NOTE: not yet formalized — apply isIso_pullbackTensorMap_of_isIso_sheafifyDelta first`) to distinguish it from stale pins for abandoned declarations. Recommend the plan agent add such a note when the blueprint-writing subagent fills in the reduction-brick block.

### Item 2: Coverage of the new reduction brick

**`isIso_pullbackTensorMap_of_isIso_sheafifyDelta`** exists in the Lean file (lines 1335–1353), is axiom-clean, and has no sorry. There is **no `\lean{...}` blueprint block** for it anywhere in `Picard_TensorObjSubstrate.tex`.

**Is this a gap the plan agent should fill?** **YES.** This is a **major** blueprint-thinness gap:
- The declaration is load-bearing (entry point for D2'-D4')
- It is landed and axiom-clean this iter
- Without a blueprint block, the chapter gives no guidance to a future prover on what has already been done, and no `\leanok` can be attached to it
- The `sync_leanok` process cannot track it (no `\lean{...}` pin → no `\leanok` sync target)

**Recommended action:** Dispatch the blueprint-writing subagent to add a lemma block for `isIso_pullbackTensorMap_of_isIso_sheafifyDelta` in the loc-triv subsection of `sec:tensorobj_pullback_monoidality`, with `\leanok` (it deserves it — it is clean and non-trivial).

### Item 3: Fidelity of D1'–D4' prose

The blueprint section `sec:tensorobj_pullback_monoidality` was rewritten this iter to describe the loc-triv chart-chase route. Assessing each D-block:

**D1' (`lem:pullback_tensor_map_natural`, `pullbackTensorMap_natural`):**
- Not built (no Lean declaration). Blueprint pin is aspirational.
- Blueprint proof sketch: naturality of `pullbackTensorMap` as pasting of naturality squares. Adequate and correct — it matches what a formalization would need.
- Chapter describes this as *to be proved*, not as done. No fidelity failure.

**D2' (`lem:pullback_tensor_iso_unit`, `pullbackTensorMap_unit_isIso`):**
- Not built (no Lean declaration). Blueprint pin is aspirational.
- Blueprint proof sketch: use `pullbackUnitIso` (an iso for every f) + oplax monoidal unit coherence to identify δ(𝒪,𝒪) with the identity. This is mathematically correct and adequate.
- The Lean file's D2' handoff comment (lines 1358-1371) adds: D2' should proceed by first applying `isIso_pullbackTensorMap_of_isIso_sheafifyDelta`, then reducing `δ(𝟙_,𝟙_)` using `Functor.OplaxMonoidal.left_unitality_hom` to the genuine sub-goal `IsIso (a_Y.map η (PresheafOfModules.pullback φ'))`. This refinement is NOT yet in the blueprint's D2' proof sketch — the blueprint says to use unit coherence directly, which is the mathematical content but skips the intermediate `isIso_pullbackTensorMap_of_isIso_sheafifyDelta` reduction step. Minor underspecification.

**D3' (`lem:pullback_tensor_map_basechange`, `pullbackTensorMap_restrict`):**
- Not built. Blueprint proof sketch: mate calculus using `Functor.OplaxMonoidal.comp_δ` to decompose the restriction. Adequate; mirrors the `pullbackObjUnitToUnit_comp` proof pattern (which IS axiom-clean). A prover can follow this.

**D4' (`lem:pullback_tensor_iso_loctriv`, `pullbackTensorIsoOfLocallyTrivial`):**
- Not built. Blueprint proof sketch: common trivialising cover → D3' reduces to D2' via naturality → D2' closes → `isIso_of_isIso_restrict` globalises. Detailed and adequate.
- No block in the chapter is describing as *done* something that is actually sorry/absent. All four D1'-D4' blocks lack `\leanok` (correctly).

**Overall fidelity:** The D1'-D4' prose is mathematically faithful and adequate to guide formalization. The chapter correctly does not claim any of D1'-D4' are done. The only fidelity gap is that the D2' proof sketch does not yet mention `isIso_pullbackTensorMap_of_isIso_sheafifyDelta` as the first step — a detail that matters because the next prover will need to apply this reduction before tackling the `δ` goal.

---

## Severity summary

- **must-fix-this-iter**: none (no placeholder bodies on blueprint-claimed-done declarations, no axioms, no wrong signatures on existing declarations)
- **major**:
  1. `lem:pullback_tensor_iso_unit` (`pullbackTensorMap_unit_isIso`) — dangling `\lean{}` pin (no Lean declaration), specifically flagged by the directive
  2. `lem:pullback_tensor_map_natural` (`pullbackTensorMap_natural`) — dangling `\lean{}` pin
  3. `lem:pullback_tensor_map_basechange` (`pullbackTensorMap_restrict`) — dangling `\lean{}` pin
  4. `lem:pullback_tensor_iso_loctriv` (`pullbackTensorIsoOfLocallyTrivial`) — dangling `\lean{}` pin
  5. `lem:isinvertible_pullback` (`IsInvertible.pullback`) — dangling `\lean{}` pin
  6. `lem:pullback_compatible_with_tensorobj` (`pullback_tensorObj_iso`) — dangling `\lean{}` pin
  7. **Blueprint-thinness gap**: `isIso_pullbackTensorMap_of_isIso_sheafifyDelta` (Lean line 1335) is a landed, axiom-clean, load-bearing reduction lemma with **no blueprint block** and no `\leanok` tracking target; the plan agent should dispatch the blueprint-writing subagent to fill this gap
- **minor**:
  1. `lem:pullback_tensor_iso` (`pullbackTensorIso`) — dangling pin for intentionally abandoned general route
  2. `lem:pullback0_tensor_iso` (`pullback0TensorIso`) — dangling pin for off-path D3
  3. `lem:isinvertible_implies_locallytrivial` (`IsInvertible.isLocallyTrivial`) — dangling pin, explicitly off-path
  4. D2' proof sketch does not mention `isIso_pullbackTensorMap_of_isIso_sheafifyDelta` as the first step (minor underspecification)

**Overall verdict:** The formalized declarations in `TensorObjSubstrate.lean` are faithful to the blueprint; the two sorries (`exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`) are correctly unfinished with adequate documentation; no axiom or wrong-signature violations exist. The section's major issue is that the iter-245 landing of `isIso_pullbackTensorMap_of_isIso_sheafifyDelta` (the D2'–D4' reduction brick) is not reflected in the blueprint with a `\lean{...}` block, and six blueprint `\lean{...}` pins in the D1'–D4' / corollary stack point to non-existent declarations (all aspirational, all correctly lacking `\leanok`).
