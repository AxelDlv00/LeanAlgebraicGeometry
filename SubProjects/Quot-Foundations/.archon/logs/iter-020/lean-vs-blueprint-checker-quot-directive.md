# Lean ↔ Blueprint Checker Directive

## Slug
quot

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean

## Blueprint chapter
blueprint/src/chapters/Picard_QuotScheme.tex

## Known issues
- The 4 file-skeleton stubs (lines ~126/165/201/228) are deliberate downstream-skeleton `sorry`
  placeholders — known, do not flag.
- `AlgebraicGeometry.GradedModule.iSupIndep_map_of_mem_ker_sup` and
  `AlgebraicGeometry.GradedModule.finrank_comap_subtype` are `private` helpers with no blueprint
  block yet (coverage debt already recorded for the planner) — note them under unreferenced
  declarations but do not raise as must-fix.
- Focus the verification on the now-CLOSED keystone chain:
  `lem:graded_subquotient_base_eventuallyZero` (Lean `subquotient_base_eventuallyZero`),
  `lem:graded_subquotient_isRatHilb` (`subquotient_hilbertSeries_rational`), and
  `lem:gradedHilbertSerre_rational` (`gradedModule_hilbertSeries_rational`) — confirm the landed
  route-(b) proof matches the chapter's informal proof.
