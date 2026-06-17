# Lean audit — iter-015

Audit the following `.lean` files as Lean code. Report outdated comments, suspect
definitions, dead-end proofs, bad Lean practices, and any excuse-comments. Pay extra
attention to: (a) `maxHeartbeats` / `synthInstance.maxHeartbeats` bumps and whether they
are honest necessity vs masking a problem; (b) any `sorry` whose surrounding comment
claims more than the body delivers; (c) stale `STATUS (iter-NNN)` / cross-project
iter-number comments that no longer reflect the code.

Files (absolute paths):
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianCells.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/RegroupHelper.lean

Note for context only (do not let it bias you): `lake build` of all modules is green;
all `sorry`s are openly present. One known oddity: `FlatteningStratification.lean` compiles
under `lake build` but a cold `lake env lean <file>` tripped a heartbeat timeout near
L1146 — assess whether the file's `maxHeartbeats` settings are sound.
