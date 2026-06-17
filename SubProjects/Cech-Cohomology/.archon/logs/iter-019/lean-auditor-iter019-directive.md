# Lean Auditor Directive

## Slug
iter019

## Scope (files)
all (every `.lean` file under `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/`)

## Focus areas
Pay extra attention to the three files edited this iteration:
- `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechAcyclic.lean`
- `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechBridge.lean`
- `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/FreePresheafComplex.lean`

Audit the rest of the project too (no scope shortcuts).

## Known issues
- `CechAcyclic.lean` line ~109: a single `sorry` on `CechAcyclic.affine` (the old relative-form
  declaration, deliberately superseded — do not re-flag as a new defect, but DO confirm it is the
  only sorry in that file and note any stale comment around it).
- `CechHigherDirectImage.lean` line ~715: a single `sorry` on the frozen P5b assembly target
  (intentional, known).
- `spanIdx` in `CechAcyclic.lean` is a `private noncomputable def` (uses `Exists.choose`); the
  word "opaque" appears in its docstring — this is expected, not a defect.
- All new declarations were reported `#print axioms`-clean ({propext, Classical.choice, Quot.sound}).
  Verify rather than assume; flag any axiom or suspect body you actually find.
