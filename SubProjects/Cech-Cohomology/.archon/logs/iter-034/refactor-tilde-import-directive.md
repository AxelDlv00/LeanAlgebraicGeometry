# Refactor directive — wire TildeExactness into the root barrel

## Scope
ONE structural edit, nothing else. Do NOT touch any proof, do NOT insert any `sorry`,
do NOT modify any other file.

## Change
The new file `AlgebraicJacobian/Cohomology/TildeExactness.lean` (created iter-033, 0-sorry,
axiom-clean, builds via `lake env lean`) is not yet imported by the root barrel
`AlgebraicJacobian.lean`, so the project-wide `lake build` does not include it.

Add the line

```
import AlgebraicJacobian.Cohomology.TildeExactness
```

to `AlgebraicJacobian.lean`, placed immediately after
`import AlgebraicJacobian.Cohomology.CechToCohomology` (line 10) and before
`import AlgebraicJacobian.Cohomology.AffineSerreVanishing` (keep the list's existing order
otherwise; alphabetical-within-cohomology is not required — just insert it in the block).

## Verify
Run `lake build` (or `lake env lean AlgebraicJacobian.lean`) and confirm EXIT 0 — the import
must not break the build. TildeExactness.lean already compiles standalone, so this should be clean.
Report the final import order.
