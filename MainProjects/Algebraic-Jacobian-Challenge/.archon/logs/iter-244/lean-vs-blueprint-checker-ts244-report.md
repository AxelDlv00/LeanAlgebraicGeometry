# Lean ↔ Blueprint Check Report

## Slug
ts244

## Iteration
244

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (1338 lines)
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (4949 lines)

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackLanDecomposition}` (chapter: lem:pullback_lan_decomposition)

- **Lean target exists**: yes — `Modules.pullbackLanDecomposition` at L1291 inside `section PullbackLanDecomposition`, `namespace AlgebraicGeometry.Scheme.Modules`.
- **Signature matches**: yes.  
  Blueprint: `pullback φ ≅ extendScalars φ ⋙ pullback₀`.  
  Lean: `PresheafOfModules.pullback φ ≅ extendScalars φ ⋙ pullback0 F R`.  
  Direction, functors, and the iso type all match the prose. `pullback0 F R` is the Lean realisation of the blueprint's `pullback₀ := (pushforward₀ F R).leftAdjoint`.
- **Proof follows sketch**: yes.  
  Blueprint proof: "left adjoint of a composite = composite of left adjoints in reverse order, canonical up to unique iso." Lean proof: one-liner using `Adjunction.leftAdjointCompIso (extendScalarsAdjunction φ) (pullback0Adjunction F R) (pullbackPushforwardAdjunction φ) (Iso.refl …)`. This is the exact argument the sketch describes.
- **Axioms**: `propext`, `Classical.choice`, `Quot.sound` — the standard Lean 4 / Mathlib baseline. Axiom-clean (no sorries, no project-local axioms, no `sorry`).
- **notes**:
  - The `\lean{}` pin was added by the review agent this iter (AFTER `sync_leanok` ran), so neither the statement nor proof block of `lem:pullback_lan_decomposition` yet carries `\leanok`. This is a **timing artifact**, not a bug; `sync_leanok` will add both markers next iter.
  - `Modules.lean` verify warning `"opaque"` at L467 is from a source-scan pattern on a `let` binding inside `tensorObj_restrict_iso`, unrelated to D1.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullback0TensorIso}` (chapter: lem:pullback0_tensor_iso)

- **Lean target exists**: no — `pullback0TensorIso` is not declared in TensorObjSubstrate.lean or any sub-file. D3 is the next build obligation.
- **Signature matches**: N/A (target absent).
- **Proof follows sketch**: N/A.
- **notes**: Correctly absent. Blueprint `lem:pullback0_tensor_iso` at L2905 has NO `\leanok` on its statement block — `sync_leanok` has correctly not added the marker. The `\lean{}` pin is an anticipatory forward-declaration of the target name, not a stale pointer. No issue beyond the outstanding work.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorIso}` (chapter: lem:pullback_tensor_iso)

- **Lean target exists**: no — `pullbackTensorIso` is not declared in TensorObjSubstrate.lean. D4 depends on D3.
- **Signature matches**: N/A.
- **Proof follows sketch**: N/A.
- **notes**: Correctly absent. Blueprint `lem:pullback_tensor_iso` at L2729 has NO `\leanok`. The `\lean{}` pin correctly names the future target. No issue.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible.pullback}` (chapter: lem:isinvertible_pullback)

- **Lean target exists**: no — `IsInvertible.pullback` is referenced only in docstring comments in the Lean file, never declared.
- **Signature matches**: N/A.
- **Proof follows sketch**: N/A.
- **notes**: Correctly absent. Blueprint `lem:isinvertible_pullback` at L3244 has NO `\leanok`. The in-blueprint comment ("three-line Stacks proof; once `pullbackTensorIso` lands this is immediate") correctly describes the dependency. No issue.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible.isLocallyTrivial}` (chapter: lem:isinvertible_implies_locallytrivial)

- **Lean target exists**: no.
- **Signature matches**: N/A.
- **Proof follows sketch**: N/A.
- **notes**: Correctly absent. Blueprint notes this is OFF the `IsInvertible.pullback` critical path and is Mathlib-scale. No `\leanok`. No issue.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjIsoclassCommMonoid}` (chapter: lem:tensorobj_isoclass_commgroup)

