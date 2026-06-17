# Lean ↔ Blueprint Check Report

## Slug
gf

## Iteration
002

## Files audited
- Lean: `AlgebraicJacobian/Picard/FlatteningStratification.lean`
- Blueprint: `blueprint/src/chapters/Picard_FlatteningStratification.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.genericFlatnessAlgebraic}` (chapter: `thm:generic_flatness_algebraic`)

- **Lean target exists**: yes — `theorem genericFlatnessAlgebraic` at line 181
- **Signature matches**: yes — exact verbatim match with the blueprint's `% INTENDED LEAN SIGNATURE` block (lines 70–76 of the chapter); every instance variable, every hypothesis, and the conclusion type match character-for-character
- **Proof follows sketch**: partial — the `by_cases hAM : Module.Finite A M` split is faithful to the blueprint's primary-route / surviving-residue decomposition:
  - **Primary branch** (`hAM` true): closed axiom-clean via `GenericFreeness.exists_free_localizationAway_of_finite`, which in turn delegates to `Module.FinitePresentation.exists_free_localizedModule_powers` — exactly the Mathlib lemma the blueprint names
  - **Residue branch** (`hAM` false): `sorry` — consistent with the blueprint's explicit "surviving residue (still sorry)" note and the absence of `\leanok` on the proof block
- **Notes**:
  - LSP diagnostics: only one sorry-warning at line 181; no errors. The primary branch is axiom-clean.
  - `\leanok` placement is correct: on the statement block (declaration exists with at least a sorry), not on the proof block (proof incomplete).
  - The three `GenericFreeness` helpers (`exists_free_localizationAway_of_finite`, `exists_flat_localizationAway_of_finite`, `exists_free_localizationAway_of_moduleFinite`) carry no sorries and compile cleanly.

---

### `\lean{AlgebraicGeometry.genericFlatness}` (chapter: `thm:generic_flatness`)

