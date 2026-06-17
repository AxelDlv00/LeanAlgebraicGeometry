# Refactor directive — add root import for CechToCohomology.lean

## Goal
The new file `AlgebraicJacobian/Cohomology/CechToCohomology.lean` landed last iter (12 axiom-clean
decls, 0 sorries) but is **not yet imported into the build root**, so the umbrella build does not see it.

## Single change
Add the line

```
import AlgebraicJacobian.Cohomology.CechToCohomology
```

to the build root `AlgebraicJacobian.lean`, placed next to the existing
`import AlgebraicJacobian.Cohomology.AbsoluteCohomology` (line 9) — keep the Cohomology imports grouped
and in a sensible order (CechToCohomology imports CechBridge + AbsoluteCohomology, so it must come
after those if the root lists them; otherwise alphabetical within the group is fine).

## Constraints
- This is the ONLY edit. Do not touch any `.lean` proof body, do not insert any `sorry`, do not modify
  CechToCohomology.lean itself.
- After editing, run `lake build` and confirm it exits 0 (the file already compiles standalone, so the
  only effect is wiring it into the umbrella).
- Report the exit code in your task result.

## Write domain
- `AlgebraicJacobian.lean`
