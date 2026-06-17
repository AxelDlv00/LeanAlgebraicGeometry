# Blueprint Reviewer Directive — iter-151

## Scope
Whole-blueprint audit (all chapters under `blueprint/src/chapters/`). Do NOT
limit to a subset — the cross-chapter view is the point.

## Context for this audit
The project is mid-way through the chart-algebra envelope (Route C, M2
critical path). The actively-proven Lean files this iter are
`AlgebraicJacobian/Cotangent/ChartAlgebra.lean` (chapter: a subsection of
`RigidityKbar.tex`) and `AlgebraicJacobian/Cotangent/ChartAlgebraS3.lean`
(chapter: `AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex`).

The iter-150 reviewer fired the HARD GATE on `RigidityKbar.tex` on
**rendering grounds** (`correct: partial`), which was remediated the same
iter by a render-fix writer round (`leanblueprint web` builds clean).
Confirm whether that remediation holds and whether `RigidityKbar.tex` now
clears the gate.

## What to report (per-chapter checklist + summary)
For each chapter give: `complete: true|partial`, `correct: true|partial|false`,
and any **must-fix-this-iter** items. Then specifically:

1. Is `RigidityKbar.tex` now clean (complete + correct), so a prover lane on
   `ChartAlgebra.lean` (KDM `mem_range_algebraMap_of_D_eq_zero` (BR.5) transfer
   step) is gate-cleared this iter?
2. Is `AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex` clean? (Note: the plan
   agent is aware of 3 wrong Stacks Tag numbers at lines ~42/46/51 carried over
   from a prior round — flag them if still present, they are slated for a
   writer fix this iter.)
3. Any chapter with a backing external source that is MISSING a proper
   mathematical cross-reference (specific lemma number + source) before its
   definitions/theorems? The plan agent is dispatching a blueprint-writer this
   iter to add verbatim source citations — your list of "which declarations
   lack a citation block" directly seeds that writer's directive. Prioritise
   `RigidityKbar.tex` and `Jacobian.tex`.
4. Any broken `\uses{}` / `\ref{}` / orphan labels.

## Out of scope
Do not edit any files. Read-only audit; write only your report to
`task_results/`.
