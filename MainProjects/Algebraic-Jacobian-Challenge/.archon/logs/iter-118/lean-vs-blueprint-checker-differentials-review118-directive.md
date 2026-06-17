# Lean ↔ Blueprint Checker Directive

## Slug
differentials-review118

## Iteration
118

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Differentials.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Differentials.tex

## Known issues
- `Differentials.lean:93` body is `sorry` — this is the scheduled
  iter-119 prover lane on the refactored forward-direction
  `smooth_locally_free_omega`. Do flag in your report but do not
  classify as fake content.
- This iteration's refactor agent renamed the Lean theorem from
  `smooth_iff_locally_free_omega` (iff) to `smooth_locally_free_omega`
  (forward implication), dropped `LocallyOfFinitePresentation`,
  switched from `IsSmoothOfRelativeDimension` (deprecated alias) to
  `SmoothOfRelativeDimension` (current Mathlib class), and made `n`
  implicit. This iteration's blueprint-writer rewrote the chapter to
  match: theorem renamed to `thm:smooth_locally_free_omega`, proof
  sketch rewritten with a five-step verified Mathlib chain, new
  section disclosing the converse-direction Mathlib gap, with three
  remarks. Audit whether the post-refactor Lean and post-rewrite
  blueprint are now in mutual agreement.
