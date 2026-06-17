# Refactor Report

## Slug
wire-import

## Status
COMPLETE

## Directive

**Problem:** `AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean` was not imported by the root
barrel `AlgebraicJacobian.lean`, leaving its declarations (`modulesRestrictBasicOpen`,
`modulesRestrictBasicOpenIso`) invisible to the build and downstream consumers.

**Changes requested:** Add `import AlgebraicJacobian.Cohomology.QcohRestrictBasicOpen` to
`AlgebraicJacobian.lean` alongside the other `AlgebraicJacobian.Cohomology.*` imports.

## Changes Made

### File: AlgebraicJacobian.lean
- **What:** Inserted `import AlgebraicJacobian.Cohomology.QcohRestrictBasicOpen` between
  `AffineSerreVanishing` and `QcohTildeSections` (alphabetical order within the Q-prefix group).
- **Why:** File is load-bearing for Route B keystone bridge (B3/B4) and must be included in the
  project build.
- **Cascading:** None — purely additive import, no existing declarations changed.

## New Sorries Introduced
None.

## Compilation Status
- `AlgebraicJacobian.lean`: compiles — EXIT 0, `Built AlgebraicJacobian (3.4s)` (job 8331/8332)
- `AlgebraicJacobian.Cohomology.QcohRestrictBasicOpen`: compiles — `Built … (1.9s)` (job 8330/8332)
- All 8332 jobs succeeded. Pre-existing style warnings in `AffineSerreVanishing.lean` are unchanged.

## Declarations deleted / renamed
None.

## Notes for Plan Agent
- No complications. The import was a clean addition.
- The pre-existing style-linter warnings in `AffineSerreVanishing.lean` (`maxHeartbeats` comment
  missing, long lines, `show` vs `change`) are unchanged from prior iters — no action needed.
