# lean-auditor directive (iter-240)

Audit the two `.lean` files that received prover edits this iteration. Report per-file:
outdated/stale comments, suspect definitions, dead-end or vacuous proofs, bad Lean
practices, and any docstring/header text that no longer matches the code.

## Files to read (absolute paths)
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/FlatBaseChange.lean

## Focus areas
- Two declarations were newly added near L880–L990 of TensorObjSubstrate.lean
  (`unitToPushforwardObjUnit_comp`, `pullbackObjUnitToUnit_comp`). Check they are
  genuine, non-vacuous constructions (not trivially-true / hypothesis-mismatched
  statements) and that their docstrings match what the code does.
- TensorObjSubstrate.lean contains TWO large `/- HANDOFF … -/` comment blocks
  (around L1011 and L1099) describing unbuilt declarations and a per-chart recipe.
  Verify these accurately describe the current code and are not stale references to
  decls that were removed mid-iter. Flag any module-header (top-of-file) text that
  lists wrong residuals or describes a route the body no longer takes.
- FlatBaseChange.lean `pushforward_spec_tilde_iso` (around L535–L660): a ~70-line
  proof now reduces an old `hloc` obligation to a single residual `sorry` (`hsq`,
  a naturality square). Check the proof scaffold is real (not sorry-padded) and that
  the surrounding comments correctly describe the residual.
- Flag any `sorry` whose surrounding comment claims it is closed, or any decl whose
  `\leanok`-implying comment overstates completion.

Output the standard per-file checklist plus a flagged-issues block (severity-tagged).
Do NOT assume what the strategy intends — audit the Lean as Lean.
