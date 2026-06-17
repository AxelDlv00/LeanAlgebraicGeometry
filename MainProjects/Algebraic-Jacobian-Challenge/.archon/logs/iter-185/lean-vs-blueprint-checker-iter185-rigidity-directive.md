# Lean ↔ Blueprint Checker Directive

## Slug
iter185-rigidity

## Lean file
AlgebraicJacobian/AbelianVarietyRigidity.lean

## Blueprint chapter
blueprint/src/chapters/AbelianVarietyRigidity.tex

## Known issues
- iter-185 Lane E sub-task (f) pickup: structural advance only — sorry count 2 → 2 unchanged, but the residual sorry at L382 area was **pushed substantially deeper** from "opaque, blocked by privacy" to a concrete `appTop` ring-map equation by a `change` + iso-chain reconstruction trick (proof-irrelevance lets reconstructing the iso chain bypass the `private` `gmScalingP1_cover_X_iso` and `gmScalingP1_chart_PLB_eq` names).
- The Lane E body work is around `iotaGm_chart1_composition_isOpenImmersion` (L238 area). The chapter consolidates AbelianVarietyRigidity + Genus0BaseObjects/GmScaling content — verify both file's pinned declarations remain accurate.
- The fix dives through Mathlib `pullbackSpecIso`, `pullbackRightPullbackFstIso`, `pullbackSymmetry` and uses `ext_of_isAffine` for the affine-target reduction.
- This is a private helper (`iotaGm_chart1_composition_isOpenImmersion`) consumed by `iotaGm_isOpenImmersion` (the actual chapter-pinned theorem); not directly chapter-pinned by `\lean{...}`.
- `genusZero_curve_iso_P1` (L678) untouched per iter-167+ standing deferral.
- Verify chapter prose (e.g. `def:iotaGm`, `thm:iotaGm_isOpenImmersion` if pinned) remains accurate after the iter-185 structural advance.
