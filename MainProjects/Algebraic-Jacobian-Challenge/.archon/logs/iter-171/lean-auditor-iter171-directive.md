# Lean Auditor Directive

## Slug
iter171

## Scope (files)
all

## Focus areas (optional)

- `AlgebraicJacobian/Genus0BaseObjects.lean` — prover lane this iter added `algebraKbarAway`,
  `gmScalingP1_cover`, `gmScalingP1_chart{0,1}_ringMap`, `gmScalingP1` (body via
  `Scheme.Cover.glueMorphisms`), three new top-level sorry-bodied scaffold helpers
  (`gmScalingP1_chart`, `gmScalingP1_chart_agreement`, `gmScalingP1_over_coherence`), and
  rewrote `homogeneousLocalizationAwayIso_aux_left` with a real proof body that depends on
  one new helper sorry `mvPolyToHomogeneousLocalizationAway_surjective`. Several docstrings
  were rewritten to remove iter-169/170 "PARTIAL/escalation" prose. Audit for stale
  comments, unsupported wrapping of `sorry` (e.g. `:= by sorry` patterns), and any
  excuse-comments that may have been kept.
- `AlgebraicJacobian/AbelianVarietyRigidity.lean` — the `refactor avr-split` agent reduced
  this file from 1198 LOC to 354 LOC by moving the Mumford chain + Cor 1.5 + Cor 1.2 to
  a new file `AlgebraicJacobian/RigidityLemma.lean`. Audit for: stale comments referring to
  moved declarations, broken namespace boundaries, redundant imports.
- `AlgebraicJacobian/RigidityLemma.lean` — NEW file (902 LOC) created by `refactor
  avr-split`. Audit the file for: namespace correctness, no fake placeholder sorries
  (refactor agents only insert sorries when bodies move; if any appeared they would be
  red flags), import correctness, no orphan declarations.

## Known issues

- 10 sorries on `Genus0BaseObjects.lean` (`projectiveLineBar_geomIrred`,
  `projectiveLineBar_smoothOfRelDim`, `mvPolyToHomogeneousLocalizationAway_surjective`,
  `gm_grpObj`, `gmScalingP1_chart`, `gmScalingP1_chart_agreement`,
  `gmScalingP1_over_coherence`, `gmScalingP1_collapse_at_zero`, `gm_geomIrred`,
  `projGm_isReduced`) — known and tracked; do NOT re-report unless the body is suspect
  (e.g. `:= True`).
- 2 sorries on `AbelianVarietyRigidity.lean` (`iotaGm_isDominant`, `genusZero_curve_iso_P1`)
  — both gated on upstream work, known.
- 1 sorry on `RigidityKbar.lean` (`[CharZero]` fallback `rigidity_genusZero_charZero_real`),
  known.
- 2 sorries on `Jacobian.lean` (Route A genus-positive sub-witnesses), known.
- `Cotangent/ChartAlgebra.lean` is intentionally minimal (the iter-145 ChartAlgebraS3
  excision left it as a thin placeholder per the project memory KB) — known.

Per-file checklist for every `.lean` file in the project, with severity-classified
flagged-issues block.