- **Lean target exists**: **no** — `tensorObjIsoclassCommMonoid` is not declared anywhere in the project. No `\leanok` on the statement block.
- **Signature matches**: N/A (target absent).
- **Proof follows sketch**: N/A.
- **notes**: **Pre-existing orphaned pin.** The Lean implementation split this into two declarations: the type `PicGroup` (definition `def:pic_carrier`, pinned at L3392, with `\leanok`) and the group law `picCommGroup` (theorem `thm:pic_commgroup`, pinned at L3603, with `\leanok`). The `lem:tensorobj_isoclass_commgroup` block at L2364 was never updated to reflect this split; its `\lean{}` pin still names a monolithic `tensorObjIsoclassCommMonoid` that does not exist. Since there is no `\leanok` on this block, no false claim of formalization is made, but the pin is stale and points at nothing. **Severity: major** (pre-existing, not introduced this iter).

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (chapter: def:scheme_modules_tensorobj)

- **Lean target exists**: yes — L140.
- **Signature matches**: yes.
- **notes**: axiom-clean, no sorry, blueprint description matches the sheafification-of-presheaf-tensor body.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` (chapter: lem:scheme_modules_tensorobj_functoriality)

- **Lean target exists**: yes — L155.
- **Signature matches**: yes.
- **notes**: axiom-clean.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso}` (chapter: lem:tensorobj_restrict_iso)

- **Lean target exists**: yes — L425.
- **Signature matches**: yes.
- **notes**: The verify warning `"opaque"` at L467 is a source-scan pattern match on a `let` binder name, not an `opaque` declaration. Axiom-clean (confirmed via `lean_verify`).

---

### `\lean{AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse}` (chapter: lem:tensorobj_inverse_invertible)

- **Lean target exists**: yes — L672.
- **Signature matches**: yes.
- **Proof follows sketch**: N/A — body is `:= sorry`.
- **notes**: Blueprint statement block has `\leanok` (correct per convention: declaration exists). Blueprint proof block (L1666–L1744) has **no** `\leanok` (correct: proof has sorry). The sorry is the known C-bridge + A-bridge gap. Not a red flag — correctly scaffolded.

---

### `\lean{AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj}` (chapter: thm:rel_pic_addcommgroup_via_tensorobj)

- **Lean target exists**: yes — L1328.
- **Signature matches**: yes.
- **Proof follows sketch**: N/A — body is `:= sorry`.
- **notes**: Blueprint statement block has `\leanok` (correct). Blueprint proof block (L3781+) has **no** `\leanok` (correct). Known-open residual.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap}` (chapter: lem:pullback_tensor_map)

- **Lean target exists**: yes — L1199.
- **Signature matches**: yes — comparison morphism `f^*(M ⊗ N) ⟶ f^*M ⊗ f^*N`.
- **Proof follows sketch**: yes.
- **notes**: Blueprint statement block has `\leanok`. Axiom-clean.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.presheafPushforwardLaxMonoidal}` (chapter: lem:presheaf_pushforward_laxmonoidal)

- **Lean target exists**: yes — L1116.
- **Signature matches**: yes — `instance` showing `(PresheafOfModules.pushforward φ).LaxMonoidal`.
- **notes**: Blueprint statement block has `\leanok`. Axiom-clean. Note: this is a general PresheafOfModules lemma scoped under `AlgebraicGeometry.Scheme.Modules` — slightly odd namespacing but correct since that is where the Lean declaration lives.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.presheafPullbackOplaxMonoidal}` (chapter: lem:presheaf_pullback_oplaxmonoidal)

- **Lean target exists**: yes — L1138.
- **Signature matches**: yes.
- **notes**: Blueprint statement block has `\leanok`. Axiom-clean.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackUnitIso}` (chapter: lem:pullback_unit_iso)

