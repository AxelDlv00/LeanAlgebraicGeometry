# Lean ↔ Blueprint Checker Directive

## Slug
fbc-iter006

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Notes
This file received prover edits this iter on `base_change_mate_regroupEquiv` (map_smul' — still sorry; the planned one-liner closure was found mathematically unsound) and `base_change_mate_generator_trace_eq` (an `ext x` reduction landed, residual sorry is the 3-step adjoint-mate trace). No new declarations were introduced. Verify bidirectionally: (A) the Lean follows the chapter's `\lean{...}` blocks and proof sketches (no fake/placeholder statements, signatures match); (B) whether the chapter is detailed enough to guide closing the two open FBC cruxes — in particular whether the 3-step mate-trace proof sketch and the regroup-equiv `map_smul'` reduction have enough mathematical detail, or whether the chapter is too thin and needs a blueprint-writer expansion before the prover can effort-break these.
