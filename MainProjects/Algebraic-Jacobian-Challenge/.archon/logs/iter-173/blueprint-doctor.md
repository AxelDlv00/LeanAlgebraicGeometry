# Blueprint Doctor

## Chapter coverage problems (`% archon:covers`)

A chapter's `% archon:covers <file> ...` declaration tells the prover-dispatch gate which Lean files that chapter blueprints. The issues below would route the gate to the wrong chapter — fix the declaration (correct the path, or make exactly one chapter own each file).

- chapter `Picard_LineBundlePullback.tex` covers `AlgebraicJacobian/Picard/LineBundlePullback.lean`, which does not exist
- chapter `RiemannRoch_RRFormula.tex` covers `AlgebraicJacobian/RiemannRoch/RRFormula.lean`, which does not exist

## Orphan chapters

These `.tex` files exist under `blueprint/src/chapters/` but are NOT reachable from `content.tex` via `\input` (directly or transitively). They contribute nothing to the rendered blueprint and likely indicate either a forgotten `\input{...}` line in `content.tex` or stale chapter files left behind by a refactor.

- `blueprint/src/chapters/Picard_LineBundlePullback.tex`
- `blueprint/src/chapters/RiemannRoch_RRFormula.tex`

