# Lean ↔ Blueprint Check Report

## Slug
snap-iter056

## Iteration
057

## Files audited
- Lean: `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/SectionGradedRing.lean`
- Blueprint: `/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_SectionGradedRing.tex`

---

## Per-declaration

All `\leanok`-marked declarations in the blueprint were verified against the Lean file. Only
the iter-056 additions and the deferred/absent items are discussed in detail; the earlier
strata (iter-051 through iter-053) are also surveyed below for completeness.

### `\lean{AlgebraicGeometry.Scheme.Modules.sheafification}` (`def:schemeModuleSheafification`) — \leanok
- **Lean target exists**: yes (line 70)
- **Signature matches**: yes — `X.PresheafOfModules ⥤ X.Modules`, specialised to `𝟙 X.ringCatSheaf.obj`, matching the blueprint description.
- **Proof follows sketch**: N/A (definition body)
- **notes**: clean

### `\lean{AlgebraicGeometry.Scheme.Modules.MonoidalPresheaf}` (`def:monoidalPresheaf`) — \leanok
- **Lean target exists**: yes (line 79, `private abbrev`)
- **Signature matches**: yes — `PresheafOfModules.{u} (X.sheaf.obj ⋙ forget₂ CommRingCat RingCat)`, matching the "exact form for which Mathlib equips it with the symmetric monoidal structure".
- **Proof follows sketch**: N/A
- **notes**: declared `private`; see "Private declarations" note in Blueprint adequacy.

### `\lean{AlgebraicGeometry.Scheme.Modules.unitModule}` (`def:unitModule`) — \leanok
- **Lean target exists**: yes (line 94, `private noncomputable abbrev`)
- **Signature matches**: yes — `SheafOfModules.unit X.ringCatSheaf`, matching the blueprint.
- **notes**: declared `private`.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (`def:sheafTensorObj`) — \leanok
- **Lean target exists**: yes (line 86)
- **Signature matches**: yes — sheafification of the presheaf-level `tensorObj` of the underlying presheaves, exactly as the blueprint describes (Stacks Tag 01CA).
- **notes**: clean

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorPow}` (`def:sheafTensorPow`) — \leanok
- **Lean target exists**: yes (line 100)
- **Signature matches**: yes — recursion: base `unitModule X`, step `tensorObj (tensorPow L m) L`, matching L^0 = O_X and L^(m+1) = L^m ⊗ L.
- **notes**: clean

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorPow_zero}` / `tensorPow_succ` — \leanok
- **Lean target exists**: yes (lines 104, 106, both `@[simp] private lemma`)
- **Signature matches**: yes — `:= rfl` is correct since these are definitional equalities.
- **notes**: declared `private`; `:= rfl` is appropriate (not a suspect body — the lemma IS trivial by definition).

### `\lean{AlgebraicGeometry.Scheme.Modules.moduleTensorPow}` (`def:sheafModuleTwist`) — \leanok
- **Lean target exists**: yes (line 112)
- **Signature matches**: yes — `tensorObj F (tensorPow L m)`, matching `F(m) = F ⊗ L^m`.
- **notes**: clean

### `\lean{AlgebraicGeometry.Scheme.Modules.moduleTensorPow_zero}` — \leanok
- **Lean target exists**: yes (line 115, `@[simp] private lemma`)
- **Signature matches**: yes — `:= rfl` appropriate (definitional equality).
- **notes**: clean

