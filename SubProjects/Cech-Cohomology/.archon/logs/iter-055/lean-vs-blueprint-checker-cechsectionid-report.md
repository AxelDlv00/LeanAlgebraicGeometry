# Lean ↔ Blueprint Check Report

## Slug
cechsectionid

## Iteration
055

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechSectionIdentification.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (Sub-brick A section: `lem:cech_backbone_left_sigma` through `lem:cechSection_contractible`)

---

## Per-declaration

### `\lean{AlgebraicGeometry.cechBackbone_left_sigma}` (chapter: `lem:cech_backbone_left_sigma`)
- **Lean target exists**: yes
- **Signature matches**: yes
  - Blueprint: `Y_p ≅ ∐_σ Over.mk j_σ` in `Over X`, σ : Fin(p+1) → I, j_σ the open immersion of `coverInterOpen 𝒰 σ`.
  - Lean: `(coverCechNerveOver 𝒰).obj (op [p]) ≅ ∐ fun σ : Fin(p+1) → 𝒰.I₀ => Over.mk (coverInterOpen 𝒰 σ).ι`
  - Perfect match on LHS (the degree-p Čech backbone), coproduct index type `Fin(p+1) → 𝒰.I₀`, and `Over.mk j_σ` form.
- **Proof follows sketch**: N/A (body is `sorry`)
- **Notes**: None. Signature is unambiguous.

### `\lean{AlgebraicGeometry.pushPull_sigma_iso}` (chapter: `lem:pushPull_sigma_iso`)
- **Lean target exists**: yes
- **Signature matches**: yes (mathematical content)
  - Blueprint: `pushPullObj F Y_p ≅ ∏_σ pushPullObj F (Over.mk j_σ)` in `X.Modules`.
  - Lean: uses `∏` (not `∏ᶜ`) at line 125–126 for the product in `X.Modules`.
  - Mathematical content matches. However, the `∏` notation at line 126 is the known compile blocker (see Red Flags below): other files in the project use `∏ᶜ` for categorical products, and `∏` at line 126 either parses as `Pi.type` or is unresolved with the current imports.
- **Proof follows sketch**: N/A (body is `sorry`)
- **Notes**: The notation fix (`∏` → `∏ᶜ` at line 126) is syntactic; the mathematical signature is exactly right.

### `\lean{AlgebraicGeometry.pushPull_leg_sections}` (chapter: `lem:pushPull_leg_sections`)
- **Lean target exists**: yes
- **Signature matches**: yes
  - Blueprint: `Γ(V, pushPullObj F (Over.mk j_σ)) ≅ Γ(U_σ ∩ V, F)` as Ab objects.
  - Lean LHS: `((SheafOfModules.forget X.ringCatSheaf).obj (pushPullObj F (Over.mk (coverInterOpen 𝒰 σ).ι))).presheaf.obj (op V)` — this is exactly `Γ(V, ...)` accessed via the forgetful functor to presheaves.
  - Lean RHS: `((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.obj (op (coverInterOpen 𝒰 σ ⊓ V))` — this is `Γ(U_σ ∩ V, F)`, same access path.
  - `coverInterOpen 𝒰 σ ⊓ V` correctly represents `U_σ ∩ V`. Implicit `{p : ℕ}` is appropriate since `σ : Fin(p+1) → 𝒰.I₀` pins `p`.
- **Proof follows sketch**: N/A (body is `sorry`)
- **Notes**: Clean. The type lives in `AddCommGrpCat` (via `.presheaf.obj`), matching the blueprint's "as Ab objects."

### `\lean{AlgebraicGeometry.pushPull_eval_prod_iso}` (chapter: `lem:pushPull_eval_prod_iso`)
- **Lean target exists**: yes
- **Signature matches**: yes
  - Blueprint: `Γ(V, pushPullObj F Y_p) ≅ ∏_σ Γ(U_σ ∩ V, F)` for all p, V.
  - Lean LHS: `((SheafOfModules.forget ...).obj (pushPullObj F ((coverCechNerveOver 𝒰).obj (op [p])))).presheaf.obj (op V)` = `Γ(V, pushPullObj F Y_p)`. Correct.
  - Lean RHS: `∏ᶜ fun σ : Fin(p+1) → 𝒰.I₀ => ((SheafOfModules.forget ...).obj F).presheaf.obj (op (coverInterOpen 𝒰 σ ⊓ V))` = `∏_σ Γ(U_σ ∩ V, F)`. The `∏ᶜ` notation is the project-standard categorical product in `AddCommGrpCat` (used in `PresheafCech.lean:305`, `CechAcyclic.lean`, etc.). Correct.
