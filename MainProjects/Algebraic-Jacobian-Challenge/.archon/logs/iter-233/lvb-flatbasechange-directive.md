# Lean ↔ blueprint check — FlatBaseChange.lean vs Cohomology_FlatBaseChange.tex

Verify exactly one Lean file against its blueprint chapter, bidirectionally.

- Lean file: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- Blueprint chapter: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Cohomology_FlatBaseChange.tex

This iter added 3 project-local locality criteria for `Scheme.Modules` morphisms
(`isIso_iff_isIso_stalkFunctor_map`, `isIso_of_isIso_app_of_isBasis`,
`isIso_iff_isIso_app_affineOpens`) that are NOT in the blueprint, and wired the first
into `affineBaseChange_pushforward_iso`'s reduction. The two engine theorems
(`affineBaseChange_pushforward_iso`, `flatBaseChange_pushforward_isIso`) remain `sorry`.

Key questions: (a) do the Lean signatures for the two engine theorems match the
blueprint statements? (b) should the blueprint record the 3 new locality lemmas (as a
supplement subsection), or are they fine as undocumented project-local infra? (c) is the
blueprint adequately detailed for the remaining tilde-dictionary proof work?

Write your report to your task_results file.
