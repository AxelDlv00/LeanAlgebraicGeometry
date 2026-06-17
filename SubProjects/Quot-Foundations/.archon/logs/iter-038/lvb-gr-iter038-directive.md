# Lean-vs-Blueprint Checker — GrassmannianCells (iter-038)

Verify exactly one Lean file against its blueprint chapter, bidirectionally.

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianCells.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_GrassmannianCells.tex

## This iter's new declarations to check
`existence_chart_kpoint_eq`, `existence_lift` (E4, `lem:gr_existence_lift`),
`liftToBaseOfMemRange` + `algebraMap_comp_liftToBaseOfMemRange` (private),
`valuativeExistence_toSpecZ` (E5, `lem:gr_valuativeExistence_toSpecZ`),
`isProper` (E6, `lem:gr_proper`).

Report: (a) does the Lean follow the blueprint (statement/signature/`\lean{}` match, no
placeholder/fake statements)? (b) is the chapter detailed enough to have guided these proofs?
Flag any missing blueprint block for a new public decl (e.g. `existence_chart_kpoint_eq`),
any `\lean{...}` pin mismatch, and any must-fix-this-iter items.
