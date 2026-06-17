# Directive: lean-vs-blueprint-checker on Cohomology/FlatBaseChange.lean

Verify ONE Lean file against ONE blueprint chapter, bidirectionally.

## Lean file
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

## Blueprint chapter
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

## What to check
- Do the three Lean declarations (`pushforwardBaseChangeMap`,
  `affineBaseChange_pushforward_iso`, `flatBaseChange_pushforward_isIso`)
  match the blueprint's `\lean{...}` pins and the mathematical statements
  (`def:pushforward_base_change_map`, `lem:affine_base_change_pushforward`,
  `thm:flat_base_change_pushforward`)?
- Is `pushforwardBaseChangeMap` a GENUINE, non-vacuous construction of the
  base-change map the blueprint describes (adjoint mate of the unit), or is it
  circular / placeholder / type-correct-but-wrong?
- Are the two `sorry`-bodied proofs (affine lemma, flat theorem) honestly
  scoped — i.e. is the `isIso_iff_isIso_app` reduction in the affine lemma a
  real reduction toward the stated goal, or a detour?
- Blueprint → Lean: is the chapter detailed enough to guide the remaining
  proofs, or too thin where the Lean clearly needs more (the affine dictionary
  / Čech machinery)?

Report bidirectionally with any must-fix-this-iter findings.
