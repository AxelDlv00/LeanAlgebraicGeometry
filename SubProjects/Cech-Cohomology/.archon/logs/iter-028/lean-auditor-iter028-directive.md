## Files to audit

Audit ONLY the Lean file modified this iteration:

- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechToCohomology.lean

## Focus areas

- The 7 declarations added this iter: `sectionsFunctor`, `faceShortComplex_shortExact_of_sheaf_ses`,
  `absoluteCohomology_one_eq_zero_of_basis`, `CovDatum`, `BasisCovSystem`, `HasVanishingHigherCech`,
  `injSES` / `injSES_shortExact`, `absoluteCohomology_eq_zero_of_basis`, `cech_eq_cohomology_of_basis`.
- Check whether any definition is vacuous, trivially-satisfiable, or weakened relative to what its name
  claims (e.g. `BasisCovSystem` fields, `HasVanishingHigherCech` predicate).
- Check whether the `[EnoughInjectives X.Modules]` hypothesis on the L4 / top theorems is genuine
  (carried because the instance is absent) vs. a way to make a goal vacuously dischargeable.
- Stale / now-false comments.
- The `attribute [local instance] hasExtModules` re-activation and the heartbeat `set_option`s — flag if
  they mask a real failure rather than a genuine performance need.

You may read the file and run `lake env lean` / `lean_verify` to check axioms. Report a per-file checklist
plus a flagged-issues block (critical / major / minor).
