# lean-vs-blueprint-checker directive (iter-019) — FlatBaseChange

Verify bidirectionally exactly ONE Lean file against its blueprint chapter.

Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean
Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex

Report:
- Lean -> blueprint: any fake/placeholder/weakened statements; signature mismatches with
  \lean{} pins; new prover-created declarations with no blueprint block.
- Blueprint -> Lean: any blueprint block too thin to have guided this iter's formalization
  (the level of detail the Lean code clearly needed but the chapter lacks).
- Flag any must-fix-this-iter items that block downstream work on this file/chapter.
