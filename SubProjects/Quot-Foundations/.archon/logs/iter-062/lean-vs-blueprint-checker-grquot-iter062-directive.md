## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianQuot.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_GrassmannianQuot.tex

## Task
Bidirectional check for THIS iter's prover work:
- New closed lemmas: `scalarEnd_pullback` (lem:gr_scalarEnd_pullback), helper
  `unitToPushforward_scalarEnd_comm`, and partial `matrixEnd_pullback` (lem:gr_matrixEnd_pullback,
  still `sorry` — should NOT carry proof-block leanok).
- Verify `\lean{}` pins resolve to real decls; statement signatures match the blueprint claims.
- Report Lean→blueprint coverage gaps (helpers with no blueprint entry) AND blueprint→Lean
  (blocks whose sketch is too thin to have guided the formalization).
- Note: do NOT treat statement-block `\leanok` on a sorry-bodied decl as laundering — that is the
  deterministic sync's "declaration formalized" semantics. Only flag proof-block leanok on sorries.
