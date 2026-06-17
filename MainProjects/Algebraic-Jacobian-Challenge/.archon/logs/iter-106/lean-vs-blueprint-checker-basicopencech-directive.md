# Lean ↔ Blueprint Checker Directive

## Slug
basicopencech-iter106

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/BasicOpenCech.lean

## Blueprint chapter
blueprint/src/chapters/Cohomology_MayerVietoris.tex

## Known issues
- Blueprint-reviewer-iter106 already flagged § "Čech acyclicity for the structure sheaf on affine basic-open covers" (~L1110–1180) as not yet exposing the iter-104/105 named-family + R-linearity engine (`cechCofaceMap_pi_smul`, `cechCofaceMap_summand_family_R_linear`, `cechCofaceMap_summand_family'`, `cechCofaceMap_summand_family'_R_linear`) as chapter-level objects. This is a known "soon" carry-over; do not re-flag unless you see active drift.
- The L1120 sorry inside `cechCofaceMap_pi_smul` body is intentionally PAUSED per strategy-critic-iter106 verdict; sorry-presence alone is not a blueprint failure. Flag only if the prose contradicts the Lean.
- The L1802 sorry inside `h_loc_exact` is the iter-108 partial-proof scaffold (geometric setup committed; remaining ~100-120 LOC of glue deferred per analogist Q1 recipe). Same treatment: flag only if prose contradicts Lean.
- The iter-106 blueprint-writer landed the typo fix at `Cohomology_StructureSheafModuleK.tex:474` (`thm:` → `def:` for `Scheme_toModuleKSheaf`); not your scope.

## Focus
Examine whether the four-step proof sketch in the Čech-acyclicity section of `Cohomology_MayerVietoris.tex` adequately previews the work that has accumulated in `BasicOpenCech.lean` between L1700 and L1810 (the `exact_of_isLocalized_span` scaffold, the `h_loc_exact` per-coord recipe, the geometric `h_V_le_U` / `h_slice_eq` setup landed iter-108). Is the blueprint sketch detailed enough that a prover could re-derive iter-108's partial-proof setup independently? If not, is the chapter's "soon" carry-over still appropriate, or has the drift hardened?
