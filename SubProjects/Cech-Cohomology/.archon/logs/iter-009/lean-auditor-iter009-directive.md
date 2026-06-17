# Lean audit — iter-009

Audit the project's Lean source. Pay extra attention to the file modified this
iter:

- `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/AcyclicResolution.lean`

Two new top-level declarations were added near the end of this file:
- `CategoryTheory.Functor.rightDerivedOneIsoCokerOfAcyclic` (~line 688)
- `CategoryTheory.Functor.rightDerivedIsoOfAcyclicResolution` (~line 895)

Check for: outdated/contradictory comments (especially any "Status (iter-NNN)"
block at the end claiming work is NOT done that now IS done), suspect or vacuous
definitions, dead-end or circular proofs, `sorry`/`admit`, axiom leakage beyond
`{propext, Classical.choice, Quot.sound}`, and bad Lean practice.

Also include in scope (whole-project read):
- `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`
- `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian.lean`

Report a per-file checklist plus a flagged-issues block with severity.
