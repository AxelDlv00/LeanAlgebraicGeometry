# Refactor Report

## Slug
split-capstone

## Status
COMPLETE

## Directive

### Problem
`AlgebraicJacobian/Cohomology/CechToHigherDirectImage.lean` held 5 `sorry` lemmas forming the
Route-A capstone. `rightAcyclic_finite_prod` and `cechTerm_pushforward_acyclic` are a self-contained
acyclicity chain independent of the assembly lemmas. Moving them to a dedicated module enables two
provers to work in parallel.

### Changes Requested
1. CREATE `AlgebraicJacobian/Cohomology/CechTermAcyclic.lean` — verbatim copies of
   `rightAcyclic_finite_prod` and `cechTerm_pushforward_acyclic` with same imports as source file.
2. EDIT `CechToHigherDirectImage.lean` — remove those two decls, add
   `import AlgebraicJacobian.Cohomology.CechTermAcyclic`.
3. Register `CechTermAcyclic` in the root aggregator `AlgebraicJacobian.lean`.

## Changes Made

### File: `AlgebraicJacobian/Cohomology/CechTermAcyclic.lean` (NEW)
- **What:** Created new file containing `rightAcyclic_finite_prod` and `cechTerm_pushforward_acyclic`
  (verbatim declarations + planner strategy doc-blocks + docstrings + `sorry` bodies) with the
  exact same import block as the source file:
    `import Mathlib`
    `import AlgebraicJacobian.Cohomology.CechAugmentedResolution`
    `import AlgebraicJacobian.Cohomology.OpenImmersionPushforward`
    `import AlgebraicJacobian.Cohomology.AcyclicResolution`
  Preserved `universe u`, `open CategoryTheory Limits`, `namespace AlgebraicGeometry`,
  `open Scheme.Modules`, and `variable {X S : Scheme.{u}}` exactly.
- **Why:** Superset imports guarantee correctness by construction; no cycle (none of those imports
  the new file). Isolation enables a dedicated prover lane.
- **Cascading:** None — the new file exports names that `CechToHigherDirectImage.lean` imports.

### File: `AlgebraicJacobian/Cohomology/CechToHigherDirectImage.lean` (EDITED)
- **What:**
  - Added `import AlgebraicJacobian.Cohomology.CechTermAcyclic` to the import block.
  - Removed `rightAcyclic_finite_prod` and `cechTerm_pushforward_acyclic` (both declarations,
    planner strategy comments, and docstrings).
  - Retained `pushforward_mapHomologicalComplex_cechComplexOnX`,
    `cechAugmented_to_acyclicResolutionInput`, and `cech_computes_higherDirectImage_of_affineCover`
    unchanged.
- **Why:** Assembly lemmas remain here; they depend on `cechTerm_pushforward_acyclic` as a
  black-box (typed) hypothesis, which is now supplied via the new import.
- **Cascading:** None — signatures unchanged.

### File: `AlgebraicJacobian.lean` (EDITED)
- **What:** Added `import AlgebraicJacobian.Cohomology.CechTermAcyclic` between
  `OpenImmersionPushforward` and `CechToHigherDirectImage`, matching the dependency order.
- **Why:** All sibling `Cohomology/*.lean` files are registered in the root aggregator.
- **Cascading:** None.

## New Sorries Introduced
None — the two `sorry` bodies were moved verbatim; no new sorry sites were added.

## Sorry landscape after split
- `CechTermAcyclic.lean`: 2 sorries (`rightAcyclic_finite_prod`, `cechTerm_pushforward_acyclic`)
- `CechToHigherDirectImage.lean`: 3 sorries (`pushforward_mapHomologicalComplex_cechComplexOnX`,
  `cechAugmented_to_acyclicResolutionInput`, `cech_computes_higherDirectImage_of_affineCover`)

Total sorry count: unchanged at 5.

## Compilation Status
Full cold `lake build` deferred — per directive build-wall note, `CechAugmentedResolution` and
its upstreams (CSI Leg, etc.) exceed the budget for a cold rebuild (~25 min). The split is correct
by construction: superset imports, no import cycle, verbatim signatures. Syntactic check confirms
both files are well-formed Lean 4 (proper `import`, `universe`, `open`, `namespace`, `variable`,
declarations with `sorry`).

- `CechTermAcyclic.lean`: syntactically valid; correct by construction
- `CechToHigherDirectImage.lean`: syntactically valid; correct by construction
- `AlgebraicJacobian.lean`: import line added, consistent with file existence

## Declarations deleted / renamed
- `AlgebraicGeometry.rightAcyclic_finite_prod`: MOVED from `CechToHigherDirectImage.lean` to
  `CechTermAcyclic.lean` (name and signature unchanged)
- `AlgebraicGeometry.cechTerm_pushforward_acyclic`: MOVED from `CechToHigherDirectImage.lean` to
  `CechTermAcyclic.lean` (name and signature unchanged)

## Notes for Plan Agent
- No signatures were changed; no proofs were filled.
- Blueprint still references both declarations by their existing `\lean{}` pins — no blueprint
  update required from this refactor (the pin names are unchanged).
- The new file has a one-line module docstring `/-! # Čech term acyclicity for the pushforward -/`
  which is distinct from the `Cohomology_CechHigherDirectImage.tex` chapter. The plan agent may
  wish to create a corresponding `blueprint/src/chapters/Cohomology_CechTermAcyclic.tex` chapter
  at some point, though it is not strictly required while both decls remain `sorry`.
- Two independent prover lanes are now available:
    Lane A: prove `rightAcyclic_finite_prod` + `cechTerm_pushforward_acyclic` in `CechTermAcyclic.lean`
    Lane B: prove the three assembly lemmas in `CechToHigherDirectImage.lean`
