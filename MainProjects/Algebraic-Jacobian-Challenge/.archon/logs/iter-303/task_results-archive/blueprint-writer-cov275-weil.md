# Blueprint Writer Report

## Slug
cov275-weil

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/RiemannRoch_WeilDivisor.tex

## Changes Made
- **Added lemma** `\lemma`/`\label{lem:primeDivisor_ext}`/`\lean{AlgebraicGeometry.Scheme.PrimeDivisor.ext}` — extensionality for prime divisors: two prime divisors with the same underlying generic point are equal (the codimension-one `coheight` witness is `Prop`-valued, hence proof-irrelevant). Statement-level `\uses{def:prime_divisor}`; one-line proof (`Proved directly in Lean.`). Placed at the head of the "Open-immersion descent for prime divisors" section (before `def:primeDivisor_restrictToOpen`), since it is the first declaration in the Lean `Scheme.PrimeDivisor` namespace (WeilDivisor.lean:152–155) and underlies the `equivOpen` round-trip identities.

This was the one helper in `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` lacking a blueprint entry; the chapter previously only mentioned `PrimeDivisor.ext` in passing inside a Lean-side note paragraph (no first-class block). The chapter now has strict 1-to-1 coverage of that declaration.

## Cross-references introduced
- Statement-level `\uses{def:prime_divisor}` in `lem:primeDivisor_ext` — `def:prime_divisor` exists in this same chapter (line ~131). Verified by leandag (not in `unknown_uses`).
- Prose `\ref{lem:primeDivisor_equivOpen}` (forward pointer in the body, not a `\uses{}` edge) — `lem:primeDivisor_equivOpen` exists in this chapter.

## References consulted
- None. `PrimeDivisor.ext` is a project-internal `@[ext]`-generated extensionality lemma; the directive explicitly stated no external citation. No `% SOURCE`/`% SOURCE QUOTE`/`\textit{Source:}` lines were written (Archon-original block).

## Verification (leandag)
- `leandag build --json`: build succeeds; `lem:primeDivisor_ext` matched its Lean declaration (NOT in `unmatched_lean`); `\uses{def:prime_divisor}` resolves (NOT in `unknown_uses`).
- `leandag query --isolated --chapter RiemannRoch_WeilDivisor`: 0 results — the new block is not isolated, and no other block in the chapter became isolated.

## Macros needed (if any)
- None. Only existing macros / standard LaTeX used.

## Reference-retriever dispatches (if any)
- None.

## Notes for Plan Agent
- The pre-existing Lean-side note paragraph (chapter line ~430) lists `PrimeDivisor.ext` among the "8 axiom-clean iter-200 substrate declarations". That note remains accurate; the new first-class block now gives the declaration its own DAG node rather than only a prose mention. No edit to that note was needed.

## Strategy-modifying findings
None.
