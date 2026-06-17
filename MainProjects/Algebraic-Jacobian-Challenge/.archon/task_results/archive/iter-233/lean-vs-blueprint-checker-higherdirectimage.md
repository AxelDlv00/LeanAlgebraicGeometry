# Lean ↔ Blueprint Check Report

## Slug
higherdirectimage

## Iteration
233

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/HigherDirectImage.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_HigherDirectImage.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.higherDirectImage}` (chapter: `def:higher_direct_image`)

- **Lean target exists**: yes — `higherDirectImage` at line 51
- **Signature matches**: partial — see notes
- **Proof follows sketch**: N/A (definition, not a proof)
- **notes**:
  - Body is `((pushforward f).rightDerived i).obj F` — a proper definition, not sorry. ✓
  - Extra `[HasInjectiveResolutions X.Modules]` instance hypothesis in Lean that does not appear in the blueprint's mathematical statement. The blueprint's `% NOTE (iter-233)` in the comment block acknowledges and explains this (Mathlib has `Abelian X.Modules` but not `EnoughInjectives` / `IsGrothendieckAbelian` for `SheafOfModules`). The NOTE is appropriate but lives only in a comment, not in the formal statement body.
  - Blueprint's `\leanok` on the statement block is correct — the declaration exists with a proper body.
  - The concrete presheaf formula `V ↦ Hⁱ(f⁻¹ V, F|…)` given in the blueprint prose is NOT part of the Lean body (which uses `rightDerived`). These are equivalent by the foundational description of right derived functors, but the equivalence is not spelled out in the Lean file. Not a blocking issue at this stage.

---

### `\lean{AlgebraicGeometry.higherDirectImage_isQuasiCoherent}` (chapter: `lem:higher_direct_image_quasi_coherent`)

- **Lean target exists**: yes — `higherDirectImage_isQuasiCoherent` at line 67
- **Signature matches**: partial — see notes
- **Proof follows sketch**: N/A (proof is `:= sorry`; proof block has no `\leanok` — correctly signalled unproven)
- **notes**:
  - Blueprint: "Let f quasi-compact and quasi-separated; for every quasi-coherent F and every p ≥ 0, R^p f_* F is quasi-coherent."
  - Lean: `[HasInjectiveResolutions X.Modules]`, `[QuasiCompact f]`, `[QuasiSeparated f]`, `(i : ℕ)`, `(hF : F.IsQuasicoherent)`, conclusion `(higherDirectImage f i F).IsQuasicoherent`. All blueprint hypotheses are present.
  - Extra `[HasInjectiveResolutions X.Modules]` propagated from the definition — blueprint statement does not record it. The definition's `% NOTE` covers only the definition block, not downstream lemma statements.
  - `i : ℕ` encodes `i ≥ 0` by type — consistent with blueprint's "every p ≥ 0".
  - `\leanok` on statement block is correct (sorry present).
  - Sorry is honest (Lean comment explains: "Needs the explicit description of `Rⁱ f_*` as the sheafification of `V ↦ Hⁱ(f⁻¹ V, F|…)` and the Mayer–Vietoris infrastructure, both currently absent from Mathlib."). Not misleading.

---

### `\lean{AlgebraicGeometry.higherDirectImage_affine_eq_zero}` (chapter: `lem:higher_direct_image_affine_vanishing`)

- **Lean target exists**: yes — `higherDirectImage_affine_eq_zero` at line 89
- **Signature matches**: partial — see notes
- **Proof follows sketch**: N/A (proof is `:= sorry`; proof block has no `\leanok` — correctly signalled unproven)
- **notes**:
  - Blueprint: "If f is affine, then R^i f_* F = 0 for all i ≥ 1."
  - Lean: `[HasInjectiveResolutions X.Modules]`, `[IsAffineHom f]`, `(hi : 1 ≤ i)`, `(hF : F.IsQuasicoherent)`, conclusion `IsZero (higherDirectImage f i F)`.
  - `(hi : 1 ≤ i)` correctly encodes "i ≥ 1". ✓
  - `IsZero (higherDirectImage f i F)` is the correct Lean representation of "R^i f_* F = 0" (category-theoretic zero object). ✓
  - `[IsAffineHom f]` for "f is affine". ✓
  - Extra `[HasInjectiveResolutions X.Modules]` not in blueprint prose (same pattern as above).
  - Sorry body honest — Lean comment explains the Mathlib gap (affine-cohomology vanishing for `Scheme.Modules` not yet present).
  - `\leanok` on statement correct.

---

### `\lean{AlgebraicGeometry.flatBaseChange_higherDirectImage_isIso}` (chapter: `thm:flat_base_change_higher`)

- **Lean target exists**: yes — `flatBaseChange_higherDirectImage_isIso` at line 127
- **Signature matches**: partial/no — two notable deviations (see notes)
- **Proof follows sketch**: N/A (proof is `:= sorry`; proof block has no `\leanok` — correctly signalled unproven)
- **notes**:
  - **Missing `hi : 1 ≤ i` hypothesis.** Blueprint: "for every i ≥ 1 the canonical base-change map is an isomorphism." Lean: `(i : ℕ)` with NO lower-bound constraint — the statement as written applies to all `i : ℕ` including `i = 0`. This is STRONGER than the blueprint's claim (i ≥ 1). At i = 0 the result IS true (reduces to the direct-image flat base change handled elsewhere), but the intent of this theorem is the i ≥ 1 case and the difference should be explicit. The Lean header comment says "for every i ≥ 1" but the signature does not enforce it.
  - **`Nonempty (...≅...)` vs canonical isomorphism.** Blueprint: "the canonical base-change map (the higher-degree analogue of the pushforward base-change map of `def:pushforward_base_change_map`) is an isomorphism." Lean: `Nonempty ((Scheme.Modules.pullback g).obj (higherDirectImage f i F) ≅ higherDirectImage f' i ((Scheme.Modules.pullback g').obj F))`. The Lean weakens from "this specific canonical morphism is an iso" to "some isomorphism exists". The Lean doc comment acknowledges this ("the canonical higher base-change map is not yet constructed"), but the blueprint prose describes a canonical morphism and states it is an iso — that stronger claim is not what the Lean declares.
  - Extra `[HasInjectiveResolutions X.Modules]` AND `[HasInjectiveResolutions X'.Modules]` — blueprint mentions neither.
  - `\leanok` on statement block: technically correct (sorry present). However, because the Lean signature differs from the blueprint's in two respects, the `\leanok` is misleading in the sense that it signals the blueprint's statement is formalized when in fact only a weakened version is.
  - Sorry body honest — Lean comment explains the Čech/spectral-sequence infrastructure gap.

---

## Red flags

### Placeholder / suspect bodies

The three theorems all have `:= sorry` bodies:
- `higherDirectImage_isQuasiCoherent` (line 76): sorry. Blueprint claims a substantive theorem. However, (a) the proof block has no `\leanok` (correctly signalled unproven), and (b) the Lean comment gives an honest account of what infrastructure is missing. **Not misleading — expected scaffold state.**
- `higherDirectImage_affine_eq_zero` (line 99): same analysis. Not misleading.
- `flatBaseChange_higherDirectImage_isIso` (line 142): same analysis. Not misleading.

None of these rise to must-fix because the blueprint semantics explicitly allow sorry on statement blocks (that is what `\leanok` on statement means), and none of the proof blocks carry `\leanok`.

### Signature deviations (not excuse-comments, but substantive mismatches)

1. **`[HasInjectiveResolutions X.Modules]`** permeates all four declarations but appears in the blueprint's `% NOTE` only for the definition block. The three downstream lemma/theorem statement blocks in the blueprint do not mention it. This is a partial signature mismatch across the board.
2. **`flatBaseChange_higherDirectImage_isIso`**: missing `hi : 1 ≤ i` (Lean is stronger), and `Nonempty (...≅...)` instead of canonical-map-is-iso (Lean is weaker). Both acknowledged in Lean comments but absent from the blueprint statement.

### Axioms / Classical.choice
None found.

---

## Unreferenced declarations (informational)

All four substantive declarations in the Lean file are referenced in the blueprint via `\lean{...}`. No unreferenced substantive declarations. There are no helper declarations in the file beyond the four main items and their associated docstring comments.

---

## Blueprint adequacy for this file

- **Coverage**: 4/4 Lean declarations have a corresponding `\lean{...}` block in the chapter. No unreferenced declarations.

- **Proof-sketch depth**: **adequate for 3 of 4 blocks; silent on one issue.**
  - `lem:higher_direct_image_quasi_coherent`: Proof sketch is detailed (Stacks 02KE — induction principle, affine base case via affine vanishing, Mayer–Vietoris inductive step). A Lean prover would know exactly what infrastructure to look for.
  - `lem:higher_direct_image_affine_vanishing`: Proof sketch is clear (Stacks 02KG — presheaf description, affine preimage, sheafification vanishes on a basis).
  - `thm:flat_base_change_higher`: Proof sketch is detailed (Stacks 02KH — affine reduction, Čech complex in separated case, Čech-to-cohomology spectral sequence in q.s. case). Adequate.
  - `def:higher_direct_image`: No proof to sketch. Adequate.

- **Hint precision**: **loose on two points**.
  - The instance hypothesis `[HasInjectiveResolutions X.Modules]` is explained in the definition block's `% NOTE` but is absent from the formal statement bodies of all three lemmas/theorems. A prover reading only the lemma statement block would not see this requirement.
  - The `Nonempty (...≅...)` weakening in `thm:flat_base_change_higher` is noted in the Lean comment but NOT in the blueprint prose. The blueprint's `\lean{AlgebraicGeometry.flatBaseChange_higherDirectImage_isIso}` tag points to a declaration whose conclusion differs from the blueprint statement.

- **Generality**: **matches need** for the three sorry lemmas. The `[HasInjectiveResolutions]` gap is a Mathlib gap, not a blueprint-generality issue.

- **Recommended chapter-side actions**:
  1. Add a `% NOTE` to the statement bodies of `lem:higher_direct_image_quasi_coherent`, `lem:higher_direct_image_affine_vanishing`, and `thm:flat_base_change_higher` recording that all three carry `[HasInjectiveResolutions X.Modules]` (and `[HasInjectiveResolutions X'.Modules]` for the base-change theorem). Refer back to the definition-block note rather than repeating the full explanation.
  2. In `thm:flat_base_change_higher`'s statement, explicitly note that (a) the Lean signature drops the `i ≥ 1` lower bound (stated for all `i : ℕ`), and (b) the conclusion is weakened to `Nonempty (…≅…)` because the canonical base-change morphism is not yet constructed. This explains why the `\leanok` on the statement is valid despite the weakening.
  3. Optionally add a `% NOTE` noting that `def:pushforward_base_change_map` (referenced in `\uses` of `thm:flat_base_change_higher`) lives in a different chapter — the cross-chapter dependency is fine but should be findable by a prover scanning this chapter alone.

---

## Severity summary

- **must-fix-this-iter**: **none**. No sorry on a declaration the blueprint claims is proven; no axioms; no excuse-comments on declarations claimed as real; no weakened-wrong definitions. The sorry bodies are honest TODOs with acknowledged infrastructure gaps and correctly absent proof-block `\leanok`.
- **major** (3 findings):
  1. `[HasInjectiveResolutions X.Modules]` instance hypothesis present in all Lean signatures but only documented in the definition block `% NOTE`; the three downstream statement blocks do not record it.
  2. `flatBaseChange_higherDirectImage_isIso`: missing `hi : 1 ≤ i` — Lean states the result for all `i : ℕ`, blueprint says "every i ≥ 1". Acknowledged in Lean header comment, not in blueprint.
  3. `flatBaseChange_higherDirectImage_isIso`: conclusion is `Nonempty (…≅…)` (existential) while blueprint prose claims a specific canonical isomorphism. Acknowledged in Lean doc comment, not in blueprint.
- **minor**: none beyond the above.

**Overall verdict**: The file scaffolds faithfully and honestly — four declarations, one with a proper body and three with acknowledged sorry proofs matching blueprint intent — but carries three major blueprint-documentation gaps around the `[HasInjectiveResolutions]` propagation and the two conscious weakening choices in `flatBaseChange_higherDirectImage_isIso`.
