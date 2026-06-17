# Lean ↔ Blueprint Checker Directive

## Slug

jacobian-review135

## Iteration

135

## Lean file

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Jacobian.lean`

## Blueprint chapter

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Jacobian.tex`

## Known issues (do NOT re-report)

- `nonempty_jacobianWitness` body restructured iter-135 from inline
  `:= sorry` to `by_cases h : genus C = 0` decomposing into
  `genusZeroWitness h` and `positiveGenusWitness C (Nat.pos_of_ne_zero h)`.
  Signature preserved verbatim — this is intentional structural
  decomposition, not a new sorry site.
- `genusZeroWitness C (h : genus C = 0)` and `positiveGenusWitness C (hg : 0 < genus C)`
  are both honest `sorry`-bodied scaffolds per the iter-127 / iter-134
  scaffold convention.
- A pre-existing long-line linter warning at `Jacobian.lean:275` is a
  protected signature (`Jacobian` definition exceeds 100 chars) and
  must NOT be reformatted. Skip.

## What's new this iter

Iter-135 (NO prover lane) plan-phase refactor:

1. `nonempty_jacobianWitness` body restructure (per
   `strategy-critic-iter135` Alternative 1 ADOPTED): inline `:= sorry`
   replaced by `by_cases h : genus C = 0` delegating to the two
   pre-existing scaffolds.
2. 3 docstring status updates on `genusZeroWitness`,
   `positiveGenusWitness`, `nonempty_jacobianWitness` reflecting the
   iter-135 body restructure.
3. Blueprint side: new `\subsection{The positive-genus arm of the
   witness existence}` with `\lean{AlgebraicGeometry.positiveGenusWitness}`
   block in `Jacobian.tex`; `thm:nonempty_jacobianWitness` proof block
   updated with body-restructure paragraph.

## Authoritative paths

- Lean file: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Jacobian.lean`
- Blueprint chapter: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Jacobian.tex`
