# lean-vs-blueprint-checker — FlatBaseChange (iter-022)

Bidirectional check of ONE Lean file against its blueprint chapter.

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## This iter's prover work
`base_change_mate_gstar_transpose` (blueprint `lem:base_change_mate_gstar_transpose`):
the prover landed a conjugate-counit scaffold (step 1 of the recipe) but the proof
still ends in `sorry`. Verify: (a) the Lean statement matches the blueprint lemma;
(b) the blueprint proof sketch is detailed enough to guide the remaining ~150-LOC
telescoping (steps 2–3), or flag the chapter as too thin; (c) no fake/placeholder
statements. Report bidirectionally.
