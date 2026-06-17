# lean-auditor — iter-158

Audit the Lean code for honesty, dead-ends, outdated comments, and bad practices.
No strategy context is provided by design — audit the Lean as Lean.

## Files to read (absolute paths)

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/AbelianVarietyRigidity.lean` (PRIMARY — received all prover edits this iter)
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Jacobian.lean` (consumer; unchanged this iter)
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RigidityKbar.lean` (fallback artifact; unchanged this iter)

## Focus areas

1. In `AbelianVarietyRigidity.lean`, the declarations `rigidity_lemma`, `rigidity_core`,
   `rigidity_eqOn_dense_open` form a stack. Check carefully whether the hypothesis named `_hf`
   (the collapse hypothesis `lift (𝟙 X) (toUnit X ≫ y₀) ≫ f = toUnit X ≫ z₀`) is GENUINELY
   CONSUMED in the proof of `rigidity_eqOn_dense_open`, or whether it is merely declared and
   ignored (laundering). A prior audit found an earlier version DROPPED this hypothesis, making
   the helpers false as stated. Verify whether that is fixed.
2. The two `sorry`s inside `rigidity_eqOn_dense_open` (named `hfib`, and the final agreement
   equation): assess whether each is a TRUE mathematical statement (an honest gap) or whether
   either is false / unsatisfiable as stated given the hypotheses in scope.
3. `snd_left_isClosedMap` (new helper): is the proof honest and complete (no sorry)?
4. Stale or misleading docstrings/comments anywhere in these files.

Report a per-file checklist plus a flagged-issues block with severity. Push back on any
over-claim. Write your report to your task_results file.
