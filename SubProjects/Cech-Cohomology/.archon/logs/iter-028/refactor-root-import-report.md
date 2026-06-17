# Refactor result — root-import (iter-028)

## Status: DONE

## Change made
Added `import AlgebraicJacobian.Cohomology.CechToCohomology` to `AlgebraicJacobian.lean`
immediately after the existing `import AlgebraicJacobian.Cohomology.AbsoluteCohomology` line,
keeping the Cohomology import group ordered by dependency.

## Build result
```
lake build
Build completed successfully (8328 jobs).
EXIT: 0
```

CechToCohomology was replayed from cache (`⚠ [8326/8328] Replayed AlgebraicJacobian.Cohomology.CechToCohomology`) with only style warnings (long lines, `show` vs `change`) — no errors, no sorries introduced.
