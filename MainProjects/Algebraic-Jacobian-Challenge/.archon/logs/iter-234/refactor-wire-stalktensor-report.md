# Refactor Report

## Slug
wire-stalktensor

## Status
COMPLETE

## Directive
**Problem:** `AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean` existed on disk but was
not imported by its aggregator, making its axiom-clean declarations invisible to downstream consumers.

**Changes requested:** Add `import AlgebraicJacobian.Picard.TensorObjSubstrate.StalkTensor` to
`AlgebraicJacobian/Picard/TensorObjSubstrate.lean`, adjacent to the other `TensorObjSubstrate.*`
sub-file imports.

## Changes Made

### File: AlgebraicJacobian/Picard/TensorObjSubstrate.lean
- **What:** Added `import AlgebraicJacobian.Picard.TensorObjSubstrate.StalkTensor` as the first
  `TensorObjSubstrate.*` import (line 6), before `Vestigial` and `PresheafInternalHom`.
- **Why:** Wire the new StalkTensor file into the dependency cone so its declarations are available
  to downstream consumers.
- **Cascading:** None. `StalkTensor.lean` imports only `Mathlib` — no project-side imports — so the
  addition is acyclic. No downstream files needed fixing.

## New Sorries Introduced
None.

## Compilation Status
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`: **compiles clean** — `Build completed
  successfully (8366 jobs)`.  All warnings (deprecation of `CategoryTheory.Sheaf.val`, unused
  variables, line-length) and the two `sorry` at lines 695 and 760
  (`exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`) are **pre-existing**.

## Notes for Plan Agent
- No issues encountered. The import addition is exactly one line; the build is green.
- `StalkTensor.lean` currently has 0 sorries (per directive); the aggregator now propagates those
  axiom-clean declarations to any file that imports `TensorObjSubstrate.lean`.
- The pre-existing `CategoryTheory.Sheaf.val` deprecation warnings in `TensorObjSubstrate.lean`
  (23 instances) are unrelated to this change; flagging in case a future iter wants to address them.
