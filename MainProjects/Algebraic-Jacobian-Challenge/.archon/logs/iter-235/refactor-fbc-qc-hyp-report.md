# Refactor Report

## Slug
fbc-qc-hyp

## Status
COMPLETE

## Directive
**Problem:** `affineBaseChange_pushforward_iso` and `flatBaseChange_pushforward_isIso` were
typed for an ARBITRARY `F : X.Modules`, but Stacks 02KH requires `F` quasi-coherent — over an
affine open a general `F` is not `tilde M`, so the affine tilde-dictionary / `cancelBaseChange`
argument cannot apply.

**Changes Requested:** Add `[F.IsQuasicoherent]` immediately after `(F : X.Modules)` in both
theorem signatures, keeping bodies and all other binders verbatim.

## Changes Made

### File: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- **What:** Added `[F.IsQuasicoherent]` after `(F : X.Modules)` in `affineBaseChange_pushforward_iso` (line 214) and `flatBaseChange_pushforward_isIso` (line 247).
- **Why:** Soundness fix — both theorems are false for general `F`; quasi-coherence is the hypothesis required by Stacks 02KH.
- **Cascading:** No downstream consumers found (project-wide grep confirmed); no cascade edits needed.

## New Sorries Introduced
None. The two pre-existing sorries remain; no new sorry sites were added.

## Compilation Status
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`: **compiles cleanly** — exactly 2 `warning: declaration uses 'sorry'` (lines 213 and 246), no errors.

## Notes for Plan Agent
- `[F.IsQuasicoherent]` elaborated without requiring any additional `variable` or import changes; `SheafOfModules.IsQuasicoherent` is already available via `import Mathlib`.
- `pushforwardBaseChangeMap` (the map definition) was correctly left untouched — the map is well-defined for all `F`.
- The 3 locality lemmas were not touched.
- Axiom count is unchanged (still 2 sorries, same files).
