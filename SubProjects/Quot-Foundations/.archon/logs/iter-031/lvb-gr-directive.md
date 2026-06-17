# lean-vs-blueprint-checker — GrassmannianCells (iter-031)

Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianCells.lean
Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_GrassmannianCells.tex

Verify bidirectionally for the iter-031 prover work (the GR-glue lane closed this iter):
- New Lean decls: `cocyclePhiId` (pin `lem:gr_cocycle_phi_id`), `chartTransition'_cocycle` (no
  block yet), `theGlueData` (no block yet), `scheme` (pin `def:gr_glued_scheme`), plus private
  helpers `rotMid`, `transitionInvImageMatrix`, `transitionInvPair`,
  `awayMulCommEquiv_comp_awayInclLeft` (no block yet — coverage debt).
- Confirm the `def:gr_glued_scheme` and `lem:gr_cocycle_phi_id` statements match the Lean signatures.
- Report: (a) any fake/placeholder/signature mismatch Lean-side; (b) whether the chapter prose was
  adequate to guide the cocycle/GlueData formalization, or too thin; (c) coverage-debt decls needing
  blueprint blocks. Note: the review agent already corrected the stale `% NOTE (formalization status)`
  at the `def:gr_glued_scheme` block to "FULLY FORMALIZED".
