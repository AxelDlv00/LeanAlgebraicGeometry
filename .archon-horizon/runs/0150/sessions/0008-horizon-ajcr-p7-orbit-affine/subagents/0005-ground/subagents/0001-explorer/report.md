Negative conclusion: no existing theorem in either project or pinned Mathlib proves `Scheme.FiniteInAffine` for an arbitrary-field finite-type/quasi-compact group scheme without the excluded hypotheses.

- The only group-specific producer is
  ```lean
  GroupScheme.finiteInAffine_of_isAlgClosed_of_irreducible
    (G : Over (Spec (.of K))) [GrpObj G] [IsAlgClosed K]
    [LocallyOfFiniteType G.hom] [IrreducibleSpace G.left] :
    Scheme.FiniteInAffine G.left
  ```
  at `Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GroupAffineOpen.lean:162`. It is sorry-free, but requires exactly `IsAlgClosed` and `IrreducibleSpace`.

- `Pic0FiniteStageOrbitAffine` calls it at lines 56-70 after adding those two assumptions. The package already supplies local finite type and quasi-compactness at `Pic0FiniteStageGeometry.lean:38-79`, and representability supplies `GrpObj` at `Pic0FiniteStageOrbitAffine.lean:43-49`, but neither supplies algebraic closure nor irreducibility.

- The alternative rebuild route is
  ```lean
  Scheme.finiteInAffine_of_isImmersion
  ```
  at `Descent/QuasiProjectiveFiniteInAffine.lean:44`, used at `Pic0FiniteStageOrbitAffine.lean:87-95`; it requires the excluded projective-space immersion. `finiteInAffine_of_isProjective` at lines 64-68 has the same problem.

- The original project’s strongest general producer is
  ```lean
  Scheme.finiteInAffine_of_isHQuasiProjective
    (h : π.IsHQuasiProjective) : FiniteInAffine X
  ```
  at `Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/QuasiProjectiveFiniteInAffine.lean:484`. Its proof extracts a finite-dimensional immersion at lines 486-489, so it does not remove the immersion/quasi-projectivity hypothesis.

- The closest arbitrary-field group result in the original project is
  ```lean
  GroupScheme.IdentityComponent.isFiniteTypeGeometricallyIrreducible
    (G ...) [GrpObj G] [LocallyOfFiniteType G.hom] :
    LocallyOfFiniteType (IdentityComponent G).hom ∧
    QuasiCompact (IdentityComponent G).hom ∧
    GeometricallyIrreducible (IdentityComponent G).hom
  ```
  at `Picard/IdentityComponent.lean:1374`. It concludes no `FiniteInAffine`. Although the file also provides the clopen inclusion (`:318`), inherited group structure (`:768`), and arbitrary-field base-change isomorphism (`:1147`), there is no theorem descending `FiniteInAffine` from an algebraic closure and no coproduct/coset decomposition of `G` into identity components.

- `Scheme.finiteInAffine_sigma` (`Rebuild/Descent/FiniteInAffine.lean:52`, original `QuasiProjectiveFiniteInAffine.lean:816`) cannot bridge this: it needs an actual coproduct presentation plus `FiniteInAffine` for every component, neither of which exists.

- `Scheme.finiteInAffine_of_isAffineHom` at `Rebuild/Descent/FiniteInAffine.lean:86` requires `IsAffineHom`; `GrpObj + LocallyOfFiniteType + QuasiCompact` does not produce that. Group separatedness at `Rebuild/AlgebraicJacobian/AbelianVariety/GroupSeparated.lean:108` likewise has no conversion to `FiniteInAffine`.

Both projects pin Mathlib `fabf563a7c95a166b8d7b6efca11c8b4dc9d911f` (`v4.31.0`) at their `lake-manifest.json:8`. Mathlib’s only algebraic-group modules are `Group/Smooth.lean` and `Group/Abelian.lean`; they prove smoothness and commutativity results, not quasi-projectivity or common affine neighborhoods. `FiniteInAffine` itself is project-local.

Highest-value next action: extend `Descent/GroupAffineOpen.lean` to the arbitrary-field, reducible Stacks `0B7S` theorem, ideally with only `[Field K] [GrpObj G] [LocallyOfFiniteType G.hom]` (the target also has `QuasiCompact`). Then `Pic0FiniteStageOrbitAffine` can invoke it directly from its existing `GrpObj` and finite-stage geometry instances.
