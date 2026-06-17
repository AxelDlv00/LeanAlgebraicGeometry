# lean-vs-blueprint-checker — GF (iter-016)

Bidirectionally verify ONE Lean file against its blueprint chapter.

- Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean
- Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_FlatteningStratification.tex

Check (a) Lean → blueprint and (b) blueprint → Lean. This iter the prover CLOSED
`free_localizationAway_of_away_tower` (blueprint `lem:gf_away_tower_descent`, ~line 1140 of the tex):
confirm the Lean proof matches the chapter's informal proof (witness `f := g·a`, single product;
the IsBaseChange.comp / Module.Basis.mapCoeffs / extendScalarsOfIsLocalization route).
The prover left `exists_free_localizationAway_polynomial` (L5, `lem:gf_polynomial_core`) PARTIAL,
blocked on an OreLocalization instance-presentation diamond between the IH output and the helper
input. Assess whether the chapter documents the L5 step-4 assembly adequately. Report coverage
counts and any must-fix.
