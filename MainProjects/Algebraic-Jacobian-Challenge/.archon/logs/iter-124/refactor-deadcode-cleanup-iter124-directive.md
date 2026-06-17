# Refactor Directive

## Slug
deadcode-cleanup-iter124

## Problem

The iter-123 `lean-auditor-review123` returned 4 must-fix items.
This directive addresses items #1 and #3 (orthogonal to the iter-124
M1.b prover lane on `Differentials.lean`).  Items #2 and #4 are
discretionary and not in scope here.

### Item #1 — `Cohomology/StructureSheafModuleK.lean:458–519`: dead class + 3 consumers

The class `IsAffineHModuleHomFinite` (declared at L458–466) is
explicitly author-disclosed as "dead scaffolding" in the file's own
docstring at L518–543: it admits no producer instance on a
non-trivial proper curve (cited counterexample on ℙ¹). The class
plus three downstream consumers carry an unsatisfiable hypothesis
through typeclass search:

- `IsAffineHModuleHomFinite` (class, L458–466)
- `module_finite_HModule'_zero_of_isAffineHModuleHomFinite` (theorem, L476–487)
- `module_finite_HModule'_of_affine` (theorem, L497–507)
- `module_finite_HModule'_of_affine_curve` (theorem, L512–519)

All four declarations should be deleted.  The file-header status
block at L17–35 should also be updated to note that the H>0 affine
carrier (iter-040 `IsAffineHModuleVanishing`) is the only surviving
affine route, while H⁰ goes through the wholespace
`IsHModuleHomFinite` (iter-043) per the iter-046 producer instance.

### Item #3 — `Genus.lean:39–61`: stale commented-out sketch

A large commented-out "OXAsAddCommGrpSheaf / H1OC" sketch sits at
`Genus.lean:39–61` describing an obsoleted route (Phase A
formulation) that the project did not take. Phase A is closed
(`Cohomology/StructureSheafAb.lean` status "closed iteration 004")
and the actual `genus` body (L65–68) uses the working
`Scheme.HModule` machinery.

Additionally, the L15–29 status block is titled "Status (iteration
011 — `genus` closure scheduled)" but the closure has landed; the
"scheduled" framing is stale.

Both fixes:

- Delete the L39–61 commented sketch block entirely.
- Retitle the L15–29 status block to past-tense ("Status (closed
  iteration 011 — `genus`)" or equivalent) and trim any prose that
  framed the closure as forthcoming.

## Mathematical Justification

Both changes are pure code-quality cleanups; no mathematical
content changes.

- For Item #1: the dead class blocks typeclass search and the
  author has explicitly documented it as unreachable. Removing
  the class + its 3 consumers strictly reduces the import surface
  and prevents accidental future re-use of an unsatisfiable
  hypothesis. No downstream files depend on these declarations
  (the consumers themselves are dead-end, parametrised by the
  unsatisfiable class).
- For Item #3: the commented-out sketch is a historical artifact
  from an abandoned route; the stale status block misrepresents
  the file's current state. Neither carries Lean-level dependencies.

## Changes Requested

- **File**: `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`
  - **Action**: Delete the four declarations at L458–466 (class),
    L476–487 (theorem 1), L497–507 (theorem 2), L512–519 (theorem 3).
  - **Action**: Update the L17–35 file-header status block to
    reflect that:
    - The H>0 affine carrier route is via `IsAffineHModuleVanishing`
      (iter-040).
    - The H⁰ route is via the wholespace `IsHModuleHomFinite` (iter-043)
      + the iter-046 producer instance.
    - The iter-041 `IsAffineHModuleHomFinite` class was an
      abandoned attempt (dead scaffolding); the file no longer
      contains it.

- **File**: `AlgebraicJacobian/Genus.lean`
  - **Action**: Delete the commented-out sketch block at L39–61
    (the "## Sketch of the route once Phase A is available"
    `OXAsAddCommGrpSheaf`/`H1OC` block).
  - **Action**: Retitle the L15–29 status block from "Status
    (iteration 011 — `genus` closure scheduled)" to past-tense
    ("Status (closed iteration 011 — `genus`)" or a phrasing
    that accurately describes the current state). Trim any prose
    that framed the closure as scheduled/future.

## Affected Files

- Direct: `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`,
  `AlgebraicJacobian/Genus.lean`.
- Cascading breakage: **none expected**. The deleted declarations
  in `StructureSheafModuleK.lean` are dead — their only consumers
  are each other (Item #1 deletes the chain entirely). Grep for
  `IsAffineHModuleHomFinite`, `module_finite_HModule'_zero_of_isAffineHModuleHomFinite`,
  `module_finite_HModule'_of_affine`, `module_finite_HModule'_of_affine_curve`
  in `AlgebraicJacobian/**` to confirm before deleting.

Run `lake build AlgebraicJacobian.Cohomology.StructureSheafModuleK`
and `lake build AlgebraicJacobian.Genus` after each file's edits;
both should succeed without new sorries or warnings.

## Expected Outcome

- Project sorry count: unchanged at 2.
- `StructureSheafModuleK.lean`: ~50 LOC reduction (4 declarations
  removed + status block tightened).
- `Genus.lean`: ~25 LOC reduction (sketch block deleted + status
  block tightened).
- No new sorries, no new axioms, no protected-signature changes.

## Out of scope

- Items #2 (unused fields on `AffineCoverMVSquare` in
  `MayerVietorisCover.lean`) and #4 (`erw [hmc]` in `Differentials.lean:239`)
  are discretionary and NOT covered by this directive. Item #4 is
  inside the iter-122-closed proof body of
  `isUnit_appLE_unitSubmonoid_in_colim` and would touch already-closed
  code; defer until a subsequent iter unless explicitly re-scoped.
- This refactor MUST NOT touch `AlgebraicJacobian/Differentials.lean`
  (iter-124 prover lane is active there) or any other file outside
  the two named above.
