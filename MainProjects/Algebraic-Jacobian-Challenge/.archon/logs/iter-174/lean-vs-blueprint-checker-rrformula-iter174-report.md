# Lean ↔ Blueprint Check Report

## Slug
rrformula-iter174

## Iteration
174

## Files audited
- Lean: `AlgebraicJacobian/RiemannRoch/RRFormula.lean`
- Blueprint: `blueprint/src/chapters/RiemannRoch_RRFormula.tex`

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.eulerCharacteristic}` (chapter: `def:eulerChar_curve`)
- **Lean target exists**: yes (line 124).
- **Signature matches**: yes. Lean ships
  `(F : Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} kbar)) : ℤ`
  with body `(finrank kbar (HModule kbar F 0) : ℤ) − (finrank kbar (HModule kbar F 1) : ℤ)`.
  This is exactly the two-term curve specialisation the chapter displays
  (`χ(𝓕) = dim H⁰ − dim H¹`) and the blueprint's "Lean signature scope"
  paragraph explicitly anticipates the `HModule k̄`-flavoured input shape and the
  `Module.finrank` extraction.
- **Proof follows sketch**: N/A (definition, body is the displayed two-term formula).
- **notes**: pin 1's signature omits `[IsIntegral C.left]` while the chapter's
  "Standing hypotheses" paragraph names it as part of the standing typeclass
  package. Pin 1 is a pure definition that does not require integrality, so
  this is a legitimate minimisation of the typeclass footprint, not a
  mismatch. Pins 2–4 carry `[IsIntegral C.left]` as advertised.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.l}` (chapter: `def:l_invariant`)
- **Lean target exists**: yes (line 192).
- **Signature matches**: yes. `(D : C.left.WeilDivisor) → ℕ`, body
  `Module.finrank kbar (Scheme.HModule kbar (sheafOf D) 0)` — i.e.,
  `dim_{k̄} H⁰(C, 𝒪_C(D))`, matching the chapter's
  `ℓ(D) := dim_{k̄} H⁰(C, 𝒪_C(D)) ∈ ℕ`.
