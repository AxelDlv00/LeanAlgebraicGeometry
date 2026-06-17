# Lean ↔ Blueprint Check Report

## Slug
ts213

## Iteration
213

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (chapter: `def:scheme_modules_tensorobj`)
- **Lean target exists**: yes (L499)
- **Signature matches**: yes — `M N : X.Modules → X.Modules`, defined as sheafification of `PresheafOfModules.Monoidal.tensorObj M.val N.val`, exactly as the blueprint describes
- **Proof follows sketch**: yes / N/A — definition body matches the blueprint's "sheafification of the presheaf-level tensor product" description
- **notes**: complete, no sorry

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` (chapter: `lem:scheme_modules_tensorobj_functoriality`)
- **Lean target exists**: yes (L515)
- **Signature matches**: yes — takes `f : M ⟶ M'`, `g : N ⟶ N'`, returns `tensorObj M N ⟶ tensorObj M' N'`
- **Proof follows sketch**: yes — inherits from `PresheafOfModules.Monoidal.tensorObj` under sheafification as described
- **notes**: complete, no sorry

---

### `\lean{PresheafOfModules.restrictScalarsLaxMonoidal}` (chapter: `lem:restrictscalars_laxmonoidal`)
- **Lean target exists**: yes (L147), with helpers `restrictScalarsLaxε` (L114) and `restrictScalarsLaxμ` (L130)
- **Signature matches**: yes — instance over `CommRingCat`-valued presheaves of rings, assembles lax monoidal structure sectionwise
- **Proof follows sketch**: yes — exactly the sectionwise lift from `ModuleCat.restrictScalars` described in the blueprint proof
- **notes**: complete, no sorry; off the critical path as documented

---

### `\lean{PresheafOfModules.W_whiskerLeft_of_flat, PresheafOfModules.W_whiskerRight_of_flat}` (chapter: `lem:flat_whisker_localizer`)
- **Lean target exists**: yes (L332, L348); helper `isLocallyInjective_whiskerLeft_of_flat` (L255) and `isLocallySurjective_whiskerLeft` (L222) also present
- **Signature matches**: yes — both take `[∀ X, Module.Flat (R.obj X) (F.obj X)]` flatness hypothesis and `g ∈ J.W`, conclude `F ◁ g ∈ J.W` and `g ▷ F ∈ J.W` respectively
- **Proof follows sketch**: yes — local surjectivity by right-exactness, local injectivity by `Module.Flat.lTensor_exact` as described
- **notes**: complete, no sorry; `\leanok` absent from the statement block — this is a `sync_leanok` gap (**minor**, automated phase's responsibility). The blueprint correctly notes these are off the associator critical path.

---

### `\lean{PresheafOfModules.isIso_sheafification_map_of_W}` (chapter: `lem:isiso_sheafification_map_of_W`)
- **Lean target exists**: yes (L464)
- **Signature matches**: yes — takes `hf : J.W ((toPresheaf _).map f)`, concludes `IsIso ((sheafification α).map f)` via `inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms`
- **Proof follows sketch**: yes — one-line reading of the structural identity as described
- **notes**: complete, no sorry

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso}` (chapter: `lem:tensorobj_assoc_iso`)
- **Lean target exists**: yes (L659)
- **Signature matches**: yes — `(hM : LineBundle.IsLocallyTrivial M) (hN : ...) (hP : ...) : tensorObj (tensorObj M N) P ≅ tensorObj M (tensorObj N P)`. Matches blueprint signature exactly.
- **Proof follows sketch**: **partial** — **route mismatch** (see Red Flags below)
- **notes**: the body has no direct `sorry`, but calls `W_whiskerRight_of_W` / `W_whiskerLeft_of_W` which delegate to `isLocallyInjective_whiskerLeft_of_W` (sorry). Three-step composite structure (absorb left / presheaf assoc / absorb right) is present and matches the blueprint's step numbering. However the mathematical content of steps 1 and 3 diverges — see Route Mismatch section.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_left_unitor, AlgebraicGeometry.Scheme.Modules.tensorObj_right_unitor}` (chapter: `lem:tensorobj_unit_iso`)
- **Lean target exists**: yes (L589, L599); also `tensorObj_unit_iso` helper (L576) not separately pinned
- **Signature matches**: yes — `O_X ⊗_X M ≅ M` and `M ⊗_X O_X ≅ M` as stated
- **Proof follows sketch**: yes — `sheafification.mapIso` of the presheaf left/right unitor composed with the sheafification counit
- **notes**: complete, no sorry; **`\leanok` absent from the statement block** — `sync_leanok` gap (**minor**). No `tensorObj_unit_iso` (the unit ⊗ unit helper) is separately pinned; it is a helper and the omission is fine.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_braiding}` (chapter: `lem:tensorobj_comm_iso`)
- **Lean target exists**: yes (L609)
- **Signature matches**: yes — `M ⊗_X N ≅ N ⊗_X M`
- **Proof follows sketch**: yes — `sheafification.mapIso` of the presheaf braiding
- **notes**: complete, no sorry

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso}` (chapter: `lem:tensorobj_restrict_iso`)
- **Lean target exists**: yes (L760)
- **Signature matches**: yes — `(M ⊗_X N).restrict f ≅ tensorObj (M.restrict f) (N.restrict f)` for open immersion `f`
- **Proof follows sketch**: partial — Steps 1–3 of the Lean proof implement the blueprint's Step 1 (reduce to pullback via `restrictFunctorIsoPullback`), Step 2 (move pullback inside sheafification via `sheafificationCompPullback`), and strip the outer sheafification. Step 4 (the presheaf-level comparison) is `sorry`, correctly identified in both blueprint ("deferred") and Lean as a genuine residual requiring Mathlib-absent ingredients (H1 + H2). The extended commentary in the Lean body identifying the exact obstacle is more detailed than the blueprint's Step 3 prose but does not contradict it.
- **notes**: sorry in step 4 — consistent with `\leanok` on statement block (scaffold present); off critical path as documented

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_isLocallyTrivial}` (chapter: `lem:tensorobj_preserves_locally_trivial`)
- **Lean target exists**: yes (L842)
- **Signature matches**: yes — `(hM : IsLocallyTrivial M) (hN : IsLocallyTrivial N) → IsLocallyTrivial (tensorObj M N)`
- **Proof follows sketch**: yes — picks common affine open, refines trivialisations via `restrictIsoUnitOfLE`, then chains `tensorObj_restrict_iso ≪≫ tensorObjIsoOfIso ≪≫ tensorObj_unit_iso`
- **notes**: depends on `tensorObj_restrict_iso` (sorry), so the proof has a transitive sorry; consistent with the blueprint's acknowledgment that `tensorObj_restrict_iso` is the "only residual gap"

---

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible}` (chapter: `def:scheme_modules_isinvertible`)
- **Lean target exists**: yes (L528)
- **Signature matches**: yes — `∃ N, Nonempty (tensorObj M N ≅ SheafOfModules.unit X.ringCatSheaf)`, matches blueprint `IsInvertible(M) :≡ ∃ N, Nonempty(M ⊗_X N ≅ O_X)`
- **Proof follows sketch**: N/A (definition)
- **notes**: complete

