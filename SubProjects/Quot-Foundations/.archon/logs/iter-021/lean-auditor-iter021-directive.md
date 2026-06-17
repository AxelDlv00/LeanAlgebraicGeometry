# Lean Auditor Directive

## Slug
iter021

## Scope (files)
all

## Focus areas (optional)
Files changed this iter — audit the whole project but pay extra attention to:
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (a deep categorical proof
  `base_change_mate_gstar_transpose` was left PARTIAL with a `sorry`; check the
  surrounding comments are not excuse-comments and the route description matches
  the code).
- `AlgebraicJacobian/Picard/FlatteningStratification.lean` (a large local proof,
  the L4 finiteness leaf, was just closed; check for stale comments and a
  documented `sorry` on the `genericFlatnessAlgebraic` B/𝔭 cascade).
- `AlgebraicJacobian/Picard/QuotScheme.lean` and
  `AlgebraicJacobian/Picard/GradedHilbertSerre.lean` — these were created/shrunk by
  a file-split refactor this iter; check for stale comments referencing the old
  single-file layout, dangling references, or duplicated declarations.

## Known issues
- 4 `sorry`s in FlatBaseChange.lean (gstar_transpose @~1551 partial-with-route;
  dead-code `fstar_reindex_legs` @1421; affine @1724; FBC-B @1746) are known
  scaffolding — report them but they are not new.
- 4 `sorry`s in QuotScheme.lean (@126/165/201/228) are deliberate protected
  file-skeleton stubs gated on upstream predicate builds.
- 2 `sorry`s in FlatteningStratification.lean (B/𝔭 cascade, GF-geo) are known
  honest residues.

## Project paths (absolute)
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/
