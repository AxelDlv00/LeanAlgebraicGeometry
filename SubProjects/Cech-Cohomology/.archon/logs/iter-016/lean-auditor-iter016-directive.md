# Lean Auditor Directive

## Slug
iter016

## Scope (files)
all

## Focus areas (optional)
Pay extra attention to the three files that received heavy new code this iter:
- `AlgebraicJacobian/Cohomology/CechAcyclic.lean` (new `CombinatorialCech.Dependent.*` section)
- `AlgebraicJacobian/Cohomology/PresheafCech.lean` (new section-Čech + free-Yoneda decls)
- `AlgebraicJacobian/Cohomology/FreePresheafComplex.lean` (new `cechFreeSimplicial` / `cechFreePresheafComplex`)

Absolute project root: `/home/archon/proj/Cech-Cohomology`

## Known issues
- `AlgebraicJacobian/Cohomology/CechAcyclic.lean` has ONE known `sorry` (the top-level
  `CechAcyclic.affine`, line ~109) with an honest scope comment describing the L1 blocker.
  Report it but it is a known, intentional pin — not a surprise.
- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean` has ONE known frozen `sorry`
  (`cech_computes_higherDirectImage`, line ~771).
- The blueprint/strategy framing is intentionally omitted per your descriptor.
