# Blueprint Writer Report

## Slug
snap-s2

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_QuotScheme.tex

## Summary
`lem:gradedHilbertSerre_rational` (`AlgebraicGeometry.gradedModule_hilbertSeries_rational`)
is now a fully self-contained pure-algebra node. Its `\uses{}`, its statement body,
and its proof no longer reference the blocked geometric section objects
(`def:sectionGradedRing`, `def:sectionGradedModule`, `lem:sectionGradedModule_fg`).
The geometric application moved entirely into the downstream theorem
`thm:hilbertPoly_of_sectionModule`. The already-correct `% LEAN SIGNATURE` was left
verbatim.

## Changes Made
- **Added Mathlib anchor** `\lemma`/`\label{lem:finrank_ses_additive_mathlib}`/`\lean{Submodule.finrank_quotient_add_finrank}` `\mathlibok`
  — rank--nullity / additivity of `\dim_κ` on a short exact sequence of
  finite-dimensional κ-vector spaces. Verified to exist in Mathlib
  (`Mathlib.LinearAlgebra.Dimension.RankNullity`):
  `finrank R (M ⧸ N) + finrank R ↥N = finrank R M`.
- **Added Mathlib anchor** `\lemma`/`\label{lem:invOneSubPow_mathlib}`/`\lean{PowerSeries.invOneSubPow}` `\mathlibok`
  — the rational power series `(1−X)^{-d}` as a unit of `S⟦X⟧`, the denominator
  form (plus the `Polynomial.toPowerSeries` coercion) in which the Hilbert series
  is expressed. Verified to exist in Mathlib
  (`Mathlib.RingTheory.PowerSeries.WellKnown`):
  `PowerSeries.invOneSubPow : (S) → [CommRing S] → ℕ → (PowerSeries S)ˣ`.
- **Edit A — fixed `\uses{}` on the statement** of `lem:gradedHilbertSerre_rational`:
  was `\uses{def:sectionGradedRing, def:sectionGradedModule, lem:sectionGradedModule_fg}`;
  now `\uses{lem:finrank_ses_additive_mathlib, lem:invOneSubPow_mathlib}` — Mathlib
  anchors only, no blocked section object.
- **Edit A (cont.) — statement body**: removed the geometric sentence
  "Applied to `R = R(X_s, L_s)` and `M = M(X_s, …)` …" and its
  `\cref{lem:sectionGradedModule_fg}`; replaced with an abstract restatement that the
  series is `toPowerSeries(p) · invOneSubPow(ℚ, d)` (`\cref{lem:invOneSubPow_mathlib}`).
  The `Status` paragraph (pure-algebra meta-comment) is retained.
- **Edit B — rewrote the proof block** as pure algebra over an abstract graded
  κ-algebra `R = ⊕ R_n` (with `R_0 = κ` a field) and f.g. graded module `M = ⊕ M_n`.
  No reference to `R(X_s,L_s)`, `M(X_s,…)`, or `lem:sectionGradedModule_fg`. Structure
  follows Stacks 00K1 verbatim: Veronese reduction to degree-1 generation ⇒ quotient
  of `κ[x_1,…,x_r]`, induction on `r`; base case `r=0` gives a polynomial (`d=0`);
  inductive step uses the degreewise SES
  `0 → K_n → M_n →^{x} M_{n+1} → C_{n+1} → 0`, additivity of `\dim_κ`
  (`\cref{lem:finrank_ses_additive_mathlib}`) to get
  `(1−X)·∑(dim_κ M_n)Xⁿ = q·(1−X)^{−(d−1)}` up to a polynomial, then multiply by
  `invOneSubPow(ℚ,1)` (`\cref{lem:invOneSubPow_mathlib}`) to conclude with `d ≤ r`.
  Proof `\uses{}` is now `\uses{lem:finrank_ses_additive_mathlib, lem:invOneSubPow_mathlib}`.
- **Edit C — `thm:hilbertPoly_of_sectionModule` proof prose**: made the geometric
  application explicit — "Applying the abstract graded Hilbert–Serre rationality lemma
  (`\cref{lem:gradedHilbertSerre_rational}`) to the graded κ(s)-algebra
  `R = R(X_s, L_s)` and the f.g. graded module `M = M(X_s, F_s, L_s)` exhibits the
  graded Hilbert function … as the eventual coefficient function of a rational series".
  This carries the sentence deleted from the abstract lemma. The theorem **statement**
  and its `\uses{}` were not otherwise changed.

