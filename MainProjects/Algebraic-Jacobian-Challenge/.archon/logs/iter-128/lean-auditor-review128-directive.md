# Lean Auditor Directive

## Slug
review128

## Scope (files)
all

## Focus areas (optional)

- `AlgebraicJacobian/Cotangent/GrpObj.lean` — NEW file this iter (iter-128 prover lane closed the `lieAlgebra` body). Audit Lean quality, docstring/comment accuracy, signature shape, body construction sanity (`extendScalars` of `relativeDifferentialsPresheaf` at top open along `η_G.appTop ≫ ΓSpecIso.hom`).
- `AlgebraicJacobian/Jacobian.lean` — carries 2 sorries (lines 178 and 197). Both currently off the active prover lane; audit comments/header for staleness or excuse-comments.
- `AlgebraicJacobian/RigidityKbar.lean` — carries 1 sorry (line 87). Audit comments and header for staleness.
- `AlgebraicJacobian/Differentials.lean` — heavy reduction earlier this Archon run (iter-126 excise); audit for residual stale comments and dead helpers.

## Known issues
- Iter-127 `lean-auditor-iter127` already flagged `Jacobian.lean:118` `geometricallyIrreducible_id_Spec` as unused with stale docstring, and `Jacobian.lean:86` `IsAlbanese.unique` docstring overselling unique-iso vs unique-morphism. Do not re-report unless severity has changed.
- Iter-126 `lean-auditor-iter126` reported `Cohomology/StructureSheafModuleK.lean:17–35` "Phase A step 5" stale file header. Do not re-report unless severity has changed.
- No `archon-protected.yaml` signatures changed this iter (still 9 protected declarations).
- `Cotangent/GrpObj.lean:84` contains the comment `This compiles to a ModuleCat k with no sorry.` inside the docstring — this is an *accurate* status note documenting the iter-128 close, NOT an excuse-comment. Do not flag.
