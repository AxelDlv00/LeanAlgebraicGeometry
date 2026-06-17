# Lean Auditor Directive

## Slug
review117

## Scope (files)
all — every `.lean` file under `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/` plus the umbrella `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian.lean`.

The project was just trimmed aggressively this iter. Files no longer on disk:
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` (deleted)
- `AlgebraicJacobian/Modules/Monoidal.lean` (deleted)
- `AlgebraicJacobian/Picard/{LineBundle,Functor,FunctorAb}.lean` (deleted)

Surviving files:
- `AlgebraicJacobian.lean` (umbrella, 10 imports)
- `AlgebraicJacobian/AbelJacobi.lean`
- `AlgebraicJacobian/Differentials.lean` (post-trim 83 lines; previous ~1100 LOC)
- `AlgebraicJacobian/Genus.lean`
- `AlgebraicJacobian/Jacobian.lean`
- `AlgebraicJacobian/Rigidity.lean`
- `AlgebraicJacobian/Cohomology/{StructureSheafAb,StructureSheafModuleK,SheafCompose,MayerVietorisCore,MayerVietorisCover}.lean`

## Focus areas
- `AlgebraicJacobian/Differentials.lean` — heavily refactored this iter. Verify the 3 surviving declarations are well-formed and the inline `sorry` body of `smooth_iff_locally_free_omega` is the only sorry.
- `AlgebraicJacobian/Jacobian.lean` — the `nonempty_jacobianWitness` sorry (L179) is the single explicit foundational existence hypothesis. Verify the witness-based definition of `Jacobian` and its four protected instance projections are coherent (no fake content, no excuse-comments, signatures of protected declarations unchanged).
- `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean:23` + `MayerVietorisCover.lean:25` — file-overview cross-references to the deleted `BasicOpenCech.lean` were removed this iter; verify no other stale references survive in the surviving cohomology files.

## Known issues
- 2 active inline sorries: `Differentials.lean:81` (`smooth_iff_locally_free_omega`) and `Jacobian.lean:179` (`nonempty_jacobianWitness`). Both are by design.
- 1 deprecation warning on `Differentials.lean:76` (`AlgebraicGeometry.IsSmoothOfRelativeDimension`) — preserved per the protected signature.
- `Genus.lean:52` contains the string `sorry⟩` inside a `--` comment (no active sorry).
- The `AlgebraicJacobian.lean:35` "Forbidden shortcut" docstring uses the phrase "mathematically wrong" to describe a *counterexample* — this is documentation, not an excuse-comment.
