# Refactor Report

## Slug
cleanup

## Status
COMPLETE

## Directive
Two mechanical, non-proof changes: wire the orphaned P5a file into the root barrel, and
remove/correct four actively-misleading stale comments. No proof bodies touched, no sorry
introduced.

## Changes Made

### File: `AlgebraicJacobian.lean`
- **What:** Added `import AlgebraicJacobian.Cohomology.HigherDirectImagePresheaf` alphabetically
  between `HigherDirectImage` and `CechHigherDirectImage`.
- **Why:** The file was outside the project build graph; now included.
- **Cascading:** None — the file was already axiom-clean standalone.

### File: `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`
- **What:** Deleted the 40-line `/-! ### Status (iter-006) -/` block (lines 924–964) which
  falsely claimed `rightDerivedIsoOfAcyclicResolution` was unproved. Replaced with a
  one-line `/-! ### P4 complete … -/` note.
- **Why:** The declaration is fully proved at lines 893–922 immediately above.
- **Cascading:** None.

### File: `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean` (comment 1, ~lines 161–183)
- **What:** Rewrote the `pushPullMap_id / pushPullMap_comp` functor-laws comment to state
  both laws are proved axiom-clean and that `pushPullFunctor` is assembled from them.
  Removed the sentence describing `pushPullMap_comp` as "remaining".
- **Why:** `pushPullMap_comp` is proved at line 627 and `pushPullFunctor` assembled at line 640.
- **Cascading:** None (comment only).

### File: `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean` (comment 2, ~lines 245–293)
- **What:** Deleted the entire 49-line block titled "Composition law `pushPullMap_comp` —
  remaining" (the most misleading comment in the project).
- **Why:** `pushPullMap_comp` is closed via `rawPushPullMap_comp` at line 627.
- **Cascading:** None (comment only).

### File: `AlgebraicJacobian/Cohomology/PresheafCech.lean`
- **What:** Replaced the module docstring with an accurate description of what the file
  actually contains (`sectionCechComplex`, `freeYonedaHomEquiv`, `freeYonedaHomAddEquiv`,
  `injective_toPresheafOfModules`) and added pointers to `FreePresheafComplex.lean` and
  `CechBridge.lean` for the moved declarations.
- **Why:** Four of the five listed declarations had moved to sibling files.
- **Cascading:** None (comment only).

## New Sorries Introduced
None.

## Compilation Status
- `AlgebraicJacobian.lean`: compiles (8326 jobs, no errors)
- `AlgebraicJacobian/Cohomology/HigherDirectImagePresheaf.lean`: compiles (newly reachable)
- `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`: compiles
- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`: compiles (pre-existing sorry at line 708, pre-existing style warnings)
- `AlgebraicJacobian/Cohomology/PresheafCech.lean`: compiles
- All other files: no change, build green.

## Declarations deleted / renamed
None — only comment text and one import line were modified.

## Notes for Plan Agent
- All pre-existing warnings (long lines, maxHeartbeats, `show` tactic, sorry in CechAcyclic/CechHigherDirectImage) are unchanged from before this refactor.
- `HigherDirectImagePresheaf.lean` is now in the main build graph; its sorry count is now visible to `sync_leanok`.
