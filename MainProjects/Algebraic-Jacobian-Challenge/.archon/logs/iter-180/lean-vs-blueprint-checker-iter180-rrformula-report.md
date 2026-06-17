# Lean ↔ Blueprint Check Report

## Slug
iter180-rrformula

## Iteration
180

## Files audited
- Lean: `AlgebraicJacobian/RiemannRoch/RRFormula.lean`
- Blueprint: `blueprint/src/chapters/RiemannRoch_RRFormula.tex`

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.eulerCharacteristic}` (chapter: `def:eulerChar_curve`)
- **Lean target exists**: yes (`RRFormula.lean:124–132`).
- **Signature matches**: yes. Takes `(C : Over (Spec (.of kbar)))` with the standard `[IsProper] [SmoothOfRelativeDimension 1] [GeometricallyIrreducible]` package and a `Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} kbar)`; returns `ℤ`. Faithfully encodes the chapter's two-term form `χ(𝓕) = dim H⁰ − dim H¹` (the curve specialisation justified by Grothendieck vanishing as the chapter explains).
- **Proof follows sketch**: N/A (definition).
- **notes**: One non-cosmetic gap vs. chapter prose — the chapter says "let `𝓕` be a coherent sheaf" but the Lean signature takes an arbitrary `Sheaf … (ModuleCat kbar)` with no `Coherent` typeclass; the chapter's "paragraph: Lean signature scope" already documents the project's `Scheme.HModule` wrapper choice and accepts this elision, so signature drift is intentional and labelled. Acceptable. `noncomputable` matches the prose's parenthetical.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.l}` (chapter: `def:l_invariant`)
- **Lean target exists**: yes (`RRFormula.lean:192–193`).
- **Signature matches**: yes. `(D : C.left.WeilDivisor) : ℕ` defined as `Module.finrank kbar (Scheme.HModule kbar (sheafOf (C := C) D) 0)` — exactly the chapter's `ℓ(D) := dim H⁰(C, 𝒪_C(D))`.
- **Proof follows sketch**: N/A (definition).
- **notes**: Threads `Scheme.WeilDivisor.sheafOf` for the `𝒪_C(D)` argument. The chapter's "Lean signature scope" paragraph explicitly documents that `𝒪_C(D)` is RR.3 work and that the present chapter consumes only its `H⁰` functor — the placeholder is admitted by chapter prose.

### `\lean{AlgebraicGeometry.Scheme.eulerCharacteristic_eq_degree_plus_one_minus_genus}` (chapter: `thm:euler_char_eq_deg_plus_one_minus_genus`)
- **Lean target exists**: yes (`RRFormula.lean:224–232`).
- **Signature matches**: yes. States `Scheme.eulerCharacteristic C (sheafOf D) = (degree D : ℤ) + 1 − (genus C : ℤ)` for any `D : C.left.WeilDivisor`, under the standing typeclass package + `[IsIntegral C.left]`. Exact transcription of `χ(𝒪_C(D)) = deg(D) + 1 − g`.
- **Proof follows sketch**: N/A — body is `:= sorry` (carried over from iter-174 file-skeleton; not touched this iter). The chapter contains the full Hartshorne IV.1.3 inductive sketch (base case `D = 0` via `H⁰(C, 𝒪_C) = 1` + `H¹(C, 𝒪_C) = g`; `D ↔ D + [P]` step via skyscraper SES, χ-additivity, `χ(k(P)) = 1`), plus an explicit Lean-reference note documenting the Mathlib gap (`CategoryTheory.ShortExact.eulerChar_additive` not in Mathlib `b80f227`; project-side closure path via `Submodule.finrank_quotient_add_finrank` + long-exact sequence). The proof body in the Lean is intentionally deferred; the chapter explicitly anticipates iter-175+ closure.
- **notes**: This is the project's next-smallest sorry per the directive. Blueprint prose is iter-181+-ready.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.l_eq_degree_plus_one_of_genus_zero}` (chapter: `thm:riemannRoch_genus_zero`)
- **Lean target exists**: yes (`RRFormula.lean:253–267`). This is the iter-180 closure target.
- **Signature matches**: yes. Takes `(D : C.left.WeilDivisor)`, `(_hg : genus C = 0)`, `(_hdeg : (0 : ℤ) ≤ degree D)`, `(_hH1 : finrank kbar (HModule kbar (sheafOf D) 1) = 0)`; concludes `(l D : ℤ) = degree D + 1`. The threaded `_hH1` premise is explicitly justified by the chapter's "The `H¹`-vanishing input" paragraph ("the Lean signature `l_eq_degree_plus_one_of_genus_zero` threads the `H¹`-vanishing hypothesis explicitly as a named premise"). The `_hdeg` premise is unused in the current body (the iter-180 proof closes via `_hH1` directly); it is retained because once RR.3 lands and the `_hH1` premise is dropped, `_hdeg` becomes the input that derives the vanishing. The leading `_` correctly suppresses the unused-argument warning.
- **Proof follows sketch**: yes. The 3-line proof is exactly the chapter's algebraic specialisation: (1) instantiate `eulerCharacteristic_eq_degree_plus_one_minus_genus C D`; (2) unfold `eulerCharacteristic` to `(finrank H⁰ : ℤ) − (finrank H¹ : ℤ)`, substitute `_hg` (collapses the `g` term) and `_hH1` (collapses the `H¹` term), and simplify the cast/subtraction; (3) `exact h` matches the goal by definitional unfolding of `l`. Faithful to chapter's three-step `\begin{proof}` outline.
- **notes**: Body is sorry-free (LSP-confirmed — no `sorry`-warning on line 253); the proof is **transitively** dependent on the upstream `eulerCharacteristic_eq_degree_plus_one_minus_genus` body and on `sheafOf`, so its axiom-cleanness inherits automatically once iter-181+ closes those upstream sorries.

