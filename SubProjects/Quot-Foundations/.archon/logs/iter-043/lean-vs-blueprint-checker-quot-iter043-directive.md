# Lean ↔ blueprint check

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_QuotScheme.tex

## Check
- New decl this iter: `isLocalizedModule_basicOpen_of_hP1` (~line 2456) — the hP1-explicit gap2
  transport (Piece B). It has NO blueprint block yet (a `lean_aux`). Report whether it should map to
  the existing `lem:qcoh_section_localization_basicOpen` part (2) or needs its own block.
- Piece A `lem:qcoh_pullback_fromSpec` (`isQuasicoherent_pullback_fromSpec`): blueprint block present,
  Lean decl ABSENT (correctly — gated). Confirm the block's `\uses` cone and proof sketch are adequate
  to guide the iter-044 formalization (the prover flagged a 5-step route-1 decomposition).
- Any `\lean{...}` pin in the chapter naming a non-existent or renamed decl; any signature mismatch.
- Bidirectional: is the chapter detailed enough for the Piece B / Piece A formalizations?

## Output
Bidirectional findings (must-fix / major / minor) to your task_results file.
