# Refactor directive — wire `AbsoluteCohomology.lean` into the build root

## Context
The file `AlgebraicJacobian/Cohomology/AbsoluteCohomology.lean` was created last iteration. It
compiles standalone (`lake env lean … exit 0`, 10 axiom-clean declarations, 0 sorries), but the
umbrella root barrel `AlgebraicJacobian.lean` does **not** import it, so it is orphaned from the
`lake build` target. A whole-project audit flagged this as the single must-fix this iter.

## Task (mechanical, one structural edit)
1. Add the line
   ```
   import AlgebraicJacobian.Cohomology.AbsoluteCohomology
   ```
   to `AlgebraicJacobian.lean`, in import order alongside the other
   `AlgebraicJacobian.Cohomology.*` imports (the file currently imports `HigherDirectImage`,
   `HigherDirectImagePresheaf`, `CechHigherDirectImage`, `CechAcyclic`, `AcyclicResolution`,
   `PresheafCech`, `FreePresheafComplex`, `CechBridge`). Place the new import in a sensible
   position (e.g. after `CechBridge`, or grouped logically).
2. Run `lake build` (or `lake env lean AlgebraicJacobian.lean`) and confirm the whole project
   still compiles green with the new import present. Report the exit status.

## Constraints
- This is the ONLY change. Do **not** touch any other file, do not edit any `.lean` proof body,
  do not add/remove declarations, do not modify `AbsoluteCohomology.lean` itself.
- Do not insert any `sorry`.
- `AbsoluteCohomology.lean` is already correct and axiom-clean; you are only wiring its import.

## Report
- Confirm the import was added and the exact line position.
- Report the `lake build` / `lake env lean` exit status (must be 0). If it is non-zero, paste the
  errors verbatim — that would indicate an unexpected interaction, which the planner needs to see.
