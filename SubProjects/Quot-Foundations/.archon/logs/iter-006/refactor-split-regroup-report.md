# Refactor Report

## Slug
split-regroup

## Status
COMPLETE

## Directive

### Problem
`base_change_mate_regroupEquiv` in `FlatBaseChange.lean` carries a `sorry` in its `map_smul'`
field due to a `Module A (A ⊗[R] R')` instance diamond that prevents in-file elaboration. The
helper `base_change_regroup_linearEquiv` (the proved `comm ≪≫ cancelBaseChange ≪≫ comm` core)
must live in a separately compiled module so the diamond normalises at the import boundary,
enabling the one-liner `exact LinearEquiv.toModuleIso (base_change_regroup_linearEquiv ↑M)`.

### Changes Requested
- Create `AlgebraicJacobian/Cohomology/RegroupHelper.lean` containing
  `base_change_regroup_linearEquiv` (verbatim move from FlatBaseChange.lean).
- Add `import AlgebraicJacobian.Cohomology.RegroupHelper` to FlatBaseChange.lean.
- Remove `base_change_regroup_linearEquiv` from FlatBaseChange.lean.
- Leave all 4 existing sorries untouched.

## Changes Made

### File: `AlgebraicJacobian/Cohomology/RegroupHelper.lean` (NEW)
- **What:** Created new file containing the `base_change_regroup_linearEquiv` definition verbatim,
  together with its section header comment and docstring. Header:
  `import Mathlib` / `set_option autoImplicit false` / `universe u` / `open scoped TensorProduct`
  / `namespace AlgebraicGeometry` / definition / `end AlgebraicGeometry`.
- **Why:** Separate compilation unit normalises the `Module A (A ⊗[R] R')` instance diamond,
  unblocking the prover's one-liner closure of `base_change_mate_regroupEquiv.map_smul'`.
- **Cascading:** None — this file imports only Mathlib.

### File: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- **What (import added):** Added `import AlgebraicJacobian.Cohomology.RegroupHelper` on line 7,
  immediately after `import Mathlib`.
- **What (definition removed):** Removed the section comment, docstring, and definition of
  `base_change_regroup_linearEquiv` (formerly lines 822–886). The name continues to resolve via the
  new import; no callsite in the file was changed.
- **Why:** The definition is now in RegroupHelper.lean; the import provides the name to all
  downstream consumers in this file.
- **Cascading:** No cascading breakage. `base_change_mate_regroupEquiv` references
  `base_change_regroup_linearEquiv` unchanged and resolves through the import.

## New Sorries Introduced
None.

## Compilation Status
- `AlgebraicJacobian/Cohomology/RegroupHelper.lean`: compiles — zero errors, zero warnings.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`: compiles — zero errors; exactly 4 sorry
  warnings (lines 853, 931, 1045, 1085), identical to the pre-refactor sorry set.
- Full project build: success (8323/8323 jobs, `lake build`).

## Declarations deleted / renamed
- `AlgebraicGeometry.base_change_regroup_linearEquiv` moved from
  `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` to
  `AlgebraicJacobian/Cohomology/RegroupHelper.lean` (name and signature unchanged).

## Notes for Plan Agent
- The move is behaviour-preserving: the fully-qualified name
  `AlgebraicGeometry.base_change_regroup_linearEquiv` is unchanged.
- The blueprint chapter `Cohomology_RegroupHelper.tex` already exists (created by the plan agent
  in iter-006); no blueprint update is needed from this refactor.
- The prover can now close `base_change_mate_regroupEquiv.map_smul'` (line 912 of the updated
  FlatBaseChange.lean, i.e. the `sorry` at line 853 in the build output) with the one-liner
  `exact LinearEquiv.toModuleIso (base_change_regroup_linearEquiv ↑M)`.
- No unexpected local dependencies were found. `base_change_regroup_linearEquiv` depends only on
  Mathlib; no other project-local declaration needed to move.
