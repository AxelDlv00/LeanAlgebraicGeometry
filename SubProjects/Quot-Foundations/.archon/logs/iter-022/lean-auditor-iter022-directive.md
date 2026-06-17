# lean-auditor — iter-022

Audit the two Lean files modified this iteration. Read them in full and report your
standard per-file checklist (outdated comments, suspect definitions, dead-end proofs,
bad Lean practices, excuse-comments) plus a flagged-issues block.

## Files (absolute paths)
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean

## Focus areas
- FlatteningStratification.lean: a `set_option maxHeartbeats 1600000` +
  `synthInstance.maxHeartbeats 400000` was added to `genericFlatnessAlgebraic`.
  Assess whether this is justified or masks a structural problem.
- FlatBaseChange.lean: `base_change_mate_gstar_transpose` carries a `sorry` with a
  large `set`/`have` scaffold above it; check the scaffold is genuine (compiles,
  no fake/weakened statements) and the inline comments are accurate.
- Flag any stale comments describing now-closed `sorry`s as still open.