### `\lean{AlgebraicGeometry.Scheme.Modules.sheafificationCounitIso}` — \leanok
- **Lean target exists**: yes (line 131, `private noncomputable def`)
- **Signature matches**: yes — `sheafification.obj ((toPresheafOfModules X).obj G) ≅ G` via the adjunction counit, as described.
- **notes**: declared `private`.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjUnitIso}` — \leanok
- **Lean target exists**: yes (line 140, `private noncomputable def`)
- **Signature matches**: yes — `tensorObj (unitModule X) G ≅ G` via `sheafification.mapIso (leftUnitor ...)` composed with the counit iso, exactly as the blueprint says.
- **notes**: declared `private`.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjRightUnitor}` — \leanok
- **Lean target exists**: yes (line 151, `private noncomputable def`)
- **Signature matches**: yes — `tensorObj G (unitModule X) ≅ G` via `sheafification.mapIso (rightUnitor ...)` composed with the counit iso.
- **notes**: declared `private`.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorBraiding}` — \leanok
- **Lean target exists**: yes (line 164, `private noncomputable def`)
- **Signature matches**: yes — `tensorObj F G ≅ tensorObj G F` via `sheafification.mapIso (BraidedCategory.braiding ...)`, matching the blueprint.
- **notes**: declared `private`.

### `\lean{AlgebraicGeometry.Scheme.Modules.sectionsMul}` (`def:sectionMul`) — \leanok
- **Lean target exists**: yes (line 188)
- **Signature matches**: yes — the domain is `(PresheafOfModules.monoidalCategory tensorObj ...)  .obj (Opposite.op ⊤)` (the top-open value of the tensor presheaf, i.e. `Γ(X,F) ⊗_{Γ(X,O_X)} Γ(X,G)`) mapping to `(tensorObj F G).val.obj (Opposite.op ⊤)` (i.e. `Γ(X, F⊗G)`). Matches blueprint description.
- **notes**: clean

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_sheafification_map_iff}` — \leanok
- **Lean target exists**: yes (line 218)
- **Signature matches**: yes — `IsIso (sheafification.map f) ↔ (opensTopology X).W (...)`, exactly the localization criterion of the blueprint.
- **Proof follows sketch**: yes — uses `PresheafOfModules.inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms` to convert between the two formulations, as the blueprint describes.
- **notes**: clean

