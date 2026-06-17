# Lean Audit Report

## Slug
iter233

## Iteration
233

## Scope
- files audited: 3
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (blanket `import Mathlib`)
- **excuse-comments**: none
- **notes**:
  - **Line 6** — `import Mathlib`. Blanket import; minor practice issue.
  - **Lines 76–83** — `pushforwardBaseChangeMap`: compiles without error. The definition is mathematically well-structured: adjoint mate of `f_*(unit) ≫ pseudofunctoriality ≫ commutativity ≫ pseudofunctoriality⁻¹`. Not suspicious.
  - **Lines 99–116** — `Modules.isIso_iff_isIso_stalkFunctor_map`: compiles clean. The backward direction invokes `CategoryTheory.isIso_iff_of_reflects_iso` which requires `(Scheme.Modules.toPresheaf X).ReflectsIsomorphisms`. Hover confirms the lemma exists in Mathlib and the instance is found automatically — proof is genuine and not circular.
  - **Lines 125–153** — `Modules.isIso_of_isIso_app_of_isBasis`: compiles clean. Uses `stalkFunctor_map_injective_of_isBasis` + `germ_exist_of_isBasis` for the bijection. The `erw` at line 151 (`erw [TopCat.Presheaf.stalkFunctor_map_germ_apply]`) is needed due to a concrete-category coercion; `rw` fails. Minor fragility concern if Mathlib renames the lemma.
  - **Lines 161–166** — `Modules.isIso_iff_isIso_app_affineOpens`: compiles clean. Honest corollary of `isIso_of_isIso_app_of_isBasis` with `isBasis_affineOpens`. No circularity.
  - **Lines 174–198** — `affineBaseChange_pushforward_iso`: sorry after a genuine reduction step (`rw [Modules.isIso_iff_isIso_app_affineOpens]; intro U`). The sorry is correctly scoped to the remaining affine-local step (tilde-dictionary missing from Mathlib). Comment is accurate.
  - **Lines 207–220** — `flatBaseChange_pushforward_isIso`: sorry'd. Comment accurately documents the missing Čech / affine-cover infrastructure. Honest scoping.
  - **Overall**: 3 new locality criteria are all genuine, compiling, and non-circular. The two sorry'd theorems are honestly scoped.

---

### `AlgebraicJacobian/Cohomology/HigherDirectImage.lean`

- **outdated comments**: 1 flagged (docstring/signature inconsistency at line 127)
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 2 flagged (blanket import; `Nonempty` weak return type)
- **excuse-comments**: none
- **notes**:
  - **Line 6** — `import Mathlib`. Blanket import; minor.
  - **Lines 51–53** — `higherDirectImage [HasInjectiveResolutions X.Modules]`: the instance hypothesis is required for `Functor.rightDerived` and is standard category-theory practice. However, the file gives no indication whether Mathlib provides `HasInjectiveResolutions` for `Scheme.Modules X` globally. If the instance is absent from Mathlib, every downstream theorem becomes practically unusable (though still well-typed). This is a real risk worth tracking.
  - **Lines 47–48** — Docstring claims "For `i = 0` this recovers the ordinary pushforward `R⁰ f_* F = f_* F`". This is mathematically true (pushforward is left-exact, being a right adjoint) but no separate `higherDirectImage_zero_iso_pushforward` lemma is stated or proved. The claim is misleading as a standalone docstring statement; it should be marked as "expected but unformalized" or a lemma should be added. Minor.
  - **Lines 67–76** — `higherDirectImage_isQuasiCoherent`: sorry'd. Hypotheses (`[QuasiCompact f] [QuasiSeparated f]`, `hF : F.IsQuasicoherent`) are correct for Stacks 02KE. Honest scope.
  - **Lines 89–99** — `higherDirectImage_affine_eq_zero`: sorry'd. Hypotheses (`[IsAffineHom f]`, `hi : 1 ≤ i`, `hF : F.IsQuasicoherent`) are correct. The `1 ≤ i` bound is present and correct — this is the one place it appears. Honest scope.
  - **Lines 127–142** — `flatBaseChange_higherDirectImage_isIso`: **Two distinct concerns** (see Major below).
    1. The docstring title says "i ≥ 1 case" and the mathematical statement reads "for every `i ≥ 1`", but the Lean signature has `(i : ℕ)` with **no `1 ≤ i` hypothesis**. Confirmed by LSP hover. This contradicts the documentation. For `i = 0`, the theorem's `Nonempty` claim is also true (it follows from `FlatBaseChange.lean`), so the theorem is not *wrong* as stated — but the argument described in the proof comment does not distinguish `i = 0`, and if someone proves it by the described Čech method, `i = 0` needs separate treatment or the hypothesis must be added.
    2. The return type `Nonempty (...≅...)` is explicitly acknowledged in the docstring ("the canonical higher base-change map is not yet constructed"). The `Nonempty` formulation prevents downstream functorial use. This is an honest scope limitation, not wrong code, but it makes the theorem weaker than what is needed to close any blueprint obligation that requires the canonical map.

