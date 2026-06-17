# Refactor Report

## Slug
scaffold-grcells

## Status
COMPLETE

## Directive
**Problem:** Create `AlgebraicJacobian/Picard/GrassmannianCells.lean` with a `sorry`-bodied stub
for `AlgebraicGeometry.Grassmannian.affineChart` and wire it into `AlgebraicJacobian.lean`.

**Changes:**
- Create `AlgebraicJacobian/Picard/GrassmannianCells.lean`
- Add `import AlgebraicJacobian.Picard.GrassmannianCells` to `AlgebraicJacobian.lean`

## Changes Made

### File: `AlgebraicJacobian/Picard/GrassmannianCells.lean` (NEW)
- **What:** Created new file with standard copyright header, `import Mathlib`,
  `set_option autoImplicit false`, `universe u`, `namespace AlgebraicGeometry.Grassmannian`,
  module docstring, blueprint pointer comment, planner note, docstring for the declaration,
  and the stub:
  ```
  noncomputable def affineChart (d r : ℕ) (I : Finset (Fin r)) : Scheme := sorry
  ```
  followed by `end AlgebraicGeometry.Grassmannian`.
- **Why:** Blueprint `def:gr_affine_chart` requires a file-level scaffold so the prover can fill
  the construction in a subsequent iteration.
- **Cascading:** None — this is a new standalone file.

### File: `AlgebraicJacobian.lean`
- **What:** Added `import AlgebraicJacobian.Picard.GrassmannianCells` immediately after
  `import AlgebraicJacobian.Picard.QuotScheme`.
- **Why:** Root aggregator must import every module in the project.
- **Cascading:** None.

## New Sorries Introduced
- `AlgebraicJacobian/Picard/GrassmannianCells.lean:60` — `affineChart` body (`sorry`);
  prover fills with `Spec (CommRingCat.of (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ))`.

## Compilation Status
- `AlgebraicJacobian/Picard/GrassmannianCells.lean`: compiles (1 sorry warning, no errors)
- `AlgebraicJacobian.lean`: compiles
- All 8324 jobs succeeded (`Build completed successfully (8324 jobs)`)

## Sorry count delta
+1 (only `affineChart` body)

## Declaration fully-qualified name
`AlgebraicGeometry.Grassmannian.affineChart` — matches blueprint `\lean{}` pin exactly.

## Declarations deleted / renamed
None.

## Notes for Plan Agent
- The argument list `(d r : ℕ) (I : Finset (Fin r))` was kept minimal and faithful to the
  blueprint. No `h : I.card = d` hypothesis was added (the blueprint does not state it as a
  precondition on the chart's existence — cardinality is used in the construction but need not
  be a parameter guard on the type).
- The planner note embedded in the file gives the prover the concrete target:
  `Spec (CommRingCat.of (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ))`.
