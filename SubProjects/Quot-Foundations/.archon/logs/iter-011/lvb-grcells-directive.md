# Lean ↔ Blueprint check — GrassmannianCells (iter-011)

Verify one Lean file against its blueprint chapter, bidirectionally.

- Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianCells.lean
- Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_GrassmannianCells.tex

This file received the bulk of this iter's prover work: 16 new declarations (the universal
matrix, its minors/determinant, the Cramer inverse, the image matrix, the pre-transition hom,
the away-localisation `transitionMap`, and `transitionMap_self`), reported axiom-clean and
`sorry`-free with `lake build` GREEN.

Report:
1. **Lean → blueprint**: does every new Lean declaration faithfully match its blueprint block
   (`\lean{...}` pin resolves, statement is the blueprinted claim, no weakened/fake/placeholder
   statement)? Several decls were pinned by the planner ahead of time — confirm the landed Lean
   matches those pins, and list any Lean decl with NO blueprint block (coverage debt).
2. **Blueprint → Lean**: is the chapter detailed enough to have guided this formalization, or
   did the Lean clearly need detail the chapter lacks? Flag any blueprint block whose `\lean{}`
   target is absent or misnamed in the Lean.
3. Any must-fix-this-iter findings (signature mismatch, vacuous statement, fake proof).
