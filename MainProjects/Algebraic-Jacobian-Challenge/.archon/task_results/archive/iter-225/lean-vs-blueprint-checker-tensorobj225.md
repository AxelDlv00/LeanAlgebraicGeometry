# Lean ↔ Blueprint Check Report

## Slug
tensorobj225

## Iteration
225

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.dual}` (chapter: `lem:internal_hom_isSheaf`)

- **Lean target exists**: yes — defined at L1580 in namespace `AlgebraicGeometry.Scheme.Modules`
- **Signature matches**: yes. Blueprint states: `dual M := ℋom_{𝒪_X}(M, 𝒪_X) ∈ Scheme.Modules X`, taking `M : X.Modules` and producing `X.Modules`. Lean: `{X : Scheme.{u}} (M : X.Modules) : X.Modules`. Exact match.
- **Proof follows sketch**: partial. The blueprint proof for `lem:internal_hom_isSheaf` describes a **direct sheaf-condition descent** argument (prove gluing from a cover; the sections of `ℋom(M,N)` satisfy the sheaf axiom because `N` is a sheaf). The Lean instead uses the **sheafification shortcut**: `PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.val) |>.obj (PresheafOfModules.dual M.val)`. The Lean docstring explicitly notes this: "sheafifying an already-sheaf gives an iso object; this is the file's convention, matching tensorObj." The two approaches are mathematically equivalent (sheafification of a sheaf is canonically isomorphic to the original), but the proof route differs.
- **No placeholder body**: correct — this is a genuine definition, not a `sorry`. Per the directive, it is axiom-clean (`{propext, Classical.choice, Quot.sound}`).
- **Notes**:
  - Construction exactly mirrors `tensorObj` (L1524): both apply `sheafification.obj` to a presheaf-level object. Structural consistency is strong.
  - `PresheafOfModules.dual (R₀ := X.presheaf) M.val` is the presheaf-level dual (project-side, pinned as `def:presheaf_dual` / `\lean{PresheafOfModules.dual}`, already `\leanok`). The sheafification with `R := X.ringCatSheaf` and identity map `𝟙 X.ringCatSheaf.val` correctly produces a `SheafOfModules X.ringCatSheaf` = `X.Modules`.
  - CommRingCat/RingCat situation: `X.presheaf` is CommRingCat-valued, so `PresheafOfModules.dual (R₀ := X.presheaf)` is well-typed and no ring-category bridge is needed. Confirmed consistent with blueprint `sec:tensorobj_api_survey` (which notes `X.ringCatSheaf.val = X.presheaf ⋙ forget₂ CommRingCat RingCat` by definitional equality). Memory entry `ts224-internalhomeval-confirmed-and-tooling` confirms this was previously flagged as a potential issue and resolved as a non-issue.

---

## Red flags

### Stale comment (not a placeholder, but misleading)

- `TensorObjSubstrate.lean:1959–1964`: The `sorry` body comment of `exists_tensorObj_inverse` (L1965) states:
  > "The PRESHEAF-level `internalHom`/`dual`/`internalHomEval` now exist axiom-clean — see the `Dual` section above — but **the sheafification of the dual** + its sheaf-level evaluation counit, and object-level descent, are still absent."
  
  The bold clause is now factually incorrect: `AlgebraicGeometry.Scheme.Modules.dual` (L1580) **is** the sheafification of the presheaf dual, and it was added in this iteration axiom-clean. The sorry in `exists_tensorObj_inverse` remains valid (the sheaf-level evaluation counit `M ⊗_X dual M → 𝒪_X` is still absent), but the stated reason for the block is partially stale. A future prover reading this comment could be confused about what remains missing.

  **No new sorry was introduced by the `dual` addition.** The pre-existing sorries at L641 (`isLocallyInjective_whiskerLeft_of_W`), L1965 (`exists_tensorObj_inverse`), and L2011 (`addCommGroup_via_tensorObj`) are all unchanged and tracked.

---

## Unreferenced declarations (informational)

The blueprint's `lem:internal_hom_isSheaf` contains the following claim in its proof/statement body that is **not separately formalized** in the Lean file:

> "the evaluation `lem:internal_hom_eval` descends to a morphism of sheaves of modules `M ⊗_X dual M → 𝒪_X`"

There is no Lean declaration `AlgebraicGeometry.Scheme.Modules.dualEval` (or equivalent) that provides this descended evaluation morphism. The blueprint only pins `\lean{AlgebraicGeometry.Scheme.Modules.dual}` for `lem:internal_hom_isSheaf`, so no separate `\lean{...}` obligation for the descended evaluation exists. The `remark:dual_discharges_inverse` block (blueprint `rem:dual_discharges_inverse`) describes how this evaluation is needed to close `exists_tensorObj_inverse`, which remains a sorry — so the missing piece is expected and tracked. This is informational only.

---

## Blueprint adequacy for this file

- **Coverage**: The dual infra sub-chain (`sec:tensorobj_dual_infra`) pins all six sub-step declarations with `\lean{...}` blocks:
  - `def:presheaf_internal_hom_value` → `PresheafOfModules.InternalHom.homModule` (\\leanok)
  - `def:presheaf_internal_hom_slice_value` → `PresheafOfModules.InternalHom.internalHomObjModule` (\\leanok)
  - `def:presheaf_internal_hom` → `PresheafOfModules.InternalHom.internalHom` (\\leanok)
  - `lem:presheaf_internal_hom_restriction` → `PresheafOfModules.InternalHom.restrictionMap` (\\leanok)
  - `def:presheaf_dual` → `PresheafOfModules.dual` (\\leanok)
  - `lem:internal_hom_eval` → `PresheafOfModules.internalHomEval` (\\leanok)
  - `lem:internal_hom_isSheaf` → `AlgebraicGeometry.Scheme.Modules.dual` (\\leanok)
  
  Coverage is complete for the dual block.

- **Proof-sketch depth**: **adequate** for the formalization actually performed (sheafification shortcut). The blueprint proof of `lem:internal_hom_isSheaf` describes a more involved direct descent argument, which is formally sufficient (it correctly characterizes the sheaf condition). The Lean used a simpler route (sheafification), but the blueprint proof is not *wrong* — it describes a valid alternative proof. The sketch gives enough mathematical context to understand what is being proved.

- **Hint precision**: **precise**. The `\lean{AlgebraicGeometry.Scheme.Modules.dual}` pin exactly matches the Lean declaration name. The sub-step chain is also precisely pinned.

- **Generality**: **matches need**. The blueprint's `lem:internal_hom_isSheaf` also mentions the general `ℋom(M,N)` case (for arbitrary `N`), but the Lean pin is only the specialization `N = 𝒪_X`. Since only the specialization is consumed downstream (by `exists_tensorObj_inverse` via `rem:dual_discharges_inverse`), this matches the actual need.

- **CommRingCat/RingCat documentation**: The blueprint's `sec:tensorobj_api_survey` correctly notes that `X.presheaf ⋙ forget₂ CommRingCat RingCat = X.ringCatSheaf.val` by definitional equality, explaining why no bridge is needed. This is accurate and consistent with the Lean code.

- **Recommended chapter-side actions**:
  - **Minor**: The proof body of `lem:internal_hom_isSheaf` could add a `% NOTE:` acknowledging that the sheafification shortcut is used in the Lean (rather than a direct sheaf-condition descent), to avoid confusing future readers who may wonder why the proof route differs. Not blocking.
  - **Minor**: The blueprint's `lem:internal_hom_isSheaf` statement and proof describe the descended evaluation `M ⊗_X dual M → 𝒪_X` but this is not separately pinned. If it becomes a separately formalized declaration (as part of closing `exists_tensorObj_inverse`), a `\lean{...}` block should be added. Currently tracked via `rem:dual_discharges_inverse` as expected next work.

---

## Severity summary

### must-fix-this-iter
*(none)*

### major
*(none)*

### minor
1. **Stale comment in `exists_tensorObj_inverse` (L1959–1964)**: States "the sheafification of the dual...is still absent" after `AlgebraicGeometry.Scheme.Modules.dual` was added this iteration. The sorry itself is still valid (the sheaf-level evaluation counit is absent), but the stated reason for the block is now partially incorrect. A prover or reviewer reading the file could be confused. Recommend updating the comment to reflect that `dual` now exists and the remaining block is specifically the sheaf-level evaluation counit. Read-only constraint prevents direct fix here.

2. **Proof-sketch route mismatch in blueprint `lem:internal_hom_isSheaf`**: The blueprint describes a direct sheaf-condition descent proof; the Lean uses sheafification. Mathematically equivalent, but the discrepancy could mislead a prover who follows the blueprint proof sketch literally. The Lean docstring correctly explains the shortcut; the blueprint could add a `% NOTE:` annotation (e.g., `% NOTE: In the Lean, the sheaf condition is obtained via sheafification of an already-sheaf, matching the tensorObj convention; the direct descent argument in the proof body is a valid alternative.`).

---

**Overall verdict**: `AlgebraicGeometry.Scheme.Modules.dual` faithfully realizes blueprint `lem:internal_hom_isSheaf` — the definition is axiom-clean, the type signature matches, the construction (sheafification of the presheaf dual) is mathematically sound, and no new sorries or placeholder bodies were introduced. Two minor findings: a stale comment and a proof-route discrepancy, neither blocking.
