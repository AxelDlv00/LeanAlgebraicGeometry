# lean-vs-blueprint-checker — iter-012 (quot)

Verify ONE Lean file against ONE blueprint chapter, bidirectionally.

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_QuotScheme.tex

Report: (a) does the Lean follow the blueprint (fake/placeholder statements, signature mismatches
with \lean/\label, weakened defs); (b) is the blueprint adequate to guide the Lean (missing proof
detail the Lean clearly needed). Flag any \lean{...} that does not resolve to a real decl and any
landed decl with no blueprint block. Mark must-fix-this-iter findings explicitly.
