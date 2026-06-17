# lean-auditor directive — iter-227

Audit the following Lean file as Lean (no strategy context, no blueprint):

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

This file received prover work this iteration. Three new declarations were added
near these locations:

- `restrictScalarsRingIsoDualEquiv` (def, ~L306)
- `AlgebraicGeometry.Scheme.Modules.homMk` (def, ~L2034)
- `AlgebraicGeometry.Scheme.Modules.toPresheaf_map_homMk` (`@[simp]` lemma, ~L2042)

Focus areas:
- Are the three new declarations genuine (no `sorry`/`admit`/`native_decide`/
  `maxHeartbeats`/disguised stubs), and do their statements say what their
  docstrings claim?
- Outdated / self-contradictory comments anywhere in the file (the file carries a
  long history of forward-pin docstrings; flag any that now describe a closed or
  reorganized state inaccurately).
- The three remaining `sorry` bodies (~L691, ~L2096, ~L2142): confirm they are
  honestly marked and their surrounding comments are accurate.
- Any bad Lean practice in the new code (e.g. `erw` abuse, fragile `rfl`, instance
  diamonds).

Report a per-file checklist plus a flagged-issues block with severity.
Write your report to `task_results/lean-auditor-ts227.md`.
