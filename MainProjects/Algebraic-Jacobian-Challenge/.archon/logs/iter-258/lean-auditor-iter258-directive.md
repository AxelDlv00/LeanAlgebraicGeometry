# Directive: lean-auditor — iter-258 touched files

Read-only Lean audit. Audit the Lean as Lean — no strategy bias.

## Files (absolute paths)
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/SheafOverEquivalence.lean` (NEW this iter)
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/LineBundleCoherence.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`

## Focus
- `SheafOverEquivalence.lean`: new file with 2 open sorries (`restrictOverIso` L235,
  `unitOverIso` leaf L276). Check the open sorries are genuine typed stubs with honest
  comments (not silently-discharged), check the `change`-to-subtype continuity-instance
  pattern and the `phiOver`/`psiOver` naturality proofs are not hiding `sorry`/`admit`,
  check for dead OLD decls (there is a `chartPresentationOLD` renamed in LineBundleCoherence
  — flag if it is dead weight).
- `LineBundleCoherence.lean`: verify the redirect import + body is clean; check the status
  block comments are not stale/overclaiming.
- `DualInverse.lean`: comment-only changes this iter; check no stale excuse-comments remain
  and the 2 typed sorries (`sliceDualTransport`, `dual_restrict_iso` Step-4) are honest.

Report per-file checklist + flagged issues with severity. Write to your task_results file.
