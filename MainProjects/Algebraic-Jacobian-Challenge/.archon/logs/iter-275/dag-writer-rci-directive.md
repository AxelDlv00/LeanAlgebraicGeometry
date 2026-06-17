# Blueprint Writer Directive

## Slug
cov275-rci

## Target chapter
blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex

## Strategy context
This chapter covers `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean` (a
Route-C / Riemann–Roch chapter, currently PAUSED for proving but in scope for
blueprint completeness). The project keeps a strict 1-to-1 Lean ↔ blueprint
correspondence: every Lean declaration, including internal private helpers, must
have a blueprint block carrying `\label{}`, `\lean{}` (exact Lean name), accurate
`\uses{}`, and at least a short proof note. The declarations below currently have
NO blueprint entry (`archon dag-query unmatched`). Add one additive block per
declaration. This is purely additive coverage — do not rewrite or restructure the
existing chapter.

## Required content
Add one faithful 1-to-1 coverage block for each of these Lean declarations
(read the exact signature + docstring from the Lean source first):

- `def`  `AlgebraicGeometry.Scheme.Hom.poleDivisor` (RationalCurveIso.lean:531) —
  the pole divisor of a non-constant morphism φ : C → ℙ¹ (positive part of the
  principal divisor of the pullback of the local parameter at ∞).
- `theorem` `AlgebraicGeometry.Scheme.Hom.poleDivisor_degree_eq_finrank` — its
  degree equals the function-field extension degree.
- `def` (private) `AlgebraicGeometry.Scheme.localParameterAtInfty` (line 304) —
  a chosen local parameter (uniformiser) at the point ∞ of ℙ¹.
- `theorem` (private) `AlgebraicGeometry.Scheme.localParameterAtInfty_uniformiser_witness`
  (line 463) — **carries a `sorry` in Lean**: give a brief HONEST informal proof
  sketch (one or two sentences), NOT a "proved directly in Lean" note.
- `theorem` (private) `AlgebraicGeometry.Scheme.algebraMap_bijective_of_finrank_one`
  (line 817).
- `def` (private) `AlgebraicGeometry.Scheme.phi_left_functionField_algEquiv_of_finrank_one`
  (line 835).
- `theorem` (private) `AlgebraicGeometry.Scheme.phi_left_locallyQuasiFinite_of_finrank_one`
  (line 873) — **carries a `sorry`**: brief honest informal sketch.
- `theorem` (private) `AlgebraicGeometry.Scheme.phi_left_toNormalization_isIso_of_isIntegralHom`
  (line 933).
- `theorem` (private) `AlgebraicGeometry.Scheme.phi_left_fromNormalization_isIso_of_smoothProper_finrank_one`
  (line 962) — **carries a `sorry`**: brief honest informal sketch.

## Proof notes
- For declarations already proved sorry-free in Lean: a one-line
  `\begin{proof} Proved directly in Lean. \end{proof}` is sufficient.
- For the three `sorry`-bodied declarations flagged above: write a brief, honest
  informal proof sketch (two lines beats an ∞ hole) so the node has finite effort.

## Wiring (critical — leandag quirk)
leandag builds dependency edges ONLY from **statement-level** `\uses{}` (a
`\uses{}` inside a `\begin{proof}` block creates NO edge). Each new block must
carry a **statement-level** `\uses{}` tying it to the declarations it actually
depends on (its sibling helpers in this chapter, or the existing block that
consumes it), so no block lands isolated. After writing, run
`leandag build --json` and `leandag query --isolated --chapter RiemannRoch_RationalCurveIso`
to confirm none of your new blocks is isolated; fix edges and re-check.

## Out of scope
- Do NOT touch existing blocks or the protected Jacobian/Genus declarations.
- Do NOT add `\leanok` (the deterministic sync handles it).
- Do NOT cover any `TensorObjSubstrate` / `Scheme.Modules.*` helpers — not this chapter.

## References
- `references/abelian-varieties.md` (Milne) and `references/summary.md` — only if
  you cite an external statement for the RR pole-divisor facts; these helpers are
  largely project-internal plumbing, so a "proved directly in Lean" note with no
  external citation is acceptable. Do NOT fabricate a citation.

## Expected outcome
Nine additive 1-to-1 coverage blocks appended into the existing chapter, each
statement-level-wired, with no new isolated nodes and no broken `\uses{}`.
