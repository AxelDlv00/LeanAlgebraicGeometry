# Blueprint Writer Directive

## Slug
cov275-weil

## Target chapter
blueprint/src/chapters/RiemannRoch_WeilDivisor.tex

## Strategy context
This chapter covers `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (Route-C /
Riemann–Roch, PAUSED for proving but in scope for blueprint completeness). Strict
1-to-1 Lean ↔ blueprint correspondence. One helper currently has NO blueprint
entry. Add one additive, faithful 1-to-1 coverage block. Purely additive.

## Required content
- `lemma` (`@[ext]`-generated) `AlgebraicGeometry.Scheme.PrimeDivisor.ext`
  (WeilDivisor.lean:34) — the extensionality lemma for `PrimeDivisor`: two prime
  divisors with the same underlying point are equal.

## Proof notes
- Proved sorry-free in Lean: one-line `\begin{proof} Proved directly in Lean. \end{proof}`.

## Wiring (critical — leandag quirk)
leandag builds edges ONLY from **statement-level** `\uses{}`. The block must carry
a statement-level `\uses{}` to the existing `PrimeDivisor` definition block in
this chapter (so it is not isolated). After writing, run `leandag build --json`
and `leandag query --isolated --chapter RiemannRoch_WeilDivisor`; ensure not isolated.

## Out of scope
- Do NOT touch existing blocks. Do NOT add `\leanok`.

## References
- None needed — `PrimeDivisor.ext` is a project-internal extensionality lemma;
  "proved directly in Lean" with no external citation. Do NOT fabricate a citation.

## Expected outcome
One additive 1-to-1 coverage block for `PrimeDivisor.ext`, statement-level-wired
to the `PrimeDivisor` definition, not isolated, no broken `\uses{}`.
