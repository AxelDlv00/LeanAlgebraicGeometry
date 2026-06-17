# Refactor Directive

## Slug
split-capstone

## Problem
`AlgebraicJacobian/Cohomology/CechToHigherDirectImage.lean` holds 5 `sorry` lemmas forming the
Route-A capstone. One (`cechTerm_pushforward_acyclic`) is a DEEP geometric argument; the other four
are moderate seams/assembly. They are currently in one file, forcing a single serial prover lane.
The user's standing directive mandates parallelism via file splitting. Split the deep acyclicity
chain into its own module so two provers can work in parallel.

## Mathematical justification
`rightAcyclic_finite_prod` and `cechTerm_pushforward_acyclic` are self-contained (the latter uses
only `cechComplexOnX`, `pushPull_sigma_iso`, the open-immersion pushforward lemmas, and
`affine_serre_vanishing` — NONE of which is `CechAugmentedResolution`). The remaining three
(`pushforward_mapHomologicalComplex_cechComplexOnX`, `cechAugmented_to_acyclicResolutionInput`,
`cech_computes_higherDirectImage_of_affineCover`) depend on `cechAugmented_exact` and/or on
`cechTerm_pushforward_acyclic` as a black-box (typed) hypothesis. So the dependency edge is
one-directional: assembly file imports the acyclicity file.

## Changes requested
1. CREATE new file `AlgebraicJacobian/Cohomology/CechTermAcyclic.lean`:
   - Move VERBATIM (declaration + its `/- Planner strategy: … -/` doc block + `/-- … -/` docstring,
     bodies kept as `sorry`) these two decls from `CechToHigherDirectImage.lean`:
       - `rightAcyclic_finite_prod`
       - `cechTerm_pushforward_acyclic`
   - **Imports — correct by construction (do NOT minimize):** give the new file the SAME import block
     as the current `CechToHigherDirectImage.lean`, i.e.
       `import Mathlib`
       `import AlgebraicJacobian.Cohomology.CechAugmentedResolution`
       `import AlgebraicJacobian.Cohomology.OpenImmersionPushforward`
       `import AlgebraicJacobian.Cohomology.AcyclicResolution`
     The two moved decls currently compile in `CechToHigherDirectImage.lean` under exactly these
     imports, so moving them verbatim into a new file with the SAME imports is correct by construction
     (no import is dropped; no cycle is created since none of those four imports the new file). This is
     deliberate — do not try to trim `CechAugmentedResolution` to make the file lighter; the
     correctness guarantee matters more than build-weight this iter.
   - Preserve `universe u`, `open CategoryTheory Limits`, `namespace AlgebraicGeometry`,
     `open Scheme.Modules`, and `variable {X S : Scheme.{u}}` exactly as in the source file.
   - Keep the Apache/Authors header and a `/-! # … -/` module docstring (one-line purpose).
2. EDIT `AlgebraicJacobian/Cohomology/CechToHigherDirectImage.lean`:
   - REMOVE the two moved decls (and their doc blocks).
   - ADD `import AlgebraicJacobian.Cohomology.CechTermAcyclic` to the import block.
   - Keep the other three decls and the file's header/namespace boilerplate unchanged.
3. Register `CechTermAcyclic.lean` in the project root aggregator if one exists
   (`AlgebraicJacobian.lean` / `AlgebraicJacobian/Cohomology.lean`) the same way sibling
   `Cohomology/*.lean` files are registered.

## Affected files
- `AlgebraicJacobian/Cohomology/CechToHigherDirectImage.lean` (loses 2 decls, gains 1 import)
- `AlgebraicJacobian/Cohomology/CechTermAcyclic.lean` (new)
- the aggregator module (add the import line)

## Expected outcome
Both files compile under `lake build` with exactly the same total sorry set (2 in CechTermAcyclic,
3 in CechToHigherDirectImage). No proof is filled, no signature changed. No protected declaration is
touched (none of these five is protected).

## Constraints
- Do NOT fill any `sorry`. Do NOT alter any of the 5 signatures.
- **Build-wall NOTE:** a full cold `lake build` of this chain exceeds ~25 min (CSI Leg +
  CechAugmentedResolution are pathologically heavy) and will likely NOT complete in your budget. The
  split is correct by construction (superset imports, no cycle), so you do NOT need a green full build
  to report success. Do a cheap sanity check instead: confirm both files parse and the import lines are
  present/well-formed (e.g. `lake env lean --only-export` is NOT required; a syntactic check or a short
  `lake build` that you abort if it's still in deps after a few minutes is fine). Report the split as
  landed, and explicitly note the full build was deferred to the prover lanes due to the build-wall.
  Do NOT spend your whole budget waiting on a cold build.
