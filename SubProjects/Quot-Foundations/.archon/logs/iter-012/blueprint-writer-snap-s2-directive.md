# Blueprint-writer — decouple `lem:gradedHilbertSerre_rational` from the blocked section objects

Chapter: `blueprint/src/chapters/Picard_QuotScheme.tex`. You edit ONLY this chapter. You may also
write `references/**` (so you can spawn a reference-retriever if you need the Stacks 00K1 source —
it is already at `references/hilbert-serre-algebra.tex`; read it, do NOT re-fetch unless missing).

## Problem (blocks the SNAP-S2 prover lane)

`lem:gradedHilbertSerre_rational` (`AlgebraicGeometry.gradedModule_hilbertSeries_rational`, ≈ line 307)
is the substantive half of graded Hilbert–Serre (Stacks 00K1): for a Noetherian graded ring with
field degree-0 part, generated in degree 1, and a f.g. graded module, the Hilbert series
`∑ (dim_κ M_n) Xⁿ` is rational with denominator `(1−X)^d`. Its **statement** and its pinned
`% LEAN SIGNATURE` are already correct PURE ALGEBRA — an abstract `[GradedAlgebra 𝒜]` over a field
`κ`, conclusion in the `Polynomial.existsUnique_hilbertPoly`-compatible rational-series form. **Good.**

BUT the block is internally inconsistent and falsely dependency-blocked:
1. Its `\uses{def:sectionGradedRing, def:sectionGradedModule, lem:sectionGradedModule_fg}` (line 310)
   ties a pure-algebra lemma to the GEOMETRIC section objects `def:sectionGradedRing` /
   `def:sectionGradedModule`, which are BLOCKED (no `% LEAN SIGNATURE`, SheafOfModules tensor
   structure not yet built). This makes the leandag treat S2 as un-ready when it is actually
   authorable now.
2. Its `\begin{proof}` (lines 388–411) and the proof's `\uses{lem:sectionGradedModule_fg}` are
   written about the geometric `R = R(X_s, L_s)`, `M = M(X_s, …)` — conflating the abstract lemma
   with its later geometric APPLICATION.

## Required edits

### Edit A — fix the `\uses{}` on the statement (line 310)
Replace `\uses{def:sectionGradedRing, def:sectionGradedModule, lem:sectionGradedModule_fg}` with a
`\uses{}` naming ONLY the genuine Mathlib dependencies the abstract lemma rests on. The proof uses:
graded-module SES additivity of `Module.finrank κ`, the numerical-polynomial / `hilbertPoly`
machinery, `PowerSeries.invOneSubPow`, `Polynomial.toPowerSeries`. If there are `\mathlibok` anchors
for these in the chapter, `\uses` them; otherwise author one or two `\mathlibok` Mathlib dependency
anchors (statement in project notation, `\lean{}` the real Mathlib decl, mark `\mathlibok`) for the
load-bearing Mathlib pieces (e.g. the numerical-polynomial additivity / `Polynomial.hilbertPoly`
extraction). Do NOT `\uses` any blocked section object.

### Edit B — rewrite the PROOF block as pure algebra
Rewrite `\begin{proof} … \end{proof}` (≈ 388–411) to prove the ABSTRACT statement with NO reference
to `R(X_s,L_s)` / `M(X_s,…)` / `sectionGradedModule_fg`. Use the Stacks 00K1 induction VERBATIM in
structure (the `% SOURCE QUOTE PROOF` at lines 377–387 is already the right fragment):
- Reduce to `𝒜` generated in degree 1 (Veronese/re-grading) so `𝒜` is a graded quotient of
  `κ[x_1,…,x_r]`; induct on `r`.
- For the inductive step, multiplication by a degree-1 generator `x_r` gives the graded SES
  `0 → K → ℳ(−1) → ℳ → C → 0` with `K, C` f.g. graded modules killed by `x_r` (so modules over
  `r−1` variables); additivity of `dim_κ` on graded pieces gives
  `(1−X)·∑(dim_κ ℳ_n)Xⁿ = q·(1−X)^{−(r−1)}` up to a polynomial, whence the claim with `d ≤ r`.
- Base case `r = 0`: `ℳ` finite-dimensional ⇒ `dim_κ ℳ_n = 0` for `n ≫ 0` ⇒ the series is a
  polynomial. Take `p ∈ ℚ[X]`.
Fix the proof's `\uses{}` to the Mathlib anchors only (drop `lem:sectionGradedModule_fg`).

### Edit C — make the geometric application live downstream
The single sentence "Applied to `R = R(X_s,L_s)` and `M = M(X_s,…)` … this exhibits the graded
Hilbert function …" belongs to the APPLICATION, not this lemma. The downstream theorem
`thm:hilbertPoly_of_sectionModule` (≈ line 413) already `\uses{lem:sectionGradedModule_fg,
lem:gradedHilbertSerre_rational, lem:hilbertPoly_exists_mathlib}` and is where the geometric instances
`R(X_s,L_s)` / `M(X_s,…)` get fed in. Ensure that theorem's prose carries the "apply the abstract
rationality lemma to the section ring/module" step (move the deleted sentence there if it is not
already covered). Do not otherwise change `thm:hilbertPoly_of_sectionModule`'s statement.

## Out of scope
- Do NOT touch `def:sectionGradedRing` / `def:sectionGradedModule` / `lem:sectionGradedModule_fg`
  (still blocked on SheafOfModules tensor structure — a separate SNAP-S1 build).
- Do NOT add `\leanok`. `\mathlibok` ONLY on genuine Mathlib dependency anchors.
- Do NOT alter the already-correct `% LEAN SIGNATURE` of `lem:gradedHilbertSerre_rational` except to
  keep it consistent with the abstract statement.

## Report
Confirm the new `\uses{}` of `lem:gradedHilbertSerre_rational` names only Mathlib anchors (no section
objects), list any `\mathlibok` anchors you added, and confirm the proof is stated abstractly. This
makes S2 a genuine leandag frontier node ready for a `mathlib-build` scaffold+prove lane.
