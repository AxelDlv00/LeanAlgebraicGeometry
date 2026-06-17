# Lean ↔ Blueprint Checker Directive

## Slug

chartalgebras3-iter150

## Target Lean file

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/ChartAlgebraS3.lean`

## Target blueprint chapter

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex`

(This is the iter-149 pointer chapter for the (S3.\*) sub-claims; the
canonical lemma statements live in the parent
`RigidityKbar.tex`. The pointer chapter forwards to the canonical
chapter and adds the (S3.\*)-specific prose.)

## Focus areas

- **Iter-150 docstring updates**: each of the four (S3.\*) lemmas had
  its in-source docstring updated with iter-150 status notes
  (HYBRID-DEFERRED for (S3.pi.\*); HYBRID-attempted with
  consumer-blocked status for (S3.sep.\*)). Verify the blueprint
  reflects the (S3.pi.\*) deferral disposition explicitly OR that a
  `% NOTE:` is warranted on the chapter side.
- **New helper lemma** `Algebra.IsSeparable.of_finite_of_perfectField`
  added at the end of the file (just before `end AlgebraicGeometry`).
  This is a CharZero-collapse helper that is NOT one of the four
  (S3.\*) blueprint declarations. Verify whether the chapter needs a
  pointer/note to it or whether it should remain unblueprinted as
  project-private infrastructure.
- **Signature drift** vs iter-149: did the prover-lane attempts at
  signature inflation (per the iter-150 task_result) leave any
  residual inconsistency between the `\lean{...}` hints and the
  current Lean signatures? Verify reverts landed cleanly.
- **Pointer chapter known issue**: per iter-150 plan, the pointer
  chapter `AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex` carries
  Stacks Tag references at lines ~42, 46, 51 that the plan flagged
  as still-wrong post the iter-150 render-fix writer. Confirm whether
  this is still the state and surface it.

## Acceptance criteria

Per-direction findings with severity tags. If the chapter is a thin
pointer (low information density), report that explicitly and note
whether the writing of the (S3.\*) statements in the canonical
`RigidityKbar.tex` is the right cross-reference target.
