# Lean ↔ Blueprint checker — AbelianVarietyRigidity, iter-162

Verify exactly one Lean file against its blueprint chapter, bidirectionally.

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/AbelianVarietyRigidity.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/AbelianVarietyRigidity.tex

## What changed this iter
- New top-level helper `AlgebraicGeometry.isIntegral_of_retract` was proven (blueprint node
  `lem:isIntegral_of_retract_of_integral`, whose `\lean{}` was left blank pending this helper —
  check whether the chapter's `\lean{}` hint matches the actual Lean name).
- `rigidity_eqAt_closedPoint_of_proper_into_affine` (Step 1) body was filled; the whole chain
  (`rigidity_lemma`, `rigidity_core`, `rigidity_eqOn_dense_open`,
  `rigidity_eqOn_saturated_open_to_affine`, `rigidity_eqAt_closedPoint_of_proper_into_affine`) is
  now sorry-free and axiom-clean.

## Check
(a) Lean → blueprint: are all `\lean{...}` signatures faithful to the actual declarations? Any
    placeholder/fake statements, signature mismatches, proof divergence from prose?
(b) Blueprint → Lean: is the chapter detailed enough to have guided this formalization? Is the
    `\uses` graph forward-acyclic with not-proven status correctly propagated (no marker-graph
    laundering of the now-closed chain)? Does any node need a `\lean{}` correction?

Report bidirectionally to your task_results report with severity-tagged findings.
