# Lean ↔ Blueprint Checker Directive

## Slug
avr

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/AbelianVarietyRigidity.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/AbelianVarietyRigidity.tex

## Focus areas
- iter-196 plan-phase landed a `lane-e-proj-appiso-pivot` recipe in blueprint
  AbelianVarietyRigidity.tex lines ~1265-1553. iter-196 prover landed 2 axiom-clean
  substrate primitives matching step (i) of that recipe:
  - `AlgebraicGeometry.Proj.awayι_preimage_basicOpen_self` (~L189)
  - `AlgebraicGeometry.Proj.awayι_eq_specMap_fromSpec` (~L199)
  Verify the Lean signatures match the blueprint's recipe step (i) statement.
- Two Lane E sorries remain:
  - `kbarChart1Ring_specMap_fac` (L326)
  - `iotaGm_chart1_appIso_eval` (~L534)
  Verify the blueprint chapter still adequately describes both, and the
  prover's documented next step (`Proj.basicOpenIsoSpec_inv_app_top` helper)
  is either reflected in the blueprint or should be added.

## Out of scope
- iter-194/195-era closures elsewhere in the file.
