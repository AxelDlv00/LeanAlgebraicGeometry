# Lean ↔ Blueprint Checker Directive

## Slug
cechacyclic

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechAcyclic.lean

## Blueprint chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Known issues
- This chapter is a consolidated chapter (`% archon:covers` lists
  CechHigherDirectImage.lean, CechAcyclic.lean, PresheafCech.lean). Restrict your
  audit to the blocks relevant to CechAcyclic.lean (the Čech-acyclicity-of-the-
  standard-cover material, label `lem:cech_acyclic_affine` and its dependencies).
- The 9 new declarations in namespace `AlgebraicGeometry.CombinatorialCech` are
  `private` helpers with NO blueprint block yet — this is known coverage debt
  already slated for the planner. Report whether they SHOULD be bundled into an
  existing block's `\lean{...}` list, but do not treat their absence as a Lean
  error.
- `CechAcyclic.affine` (L74) is a known open `sorry`.