- **Proof follows sketch**: N/A (body is `sorry`)
- **Notes**: Clean. `∏ᶜ` is correct here (product in `AddCommGrpCat`).

### `\lean{AlgebraicGeometry.cechSection_complex_iso}` (chapter: `lem:cechSection_complex_iso`)
- **Lean target exists**: yes
- **Signature matches**: yes (mathematical content)
  - Blueprint: The augmented Čech complex evaluated at V is isomorphic, as a cochain complex, to the concrete section Čech complex over `(coverInterOpen 𝒰 · ∩ V)`.
  - Lean: `D ≅ D'` where `D` is the evaluated Čech complex (via `GV.mapHomologicalComplex`) and `D' = sectionCechComplex (fun i => coverOpen 𝒰 i ⊓ V) Fp`. Both are `CochainComplex AddCommGrpCat ℕ`.
  - The family `fun i => coverOpen 𝒰 i ⊓ V` produces multi-index opens `⊓_k (coverOpen 𝒰 (σ k) ⊓ V) = coverInterOpen 𝒰 σ ⊓ V`, matching the blueprint's `U_σ ∩ V`. Correct.
  - The `PresheafOfModules.restrictScalars α` adapter (with `α = 𝟙 X.ringCatSheaf.obj`) is the bridge between `SheafOfModules.forget` landing in `PresheafOfModules X.ringCatSheaf.val` and `PresheafOfModules.toPresheaf X.ringCatSheaf.obj`. The planner's AMBIGUITY FLAG notes this adapter path needs verification against `CechAugmentedResolution.lean:185–205`. This is appropriate due diligence, not a signature error.
  - The `let`-binding style in the type is unusual (makes the goal opaque to tactics) but mathematically valid in Lean 4.
- **Proof follows sketch**: N/A (body is `sorry`)
- **Notes**: The prover should verify that `X.ringCatSheaf.obj` (used in `α`) resolves consistently with the path taken in `CechAugmentedResolution.lean`. This is a planner-flagged implementation detail, not a statement-level error.

### `\lean{AlgebraicGeometry.cechSection_contractible}` (chapter: `lem:cechSection_contractible`)
- **Lean target exists**: yes
- **Signature matches**: yes
  - Blueprint: Given `V ≤ coverOpen 𝒰 i_fix`, the concrete section Čech complex `D'` over `U'_j = coverInterOpen 𝒰 j ∩ V` admits a contracting homotopy `id_{D'} ≃ 0`.
  - Lean hypothesis: `(hiV : V ≤ coverOpen 𝒰 i_fix)`. Correct.
  - Lean conclusion: `Homotopy (𝟙 D') 0` where `D' = sectionCechComplex (fun i => coverOpen 𝒰 i ⊓ V) Fp`. This is exactly a contracting homotopy `id_{D'} ≃ 0` in `CochainComplex AddCommGrpCat ℕ`. Correct.
  - The `\uses{lem:cech_acyclic_affine}` edge in the blueprint is purely for the Lean location of the dependent-coefficient engine, not a mathematical dependency. Stub's planner note correctly reflects this.
- **Proof follows sketch**: N/A (body is `sorry`)
- **Notes**: Cleanest stub in the file. Blueprint and Lean are in perfect alignment.

---

## Red Flags

### Placeholder / suspect bodies

All 6 declarations have `:= sorry` bodies on non-trivial claims that the blueprint fully states and proves. Per severity rules each is **must-fix-this-iter**. Contextual note: the file was scaffolded this iteration as a new shared "Sub-brick A" extraction; the sorries are expected scaffold state to be filled in the next prover phase. The must-fix classification still applies (the prover gate fires on sorry in blueprint-substantive declarations).

- `cechBackbone_left_sigma` (line 78): `:= sorry`. Blueprint `lem:cech_backbone_left_sigma` has a full proof.
- `pushPull_sigma_iso` (line 127): `:= sorry`. Blueprint `lem:pushPull_sigma_iso` has a full proof.
- `pushPull_leg_sections` (line 168): `:= sorry`. Blueprint `lem:pushPull_leg_sections` has a full proof.
- `pushPull_eval_prod_iso` (line 206): `:= sorry`. Blueprint `lem:pushPull_eval_prod_iso` has a full proof.
- `cechSection_complex_iso` (line 263): `:= sorry`. Blueprint `lem:cechSection_complex_iso` has a full proof.
- `cechSection_contractible` (line 320): `:= sorry`. Blueprint `lem:cechSection_contractible` has a full proof.

