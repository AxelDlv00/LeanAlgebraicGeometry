# Lean Auditor Directive

## Slug
iter179-touched

## Scope (files)
all

## Focus areas (optional)
Pay extra attention to the 6 files prover lanes touched this iter:
- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` (Lane A — chart-bridge body retirement was attempted; 2 TEMP project axioms still alive at L193 + L336; new partial body at L213; flag laundering pattern if any)
- `AlgebraicJacobian/Picard/RelativeSpec.lean` (Lane B — Block B downstream fills against a Mathlib-backed carrier introduced plan-phase; 2 helper sorries at L229 + L353 introduced — verify the helper types are substantive, not laundering)
- `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean` (Lane C — `morphismToP1OfGlobalSections` signature was tightened with `_halg` hypothesis and the body discharged; verify the `_halg` hypothesis is non-trivial)
- `AlgebraicJacobian/Albanese/CodimOneExtension.lean` (Lane D — `extend_iff_order_nonneg` was RENAMED to `mem_domain_iff_exists_partialMap_through_point` per auditor 178B Path D2; verify the rename + body is honest)
- `AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean` (Lane E — `extend_to_av` body landed with 1 named helper carrying `sorry`; verify helper type is substantive)
- `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` (Lane F — docstring only; verify the stale paragraph the iter-178 auditor flagged is actually gone)

Read every file under `AlgebraicJacobian/` (whole-project sweep is required by your role; do not narrow scope to the focus list).

## Known issues
- The 2 TEMP axioms `gmScalingP1_chart_data_temp` (L193) and `gmScalingP1_collapse_at_zero_temp` (L336) in `GmScaling.lean` are project-known temp axioms admitted iter-177 under the HARD STOP corrective; iter-181 RETIRE-OR-ESCALATE deadline is upcoming. You should still flag them and the laundering pattern they enable, but the fact they exist is not new information.
- 2 honest scaffold sorries in `Genus0BaseObjects/BareScheme.lean` are pre-existing Mathlib-gap scaffolds (`projectiveLineBar_geomIrred`, `projectiveLineBar_smoothOfRelDim`) — flag if their bodies became weakened-wrong, else skip.
- 1 long-line warning in `AlgebraicJacobian/AbelJacobi.lean:22` is the only style-linter hit; not a correctness issue.
- Auditor 178A (RationalCurveIso section-condition gap) was addressed THIS iter by Lane C; if you find the gap closed, do not re-flag.
- Auditor 178B (CodimOne shallow body + unused KrullDimLE binder) was addressed THIS iter by Lane D via Path D2 (rename); the binder was dropped, the rename happened. Verify.
- Auditor 178C (AuslanderBuchsbaum stale docstring) was addressed THIS iter by Lane F. Verify.
