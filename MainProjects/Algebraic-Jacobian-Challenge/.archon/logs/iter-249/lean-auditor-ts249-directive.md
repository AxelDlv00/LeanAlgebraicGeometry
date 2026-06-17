# lean-auditor directive — iter-249

## Files to audit (read these absolute paths)

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

## Focus areas

1. The module-status docstring near the top of the file (approx L41–L51): it was rewritten
   this iter to claim "TWO tracked typed-`sorry` residuals" (`exists_tensorObj_inverse` ~L699
   and a `(∗∗)` presheaf residual inside `pullbackEtaUnitSquare` ~L1741) and that "the entire
   abstract mate-calculus telescope is CLOSED axiom-clean this iter." Verify these claims against
   the actual code: are there exactly two `sorry` bodies? Is the docstring's description of what
   is closed vs. open accurate, or is it an excuse-comment / over-claim?

2. The `pullbackEtaUnitSquare` lemma proof (approx L1665–L1741): it contains in-proof comments
   describing the remaining `(∗∗)` step and a 3-substep recipe `(i)/(ii)/(iii)`, plus a reference
   to a not-yet-created lemma `epsilonPresheafToSheafUnit`. Flag any in-code comment that
   describes a step as done when the surrounding code does not actually do it, any stale
   route/handoff comment, or any comment that excuses a `sorry` rather than documenting it.

3. General: outdated comments, dead declarations, bad Lean practices, suspect definitions,
   any `sorry` that is masked or laundered.

Report a per-declaration checklist plus a flagged-issues block with severity. Write your report
to `task_results/lean-auditor-ts249.md`.