## Confirmation against directive
- New `\uses{}` of `lem:gradedHilbertSerre_rational` (statement and proof) names ONLY
  the two Mathlib anchors — NO section object. Confirmed via leandag: edges into
  `lem:gradedHilbertSerre_rational` are exactly
  `lem:finrank_ses_additive_mathlib → lem:gradedHilbertSerre_rational` and
  `lem:invOneSubPow_mathlib → lem:gradedHilbertSerre_rational`; the only outgoing edge
  is `lem:gradedHilbertSerre_rational → thm:hilbertPoly_of_sectionModule`. No edge from
  any `def:sectionGraded*` / `lem:sectionGradedModule_fg` remains.
- `\mathlibok` anchors added: `lem:finrank_ses_additive_mathlib`
  (`Submodule.finrank_quotient_add_finrank`) and `lem:invOneSubPow_mathlib`
  (`PowerSeries.invOneSubPow`). Both Lean declarations were verified to exist with the
  stated signatures via the Lean LSP (`#check`), and both module paths confirmed
  (`Mathlib.LinearAlgebra.Dimension.RankNullity`,
  `Mathlib.RingTheory.PowerSeries.WellKnown`). Neither appears in leandag's
  `unmatched_lean`, so both nodes match real Mathlib decls.
- Proof is now stated abstractly (no geometric realisation).
- `% LEAN SIGNATURE` of `lem:gradedHilbertSerre_rational` left unchanged.

## leandag verification
- `leandag build --json`: parsed OK (101 declarations, 62 proof blocks), `conflicts: []`,
  `unknown_uses: []`.
- The two new anchors are NOT isolated (each has an outgoing edge to the rationality
  lemma); `mathlib_ok` count includes them.

## Interpretation note (numerical-polynomial / hilbertPoly machinery)
The directive listed "the numerical-polynomial / `hilbertPoly` machinery
(`Polynomial.existsUnique_hilbertPoly`, `lem:hilbertPoly_exists_mathlib`)" among the
pieces "the proof uses". Mathematically, `existsUnique_hilbertPoly` is the *converse*
extraction step — it produces the eventual polynomial *from* a rational series — and is
applied downstream in `thm:hilbertPoly_of_sectionModule`, not inside the rationality
proof, which *produces* the rational series. To keep the DAG edges accurate I therefore
did NOT add a `\uses{lem:hilbertPoly_exists_mathlib}` edge to the rationality lemma; the
rational-series *shape* compatible with it is captured by `lem:invOneSubPow_mathlib`
(`invOneSubPow` + `toPowerSeries`), which the anchor's prose cross-references. Flagging
in case the plan agent prefers the extra (mathematically spurious) edge.

## References consulted
- `references/hilbert-serre-algebra.tex` (L13893-L13947) — Stacks Tag 00K1 proposition
  statement and proof (induction on number of degree-1 generators; the degreewise SES
  `0 → M_d →^x M_{d+1} → \bar M_{d+1} → 0`). Confirmed the existing
  `% SOURCE QUOTE PROOF` fragment (chapter L377-L387) is the correct verbatim fragment;
  no new citation block was authored, so no new verbatim quote was introduced.

## Macros needed
- None. `\operatorname` (amsmath) and `\llbracket`/`\rrbracket` are already used
  elsewhere in the chapter / available; no new macros required.

## Reference-retriever dispatches
- None. The Stacks 00K1 source was already present at
  `references/hilbert-serre-algebra.tex`.

## Notes for Plan Agent
- `def:sectionGradedRing` / `def:sectionGradedModule` / `lem:sectionGradedModule_fg`
  remain blocked (SheafOfModules tensor structure, SNAP-S1) and were left untouched.
  They still feed `thm:hilbertPoly_of_sectionModule` (correctly — that theorem is the
  geometric application and genuinely depends on them).
- `lem:gradedHilbertSerre_rational` is now a genuine leandag frontier node: all its
  dependencies are `\mathlibok` Mathlib anchors, so it is ready for a `mathlib-build`
  scaffold+prove lane with no geometric prerequisites.

## Strategy-modifying findings
None.
