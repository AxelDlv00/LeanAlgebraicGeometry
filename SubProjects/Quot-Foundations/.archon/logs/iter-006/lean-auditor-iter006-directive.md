# Lean Auditor Directive

## Slug
iter006

## Files to audit
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/RegroupHelper.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean

## Focus areas
- These three files received heavy edit churn this iteration (17 edits, many reverted), ending with the same sorry count they started with. Pay extra attention to:
  - Whether every remaining `sorry` is honest scaffolding (no weakened-wrong definition standing in for the real concept; no tautological/placeholder statement).
  - In-code comments near sorries that may overstate or misstate what was achieved, or that read as excuse-comments ("temporary", "will fix later", "works for now").
  - The `eT`/`g` local `let` construction in `base_change_mate_regroupEquiv` (FlatBaseChange.lean, ~line 900-985) and the `ext x` reduction in `base_change_mate_generator_trace_eq` — confirm they are mathematically faithful, not vacuous.
  - The `induction d using Nat.strong_induction_on generalizing N` skeleton in `exists_free_localizationAway_polynomial` (FlatteningStratification.lean ~line 460-513) — confirm the closed branches are genuinely closed and the residual sorry is the honest dévissage gap.
- Report any outdated comments, dead-end proofs, or bad Lean practices per file.

## Output
Per-file checklist + flagged-issues block with severities, written to your task_results report.
