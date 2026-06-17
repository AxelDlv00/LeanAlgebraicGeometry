# Lean Auditor Directive

## Slug
iter015

## Scope (files)
all

## Focus areas (optional)
Pay extra attention to the two files that received new code this iter:
- `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechAcyclic.lean`
  (new `private` namespace `AlgebraicGeometry.CombinatorialCech`: 9 declarations
  added; the pre-existing `CechAcyclic.affine` still carries a `sorry` at L74 with
  a large explanatory comment block above it — judge whether that comment is an
  honest scope note or an excuse-comment).
- `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/PresheafCech.lean`
  (2 new declarations: `injective_toPresheafOfModules`, `freeYonedaHomEquiv`).

Still cover every other `.lean` file in the project per your descriptor.

## Known issues
- `CechAcyclic.affine` (CechAcyclic.lean:74) is a known open `sorry` blocked on a
  large categorical bridge — report it, but it is already tracked, no need to
  belabour the blocker rationale.
- `CechHigherDirectImage.lean` carries one frozen/protected `sorry` (~line 771).