## Red flags

### Placeholder / suspect bodies (informational — NOT must-fix)
- `Scheme.WeilDivisor.sheafOf` at L168: body is `:= sorry`. Acknowledged transitional placeholder for the `𝒪_C(D)` line bundle of `RR.3` (`RiemannRoch_OcOfD.tex`, not yet written). NO `\lean{...}` pin claims it should be substantive in this file; both the Lean docstring (L154–171) and the chapter prose (L173–181 and L444–453) explicitly defer its construction to RR.3 with the same justification. The placeholder is consumed only through its `H⁰` and `H¹` finiteness outputs by the four pinned consumers, so consumer signatures remain substantive arithmetic identities. Pattern is the standard project-side file-skeleton scaffolding.
- `Scheme.eulerCharacteristic_eq_degree_plus_one_minus_genus` at L224: body is `:= sorry`. Pre-existing iter-174 scaffold; the chapter's proof block carries the full inductive Hartshorne IV.1.3 sketch but the body closure is explicitly tagged iter-175+/iter-181+ work in both the Lean header (L197–207) and the directive. Not a regression; classified by chapter as the next iter's work.

### Excuse-comments
None.

### Axioms / Classical.choice on non-trivial claims
None. No `axiom` declarations in the file.

## Unreferenced declarations (informational)

- `Scheme.WeilDivisor.sheafOf` — only declaration without a `\lean{...}` pin. Not flagged as a missing-blueprint-block: the chapter explicitly defers to `RR.3` and consumes the carrier only through its cohomology. When `RR.3` lands and an honest `𝒪_C(D)` definition is created in `RiemannRoch/OcOfD.lean`, the placeholder should be **deleted** (not promoted to a chapter block in this file).

## Blueprint adequacy for this file

A bidirectional check: does the blueprint chapter give a prover enough detail to formalize this file correctly?

- **Coverage**: 4/5 Lean declarations have a corresponding `\lean{...}` block. The 1 unpinned declaration (`sheafOf`) is a documented transitional placeholder admitted by chapter prose; it is not a coverage gap.
- **Proof-sketch depth**: **adequate**. The χ-identity proof block (L238–335) contains the full Hartshorne IV.1.3 inductive sketch plus the explicit Mathlib-gap reference note for `χ`-additivity on a SES (`CategoryTheory.ShortExact.eulerChar_additive` flagged as not-in-Mathlib `b80f227`, with the alternative `Submodule.finrank_quotient_add_finrank` + long-exact-sequence path called out). The genus-`0` specialisation proof block (L373–428) gives the exact three-step specialisation the iter-180 Lean body implements. The `_hH1` premise and its eventual RR.3 discharge are explicitly justified in the prose. The iter-181+ prover starting the χ-identity body has chapter prose + Hartshorne pp. 295-296 quoted verbatim + a named Mathlib-gap-or-project-helper path — all the inputs needed.
- **Hint precision**: **precise**. Every `\lean{...}` pin names the exact declaration; namespaces match (`AlgebraicGeometry.Scheme.…`, `AlgebraicGeometry.Scheme.WeilDivisor.…`); the chapter's typeclass-package quote at L74–79 exactly mirrors the Lean signature's `[IsProper] [SmoothOfRelativeDimension 1] [GeometricallyIrreducible] [IsIntegral]` cluster.
- **Generality**: **matches need**. The genus-`0` carve-out vs. general `g` is correctly documented in the L52–67 NOTE block (Serre duality / canonical divisor not in Mathlib; general-`g` statement queued for follow-up chapter). The intermediate χ-identity is stated genus-uniformly (matches Lean signature, which takes `D` with no `_hg`). The `_hH1`-as-premise pattern is acknowledged by chapter prose.
- **Recommended chapter-side actions**:
  - (minor, optional) Add a `\notready` annotation or `% NOTE: sheafOf placeholder` block in §3 of the chapter so a future reader sees the deferred sub-build status of `𝒪_C(D)` without needing to cross-reference the §"Out of scope" itemisation; or alternatively, add an explicit "stub-pin" block for `Scheme.WeilDivisor.sheafOf` flagged as RR.3-placeholder. Either improves chapter↔file legibility but is not required for iter-181+ work to proceed.
  - When `RR.3` (`RiemannRoch_OcOfD.tex`) is written, update the L173–181 `def:l_invariant`-paragraph + the L398–416 `_hH1`-paragraph to drop the "to be added" wording. (Tracked as part of the RR.3 sub-build, not iter-180.)

## Severity summary

- **must-fix-this-iter**: NONE. The two `:= sorry` bodies (`sheafOf`, χ-identity) are documented file-skeleton scaffolding the chapter explicitly defers; the iter-180 Lean closure (`l_eq_degree_plus_one_of_genus_zero`) faithfully implements the chapter's three-step specialisation; all 4 `\lean{...}` pins match; no axioms; no excuse-comments. LSP confirms zero errors and exactly two `sorry` warnings on the two pre-existing scaffold lines (L168, L224).
- **major**: NONE.
- **minor**: optional `\notready` / explicit-stub-pin for `sheafOf` to improve chapter↔file legibility (see Recommended chapter-side actions above).

**Overall verdict**: iter-180 Lane E landed a clean specialisation faithful to the chapter's `\begin{proof}` of `thm:riemannRoch_genus_zero`; chapter prose and Lean implementation are mutually consistent and iter-181+-ready on the χ-identity body.
