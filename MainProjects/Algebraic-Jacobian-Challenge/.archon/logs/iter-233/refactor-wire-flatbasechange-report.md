# Refactor Report

## Slug
wire-flatbasechange

## Status
COMPLETE

## Directive
**Problem:** `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` existed and built standalone
but was not imported by the package aggregator `AlgebraicJacobian.lean`, making its
declarations invisible to the canonical build and its 2 sorries uncounted.

**Changes requested:** Add `import AlgebraicJacobian.Cohomology.FlatBaseChange` to
`AlgebraicJacobian.lean` in the Cohomology import group.

## Changes Made

### File: AlgebraicJacobian.lean
- **What:** Added `import AlgebraicJacobian.Cohomology.FlatBaseChange` as the first line
  of the Cohomology import block (alphabetically before `MayerVietorisCover`,
  `SheafCompose`, `StructureSheaf*`).
- **Why:** Wire the file into the canonical aggregator build so its declarations are
  visible project-wide and its sorries are counted.
- **Cascading:** None — pure import addition, no downstream type changes.

## New Sorries Introduced
None. The 2 existing sorries in `FlatBaseChange.lean` (lines 91 and 123) were already
present; they are now counted in the canonical build.

## Compilation Status
- `AlgebraicJacobian.lean`: **compiles** — `Build completed successfully (8365 jobs)`
  (exit 0). The two expected sorry warnings from `FlatBaseChange.lean` appear:
  - `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:91:8: declaration uses 'sorry'`
  - `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:123:8: declaration uses 'sorry'`
- Total sorry-warning count in canonical build: **83** (was 81 before wiring).

## Notes for Plan Agent
- The job count rose from ~8317 to 8365, consistent with `FlatBaseChange.lean` and its
  transitive imports being added to the graph.
- No other files required changes.
