# Lean Auditor Directive

## Slug
iter002

## Scope (files)
all

## Focus areas (optional)
`AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean` received heavy edits this iter
(push–pull functoriality stack + a new functor + a simplicial-nerve construction). Pay extra
attention to it, but audit every `.lean` file in the project.

## Known issues
- Two intentional, documented `sorry`s remain in `CechHigherDirectImage.lean`
  (`CechAcyclic.affine`, `cech_computes_higherDirectImage`) — these are out-of-scope blocked
  targets; report them in the checklist but do not treat them as excuse-comments.
- Style warnings (long lines >100 chars) are known and not of interest.
