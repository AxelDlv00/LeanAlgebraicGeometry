# Lean ↔ Blueprint Check Report

## Slug
ts221

## Iteration
221

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration (iter-221 additions)

### `\lean{PresheafOfModules.dual}` (chapter: `def:presheaf_dual`)
- **Lean target exists**: yes — `noncomputable def dual` at line 1349, inside `namespace PresheafOfModules` (section Dual), outside the `InternalHom` namespace.
- **Signature matches**: yes — `dual M := InternalHom.internalHom M (𝟙_ (...))`, i.e. the internal hom of `M` into the monoidal unit (structure presheaf), exactly matching the blueprint prose `M^∨ := ℋom(M, R)`.
- **Proof follows sketch**: N/A — definition, no proof body required.
- **`\leanok` marker**: present on `def:presheaf_dual` in blueprint ✓ (managed by `sync_leanok`; declaration exists axiom-clean, so marker is correct).
- **notes**: Clean. No sorry, no placeholder.

### `PresheafOfModules.InternalHom.termRingMap_terminal` (no blueprint `\lean{}` pin)
- **Lean target exists**: yes — `lemma termRingMap_terminal` at line 1321, inside `namespace InternalHom` (third opening of that namespace in the file, lines 1308–1327). Fully-qualified name: `PresheafOfModules.InternalHom.termRingMap_terminal`.
- **Blueprint pin**: none — helper lemma, not pinned. Acceptable: it is purely an internal helper for `evalLin_smul`.
- **Proof follows sketch**: N/A — no blueprint sketch.
- **notes**: Axiom-clean. Correctly placed in the `InternalHom` namespace.

### `PresheafOfModules.evalLin` (no blueprint `\lean{}` pin)
- **Lean target exists**: yes — `noncomputable def evalLin` at line 1357, inside `section Dual` (inside `namespace PresheafOfModules`, but **outside** `InternalHom`). Fully-qualified name: `PresheafOfModules.evalLin` (not `InternalHom.evalLin`).
- **Blueprint pin**: none — helper, not pinned. Acceptable.
- **notes**: Axiom-clean. The `open InternalHom` at line 1337 of `section Dual` means the `InternalHom` definitions are available by short name, but `evalLin` itself lives in the `PresheafOfModules` namespace. Worth noting for any future `\lean{}` reference.

### `PresheafOfModules.evalLin_add` and `PresheafOfModules.evalLin_smul` (no blueprint `\lean{}` pins)
- **Lean targets exist**: yes — lines 1367 and 1375, both in `section Dual` inside `namespace PresheafOfModules`. Fully-qualified: `PresheafOfModules.evalLin_add` / `PresheafOfModules.evalLin_smul`.
- **Blueprint pin**: none — helpers, not pinned. Acceptable.
- **notes**: Both axiom-clean. `evalLin_add` closes with `LinearMap.ext fun _ => rfl`. `evalLin_smul` uses `termRingMap_terminal` and `rfl`.

### `PresheafOfModules.internalHomEvalApp` (chapter: `lem:internal_hom_eval` — **MISMATCH**)
- **Lean target exists**: yes — `noncomputable def internalHomEvalApp` at line 1398, in `section Dual` inside `namespace PresheafOfModules`. Fully-qualified: `PresheafOfModules.internalHomEvalApp`.
- **Blueprint pin**: `lem:internal_hom_eval` has `\lean{PresheafOfModules.internalHomEval}` — but `internalHomEval` does **not exist** in the Lean file. Only the per-object piece `internalHomEvalApp` was built. See **Red Flags** below.
- **Signature of what was built**: `internalHomEvalApp M X : (M ⊗ M^∨).obj X ⟶ (𝟙_).obj X` — the per-object `R(X)`-bilinear contraction `s ⊗ φ ↦ φ(s)`.
- **Proof follows sketch**: partial — the blueprint's proof body for `lem:internal_hom_eval` correctly describes BOTH (a) the per-object bilinearity (done) AND (b) the naturality check that assembles them into a morphism of presheaves (not yet done).
- **notes**: Axiom-clean. The mismatch is between the per-object helper (what was built) and the full natural morphism named in the pin (what is the NEXT sub-step target).

---

## Red flags

### `\lean{}` pin pointing to a non-existent declaration

- **`lem:internal_hom_eval`** (`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`, lines 2610–2611): `\lean{PresheafOfModules.internalHomEval}`. This declaration does **not exist** in the Lean file. What exists is `PresheafOfModules.internalHomEvalApp` (the per-object version, line 1398). The full natural morphism `internalHomEval : M ⊗ M^∨ ⟶ R` assembling the per-object pieces via the naturality square is the **next sub-step** and has not been built.

  The declaration named in the pin (`internalHomEval`) is the correct **target name** for the next prover round. The per-object building block `internalHomEvalApp` is DONE this iter. The blueprint block does NOT conflate the two — the prose describes the full natural morphism, and the pin correctly names the future target. However, the blueprint currently has no explicit reference to `internalHomEvalApp` as the per-object piece-already-in-hand. This makes it impossible for the next prover to know that the per-object step is done and only the naturality assembly remains.

  **Review-agent action needed**: Add a `% NOTE:` comment under `lem:internal_hom_eval` indicating that the per-object step `PresheafOfModules.internalHomEvalApp` (built iter-221) is the sub-step building block, and that the next prover step is to assemble the naturality square. No `\lean{}` repoint needed — `internalHomEval` is the correct future target.

