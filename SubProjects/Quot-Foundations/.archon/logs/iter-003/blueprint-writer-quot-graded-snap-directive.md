# Blueprint-writer directive — QUOT chapter graded-encoding rewrite + SNAP sub-steps

## Chapter to edit
`blueprint/src/chapters/Picard_QuotScheme.tex` (ONLY this file; you may spawn a
reference-retriever into `references/**` if you find you need a source you lack).

## Strategy context (the slice that matters)
The project pivoted (this iteration) the encoding of `def:hilbert_polynomial` from the
**cohomological Euler characteristic** `χ(X_s, F_s⊗L_s^m)=Σᵢ(-1)ⁱ dim Hⁱ(...)` to the
**graded Hilbert-function** encoding. Reason: the χ form requires higher coherent
cohomology (Hⁱ, i>0), which breaks this subproject's "Čech-independent leg" identity and
is a multi-month from-scratch infrastructure build. The graded encoding yields the SAME
polynomial (they agree for m≫0) but routes polynomiality directly through Mathlib's
already-verified `Polynomial.existsUnique_hilbertPoly` (graded Hilbert–Serre), staying
Čech-independent.

## Required edits

### (1) Rewrite `def:hilbert_polynomial` to the graded encoding
Replace the cohomological-χ prose with: `Φ_s` is the unique polynomial agreeing for
`m ≫ 0` with the graded Hilbert function `m ↦ dim_{κ(s)} Γ(X_s, F_s ⊗ L_s^m)` of the
section module `⊕_{m≥0} Γ(X_s, F_s ⊗ L_s^m)`, viewed as a finitely-generated graded
module over the homogeneous section ring `⊕_{m≥0} Γ(X_s, L_s^m)`. Keep the existing
`\lean{AlgebraicGeometry.Scheme.hilbertPolynomial}` pin. State that for m≫0 it equals the
Euler characteristic (so no invariant is lost) but that the construction uses only H⁰.

### (2) Add the SNAP sub-step declaration blocks (S1 → S2)
Add a `\section{Graded Hilbert polynomial}` (embedded here, NOT a standalone file) with
these blocks in dependency order — use the outline the blueprint-reviewer produced:

1. `\definition \label{def:sectionGradedRing}` — graded section ring `⊕_{m≥0} Γ(X_s, L_s^m)`
   as a graded commutative ring; a finite-type κ(s)-algebra when L_s is ample.
   `\lean{AlgebraicGeometry.sectionGradedRing}` [expected].
2. `\definition \label{def:sectionGradedModule}` — graded section module
   `⊕_{m≥0} Γ(X_s, F_s ⊗ L_s^m)` as a graded module over `def:sectionGradedRing`.
   `\lean{AlgebraicGeometry.sectionGradedModule}` [expected]. `\uses{def:sectionGradedRing}`.
3. `\lemma \label{lem:sectionGradedModule_fg}` — Serre correspondence (H⁰ only): under
   coherence + proper-support of F and ampleness of L_s, the section graded module is
   finitely generated over the section graded ring (which is Noetherian because L_s is
   ample and X_s proper over a field). `\lean{AlgebraicGeometry.sectionGradedModule_fg}`
   [expected]. `\uses{def:sectionGradedModule, def:sectionGradedRing}`.
4. `\mathlibok` anchor `\label{lem:hilbertPoly_exists_mathlib}` — Mathlib's
   `Polynomial.existsUnique_hilbertPoly` (`Mathlib.RingTheory.Polynomial.HilbertPoly`,
   VERIFIED present): for a f.g. graded module over a Noetherian graded ring there is a
   unique `p : ℚ[X]` with `p.eval n = dim M_n` for n≫0. Carries `[CharZero]` on the
   coefficient field (satisfied by ℚ). State it in project notation, pin
   `\lean{Polynomial.existsUnique_hilbertPoly}`, and mark it `\mathlibok` (this is the ONLY
   block you mark; do NOT add `\leanok` or `\mathlibok` to any project-own block).
5. `\theorem \label{thm:hilbertPoly_of_sectionModule}` — `Φ_s` extracted by applying
   `lem:hilbertPoly_exists_mathlib` to `def:sectionGradedModule`.
   `\lean{AlgebraicGeometry.Scheme.hilbertPolynomialOfSectionModule}` [expected].
   `\uses{lem:sectionGradedModule_fg, lem:hilbertPoly_exists_mathlib}`.

Then make `def:hilbert_polynomial` `\uses{thm:hilbertPoly_of_sectionModule}`.

### (3) Fix the prose misnaming (informational)
In `lem:functor_is_representable_mathlib`, the prose says `Functor.representableBy` — the
actual Mathlib method is `representableByEquiv`. Correct the prose. The `\lean{}` pin
(`CategoryTheory.Functor.IsRepresentable`) is already correct — do not change it.

## Citation discipline (MANDATORY)
Every new block deriving from a source needs `% SOURCE:` (pointer + `(read from
references/<file>)`), a verbatim `% SOURCE QUOTE:` in the original language, and a visible
`\textit{Source: ...}` first line. Sources:
- Nitsure §1 "Stratification by Hilbert Polynomials":
  `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` (≈L453–L500). Open and
  quote it verbatim — do NOT cite from memory.
- Mathlib `Mathlib.RingTheory.Polynomial.HilbertPoly` for the `\mathlibok` anchor.
- Hartshorne I.7 is the textbook reference but its PDF has no text layer — cite via the
  Nitsure §1 quotes, do not transcribe Hartshorne.

## Out of scope
- Do NOT touch the GR-cells/glue Grassmannian decomposition (separate chapter, separate
  writer).
- Do NOT modify `thm:grassmannian_representable`'s monolithic block beyond what (3) needs.
- Do NOT add `\leanok` anywhere. Mark `\mathlibok` ONLY on `lem:hilbertPoly_exists_mathlib`.
- Do NOT re-introduce the cohomological-χ encoding anywhere.

## Report
If anything you write surfaces a strategy-level issue (e.g. the graded encoding needs a
prerequisite not in Mathlib), put it under "Strategy-modifying findings" in your report.