- **Lean target exists**: yes — `theorem genericFlatness` at line 229
- **Signature matches**: yes — the Lean signature carries `[F.IsQuasicoherent] [F.IsFiniteType]` precisely as specified in the blueprint's `% CORRECTED INTENDED LEAN SIGNATURE` block (chapter lines 178–181); the full flatness conclusion (the `∀`-quantification over affine opens with `letI` module-structure) is present in the Lean but only summarised as "… (flatness conclusion unchanged)" in the blueprint note — the Lean conclusion is correct
- **Proof follows sketch**: partial — the proof opens by extracting a non-empty affine open `U₀ ⊆ S` (matching the blueprint's "restrict to a non-empty affine open Spec A ⊆ S"), then leaves the remaining assembly as `sorry` with a detailed inline comment naming the missing steps; this is faithful to the blueprint's one-paragraph proof
- **Notes**:
  - LSP diagnostics: only one sorry-warning at line 229; no errors.
  - `\leanok` placement is correct: on the statement block only, not on the proof block.
  - The `% NOTE:` in the chapter describes the *pre-correction* state ("currently takes `F : X.Modules` with NO coherence hypothesis, so it is FALSE as stated"). Since the Lean file already carries the corrected signature, this note is **stale** — it should be reframed as "was false before re-sign; corrected signature below." This is a minor documentation issue, not a code correctness issue.

---

## Red flags

### Placeholder / suspect bodies

- `genericFlatnessAlgebraic` at line 181: the `sorry` is in the residue branch of a `by_cases`; the primary branch is closed. The blueprint explicitly acknowledges this as an outstanding gap (Mathlib does not yet have the polynomial-ring core of generic freeness). The theorem *statement* is correct and non-trivial. This is an expected, blueprint-authorised sorry — not a fake placeholder.
- `genericFlatness` at line 229: the proof body is `sorry` after scaffolding the affine-open witness. The blueprint's proof block has no `\leanok` and the `% NOTE:` explains the gap. Expected and blueprint-authorised.

**No other red flags.** No axiom declarations. No `Classical.choice _` on substantive claims. No excuse-comments of the form "wrong but works for now" — the inline proof comments describe genuine mathematical content of what remains and name candidate Lean APIs, which is informative documentation, not an excuse.

---

## Unreferenced declarations (informational)

All three `GenericFreeness` helpers lack an individual `\lean{...}` pin:

| Declaration | Status |
|---|---|
| `GenericFreeness.exists_free_localizationAway_of_finite` | No pin — but directly called from `genericFlatnessAlgebraic`'s primary branch; mentioned collectively in the blueprint's Mathlib-status section |
| `GenericFreeness.exists_flat_localizationAway_of_finite` | No pin — axiom-clean; not yet called from outside the namespace in this file |
| `GenericFreeness.exists_free_localizationAway_of_moduleFinite` | No pin — axiom-clean; not yet called from outside the namespace |

None of these suggest a problem. They are bona-fide proof helpers. `exists_flat_localizationAway_of_finite` and `exists_free_localizationAway_of_moduleFinite` are forward-looking reusable lemmas that will be needed when the dévissage residue and the finite-morphism case of the globalization are addressed — consider adding a brief collective `\lean{...}` note to the blueprint for discoverability.

---

## Blueprint adequacy for this file

**Coverage**: 2/2 blueprint-pinned Lean declarations (`genericFlatnessAlgebraic`, `genericFlatness`) exist and are reachable from the file. Three helpers are unreferenced — acceptable for supporting lemmas.

**Proof-sketch depth**: **under-specified** for two of the four proof segments:

1. **`thm:generic_flatness_algebraic`, primary route** — adequate. The blueprint names the Mathlib lemma (`Module.FinitePresentation.exists_free_localizedModule_powers`), describes the generic-fibre argument, and the Lean proof matches it exactly.

2. **`thm:generic_flatness_algebraic`, dévissage residue** — under-specified. The blueprint gives the high-level induction schema (prime filtration → Noether normalisation → clearing denominators → splicing) but does not:
   - Name the Lean induction principle to use for the prime-filtration step (the blueprint mentions `IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime` in the Mathlib-status section but not in the proof block itself)
   - Name a Lean lemma for the "splicing fact" (`M_{f'f''}` free when `M'_{f'}` and `M''_{f''}` are free)
   - Identify the Lean API for the Noether-normalisation step (clearing denominators to make `Bₘ` finite over `Aₘ[b₁,…,bₙ]`)
   - State what the bottom of the induction should call (the polynomial-ring core is acknowledged as missing from Mathlib, but no stub or tracked gap name is given for when it becomes available)
   A prover attempting to close this sorry would face substantial API discovery with no blueprint guidance.

3. **`thm:generic_flatness`, geometric globalization** — under-specified. The blueprint proof is one paragraph (~4 sentences). The Lean proof comment is more informative than the blueprint prose, naming specific API candidates. Key gaps in the blueprint:
   - No guidance on extracting `Γ(F, W)` as a finite module over a finite-type `A`-algebra `B` (which coherence + finite-type API to use)
   - No guidance on quasi-compactness of `p⁻¹(U₀)` needed to reduce to a finite affine cover
   - No API reference for flatness-from-freeness (the blueprint does not name `Module.Flat.of_free` or `Module.flat_of_isLocalized_maximal`)
   - "Shrinking to the basic open D(∏ fⱼ)" is stated but not translated into Lean opens API

4. **`thm:generic_flatness`, scaffolding start** — adequate. The blueprint's "restrict to a non-empty affine open" is faithfully implemented by the `exists_isAffineOpen_mem_and_subset` call.

**Hint precision**: 
- `genericFlatnessAlgebraic`: **precise** — the `% INTENDED LEAN SIGNATURE` block is verbatim-accurate
- `genericFlatness`: **partially precise** — the `% CORRECTED INTENDED LEAN SIGNATURE` in the `% NOTE:` block gives the hypothesis header but abbreviates the full flatness conclusion as "… (flatness conclusion unchanged)". For a prover relying on the blueprint alone the full formal conclusion (`∀ {U : S.Opens} (_ : IsAffineOpen U) (_ : U ≤ V) {W : X.Opens} (_ : IsAffineOpen W) (e : W ≤ p ⁻¹ᵁ U), letI : Module Γ(S, U) Γ(F, W) := Module.compHom _ (p.appLE U W e).hom ⊢ Module.Flat Γ(S, U) Γ(F, W)`) should appear verbatim. The abbreviation is a latent source of drift.

**Generality**: matches need — both theorems are at the correct level of generality for the project.

**Recommended chapter-side actions** (for a blueprint-writing subagent):

1. In the `thm:generic_flatness` `% NOTE:`: update the stale description — reframe "currently takes `F : X.Modules` with NO coherence hypothesis" as past-tense ("previously lacked coherence hypothesis; re-signed in iter-002 to add…"); update `% CORRECTED INTENDED LEAN SIGNATURE` to include the full flatness conclusion verbatim rather than "… (flatness conclusion unchanged)".

2. In the `thm:generic_flatness` proof block: expand the one-paragraph sketch to name the key Lean API steps:
   - Quasi-compactness API for obtaining the finite affine cover of `p⁻¹(U₀)`
   - Coherence API for reading off `Γ(F, W)` as a finite module over the finite-type algebra `Γ(X, W)`
   - `Module.Flat.of_free` (or whichever flatness-from-freeness lemma applies) for the conclusion step

3. In the `thm:generic_flatness_algebraic` proof block: move the key API names from the Mathlib-status section into the dévissage sub-proof, specifically:
   - Name the Lean induction principle for prime filtration (`IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime`)
   - Name a splicing lemma or indicate it needs to be constructed
   - Create a named tracked gap ("polynomial-ring core of generic freeness") with a stub placeholder so the prover knows the bottom-of-induction target

4. Consider adding `\lean{...}` pins for `GenericFreeness.exists_free_localizationAway_of_finite` (at minimum) since it is the direct building block of the primary-route proof and already axiom-clean.

---

## Severity summary

| # | Finding | Severity |
|---|---|---|
| 1 | `% NOTE:` on `thm:generic_flatness` still describes the pre-correction state as current; minor stale documentation | **minor** |
| 2 | `% CORRECTED INTENDED LEAN SIGNATURE` for `thm:generic_flatness` abbreviates the flatness conclusion; full verbatim form absent from the blueprint | **minor** |
| 3 | Blueprint proof sketch for `thm:generic_flatness` geometric globalization is under-specified — no API guidance for coherence extraction, quasi-compactness, or flatness-from-freeness | **major** (blueprint adequacy) |
| 4 | Blueprint proof sketch for `thm:generic_flatness_algebraic` dévissage residue lacks API-level guidance for the prime-filtration, splicing, and Noether-normalisation Lean steps | **major** (blueprint adequacy) |

No must-fix-this-iter findings. Both sorries are on acknowledged incomplete proof segments the blueprint does not claim are closed. Both Lean signatures exactly match their blueprint targets. No axioms, no fake placeholders, no excuse-comments.

**Overall verdict**: The Lean file faithfully implements the blueprint — both signatures are exact verbatim matches, the proof decompositions follow the blueprint's structure, and the sorries fall on blueprint-authorised open obligations — but the blueprint is inadequate to guide a prover past the sorry boundaries: the dévissage residue and geometric globalization proof blocks are under-specified and should be expanded by a blueprint-writing pass before the next prover iteration on these gaps.
