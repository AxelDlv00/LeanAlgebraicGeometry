# Lean ↔ blueprint check — LineBundleCoherence

Verify bidirectionally:

- Lean file: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/LineBundleCoherence.lean`
- Blueprint chapter: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_LineBundleCoherence.tex`

This iter the prover closed 4 of 5 pinned bodies axiom-clean
(`exists_trivializing_cover`, `chart_free_rank_one`, plus chart-presentation /
`isFinitePresentation` / `isFiniteType` modulo one isolated iso `chartOverIso`,
which remains a typed `sorry`). New helper bricks (`freeUnitIso`, `unitGenerators`,
`unitPresentation`) were added.

Report:
(a) Lean → blueprint: do the `\lean{...}` pins match the actual declaration names /
    signatures? Are the closed statements faithful (not fake/weakened)? Is
    `chartOverIso` represented in the chapter or is it an un-blueprinted helper the
    Lean needed?
(b) blueprint → Lean: is the chapter detailed enough to have guided this
    formalization, in particular the over↔restrict bridge (`chartOverIso`) whose
    construction the Lean clearly needed but appears under-specified?

Flag any must-fix-this-iter findings. Report to your task_results file.
