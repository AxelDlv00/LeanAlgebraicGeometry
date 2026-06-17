# Lean ↔ Blueprint Checker Directive

## Slug
jacobian-iter127

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Jacobian.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Jacobian.tex

## Known issues
- `Jacobian.lean:178` `genusZeroWitness` body is a single `sorry` — recognized iter-127 scaffold per the blueprint's `\subsection{The genus-0 arm of the witness existence}`. Do not flag as must-fix.
- `Jacobian.lean:197` `nonempty_jacobianWitness` body is a single `sorry` — recognized off-limits scaffold (Phase-C deferred). Do not flag as must-fix.
- Iter-127 blueprint-writer added `def:genusZeroWitness` block + proof sketch + `\uses{thm:rigidity_over_kbar}` cross-ref to `Jacobian.tex`. Confirm the new block's `\lean{...}` hint and signature align with the Lean declaration `AlgebraicGeometry.genusZeroWitness` (line 174–178).
- This is the FIRST checker pass on the iter-127 `Jacobian.tex` edits — please be thorough on the new `\subsection`.