- **Lean target exists**: yes — L1045.
- **Signature matches**: yes — `f^*𝒪_X ≅ 𝒪_Y` for any scheme morphism `f`.
- **notes**: Blueprint statement block has `\leanok`. Axiom-clean.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_comp}` (chapter: lem:pullbackObjUnitToUnit_comp)

- **Lean target exists**: yes — L902.
- **Signature matches**: yes — pseudofunctor coherence for the composition of unit comparisons.
- **notes**: Blueprint statement block has `\leanok`. Axiom-clean.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.picCommGroup}` (chapter: thm:pic_commgroup)

- **Lean target exists**: yes — L813.
- **Signature matches**: yes — `CommGroup (PicGroup X)`.
- **notes**: Blueprint statement block has `\leanok`. Full CommGroup proof, no sorry, axiom-clean.

---

## Red flags

### Placeholder / suspect bodies

- `Scheme.Modules.exists_tensorObj_inverse` at L672: body is `:= sorry`. The blueprint (`lem:tensorobj_inverse_invertible`) claims this as a substantive lemma. However, the proof block in the blueprint does NOT carry `\leanok`, and the sorry is the documented open obligation (C-bridge + A-bridge). This is an ongoing sorry, not a hidden placeholder — **not** a must-fix.
- `PicSharp.addCommGroup_via_tensorObj` at L1328: body is `:= sorry`. Same reasoning — proof block has no `\leanok`. Ongoing open obligation.

### Orphaned `\lean{}` pin (no corresponding declaration)

- `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjIsoclassCommMonoid}` at blueprint L2366 on `lem:tensorobj_isoclass_commgroup`: declaration does not exist in the project. The mathematical content it was supposed to describe was refactored into `PicGroup` + `picCommGroup`. The stale pin points at nothing. **No `\leanok` is present**, so no false formalization claim is made. **Severity: major** (pre-existing).

### Axioms / Classical.choice on non-trivial claims

- None introduced this iter. Standard axiom profile (propext/Classical.choice/Quot.sound) throughout the D1 section.

---

## Unreferenced declarations (informational)

The following declarations in TensorObjSubstrate.lean have no `\lean{}` pin in the blueprint. Most are helpers and their absence is acceptable. Declarations worth noting:

- `pullback0 F R` (L1260), `extendScalars φ` (L1268), `pullback0Adjunction` (L1274), `extendScalarsAdjunction` (L1280) — the **D1 carrier declarations**. These are named in the blueprint prose of `lem:pullback_lan_decomposition` and are the subjects of D2/D3 lemmas. The D2 lemma `lem:pullback0_tensor_iso` refers to `pullback₀` but does not pin its Lean name; a prover working D3 would need to discover the names from D1. Adding `\lean{}` pins for these would improve D2/D3 navigation (minor). They are axiom-clean.
- `tensorObj_unit_iso` (L258), `tensorObjIsoOfIso` (L242) — helpers cited in docstrings but not independently pinned. Minor.
- `pullbackValIso` (L1182), `pullbackObjUnitToUnitIso` (L1028) — helper declarations used by `pullbackTensorMap`/`pullbackUnitIso`. Minor.
- `restrictIsoUnitOfLE` (L373), `picSetoid` (L772), `picMul` (L784), `picInv` (L793) — internal helpers for proof structure. Acceptable.
- `isIso_of_isIso_restrict` (L546) and `homMk` (L587) — pinned in the blueprint's later dual-infra section (L4752, L4789); not in TensorObjSubstrate.lean's primary section but present in the file. ✓
- `tensorObj_middleFour` (L730) — private helper. Fine.

---

## Blueprint adequacy for this file