- **Proof follows sketch**: N/A (definition).
- **notes**: depends on the unpinned helper `sheafOf` (see "Unreferenced
  declarations"), which the chapter prose and Out-of-scope section explicitly
  document as the `RR.3` line-bundle stand-in. The `\uses{def:codim1_cycles,
  def:eulerChar_curve}` chain lists `def:eulerChar_curve` even though `l`
  refers only to `H⁰`, not the full Euler characteristic; reading this as
  a conceptual `\uses` (l is the H⁰-side of χ) makes it acceptable, but a
  literal-reading reviewer might prefer `\uses{def:codim1_cycles}` only.
  Classified as minor.

### `\lean{AlgebraicGeometry.Scheme.eulerCharacteristic_eq_degree_plus_one_minus_genus}` (chapter: `thm:euler_char_eq_deg_plus_one_minus_genus`)
- **Lean target exists**: yes (line 224).
- **Signature matches**: yes. Lean asserts
  `Scheme.eulerCharacteristic C (sheafOf D) = WeilDivisor.degree D + 1 − (genus C : ℤ)`,
  exact translation of the chapter's
  `χ(𝒪_C(D)) = deg(D) + 1 − g`.
- **Proof follows sketch**: N/A (body is `sorry`, known iter-175+ deferral
  per the directive). The chapter's `\begin{proof}` is detailed enough to
  guide closure: base case `D = 0` (`H⁰(C,𝒪_C) ≅ k̄`, `H¹(C,𝒪_C) = g`),
  inductive step via the closed-point SES `0 → 𝒪_C(−P) → 𝒪_C → k(P) → 0`
  tensored with `𝒪_C(D+P)`, χ-additivity, `χ(k(P)) = 1`, `deg([P]) = 1`,
  plus a "Lean reference note" calling out the Mathlib gap on χ-additivity
  (`HomologicalComplex.eulerChar` is present, but no
  `ShortExact.eulerChar_additive`) and proposing a project-side
  `Submodule.finrank_quotient_add_finrank` + LES proof.
- **notes**: sorry-bodied, per directive's known-issues; no fresh must-fix.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.l_eq_degree_plus_one_of_genus_zero}` (chapter: `thm:riemannRoch_genus_zero`)
- **Lean target exists**: yes (line 253).
- **Signature matches**: yes, including the explicit `_hH1` premise
  `Module.finrank kbar (Scheme.HModule kbar (sheafOf D) 1) = 0` that the
  chapter's proof body and the "The H¹-vanishing input" paragraph both
  spell out as the iter-174 threading convention pending `RR.3`. Hypotheses
  `_hg : genus C = 0` and `_hdeg : 0 ≤ degree D` reproduce the chapter's
  `g(C) = 0` and `deg(D) ≥ 0`. Conclusion `(l D : ℤ) = degree D + 1`
  matches `ℓ(D) = deg(D) + 1`.
- **Proof follows sketch**: N/A (body is `sorry`, known iter-175+ deferral
  per the directive). The chapter's `\begin{proof}` gives a complete
  closure recipe in three steps: (i) specialise `thm:euler_char_eq_…` at
  `g = 0`, (ii) unfold χ via `def:eulerChar_curve` and `ℓ` via
  `def:l_invariant`, (iii) substitute the `H¹`-vanishing premise. Adequate
  for a prover.
- **notes**: pin 4's signature deliberately threads `_hH1` as a named
  premise; the chapter's "The H¹-vanishing input" paragraph explicitly
  documents the departure from the informal statement and notes the
  signature simplification that follows once `RR.3` closes the vanishing
  intrinsically. Signature scope is faithful to the chapter's stated
  intent.

## Red flags

None — the iter-174 landing is a scaffold-with-deferral file-skeleton; the
two `sorry`-bodied pinned theorems and the `sheafOf` typed-`sorry` helper
are all explicitly anticipated by the directive's "Known issues" section
and by chapter prose (`RR.3` is named at every consumer site, the
"Out of scope" section lists each deferred input). No
`-- TODO replace`-style excuse-comments. No `axiom` introductions. No
`:= True` / `:= rfl` on substantive claims. No `Classical.choice _`
laundering.

## Unreferenced declarations (informational)

- `AlgebraicGeometry.Scheme.WeilDivisor.sheafOf` (line 168) — typed-`sorry`
  helper of type `C.left.WeilDivisor → Sheaf … (ModuleCat k̄)`. Not pinned
  by any `\lean{...}` block, but the chapter prose around `def:l_invariant`
  and the "Out of scope" itemise (`RR.3` sibling chapter
  `RiemannRoch_OcOfD.tex`) explicitly identify it as the placeholder for
  the `𝒪_C(D)` line bundle whose honest construction is queued for `RR.3`.
  The Lean file devotes a full section header (`§2`) and a multi-paragraph
  docstring to documenting the placeholder pattern (lines 134–171). This
  is the cleanest possible "documented scaffold typed-`sorry`" pattern —
  not a hidden weakened-wrong definition. Worth promoting to its own
  `\lean{...}` block once `RR.3` lands (or sooner, with a `\notready`
  marker), but acceptable as an unpinned helper for the iter-174 landing.

## Blueprint adequacy for this file

- **Coverage**: 4/4 pinned Lean declarations have a corresponding
  `\lean{...}` block in the chapter. Unreferenced declarations: 1
  scaffold helper (`sheafOf`, documented in prose and Out-of-scope) — 0
  unflagged substantive omissions.
- **Proof-sketch depth**: adequate. Pin 3 (`thm:euler_char_eq_…`) ships
  a Hartshorne IV.1.3-faithful inductive sketch with all four pieces a
  prover needs (base case ingredients, SES, χ-additivity, `χ(k(P)) = 1`,
  `deg([P]) = 1`) AND a Lean-side reference note flagging the
  `eulerChar_additive` Mathlib gap and proposing a `finrank_quotient_add_finrank`
  + LES route. Pin 4 (`thm:riemannRoch_genus_zero`) ships a clean
  three-step specialisation recipe and explicitly justifies the
  `_hH1`-premise threading.
- **Hint precision**: precise. Each `\lean{...}` block names the exact
  fully-qualified Lean target. The "Standing hypotheses" paragraph pins
  the typeclass package verbatim (`[IsProper C.hom]`,
  `[SmoothOfRelativeDimension 1 C.hom]`, `[GeometricallyIrreducible C.hom]`,
  `[IsIntegral C.left]`), matching the Lean signatures of pins 2–4
  (pin 1 legitimately drops `[IsIntegral]`).
- **Generality**: matches need. The chapter explicitly carves out the
  genus-`0` specialisation (no canonical divisor `K`, no Serre duality)
  and the file-skeleton inherits this scope. Two NOTE blocks (lines 36–67)
  document why the Serre-duality route was rejected (no `ω_X` in Mathlib)
  and why the general-`g` statement is sequenced out — both decisions
  match the project's iter-170 STRATEGY.md Route-3-row-3 horizon.
- **Recommended chapter-side actions**: none required for iter-174's
  file-skeleton landing. Iter-175+ wishlist (not blocking):
  - Promote `sheafOf` to its own `\lean{...}` block once `RR.3` lands
    (or earlier as a `\notready` placeholder), so that the
    blueprint-doctor's `\lean{...}` orphan check covers it.
  - Consider trimming `def:l_invariant`'s `\uses` to drop
    `def:eulerChar_curve` (the Lean `l` directly uses only `H⁰`, not
    the full χ); the conceptual link is preserved by the chapter prose.

## Severity summary

- **must-fix-this-iter**: none.
  Rationale: per the rule, `sorry` on a substantive claim is normally
  must-fix; here, both `sorry`-bodied pins are (a) pre-acknowledged by
  the directive as iter-175+ deferrals, (b) explicitly deferred in
  chapter prose to the `RR.3` line-bundle landing, and (c) signature-
  faithful to the blueprint statements (no laundering, no weakened-wrong
  reformulation). The `sheafOf` typed-`sorry` is a documented placeholder
  for the `RR.3` line bundle, transparently scoped via the
  `H⁰`-and-`H¹`-only consumer surface that the Lean file documents in
  its §2 section header. None of the rule's must-fix triggers
  (placeholder masquerading as substantive, signature mismatch, hidden
  excuse-comment, axiom introduction, weakened-wrong definition,
  blueprint adequacy failure) fire on this landing.
- **major**: none.
- **minor**:
  - `sheafOf` (line 168) is a typed-`sorry` of substantive type
    `C.left.WeilDivisor → Sheaf … (ModuleCat k̄)` and has no `\lean{...}`
    pin; promote to a pinned scaffold block in iter-175 (with
    `\notready` or `\leanok`-on-statement-only) so the blueprint-doctor
    can track it.
  - `def:l_invariant`'s `\uses` chain lists `def:eulerChar_curve` but
    the Lean `l` only uses the `H⁰` half of χ, not the full
    `eulerCharacteristic`. Cosmetic — does not affect provability.

Overall verdict: pin signatures faithfully translate the chapter's
informal statements, proof sketches are detailed enough to guide
iter-175+ closure (including the Mathlib χ-additivity gap call-out),
and the two `sorry`-bodied pins plus the `sheafOf` typed-`sorry` helper
are all transparently scaffolded against the `RR.3` deferral the
chapter advertises — no fresh blockers for iter-174's file-skeleton
landing.
