# Lean Auditor Directive

## Slug
review138

## Scope (files)
all .lean files under the project root (exclude `.lake/`, `lake-packages/`, and the `.archon/multilane/` snapshot lanes).

## Focus areas (optional)
- `AlgebraicJacobian/Cotangent/GrpObj.lean` — this received the iter-138
  prover lane and now contains a new `noncomputable def
  basechange_along_proj_two_inv_derivation` (around line 547) plus a
  new `basechange_along_proj_two_inv` (around line 596). Two new
  internal `sorry`s in `_derivation` (sub-goals `d_app`, `d_map`) plus
  a `letI : IsIso ... := sorry` inside
  `relativeDifferentialsPresheaf_basechange_along_proj_two`. The file
  also carries large iter-138 docstring updates (esp. ~L468–L515).
  Pay extra attention to excuse-comment patterns ("Iter-139+ target")
  attached to the new sorry sites, and to whether the structural
  decomposition is honestly described or papered over.

## Known issues
- Carry-over stale line anchors at L61/L107/L146/L155/L160 in
  `Cotangent/GrpObj.lean` — already flagged in iter-135/137 reviews
  as MED-C; iter-138 PARTIAL deferred the cleanup intentionally.
- Stale forward-references in cohomology docstrings (iter-137 carry-over).
- Line-length warnings on protected signature lines in `Jacobian.lean`
  (do not reformat).
