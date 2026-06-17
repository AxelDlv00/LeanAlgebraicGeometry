# lean-vs-blueprint-checker directive — CechHigherDirectImage (iter-271)

Verify exactly one Lean file against its blueprint chapter, bidirectionally.

Lean file:
  /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean

Blueprint chapter:
  /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

Specific points to check:
- `lem:push_pull_functor` carries `\lean{AlgebraicGeometry.pushPullMap_comp}` but NO Lean
  declaration `pushPullMap_comp` exists (it is an in-file comment only). A `% NOTE (iter-264)`
  already flags this. Confirm the note is still accurate and the `\lean{}` target is honestly
  marked as not-yet-formalized (the statement-block should not over-claim).
- This iter added `AlgebraicGeometry.pushPull_transport_cancel` (an infra helper with no
  blueprint environment of its own). Report it as 1-to-1 coverage debt if it has no `\lean{}`
  entry anywhere — name it for the planner to blueprint.
- Report whether the chapter is detailed enough to guide the deferred `pushPullMap_comp`
  formalization, or whether the blueprint is too thin.

Report bidirectionally (Lean→blueprint and blueprint→Lean) with any must-fix-this-iter findings.
