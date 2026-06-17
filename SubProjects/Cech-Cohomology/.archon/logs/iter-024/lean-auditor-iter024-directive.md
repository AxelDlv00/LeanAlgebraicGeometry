# lean-auditor directive — iter-024

Audit the two Lean files that received prover work this iteration. Audit the Lean as Lean —
outdated comments, suspect definitions, dead-end proofs, bad Lean practices, excuse-comments,
fake/placeholder statements, overstated docstrings.

## Files
- `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechBridge.lean`
- `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/FreePresheafComplex.lean`

## Focus areas
- Both files added a named top-level result this iter (`ses_cech_h1` in CechBridge;
  `cechFreeComplex_quasiIso` in FreePresheafComplex). Verify these are genuine, complete proofs
  — no `sorry`, no axiom shims, no statement weakened to triviality.
- Check module docstrings at the top of each file for staleness (do they still claim a target is
  "not yet built" when it now is, or vice versa).
- `ses_cech_h1` carries `set_option maxHeartbeats 1600000`. Flag if that is masking a real
  performance/structure problem vs. a legitimately large proof.
- Many new helpers are `private`. Check they are real lemmas, not no-op wrappers.

Report a per-file checklist plus a flagged-issues block with severities.
