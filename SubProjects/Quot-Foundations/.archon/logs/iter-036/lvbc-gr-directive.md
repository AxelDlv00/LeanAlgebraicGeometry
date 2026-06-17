# lean-vs-blueprint-checker — GrassmannianCells (iter-036)

Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianCells.lean
Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_GrassmannianCells.tex

Verify bidirectionally:
- This iter added E1 `existence_chart_factorization` (pinned `lem:gr_existence_chart_factorization`),
  E2 `existence_minimal_valuation` (pinned `lem:gr_existence_minimal_valuation`), and a NEW helper
  `existence_lift_transitionPreMap_minorDet_mul` (E3 ratio core) with NO blueprint block.
- Confirm the E1/E2 `\lean{...}` pins match the actual decl names and that the Lean signatures are
  faithful to the chapter statements (E1 had no `% LEAN SIGNATURE` — the prover designed one).
- Report the E3 ratio core as coverage debt needing a blueprint block (the displayed equation in the
  E3 proof: `f'(θ̃_{I,J}(P^J_K))·f(P^I_J) = f(P^I_K)`).
- E3-full (`existence_factor_through_valuationRing`) is blocked on a cofactor-expansion matrix gap;
  confirm the chapter acknowledges this gap and is not claiming it done.
- Report any broken `\lean{...}` pins or uncovered Lean decls.

Report Lean->blueprint AND blueprint->Lean findings with must-fix-this-iter flags where warranted.
