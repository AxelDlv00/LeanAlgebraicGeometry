# refactor directive — iter-037 — wire QcohRestrictBasicOpen into the build

## Task
The file `AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean` is currently NOT imported by the
root barrel `AlgebraicJacobian.lean` (the barrel imports TildeExactness, AffineSerreVanishing,
QcohTildeSections but not QcohRestrictBasicOpen). This file is NO LONGER dormant — its
`modulesRestrictBasicOpen`/`modulesRestrictBasicOpenIso` are load-bearing for the Route B keystone
bridge (B3/B4), which will be built into this file. Wire it into the project build.

## Exact change (ONE edit)
Add the line
  `import AlgebraicJacobian.Cohomology.QcohRestrictBasicOpen`
to `AlgebraicJacobian.lean`, alongside the other `AlgebraicJacobian.Cohomology.*` imports (keep the
import list tidy/alphabetical if it already is).

## Verify
Run `lake build` (or `lake env lean AlgebraicJacobian.lean`) and confirm EXIT 0 with no new errors.
Do NOT modify any `.lean` proof bodies. Do NOT insert any `sorry`. If the build fails for a reason
other than this import, STOP and report — do not paper over it.