### Compile blockers (must-fix-this-iter)

- **Line 126 — `∏` notation in `X.Modules` context**: `pushPull_sigma_iso` uses `∏ fun σ ...` for the categorical product in `X.Modules`. All other categorical products in this project use `∏ᶜ` (see `PresheafCech.lean:305`, `CechAcyclic.lean:1421`, `CechToCohomology.lean:106`). With the current imports and opens, `∏` at line 126 is either parsed as `Pi.type` (wrong) or unresolved, causing the compile error that `CechAugmentedResolution.lean:224` explicitly documents. Fix: change `∏` to `∏ᶜ` at line 126 to match the project convention for categorical products.

- **Missing `open Over`**: `Over.mk` appears in stub 1 (line 77) and stub 2 (line 126). The file opens `CategoryTheory Limits Scheme.Modules Opposite` but not `CategoryTheory.Over`. This may resolve through the transitive import chain, but the `CechAugmentedResolution.lean:224` note lists "`Over.mk` out of scope" as a compile issue. Fix: add `Over` to the `open` statement.

- **`evaluation` functor resolution** (stub 5, line 258): `evaluation (TopologicalSpace.Opens X)ᵒᵖ AddCommGrpCat` — with `open CategoryTheory`, this should resolve as `CategoryTheory.Functor.evaluation`, but may need `open Functor` or explicit qualification if the LSP throws an ambiguity error.

### Excuse-comments

None. The planner strategy comments are properly demarcated as strategy/instruction text, not as excuses for wrong code.

### Axioms / Classical.choice on non-trivial claims

None.

---

## Unreferenced declarations (informational)

None. The Lean file contains exactly the 6 stubs corresponding to the 6 blueprint lemmas, plus module-level documentation and planner strategy comments (not declarations). No unreferenced substantive declarations.

---

## Blueprint adequacy for this file

- **Coverage**: 6/6 Lean declarations have a corresponding `\lean{...}` block in the blueprint. Zero unreferenced substantive declarations; zero missing `\lean{...}` hints.

- **Proof-sketch depth**: **adequate**. Every lemma in the blueprint has:
  - A clear informal statement with explicit types and categories.
  - A multi-step proof sketch with named Mathlib anchors (`TopCat.Sheaf.isProductOfDisjoint`, `SheafOfModules.evaluationPreservesLimitsOfShape`, `HomologicalComplex.mkIso`, etc.) and explicit `\uses{}` dependencies.
  - The Lean planner strategy comments in the stubs mirror the blueprint proof sketches precisely, confirming the blueprint was detailed enough to guide the scaffold.

- **Hint precision**: **precise**. Each `\lean{AlgebraicGeometry.<name>}` hint pins the exact qualified name used in the Lean file. No ambiguity between Mathlib predicates.

- **Generality**: **matches need**. The blueprint states results at exactly the level of generality the Lean file needs. No parallel API required.

- **Recommended chapter-side actions**: None. The blueprint Sub-brick A chain is one of the best-specified sections in the chapter. The only documentation improvement would be to note that `∏ᶜ` (not `∏`) is the project-standard categorical product notation — a minor editorial note, not blocking.

---

## Severity summary

| Item | Severity | Notes |
|------|----------|-------|
| All 6 stubs have `:= sorry` body | **must-fix-this-iter** | Expected scaffold; provers must fill next phase |
| `∏` at line 126 (stub 2) should be `∏ᶜ` | **must-fix-this-iter** | Compile blocker documented in `CechAugmentedResolution.lean:224` |
| Missing `open Over` for `Over.mk` | **must-fix-this-iter** | Compile blocker preventing prover use |
| `evaluation` functor qualification | **major** | May resolve via imports; needs verification |
| `let`-binding style in `cechSection_complex_iso` type | **minor** | Tactically awkward but mathematically valid |
| `X.ringCatSheaf.obj` vs `.val` in stub 5's adapter | **minor** | Planner-flagged; prover should verify against `CechAugmentedResolution.lean` |

**Overall verdict**: The 6 stub signatures faithfully match the blueprint's Sub-brick A chain — all mathematical types, quantifiers, and categories are correct — but three compile blockers (sorry bodies, `∏` → `∏ᶜ` at line 126, missing `open Over`) must be fixed before provers can use the file.
