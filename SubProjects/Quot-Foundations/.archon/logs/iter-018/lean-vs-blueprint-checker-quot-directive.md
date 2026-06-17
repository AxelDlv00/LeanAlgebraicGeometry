# Lean ↔ Blueprint Checker Directive

## Slug
quot

## Lean file
AlgebraicJacobian/Picard/QuotScheme.lean

## Blueprint chapter
blueprint/src/chapters/Picard_QuotScheme.tex

## Known issues
- 20 new declarations were added this iter under `AlgebraicGeometry.GradedModule` and are NOT yet
  blueprinted (known coverage debt): `polyEndHom`, `polyEndHom_X`, `polyEndHom_C`, `polyModule`,
  `polyModule_X_smul`, `polyModule_C_smul`, `polyModule_isScalarTower`, `polySubmodule`,
  `polySubmodule_coe`, `SubquotientDatum`, `SubquotientDatum.hilb`,
  `finiteDimensional_of_mvPolynomial_isEmpty_finite`, `ker_isHomogeneous`, `coker_isHomogeneous`,
  `ker_le`, `coker_le`, `ker_annihilate`, `coker_annihilate`, `comap_map_le_of_commute`,
  `map_map_le_of_commute`. These are already on the planner's list to blueprint next iter — do not
  re-report each one as "missing block"; instead assess collectively whether the chapter's existing
  `lem:graded_subquotient_*` / `def:graded_subquotientHilb` blocks are detailed enough to have
  guided these, and whether the new `SubquotientDatum` structure faithfully realizes
  `def:graded_subquotientHilb`.
- The 4 protected stubs (`subquotient_hilbertSeries_rational` route + downstream) still carry `sorry`
  by design.
