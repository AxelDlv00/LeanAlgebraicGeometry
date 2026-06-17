# Lean ↔ Blueprint Checker Directive

## Slug
cechacyclic

## Lean file
AlgebraicJacobian/Cohomology/CechAcyclic.lean

## Blueprint chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

(This is a consolidated chapter — it `% archon:covers` several files. The block
relevant to this Lean file is `lem:cech_acyclic_affine` at label `\label{lem:cech_acyclic_affine}`.
Focus your check on that block and its `\lean{...}` bundle.)

## Known issues
- The top-level `CechAcyclic.affine` carries one intentional `sorry` (L1 categorical→module
  bridge blocker), with an honest scope comment. Known pin — verify the comment is honest, but
  it is not a surprise placeholder.
- This iter added a `CombinatorialCech.Dependent.*` private helper section (dependent-coefficient
  port of the combinatorial Čech homotopy). These helpers are not yet individually blueprinted
  (coverage debt already tracked); your job is to assess whether the chapter prose for
  `lem:cech_acyclic_affine` is adequate to guide the formalization, and whether the Lean matches it.
