# Lean ↔ Blueprint Checker Directive

## Slug
fbc

## Lean file
AlgebraicJacobian/Cohomology/FlatBaseChange.lean

## Blueprint chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Known issues
- No new declarations and no proof closure this iter. The only Lean change was rewriting an
  explanatory comment block around `base_change_mate_fstar_reindex_legs` (Seam 2 step-iii crux, still
  `sorry`) plus a one-line `rw [he, hinclA] at key` scaffolding step. Four `sorry`s remain
  (Seam 2 step-iii, Seam 3 `base_change_mate_gstar_transpose`, `affineBaseChange_pushforward_iso`,
  `flatBaseChange_pushforward_isIso`) — all expected/gated. Assess whether the Seam-2/Seam-3 blueprint
  blocks remain faithful to the Lean and whether the chapter still gives enough mechanism detail to
  close the step-iii telescoping (the chapter gate-passed in iter-017 via slug `fbc-fastpath`).