---

### `\lean{AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse}` (chapter: `lem:tensorobj_inverse_invertible`)
- **Lean target exists**: yes (L868)
- **Signature matches**: yes — `(hL : IsLocallyTrivial L) → ∃ Linv, IsLocallyTrivial Linv ∧ Nonempty (tensorObj L Linv ≅ SheafOfModules.unit X.ringCatSheaf)`
- **Proof follows sketch**: N/A (body is `sorry`; blueprint explicitly marks this off critical path with a `% NOTE:` comment)
- **notes**: sorry body; consistent with `\leanok` on statement

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjOnProduct}` (chapter: `lem:tensorobj_lift_onproduct`)
- **Lean target exists**: yes (L880)
- **Signature matches**: **partial** — Lean takes `L L' : LineBundle.OnProduct πC πT` (the `IsLocallyTrivial` subtype from `LineBundlePullback.lean`) and produces a `LineBundle.OnProduct πC πT` by applying `tensorObj_isLocallyTrivial`. Blueprint's prose claims the carrier is the `IsInvertible` subtype (`LineBundle.OnProduct πC πT = {M | IsInvertible M}`), which contradicts the Lean type. The `\lean{...}` name is correct but the prose description of `LineBundle.OnProduct`'s underlying predicate is wrong.
- **Proof follows sketch**: no — blueprint proof uses `IsInvertible`, `tensorObj_isoclass_commgroup`, and the coherence isomorphisms; Lean body uses only `tensorObj_isLocallyTrivial` directly. Completely different implementation.
- **notes**: **major** blueprint-side prose error: the blueprint misidentifies `LineBundle.OnProduct` as an `IsInvertible`-based subtype; the Lean uses `IsLocallyTrivial`. The `\uses{lem:tensorobj_isoclass_commgroup}` and `\uses{def:scheme_modules_isinvertible}` annotations are therefore incorrect for this declaration.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjIsoclassCommMonoid}` (chapter: `lem:tensorobj_isoclass_commgroup`)
- **Lean target exists**: **no** — no declaration named `tensorObjIsoclassCommMonoid` exists anywhere in the Lean file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: The blueprint has no `\leanok` here, correctly reflecting that there is no Lean scaffold. The declaration is pinned but unscaffolded. Since `tensorObjOnProduct` (which the blueprint says uses this) actually uses a different route (`tensorObj_isLocallyTrivial`), the downstream consequence of the missing `tensorObjIsoclassCommMonoid` on critical-path consumers is not immediate. However, `lem:tensorobj_isoclass_commgroup` is consumed by the proof of `thm:rel_pic_addcommgroup_via_tensorobj` in the blueprint, so eventually this must be provided.

---

### `\lean{AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj}` (chapter: `thm:rel_pic_addcommgroup_via_tensorobj`)
- **Lean target exists**: yes (L908)
- **Signature matches**: yes — `AddCommGroup (Quotient (RelPicPresheaf.preimage_subgroup πC πT))`
- **Proof follows sketch**: N/A (body is `sorry`; this is the iter-204+ closure target)
- **notes**: sorry body; consistent with `\leanok` on statement

---

## Red Flags

### Route mismatch — `tensorObj_assoc_iso` proof diverges from blueprint sketch

**Lean (ROUTE d, stalkwise):** Steps 1 and 3 of the three-step composite invoke `W_whiskerRight_of_W` and `W_whiskerLeft_of_W` respectively (lines 688–693 of the Lean file). These lemmas prove that whiskering an *arbitrary* module by a *locally bijective* (∈ J.W) morphism preserves local bijectivity — via the stalkwise argument that a J.W-map is a stalkwise isomorphism, and tensoring an iso by id gives an iso, requiring no flatness or local triviality. The `IsLocallyTrivial` hypotheses `hM`, `hN`, `hP` are received but **not consumed** anywhere in the proof body (Lean comment: "the locally-trivial hypotheses are not even consumed").

**Blueprint (locally-trivial-cover route):** The proof sketch for `lem:tensorobj_assoc_iso` (§ "The key claim", blueprint lines 726–766) describes checking local injectivity of the whiskered unit after passing to a trivialising cover on which `F` restricts to `O_X`, then using the right unitor to reduce to `isLocallyInjective_toSheafify`. This is a cover-based argument that **requires** and consumes the `IsLocallyTrivial` hypothesis. The blueprint explicitly writes: "The sieve bookkeeping is exactly that of the flat-whiskering injectivity argument `isLocallyInjective_whiskerLeft_of_flat`; its `Module.Flat.lTensor_exact` injectivity step is the only thing swapped — replaced here by the trivialisation F^♭(V) ≅ O_X(V) on the cover and the right unitor."

**Source of truth:** The Lean side. The locally-trivial cover route has been superseded by ROUTE (d) (confirmed in the iter-212 finding documented in the Lean comments: flatness over non-affine opens is false for invertible sheaves, and the locally-trivial cover route effectively avoids that by using triviality — but the stalkwise route is cleaner and more general). The blueprint's `lem:tensorobj_assoc_iso` proof block needs to be updated to describe ROUTE (d): the key claim should say "for **arbitrary** F and **locally bijective** g ∈ J.W, the whiskered F ◁ g is locally bijective, because g_x is a stalkwise isomorphism so id ⊗ g_x is a stalkwise isomorphism." The locally trivial hypotheses on M, N, P should be explained as retained for the blueprint signature match, not as proof ingredients.

**Severity: major** — proof sketch mathematically diverges from Lean implementation; blueprint needs updating.

---

### Three new WhiskerOfW lemmas have no `\lean{...}` blueprint pins

The following substantive declarations introduced in iter-213 appear in the Lean file but have NO corresponding `\lean{...}` pin in the blueprint chapter:

| Declaration | Line | Status | Role |
|---|---|---|---|
| `PresheafOfModules.isLocallyInjective_whiskerLeft_of_W` | L411 | **sorry** | Load-bearing sole residual of `tensorObj_assoc_iso` |
| `PresheafOfModules.W_whiskerLeft_of_W` | L427 | complete | ROUTE (d) replacement for `W_whiskerLeft_of_flat` |
| `PresheafOfModules.W_whiskerRight_of_W` | L440 | complete | ROUTE (d) replacement for `W_whiskerRight_of_flat` |

The blueprint's `lem:flat_whisker_localizer` is pinned only to `W_whiskerLeft_of_flat` and `W_whiskerRight_of_flat` (the flat-hypothesis versions). The three flatness-free variants live in a separate `WhiskerOfW` section of the Lean file with no corresponding blueprint block.

`isLocallyInjective_whiskerLeft_of_W` is particularly critical: it is the **sole sorry** in the `tensorObj_assoc_iso` chain and the genuine remaining obstacle to the associator's closure. Its docstring documents the two missing Mathlib ingredients (d.1: module-level stalk characterisation of J.W on `Opens X`; d.2: stalk/tensor commutation for `PresheafOfModules`). This sorry should be a visible open obligation in the blueprint.

**Severity: must-fix-this-iter** — the load-bearing open sorry is invisible in the blueprint; a blueprint-writer should add a dedicated lemma block (e.g. `lem:isLocallyInjective_whiskerLeft_of_W`) pinned to this declaration, with its sorry body and the two missing Mathlib ingredients documented as the residual.

---

### `tensorObjOnProduct` carrier predicate wrong in blueprint prose

The blueprint `lem:tensorobj_lift_onproduct` claims `LineBundle.OnProduct πC πT = {M ∈ Scheme.Modules(C ×_S T) | IsInvertible M}` (the `IsInvertible` subtype from `def:scheme_modules_isinvertible`). The Lean code's `tensorObjOnProduct` takes arguments of type `LineBundle.OnProduct πC πT` where this type is the `IsLocallyTrivial` subtype (defined in `LineBundlePullback.lean`). The `\lean{...}` name is correct but:
- The blueprint prose misidentifies the predicate
- The `\uses{def:scheme_modules_isinvertible, lem:tensorobj_isoclass_commgroup}` annotations are incorrect for this Lean declaration (the Lean body uses only `tensorObj_isLocallyTrivial`)
- The blueprint proof for this lemma is entirely different from the Lean body

**Severity: major** — the blueprint's description of `LineBundle.OnProduct` is wrong and the proof sketch does not match the Lean implementation.

---

### Missing `\leanok` on two completed statement blocks

- `lem:flat_whisker_localizer` (`W_whiskerLeft_of_flat`, `W_whiskerRight_of_flat`): both proofs are complete (no sorry); statement block lacks `\leanok`. `sync_leanok` should have set this.
- `lem:tensorobj_unit_iso` (`tensorObj_left_unitor`, `tensorObj_right_unitor`): both proofs complete (no sorry); statement block lacks `\leanok`. `sync_leanok` should have set this.

**Severity: minor** — automated `sync_leanok` issue; no agent action required.

---

## Unreferenced declarations (informational)

The following Lean declarations have no `\lean{...}` pin in the blueprint but are assessed as helpers (acceptable):

| Declaration | Assessment |
|---|---|
| `PresheafOfModules.restrictScalarsLaxε` | helper for `restrictScalarsLaxMonoidal`, fine |
| `PresheafOfModules.restrictScalarsLaxμ` | helper for `restrictScalarsLaxMonoidal`, fine |
| `PresheafOfModules.toPresheaf_whiskerLeft_app_tmul` | helper for `isLocallyInjective_whiskerLeft_of_flat`, fine |
| `PresheafOfModules.toPresheaf_whiskerLeft_app_apply` | helper for `isLocallyInjective_whiskerLeft_of_flat`, fine |
| `PresheafOfModules.isLocallySurjective_whiskerLeft` | half of `lem:flat_whisker_localizer`, implicit in the pin |
| `PresheafOfModules.isLocallyInjective_whiskerLeft_of_flat` | half of `lem:flat_whisker_localizer`, implicit in the pin |
| **`PresheafOfModules.isLocallyInjective_whiskerLeft_of_W`** | **load-bearing sorry; should be pinned — see Red Flags** |
| **`PresheafOfModules.W_whiskerLeft_of_W`** | **key ROUTE (d) lemma; should be pinned** |
| **`PresheafOfModules.W_whiskerRight_of_W`** | **key ROUTE (d) lemma; should be pinned** |
| `AlgebraicGeometry.Scheme.Modules.tensorObjIsoOfIso` | helper for `tensorObj_isLocallyTrivial`, fine |
| `AlgebraicGeometry.Scheme.Modules.tensorObj_unit_iso` | helper unitor (unit ⊗ unit ≅ unit), not separately pinned but used by `tensorObj_left/right_unitor`; fine |
| `AlgebraicGeometry.Scheme.Modules.restrictIsoUnitOfLE` | helper for `tensorObj_isLocallyTrivial`, fine |

---

## Blueprint adequacy for this file

- **Coverage**: 13/13 blueprint-pinned declaration names exist in the Lean file, EXCEPT `tensorObjIsoclassCommMonoid` which has no Lean scaffold (blueprint correctly has no `\leanok` for it). The three new WhiskerOfW lemmas (unreferenced) are substantive and should be added to the blueprint.
- **Proof-sketch depth**: **under-specified** on two counts:
  1. `lem:tensorobj_assoc_iso` proof sketch describes the locally-trivial-cover route; the Lean uses ROUTE (d). Future provers reading the blueprint would pursue the wrong route.
  2. No blueprint block exists for the WhiskerOfW section (`isLocallyInjective_whiskerLeft_of_W`, `W_whiskerLeft_of_W`, `W_whiskerRight_of_W`). The sole remaining sorry is invisible.
- **Hint precision**: **loose on two declarations**: (a) `lem:tensorobj_lift_onproduct`'s prose describes `LineBundle.OnProduct` as `IsInvertible`-based whereas it is `IsLocallyTrivial`-based; (b) the `\lean{...}` pin for `lem:tensorobj_assoc_iso` is correct but the `\uses{...}` could reference the new WhiskerOfW lemmas.
- **Generality**: matches need for all existing pinned declarations.

### Recommended chapter-side actions for the blueprint-writing subagent

1. **Add a new lemma block** for `PresheafOfModules.isLocallyInjective_whiskerLeft_of_W` documenting:
   - Its signature (arbitrary F, locally bijective g ∈ J.W ⟹ F ◁ g locally injective)
   - That the proof is ROUTE (d): g is a stalkwise iso (J.W on `Opens X` = stalkwise iso via enough points), so id ⊗ g_x is an iso for any F_x
   - The two Mathlib-absent ingredients: (d.1) module-level stalk characterisation of J.W on `Opens X`; (d.2) stalk/tensor commutation `(A ⊗ᵖ B)_x ≅ A_x ⊗ B_x` for `PresheafOfModules`
   - Mark it as the **sole remaining open obligation** for `lem:tensorobj_assoc_iso`

2. **Add lemma blocks** for `W_whiskerLeft_of_W` and `W_whiskerRight_of_W` (the flatness-free ROUTE (d) replacements), explaining they are closed and replace `lem:flat_whisker_localizer` on the associator critical path.

3. **Update the proof of `lem:tensorobj_assoc_iso`** to describe ROUTE (d): the key claim is that whiskering an **arbitrary** module by a **locally bijective** (∈ J.W) morphism stays in J.W, proved stalkwise. Remove the locally-trivial-cover argument (it belongs to the flat-whiskering section, not the associator). Explain that `IsLocallyTrivial` on M, N, P is retained in the signature to match the blueprint pin, not as a proof ingredient.

4. **Correct `lem:tensorobj_lift_onproduct`** prose: `LineBundle.OnProduct πC πT` is the `IsLocallyTrivial` subtype (not `IsInvertible`), and the Lean proof uses `tensorObj_isLocallyTrivial` directly. Update `\uses{...}` accordingly.

---

## Severity summary

| Finding | Severity |
|---|---|
| Three new WhiskerOfW lemmas (esp. sorry `isLocallyInjective_whiskerLeft_of_W`) have no blueprint pins | **must-fix-this-iter** |
| `tensorObj_assoc_iso` proof sketch describes locally-trivial-cover route; Lean uses ROUTE (d) | **major** |
| `tensorObjOnProduct` / `lem:tensorobj_lift_onproduct`: prose identifies wrong predicate for `LineBundle.OnProduct`, proof sketch diverges | **major** |
| `tensorObjIsoclassCommMonoid` pinned but not scaffolded (blueprint correctly has no `\leanok`) | **major** (unscaffolded pin; not blocking since blueprint tracks it as unformalized) |
| Missing `\leanok` on `lem:flat_whisker_localizer` and `lem:tensorobj_unit_iso` | **minor** (`sync_leanok` issue) |

**Overall verdict**: The file's new ROUTE (d) WhiskerOfW content is completely absent from the blueprint, and the load-bearing sorry `isLocallyInjective_whiskerLeft_of_W` is invisible as a tracked obligation — this is the must-fix-this-iter gap. The associator proof sketch is also mathematically misaligned (locally-trivial route vs. ROUTE d). 15 declarations checked, 4 red flags.
