# lean-auditor directive — iter-222

Audit the following Lean file as Lean code, with no strategy bias:

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

Focus areas:
- The region L1390–1460 (the `internalHomEvalApp` / `internalHomEvalApp_tmul` /
  `restr_map_homMk` / `internalHomEval` block added this iter). `internalHomEval`
  (≈L1449) carries a typed `sorry` in its naturality field. Assess: is the `sorry`
  honestly flagged in its docstring, or is it laundered to read as complete?
- Large in-source `/- ... -/` comment block(s) holding a "WORKED-OUT NATURALITY PROOF"
  for `internalHomEval` (a preserved proof attempt). Is preserving a multi-screen proof
  attempt in a source comment appropriate, or is it dead clutter that should live in
  task_results instead?
- Any `set_option maxHeartbeats` raises left in the file — flag stray/large budgets.
- Stale docstrings anywhere claiming decls are complete/landed when they carry `sorry`,
  or scaffold headers (≈L37–85) misreporting current sorry status.
- `private lemma restr_map_homMk` — flag if its `rfl` proof is fragile (e.g. relies on
  defeq that could break) or if it should be more general.

Report your standard per-file checklist plus a flagged-issues block with severities.
Write your report to task_results/.