---

### `AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean`

- **outdated comments**: 1 flagged (workflow-era phrases in module docstring)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (blanket `import Mathlib`)
- **excuse-comments**: none
- **notes**:
  - **Line 6** — `import Mathlib`. Blanket import; minor.
  - **Lines 22–24** — Module docstring contains "This iteration builds..." and "see the handoff in `task_results`". These are workflow-era cross-references that will become stale once the iteration is closed. Not an excuse-comment (no code is wrong), but these process phrases should be removed or rewritten as neutral prose.
  - **Lines 66–73** — `stalkTensorBilin`: proofs `map_zero'` and `map_add'` use `ext n; simp`. The `simp` must reduce `TensorProduct.zero_tmul` and `TensorProduct.add_tmul`; the file compiles clean, confirming this works. Not suspicious.
  - **Lines 77–84** — `stalkTensorBilin_balanced`: the `erw` at line 83 (`erw [PresheafOfModules.germ_smul B x U hx]`) is needed because the second `germ_smul` has a coercion mismatch that `rw` cannot handle. The proof is mathematically correct (`(r•m)⊗n = m⊗(r•n)` at stalk level via `TensorProduct.smul_tmul`). Mild fragility: if `germ_smul` gains a more explicit universe annotation in a Mathlib bump, `erw` might break.
  - **Lines 89–102** — `stalkTensorDescU` and `stalkTensorDescU_tmul`: clean. The `change` + `rw [liftAddHom_tmul]` + `rfl` chain in `stalkTensorDescU_tmul` is valid because after unfolding `TensorProduct.liftAddHom`, the result is definitionally `stalkTensorBilin A B x U hx a b`, which unfolds to `germ(a) ⊗ germ(b)` by definition of `stalkTensorBilin`.
  - **Lines 106–124** — `stalkTensorDesc`: the cocone naturality proof is **genuine** — it is not a defeq-collapsed triviality. The `tmul` case performs a real computation: `erw [tensorObj_map_tmul]` unfolds the tensorObj restriction, two `erw [stalkTensorDescU_tmul]` reduce both legs, then `erw [germ_res_apply, germ_res_apply]` uses stability of germs under restriction, and `rfl` closes the goal. This correctly verifies the intended cocone compatibility.
  - **Lines 121–124** — `add` case in the cocone proof: uses `(AddMonoidHom.map_add _ p q).trans ((congrArg₂ HAdd.hAdd hp hq).trans (AddMonoidHom.map_add _ p q).symm)`. Mathematically correct but verbose; `simp only [map_add, hp, hq]` would be more idiomatic. Minor style issue only.
  - **Lines 129–132** — `germ_stalkTensorDesc`: proof is `colimit.ι_desc _ _`, which is exactly the universal property of the cocone. Correct and clean.
  - **Lines 136–144** — `stalkTensorDesc_germ_tmul`: the `rw [← stalkTensorDescU_tmul, ← comp_apply, germ_stalkTensorDesc]` chain is correct and transparent.
  - **File-level note**: The file is an intentional partial build (only the forward map; `stalkTensorIso` is deferred). The module docstring is honest about this. No `sorry` is present anywhere in the file — all 7 declarations are axiom-free.

