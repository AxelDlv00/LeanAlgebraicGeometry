# Lean ↔ Blueprint Checker Directive

## Slug
fbc-iter008

## Lean file
AlgebraicJacobian/Cohomology/FlatBaseChange.lean

## Blueprint chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Known issues
- `base_change_mate_regroupEquiv` (`lem:base_change_mate_regroupEquiv`) still carries
  2 `sorry`s (the two `r' • 0 = 0` zero-bookkeeping branches); its generator
  computation + additivity are proven this iter. This is known — do not report the
  remaining sorries as a placeholder failure; instead assess whether the blueprint
  proof sketch is adequate for the documented route-(b) fix (retype `g`'s domain/codomain
  at the genuine iso objects so the `R'`-module is transparent and `smul_zero` synthesizes).
- The three mate-trace sub-lemmas `lem:base_change_mate_unit_value`,
  `lem:base_change_mate_fstar_reindex`, `lem:base_change_mate_gstar_transpose` have prose
  in the chapter but NO `% LEAN SIGNATURE` block, so they were NOT formalized this iter.
  The prover reported this as the blocker for closing
  `base_change_mate_generator_trace_eq`. Assess whether the chapter is under-specified for
  these three (i.e. does it need `% LEAN SIGNATURE` blocks before the next prover dispatch?).
