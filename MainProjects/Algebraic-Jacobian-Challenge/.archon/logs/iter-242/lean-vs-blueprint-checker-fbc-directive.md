# Lean ↔ Blueprint Checker Directive

## Slug
fbc

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/FlatBaseChange.lean

## Blueprint chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Known issues
- `affineBaseChange_pushforward_iso` and `flatBaseChange_pushforward_isIso` are known to remain `sorry`
  this iter (documented partials); do not re-classify their open status as a placeholder red flag, but DO
  verify the surrounding documentation is accurate and check whether the chapter's proof sketch for
  `affineBaseChange_pushforward_iso` adequately previews the two named obligations (affine reduction +
  adjoint-mate ↔ `cancelBaseChange`).
- This iter newly LANDED `AlgebraicGeometry.pullback_spec_tilde_iso` (pinned to `lem:pullback_spec_tilde_iso`,
  Stacks 01I9 part 1) and the supporting `gammaPushforwardNatIso`. Verify the signature of
  `pullback_spec_tilde_iso` matches the chapter's informal statement.
