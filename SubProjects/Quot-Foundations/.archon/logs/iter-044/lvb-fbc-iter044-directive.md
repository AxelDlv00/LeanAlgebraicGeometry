# Lean ↔ blueprint check — FlatBaseChange

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Focus
This iter added NO new declaration; only in-proof scaffolding (`adjL`/`hunitL`) above the still-open
`sorry` @1891 inside `base_change_mate_fstar_reindex_legs_conj` (blueprint
`lem:base_change_mate_fstar_reindex_legs_conj`). Verify: (a) that keystone block still matches the Lean
signature; (b) the dead/illusory `sections_direct` route — blueprint has
`lem:pushforward_base_change_mate_sections_direct` (frontier node, effort 5351) whose Lean target
`pushforward_base_change_mate_sections_direct` may NOT exist or be sorry — flag if the blueprint frontier
node points at an absent/abandoned Lean decl (the iter-043 reversal recorded that route as illusory).
Report bidirectionally.

## Output
must-fix / major / minor. Report to task_results.
