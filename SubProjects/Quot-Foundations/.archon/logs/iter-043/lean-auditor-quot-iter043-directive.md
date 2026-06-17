# Audit directive

## Files
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean

## Focus
- The new non-private decl `isLocalizedModule_basicOpen_of_hP1` (~line 2456): is the statement honest
  (no placeholder hypotheses, no vacuous form), is the proof a genuine transport (not defeq abuse),
  any orphaned `have`/`letI` left dangling?
- The `letI : Module … := Module.compHom …` + `show … from restrictₗ …` idiom around the `core`
  binding: legitimate instance plumbing, or does it weaken/duplicate an in-scope instance?
- Any `change`/`eqToHom`/`Subsingleton.elim` step that silently swaps a non-defeq goal.
- Stale or misleading comments; dead helpers; `maxHeartbeats` bump justified by a real cost.

## Output
Per-file checklist + flagged-issues block (must-fix / major / minor). Write to your task_results file.
