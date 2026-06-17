# Directive — lean-auditor (iter-169 narrow scope)

## Files to audit

This iter the prover touched only ONE file:

- `AlgebraicJacobian/Genus0BaseObjects.lean`

Edits this iter (per `task_results/AlgebraicJacobian_Genus0BaseObjects.lean.md`):
1. SECONDARY-1: `homogeneousLocalizationAwayIso_aux_left` docstring (L350-367) — replaced the
   "iter-168 partial: structural setup via …" prose with an honest "TODO — no body landed;
   deferred infrastructure not on the genus-0 critical path" message. Body remains `sorry`.
2. SECONDARY-2: `projectiveLineBar_isReduced` docstring (L708-718) — replaced "Project-side
   scaffold sorry (Mathlib does not ship …)" with "Closed axiom-clean iter-168 via
   `IsReduced.of_openCover` over `projectiveLineBarAffineCover` …". Body unchanged
   (already axiom-clean iter-168).
3. SECONDARY-3: section-(E) header (L680-696) — refreshed `ℙ¹` reduced bullet.
4. SECONDARY-4: deleted `ga_grpObj` (L526-540) and `ga_smooth` (~L555). `Ga` no longer carries
   a `GrpObj` instance. The `def:ga_grpObj` blueprint pin is now orphaned.
5. `gmScalingP1` (L685) docstring — replaced with iter-169 PARTIAL findings (3 attempts
   recorded). Body remains typed `sorry`.
6. `gmScalingP1_collapse_at_zero` (L709) docstring — replaced with iter-169 PARTIAL findings
   (gated on `gmScalingP1` body). Body remains `sorry`.

Per-file checklist requested: outdated comments, suspect definitions, dead-end proofs,
bad Lean practices. **Specifically re-audit** whether the FOUR "Mathlib gap"-framed
scaffold sorries the prover deferred (`projectiveLineBar_geomIrred` L175,
`projectiveLineBar_smoothOfRelDim` L182, `gm_geomIrred` L789, `projGm_isReduced` L819)
genuinely sit on Mathlib gaps or could close in <30 LOC like
`projectiveLineBar_isReduced` did at iter-168.

## Out of scope

- Other `.lean` files were not touched this iter; you may skim them only to confirm
  consistency (e.g. is the `ga_grpObj` deletion referenced anywhere else? Should it be?).

## Output

Per the auditor descriptor: per-file checklist plus flagged-issues block. Write to
the conventional `task_results/lean-auditor-iter169.md`.
