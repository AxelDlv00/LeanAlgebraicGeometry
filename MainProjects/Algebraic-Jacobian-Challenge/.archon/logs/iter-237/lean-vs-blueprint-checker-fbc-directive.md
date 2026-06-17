# lean-vs-blueprint-checker directive — FlatBaseChange.lean ↔ Cohomology_FlatBaseChange.tex (iter-237)

Verify ONE Lean file against ONE blueprint chapter, bidirectionally.

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/FlatBaseChange.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## What changed this iter
Three new axiom-clean decls were added, NOT pinned in the blueprint yet:
`AlgebraicGeometry.IsLocalizedModule.powers_restrictScalars`,
`AlgebraicGeometry.fromTildeΓ_app_isIso_of_isLocalizedModule`,
`AlgebraicGeometry.pushforward_spec_tilde_iso_of_isLocalizedModule`.
The blueprint pins `lem:pushforward_spec_tilde_iso` → `AlgebraicGeometry.pushforward_spec_tilde_iso`, but the
prover built only the **conditional** version (`..._of_isLocalizedModule`, taking the basic-open localization
fact `hloc` as a hypothesis); the unconditional `pushforward_spec_tilde_iso` was NOT built. Two `sorry`s
remain (`affineBaseChange_pushforward_iso`, `flatBaseChange_pushforward_isIso`).

## Specific things to verify
1. Is `lem:pushforward_spec_tilde_iso`'s `\lean{}` pin (`pushforward_spec_tilde_iso`) dangling — i.e. does the
   chapter claim a decl that does not exist? If so, report it (Lean→blueprint).
2. Do the 3 new helper decls deserve their own `\lean{}` blocks, and does the route-iii prose already
   describe them well enough that the plan agent only needs to add pins (blueprint→Lean adequacy)?
3. Are the 2 remaining sorries honestly reflected in the blueprint (no `\leanok` should be present on their
   statement/proof blocks)?

## Output
Bidirectional report with any must-fix-this-iter findings clearly marked. Write to your task_results report.
