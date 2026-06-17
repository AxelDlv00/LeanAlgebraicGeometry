# Lean ↔ Blueprint Checker Directive

## Slug
fbc

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean

## Blueprint chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Known issues
- The L4 chain landed this iter: `base_change_mate_regroupEquiv` (sorry in its
  `map_smul'`), `base_change_mate_generator_trace_eq` (sorry body),
  `base_change_mate_generator_trace` (proof closed, consumes the two above).
  These `sorry`s are known — flag them only if the blueprint claims they are
  proved or the signatures mismatch the prose.
- `base_change_regroup_linearEquiv` is a NEW prover-created helper with NO
  blueprint block yet (known coverage debt) — report it under blueprint
  adequacy / unreferenced declarations, do not treat as a Lean error.
- `affineBaseChange_pushforward_iso` and `flatBaseChange_pushforward_isIso`
  carry deferred `sorry`s (later lanes), known.
- The tensor-orientation divergence (`A ⊗[R] R'` in Lean vs `R' ⊗_R A` in
  prose) was confirmed faithful in prior iters — do not re-report.