### Coverage
Approximately 27 of the ~45 substantive non-private declarations in TensorObjSubstrate.lean have a corresponding `\lean{}` block in the blueprint. The unreferenced declarations are largely helpers (private, or cited only in prose). The four D1 carrier declarations (`pullback0`, `extendScalars`, and their adjunctions) are the most substantive un-pinned public declarations.

### Proof-sketch depth
**Adequate for D1** (just delivered): the proof sketch of `lem:pullback_lan_decomposition` ("left adjoint of composite = composite of left adjoints") matches the one-liner Lean proof exactly.

**Adequate for D2/D3** (next obligation): the `lem:pullback_tensor_iso` proof (`sec:tensorobj_pullback_monoidality`) is the most detailed section of the chapter. D2 (extendScalars strong monoidal via `distribBaseChange`) and D3 (filtered-colimit/⊗ interchange via LKE formula) are both sketched with the Mathlib-absent ingredients explicitly named. D4 (leftAdjointUniq transport) is concretely specified. The blueprint note correctly flags that the LKE pointwise model and `ModuleCat`-valued filtered-colimit/⊗ interchange are not in Mathlib and require bottom-up construction. This is honest and useful for the next prover.

### Hint precision
**Precise** for all pinned declarations. The `\lean{}` names are exact Lean qualified names. The sole exception is the stale `tensorObjIsoclassCommMonoid` pin (see Orphaned pin above).

### Generality
**Matches need.** D1 is formulated for general `PresheafOfModules` (any `C ⥤ D`, ring presheaves `R, S`), which is the right level of generality.

### Recommended chapter-side actions
1. **Must-fix (pre-existing)**: Remove the stale `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjIsoclassCommMonoid}` pin from `lem:tensorobj_isoclass_commgroup` (L2366). Either delete the pin or replace it with two pins: `\lean{AlgebraicGeometry.Scheme.Modules.PicGroup, AlgebraicGeometry.Scheme.Modules.picCommGroup}` and update the `\uses{}` to reference `def:pic_carrier`. The current block is a legacy vestige of a now-refactored design.
2. **Minor**: Add `\lean{}` pins for the D1 carrier declarations `pullback0`, `extendScalars`, `pullback0Adjunction`, `extendScalarsAdjunction` — e.g., as a `\begin{definition}` block on `lem:pullback_lan_decomposition`'s proof noting the carriers, or as a separate sub-lemma block. This aids D2/D3 navigation.
3. **Informational**: After the next `sync_leanok` run, `lem:pullback_lan_decomposition` will acquire `\leanok` on both statement and proof blocks automatically.

---

## Severity summary

| Finding | Severity | Introduced this iter? |
|---------|----------|-----------------------|
| `tensorObjIsoclassCommMonoid` pin orphaned (points to non-existent decl) | **major** | No (pre-existing) |
| Missing `\leanok` on `lem:pullback_lan_decomposition` statement/proof blocks | not a finding | N/A — timing artifact |
| D1 carrier decls (`pullback0`, `extendScalars`, etc.) lack `\lean{}` pins | **minor** | No (pre-existing) |
| `exists_tensorObj_inverse` and `addCommGroup_via_tensorObj` have `:= sorry` | not a red flag | No — ongoing, blueprint correctly not-`\leanok` on proof blocks |
| Downstream D2/D3/`IsInvertible.pullback` absent with no `\leanok` | none — correct | N/A |

**Overall verdict:** D1 (`pullbackLanDecomposition`) is axiom-clean, correctly pinned, and its statement exactly matches the blueprint; the downstream D2/D3 and `IsInvertible.pullback` lemmas are correctly absent with no false formalization markers. One pre-existing major finding: the orphaned `\lean{...tensorObjIsoclassCommMonoid}` pin on `lem:tensorobj_isoclass_commgroup` points to a non-existent declaration and should be updated to the actual `PicGroup` + `picCommGroup` split. No must-fix-this-iter issues were introduced by the iter-244 prover work.