---

## Must-fix-this-iter

None.

All `sorry`-bodied declarations have honest, accurately described scope. No excuse-comments. No wrong definitions. The closed proofs in `FlatBaseChange.lean` and `StalkTensor.lean` compile without errors.

---

## Major

- `HigherDirectImage.lean:127` — `flatBaseChange_higherDirectImage_isIso` signature has `(i : ℕ)` with **no `1 ≤ i` bound**, contradicting the docstring "i ≥ 1 case" and the Stacks source (02KH's "i ≥ 1" case). When this sorry is eventually filled, the proof strategy described in the comment (Čech complex, Čech-to-cohomology spectral sequence) only closes the `i ≥ 1` case; the `i = 0` case requires the entirely separate argument in `FlatBaseChange.lean`. The missing hypothesis will either need to be added or the `i = 0` sub-case explicitly handled.

- `HigherDirectImage.lean:127` — `Nonempty (...≅...)` return type. The theorem as stated cannot serve as a source of the canonical base-change natural transformation. Any blueprint node requiring the functorial or natural form of the higher base-change isomorphism cannot be closed by this theorem alone. The `Nonempty` weakening is acknowledged in the docstring ("the canonical higher base-change map is not yet constructed") but the theorem should be upgraded to provide the actual isomorphism once the canonical map is built, rather than leaving a permanently weak statement in the library.

---

## Minor

- `FlatBaseChange.lean:6` — `import Mathlib`. Blanket import.
- `FlatBaseChange.lean:151` — `erw [TopCat.Presheaf.stalkFunctor_map_germ_apply]` in `isIso_of_isIso_app_of_isBasis`. The `erw` vs `rw` signals a coercion mismatch. Low risk but may break on Mathlib bumps.
- `HigherDirectImage.lean:6` — `import Mathlib`. Blanket import.
- `HigherDirectImage.lean:47–48` — Docstring asserts "For `i = 0` this recovers the ordinary pushforward `R⁰ f_* F = f_* F`" without a corresponding lemma. True, but unproved. Should be tagged as an unformalized remark or accompanied by a `higherDirectImage_zero_iso_pushforward` lemma (even if sorry'd).
- `HigherDirectImage.lean:51` — `[HasInjectiveResolutions X.Modules]` hypothesis. No indication in the file whether this instance is available globally in Mathlib for `Scheme.Modules X`. If absent, `higherDirectImage` requires users to provide the instance manually. A `-- Note: Mathlib provides HasInjectiveResolutions for ...` comment or a separate instance lemma would clarify the situation.
- `StalkTensor.lean:6` — `import Mathlib`. Blanket import.
- `StalkTensor.lean:22–24` — "This iteration builds..." and "see the handoff in `task_results`" in the module docstring. Workflow-era cross-references that rot after the iteration is archived.
- `StalkTensor.lean:83` — `erw` for second `germ_smul` in `stalkTensorBilin_balanced`. Coercion fragility.
- `StalkTensor.lean:121–124` — Verbose `congrArg₂ HAdd.hAdd hp hq` in the `add` case of the cocone proof; `simp only [map_add, hp, hq]` would be more idiomatic.

---

## Excuse-comments (always called out separately)

None found in any of the three files.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2
- **minor**: 9
- **excuse-comments**: 0

Overall verdict: All three files are technically sound — closed proofs compile axiom-free, `sorry` scoping is honest throughout, and `StalkTensor.lean` delivers a complete partial build with no outstanding proof obligations. The two major findings are confined to `HigherDirectImage.lean`: a missing `1 ≤ i` hypothesis that contradicts its own docstring, and a `Nonempty` return type that will prevent the theorem from serving downstream blueprint obligations once the canonical base-change map is constructed.
