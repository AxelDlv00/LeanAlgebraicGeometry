# Lean ↔ Blueprint Check Report

## Slug
rationalcurveiso-iter179

## Iteration
179

## Files audited
- Lean: `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`
- Blueprint: `blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex`

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.morphismToP1OfGlobalSections}` (chapter: `lem:morphism_to_p1_from_global_sections`)
- **Lean target exists**: yes (L204 in the Lean file; `noncomputable def`).
- **Signature matches**: **partial** — the Lean takes `(f : MvPolynomial (Fin 2) kbar →+* Γ(X.left, ⊤))`, `_halg` (a concrete `kbar`-algebra-map equation), and `_hf` (irrelevant-ideal → unit ideal). The blueprint statement frames the lemma as "two global sections `s₀, s₁ ∈ H⁰(X, ℒ)` of an invertible sheaf without common zeros → unique morphism `φ : X → ℙ¹` with `φ*𝒪(1) = ℒ` and `φ*xᵢ = sᵢ`". The Lean specialises the input shape to the algebra-hom packaging consumed by `Proj.fromOfGlobalSections` (so implicitly `ℒ = 𝒪_X` with sections embedded into `Γ(X, ⊤)`), and adds the `_halg` `kbar`-algebra-compatibility hypothesis that the chapter never mentions. The Lean conclusion is the morphism in `Over (Spec kbar)`; the blueprint claims existence + uniqueness + line-bundle-pullback + section-pullback identities, none of which are output by the Lean wrapper (it returns only the morphism, with no uniqueness/pullback bundling).
- **Proof follows sketch**: **partial** — the Lean body genuinely invokes `Proj.fromOfGlobalSections (projectiveLineBarGrading kbar) f _hf` and closes the slice-category section condition via `Proj.fromOfGlobalSections_toSpecZero`, `Scheme.toSpecΓ_naturality`, and `toSpecΓ_SpecMap_ΓSpecIso_inv` (a substantive ~20-line tactic chain that uses `_halg` to bridge `f.comp MvPolynomial.C` to `(ΓSpecIso _).inv ≫ X.hom.appTop`). This matches the chapter's high-level "specialise `Proj.fromOfGlobalSections` to `ℕ`-graded `k̄[x₀, x₁]`" strategy. **However**, the chapter's proof sketch additionally claims the wrapper "chains `Proj.fromOfGlobalSections` with the chart-restriction-and-glue pattern of `Scheme.Cover.glueMorphisms`" (L150-154). The actual Lean body uses neither `glueMorphisms` nor any chart cover — the chart-glue reduction (`ℒ`-sections → algebra-hom into `Γ(X, ⊤)`) is absorbed into the **caller's** responsibility to construct `f`. The blueprint prose overstates what this wrapper does.
- **notes**: pin verified kernel-clean by `lean_diagnostic_messages` (no `sorry` warning at L204; warnings only at L296 / L356). Signature now correctly threads `_halg` — the iter-178 audit gap (audited on the OLD signature without `_halg`) is resolved on the Lean side, but the chapter prose has not been updated to mention `_halg`, the slice-category section-condition obligation, or the fact that the chart-glue is upstream rather than inside this wrapper.

### `\lean{AlgebraicGeometry.Scheme.morphism_degree_via_pole_divisor}` (chapter: `lem:degree_via_pole_divisor`)
- **Lean target exists**: yes (L296; `theorem ... := sorry`).
- **Signature matches**: per directive, off-target this iter — flagging blueprint adequacy only. (Observation, not classified as a finding: the Lean conclusion `∃ d D, 0 < d ∧ D.degree = (d : ℤ)` is substantially weaker than the chapter's claim that `D = φ^*[∞] = ∑ ord_P(φ^*t_∞)·[P]` and `d = [K(C):k̄(ℙ¹)] = deg(φ)`; the chapter ties `D` and `d` to `φ` whereas the Lean leaves them existentially unrelated to `φ`. Iter-178+ work should tighten before the body lands.)
- **Proof follows sketch**: N/A — `sorry` body.
- **notes**: blueprint side carries `\leanok` on the statement block (L168), matching the file-skeleton policy.

### `\lean{AlgebraicGeometry.Scheme.iso_of_degree_one}` (chapter: `lem:degree_one_morphism_iso`)
- **Lean target exists**: yes (L356; `theorem ... := sorry`).
- **Signature matches**: per directive, off-target this iter — flagging blueprint adequacy only. (Observation: blueprint hypothesis is `deg(φ) = 1`; Lean encodes it as `Nonempty (C'.left.functionField ≃+* C.left.functionField)` — a function-field iso whose existence the Lean does NOT tie to `φ`. Blueprint conclusion is "`φ` is an isomorphism"; Lean conclusion is `Nonempty (C ≅ C')` — there exists *some* iso, not necessarily `φ`. Iter-178+ work should tighten.)
- **Proof follows sketch**: N/A — `sorry` body.
- **notes**: blueprint side carries `\leanok` on the statement block (L251), matching the file-skeleton policy.

### `\lean{AlgebraicGeometry.genusZero_curve_iso_P1}` (chapter: `thm:genus_zero_curve_iso_p1`)
- **Lean target exists**: yes — but **declaration lives outside this file**, at `AlgebraicJacobian/AbelianVarietyRigidity.lean:290` (Pin 4 cross-reference; §0 of the file documents this).
- **Signature matches**: out of scope for this file pair — the chapter explicitly states the `\lean{...}` resolves to the AVR.lean target (chapter L46-49, L367-373) and §0 of the Lean file mirrors that disclosure.
- **Proof follows sketch**: N/A — body lives in AVR.lean and is `sorry`.
- **notes**: cross-reference is consistent on both sides.

## Red flags

### Placeholder / suspect bodies
- `morphism_degree_via_pole_divisor` at L306: body is `sorry`. Blueprint flags the proof as fully detailed (Hartshorne II.6.9 + finiteness argument) — per directive, off-target this iter, no must-fix classification.
- `iso_of_degree_one` at L369: body is `sorry`. Blueprint provides a detailed scheme-theoretic argument plus an alternative direct argument — per directive, off-target this iter, no must-fix classification.

### Excuse-comments
None. The file's status block (L36-43) frankly labels the file as "iter-177 Lane 8 file-skeleton" with iter-178+ as the body window; that is honest workflow documentation, not an excuse for wrong code.

### Axioms / Classical.choice on non-trivial claims
None. The only `Classical.choice` token in the file is in the docstring of §0 saying "no `Classical.choice ⟨witness⟩` placeholders are used".

## Unreferenced declarations (informational)

None. The file contains exactly three substantive declarations (`morphismToP1OfGlobalSections`, `morphism_degree_via_pole_divisor`, `iso_of_degree_one`), every one is `\lean{...}`-pinned in the chapter.

## Blueprint adequacy for this file

- **Coverage**: 3/3 in-file declarations have `\lean{...}` references in the chapter (plus the Pin-4 cross-reference to AVR.lean). No unreferenced helpers.
- **Proof-sketch depth**: **under-specified for Pin 1**, adequate for Pins 2/3/4. Pin 1's chapter proof (L118-162) explains the Mathlib `Proj.fromOfGlobalSections` invocation and discusses chart-glue, but does not preview either of the two substantive ingredients of the *actually closed* Lean body:
  1. The `_halg` algebra-compatibility hypothesis (without which the slice-category section condition over `Spec kbar` cannot be derived). The Lean docstring (L186-188) is explicit: "`halg` is the `kbar`-algebra-compatibility condition (without which the section condition over `Spec kbar` cannot be derived)". The chapter is silent on this obligation.
  2. The slice-category lift via `Over.homMk` and the section-condition proof that uses `Scheme.toSpecΓ_naturality` + `toSpecΓ_SpecMap_ΓSpecIso_inv` + `Proj.fromOfGlobalSections_toSpecZero`. The chapter's proof talks about "Mathlib's `Proj.fromOfGlobalSections` lands in `Proj 𝒜 = ℙ¹`" but skips the lift to `Over (Spec k̄)`.

  Additionally, the chapter says the wrapper performs chart-glue via `Scheme.Cover.glueMorphisms`; the actual wrapper does no chart-glue and pushes that obligation to its caller (the caller must already have assembled `f : MvPolynomial (Fin 2) kbar →+* Γ(X.left, ⊤)`). This is a divergence: the Lean is correct for its downstream `(1, f)`-from-`H⁰(C, 𝒪_C([P]))` consumer in Pin 4, but the chapter prose materially overstates the wrapper's scope.

- **Hint precision**: precise. `\lean{...}` targets resolve and namespaces (`AlgebraicGeometry.Scheme.*`) line up.
- **Generality**: **too broad on the prose side**. The chapter states Pin 1 in arbitrary-invertible-sheaf-plus-two-sections generality, but the Lean wrapper is correctly restricted to the algebra-hom shape that the downstream genus-0 caller actually uses (`(1, f)` from `H⁰(C, 𝒪_C([P]))`). The blueprint over-promises an `ℒ`-arbitrary lemma whose Lean realisation only covers the `Γ(X, ⊤)` case; downstream callers must perform the trivialisation themselves before calling the wrapper.

- **Recommended chapter-side actions** (for blueprint-writing subagent, not blocking this iter):
  - Amend the statement of `lem:morphism_to_p1_from_global_sections` to mention either (a) restrict to the `ℒ = 𝒪_X` / `Γ(X, ⊤)` case to match the Lean, or (b) explicitly note that the Lean wrapper accepts the post-trivialisation algebra-hom shape and the caller's chart-restriction work is upstream.
  - Add a sentence to the proof body previewing the `_halg` `kbar`-algebra-compatibility hypothesis and its role in closing the slice-category section condition (the chapter's quote of `Proj.fromOfGlobalSections` shows the Mathlib signature has no analogue of `_halg`, so a reader cannot derive its necessity from the quoted signature alone).
  - Drop or rewrite the claim that the wrapper "chains `Proj.fromOfGlobalSections` with the chart-restriction-and-glue pattern of `Scheme.Cover.glueMorphisms`" (L150-154) — the actual body uses neither cover nor `glueMorphisms`.

## Severity summary

- **must-fix-this-iter**: none. Pin 1 is kernel-clean, body is substantive and faithful to the chapter's high-level strategy. Pin 2 and Pin 3 carry `sorry` bodies but per directive are off-target this iter; their statement blocks are `\leanok`-marked as file-skeleton stubs, which is consistent with the iter-177 file-skeleton policy + iter-178+ body window.
- **major**: blueprint chapter under-specifies Pin 1 in three concrete ways (`_halg` not previewed, slice-category section-condition not previewed, chart-glue claim overstated). These do not invalidate the closed proof but should be addressed by a blueprint-writing subagent so the chapter is faithful to the Lean shape that actually shipped.
- **minor**: none.

Overall verdict: Pin 1's closed body is kernel-clean and substantively faithful to the chapter's strategic sketch; the chapter prose itself, however, materially overstates the wrapper's scope and omits the `_halg` hypothesis that the closed proof relies on — a blueprint-side `major` for a follow-up blueprint-writer dispatch, not a Lean-side blocker.