---

## Unreferenced declarations (informational)

The following 5 declarations in the Lean file were added this iter and have no `\lean{}` blueprint reference. All are internal helpers; none suggests it should be a standalone blueprint block:

- `PresheafOfModules.InternalHom.termRingMap_terminal` — scalar-identity at terminal, sole purpose is discharging `evalLin_smul`.
- `PresheafOfModules.evalLin` — evaluation functional extractor, used only by `internalHomEvalApp`.
- `PresheafOfModules.evalLin_add` — linearity half for `internalHomEvalApp`.
- `PresheafOfModules.evalLin_smul` — scalar-linearity half for `internalHomEvalApp`.
- `PresheafOfModules.internalHomEvalApp` — per-object bilinear contraction; should be **mentioned** in a `% NOTE:` comment on `lem:internal_hom_eval` (see Red Flags above), but does not need its own blueprint block.

---

## Blueprint adequacy for this file

- **Coverage**: `def:presheaf_dual` (1 declaration) is correctly covered. The 5 helpers (`termRingMap_terminal`, `evalLin`, `evalLin_add`, `evalLin_smul`, `internalHomEvalApp`) are correctly unblocked as helpers. `lem:internal_hom_eval` covers the full natural morphism (next step) — 6/6 declarations from this iter are accounted for, either by direct pin or as helpers.
- **Proof-sketch depth**: **adequate** for the next sub-step. The `lem:internal_hom_eval` proof sketch (blueprint lines 2642–2655) correctly identifies the two components needed: (a) per-object bilinearity `s ⊗ φ ↦ φ(s)` over `R(U)` (DONE as `internalHomEvalApp`), and (b) naturality of the open-by-open contractions — "evaluating then restricting equals restricting both arguments then evaluating (φ(s)|_V = (φ|_V)(s|_V))". The next prover should: take `internalHomEvalApp M` as the app-component, prove the naturality square using the slice-restriction structure of `dual`, and assemble via `PresheafOfModules.Hom.mk` or a presheaf morphism constructor.
- **Hint precision**: **loose for the per-object step** — the single `\lean{PresheafOfModules.internalHomEval}` pin does not acknowledge that `internalHomEvalApp` is the completed sub-step. The naturality proof key is `φ(s|_V) = (φ|_V)(s|_V)`, which holds by definition of `restrictionMap` (the restriction of `φ` in `dual M` is defined via `Over.map`). The blueprint does not state this key identity explicitly; a `% NOTE:` pointing to `restrictionMap_comp_hom` or `restr` definitional equality would help the next prover.
- **Generality**: matches need — the definition over a general category `D` with `R₀ : Dᵒᵖ ⥤ CommRingCat` is the correct level.
- **Recommended chapter-side actions**:
  1. Add a `% NOTE: per-object piece PresheafOfModules.internalHomEvalApp (built iter-221) is the app component; next step assembles naturality.` comment immediately after the `\lean{PresheafOfModules.internalHomEval}` line in `lem:internal_hom_eval`.
  2. Optionally add a brief proof hint: "the naturality square follows from `restrictionMap`'s functoriality and the definition of `restr` via `Over.map`."

### Carryover item — `def:presheaf_internal_hom` namespace pin

**RESOLVED.** The blueprint currently shows `\lean{PresheafOfModules.InternalHom.internalHom}` at `def:presheaf_internal_hom` (line 2451). This is the correct fully-qualified name: `internalHom` lives in `namespace InternalHom` inside `namespace PresheafOfModules` (Lean lines 1284–1306, second and third openings of `InternalHom`). No further repointing is needed.

---

## Severity summary

### must-fix-this-iter
*None.* All 6 new declarations are axiom-clean, have no sorry, no excuse-comments, and no weakened-wrong definitions. The blueprint states match the Lean proofs for the ones that are complete.

### major
1. **`lem:internal_hom_eval` `\lean{}` pin points to a non-existent declaration.** `\lean{PresheafOfModules.internalHomEval}` is the correct *future* target but does not yet exist. The per-object building block `PresheafOfModules.internalHomEvalApp` (built this iter) is not acknowledged anywhere in the blueprint. The plan agent should dispatch a blueprint update adding a `% NOTE:` comment cross-referencing `internalHomEvalApp`.

### minor
2. **Namespace of `evalLin` / `evalLin_add` / `evalLin_smul` / `internalHomEvalApp`** is `PresheafOfModules` (section Dual, outside `InternalHom`), not `InternalHom`. If any future `\lean{}` pin references these helpers, the correct prefix is `PresheafOfModules.evalLin` etc., not `InternalHom.evalLin`. The `open InternalHom` at line 1337 is a local-open only and does not change the namespace.

---

**Overall verdict**: 6 declarations checked, all axiom-clean and signature-correct; 1 major finding (the `lem:internal_hom_eval` `\lean{}` pin names the correct future target `internalHomEval` but lacks an acknowledgement of the per-object building block `internalHomEvalApp` already in hand); carryover namespace repointing for `def:presheaf_internal_hom` is already resolved.
