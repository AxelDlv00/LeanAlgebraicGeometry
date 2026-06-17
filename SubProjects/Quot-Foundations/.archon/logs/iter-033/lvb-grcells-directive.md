# lean-vs-blueprint-checker — GrassmannianCells (iter-033)

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianCells.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_GrassmannianCells.tex

This iter added the ring-theoretic heart of separatedness (`diagonalRingMap`, `_left`, `_right`,
`diagonalRingMap_surjective`, `transitionPreMap_minorDet_swap_mul`) plus the pullback source iso
`pullbackιIso`. CRITICAL: the blueprint `lem:gr_separated` pins
`\lean{AlgebraicGeometry.Grassmannian.isSeparated}` but that declaration does NOT exist in the file
(a sorry'd `isSeparated_dev` stub was added then removed; only a doc-comment reduction remains).
Check: (a) is the `\lean{}` pin a dangling forward-reference that needs a `% NOTE`; (b) are the new
helpers faithful to the blueprint's separatedness argument; (c) which new helpers lack blueprint
coverage. Report bidirectionally.