### `\lean{AlgebraicGeometry.Scheme.Modules.localIso_toPresheaf_map_unit}` — \leanok
- **Lean target exists**: yes (line 243)
- **Signature matches**: yes — `(opensTopology X).W (toPresheaf.map (η_P))` proved via `W_toSheafify`, as the blueprint says.
- **Proof follows sketch**: yes
- **notes**: clean

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_sheafification_map_unit}` — \leanok
- **Lean target exists**: yes (line 255)
- **Signature matches**: yes — `IsIso (sheafification.map (η_P))` via `(isIso_sheafification_map_iff _).mpr (localIso_toPresheaf_map_unit P)`.
- **notes**: clean

### `\lean{AlgebraicGeometry.Scheme.Modules.relTensorDomainPresheaf}` (`def:relTensorDomainPresheaf`) — \leanok
- **Lean target exists**: yes (line 450)
- **Signature matches**: yes — functor `(Opens X)^op ⥤ Ab`, `obj U = P.obj U ⊗[ℤ] Q.obj U`, restriction maps the ℤ-tensor of the underlying restriction maps; functoriality proved by TensorProduct induction.
- **notes**: clean

### `RelativeTensorCoequalizer.*` (22 declarations) (`lem:relativeTensor_objectwise_coequalizer`)
- **Lean targets exist**: yes (lines 287–420, all 22 declarations present)
- **Signature matches**: yes for all — `actN`, `actM`, `actLmap`, `actRmap` match the ℤ-linear action maps; `projL`/`piMor` match the quotient map; `cofork`/`isColimitCofork` match the colimit data; simp lemmas `_tmul`/`_apply` match the computational rules; `piMor_epi` is an instance (not a def); `descHom`/`descMor`/`descFac` match the descent data.
- **Proof follows sketch**: yes — `isColimitCofork` uses `TensorProduct.liftAddHom` + `cancel_epi` exactly as the blueprint proof describes.
- **notes**: No `\leanok` on `lem:relativeTensor_objectwise_coequalizer` in the blueprint despite memory showing this was closed axiom-clean in iter-053. This is a **pre-existing anomaly** (not an iter-056 issue) — see Informational note below.

### Deferred / absent declarations (correctly absent, no sorry)
- `relativeTensorCoequalizerIso` (`lem:relativeTensor_as_coequalizer`) — **absent** from Lean, no `\leanok` in blueprint. Correct.
- `isIso_sheafification_whiskerRight_unit` — **absent**, no `\leanok`. Correct.
- `tensorObjAssoc` (`cor:sheafTensorObjAssoc`) — **absent**, no `\leanok`. Correct.
- `tensorPowAdd` (`lem:sheafTensorPow_add`) — **absent**, no `\leanok`. Correct.
- `sectionsMul_assoc_unit` (`lem:sectionMul_coherent`) — **absent**, no `\leanok`. Correct.
- `AlgebraicGeometry.sectionGradedRing_gcommSemiring` — **absent**, no `\leanok`. Correct.
- `AlgebraicGeometry.sectionGradedModule_gmodule` — **absent**, no `\leanok`. Correct.

These follow the project convention: deferred work is recorded as absent (no sorry) in the Lean file and as untagged (no `\leanok`) in the blueprint. Compliant.

---

## Red flags

**None.** The Lean file has:
- No `:= sorry` on any declaration.
- No `:= True` or other suspect bodies.
- No `axiom` declarations.
- No excuse-comments on any substantive declaration.

The extensive block comments (`/- ... -/`) at lines 504–641 and 643–758 are handoff notes — legitimate workflow documentation for deferred work (the `relTensorActL` carrier-gap blocker and the `tensorPowAdd` strong-monoidality gap). These are NOT code and are NOT attached to any substantive declaration as an excuse. The pattern is correct: deferred work has no Lean code at all (rather than sorry-backed code), and the blueprint correctly has no `\leanok` on those blocks.

The iter-056 addition `relTensorTriplePresheaf` (lines 476–502) has a complete, non-sorry body with real proofs of `map_id` and `map_comp` by TensorProduct induction. ✅

---

## Unreferenced declarations (informational)

The following Lean declarations have no corresponding `\lean{...}` block in the blueprint:

| Declaration | Line | Type | Assessment |
|---|---|---|---|
| `relTensorTriplePresheaf` | 476 | `noncomputable def` | **Substantive — should be blueprinted** (see below) |
| `opensTopology` | 205 | `private abbrev` | Helper, acceptable |
| `sheafificationCounitIso` | 131 | `private noncomputable def` | IS referenced via `def:sheafificationCounitIso` — no gap |

**Note**: `sheafificationCounitIso` IS blueprinted (line 301 in the chapter, `\leanok`). The only unreferenced substantive declaration is `relTensorTriplePresheaf`.

---

## Blueprint adequacy for this file

### `relTensorTriplePresheaf` — missing blueprint block **(MAJOR)**

`relTensorTriplePresheaf` (line 476) defines the functor
`U ↦ Γ(U,P) ⊗_ℤ (O_X(U) ⊗_ℤ Γ(U,Q))`, the **domain row** of the relative-tensor
coequalizer cofork. It is a direct peer of `relTensorDomainPresheaf` (which has a
dedicated `def:relTensorDomainPresheaf` block with `\leanok`) and is equally
substantive: it is the Lean object on which the two `R(U)`-action maps
`actLmap`/`actRmap` act in the presheaf-level promotion step.

The blueprint discusses this presheaf informally in the proof sketch of
`lem:relativeTensor_as_coequalizer` (as "P ⊗_ℤ O_X ⊗_ℤ Q"), but has **no**
dedicated `\lean{...}` block for it. A blueprint block `def:relTensorTriplePresheaf`
with `\lean{AlgebraicGeometry.Scheme.Modules.relTensorTriplePresheaf}` and `\uses{lem:presheafModule_monoidal_mathlib}` should be added as a sibling of
`def:relTensorDomainPresheaf`.

### Action nat-trans over-claim check — **PASS**

`lem:relativeTensor_as_coequalizer` has `\lean{AlgebraicGeometry.Scheme.Modules.relativeTensorCoequalizerIso}` but **no `\leanok`**. The blueprint does NOT claim the presheaf-level action nat-trans `relTensorActL`/`relTensorActR`/`relTensorProj` are formalized. The blocked work is documented only in handoff comments inside `/- ... -/` blocks, not as Lean code. The blueprint is honest here. ✅

### `lem:relativeTensor_objectwise_coequalizer` missing `\leanok` — **informational anomaly**

The memory records `isColimitCofork` as axiom-clean since iter-053 (4 iters ago), and all 22 `\lean{...}` targets of this lemma block exist with complete proofs in the Lean file. Yet the blueprint block has no `\leanok`. This suggests a possible `sync_leanok` edge case with multi-lean blocks (not an iter-056 issue). The review agent should verify `sync_leanok` handles multi-lean blocks for `lem:relativeTensor_objectwise_coequalizer` correctly.

### Private declarations blueprinted — **minor**

Nine declarations are `private` in Lean (`MonoidalPresheaf`, `unitModule`, `tensorPow_zero`, `tensorPow_succ`, `moduleTensorPow_zero`, `sheafificationCounitIso`, `tensorObjUnitIso`, `tensorObjRightUnitor`, `tensorBraiding`) yet have dedicated `\lean{...}` blocks with `\leanok` in the blueprint. These are correctly axiom-clean infrastructure; the `private` modifier prevents external use by name but is acceptable for sheafification-level helpers. The blueprint-side `\lean{...}` references are valid as informal bookkeeping, though technically a `lean_verify` call on a `private` declaration would need the fully-qualified name in context. No mathematical concern.

### Coverage, depth, generality
- **Coverage**: ~40 of 41 formalized Lean declarations have a `\lean{...}` block. Unreferenced: 1 substantive (`relTensorTriplePresheaf`), 1 helper (`opensTopology`).
- **Proof-sketch depth**: adequate for formalized blocks; deferred blocks correctly have no `\leanok` and no Lean code.
- **Hint precision**: precise — all `\lean{...}` tags match the actual Lean names.
- **Generality**: matches need.

### Recommended chapter-side actions
- **Add** a `\begin{definition}[Triple-tensor domain presheaf] \label{def:relTensorTriplePresheaf} \lean{AlgebraicGeometry.Scheme.Modules.relTensorTriplePresheaf} \uses{lem:presheafModule_monoidal_mathlib} ... \end{definition}` block (with `\leanok` to be added by `sync_leanok`) immediately after `def:relTensorDomainPresheaf`. The informal description: "The assignment U ↦ Γ(U,P) ⊗_ℤ (O_X(U) ⊗_ℤ Γ(U,Q)) is a functor (Opens X)^op → Ab, the domain row of the coequalizer cofork of lem:relativeTensor_as_coequalizer."
- **Investigate** `sync_leanok`'s handling of multi-lean blocks: `lem:relativeTensor_objectwise_coequalizer` should have `\leanok` if all 22 targets are axiom-clean.

---

## Severity summary

| Finding | Severity |
|---|---|
| `relTensorTriplePresheaf` has no `\lean{...}` blueprint block (substantive def) | **major** |
| `lem:relativeTensor_objectwise_coequalizer` missing `\leanok` despite iter-053 closed (pre-existing, `sync_leanok` anomaly) | **informational** |
| Nine `private` Lean decls have blueprint `\lean{...}` blocks | **minor** |

No **must-fix-this-iter** findings. No placeholder bodies, no sorry, no axiom, no excuse-comments, no signature mismatches. The iter-056 addition (`relTensorTriplePresheaf`) is clean.

**Overall verdict**: The Lean file for iter-056 is axiom-clean and all formalized declarations faithfully implement their blueprint counterparts; the single gap is a missing blueprint block for the newly-added `relTensorTriplePresheaf` definition (major, but does not block formalization progress on the deferred coequalizer chain).
