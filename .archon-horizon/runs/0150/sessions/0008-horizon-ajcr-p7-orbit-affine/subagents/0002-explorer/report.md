## Current lane

- `Descent/FiniteInAffine.lean:32`:
  ```lean
  def Scheme.FiniteInAffine (X : Scheme.{u}) : Prop :=
    ∀ s : Set X, s.Finite → ∃ U : X.affineOpens, s ⊆ U.1
  ```
- `Descent/GroupAffineOpen.lean:162` is the only group producer:
  ```lean
  theorem GroupScheme.finiteInAffine_of_isAlgClosed_of_irreducible
      (G : Over (Spec (.of K))) [GrpObj G] [IsAlgClosed K]
      [LocallyOfFiniteType G.hom] [IrreducibleSpace G.left] :
      Scheme.FiniteInAffine G.left
  ```
- `Picard/Pic0FiniteStageOrbitAffine.lean:43` transports `rep` to:
  ```lean
  pic0FiniteStageGrpObjOfRepresentableBy ... :
    GrpObj P.gluedOver
  ```
  Local finite type is already available from `Pic0FiniteStageGeometry.lean:39,49`.
- The exact carrier producer at `Pic0FiniteStageOrbitAffine.lean:56` is:
  ```lean
  pic0FiniteStageFiniteInAffine_of_isAlgClosed_of_irreducible
      (P : Pic0FiniteStageGluePackage Ck F)
      [Algebra K P.N.1] [IsAlgClosed P.N.1]
      [IrreducibleSpace P.glueData.glued]
      (rep : (pic0TypeFunctor ((baseChange K P.N.1).obj C))
        .RepresentableBy P.gluedOver) :
      Scheme.FiniteInAffine P.glueData.glued
  ```
- `FiniteInAffine.lean:66` converts this to `rho.OrbitsInAffineOpen`; the specialized wrapper is `Pic0FiniteStageOrbitAffine.lean:76`.
- `Pic0FiniteStageStableAffineCover.lean:43` installs that orbit instance and obtains `HasStableAffineCover`; `:96` consumes it in finite-Galois Picard descent.
- The final consumer is `Pic0FiniteGaloisRepresentable.lean:35`; its sole extra geometric binder is:
  ```lean
  [(pic0SemilinearGalActionOfRepresentableBy C rep).OrbitsInAffineOpen]
  ```
- Root exposure is direct/transitive at `AlgebraicJacobian.lean:549-550,816-817`.

## Exact blockers

`rep` already supplies the group object, and `P.gluedMap` already has `LocallyOfFiniteType`. The genuine unsolved binders are exactly:

```lean
[IsAlgClosed P.N.1]
[IrreducibleSpace P.glueData.glued]
```

In `GroupAffineOpen.lean`, irreducibility is used only at `:133-138` to make a finite intersection of nonempty translated opens nonempty. Algebraic closedness is essential to the current proof at `:144-148` and `:178-191`: `pointEquivClosedPoint` turns closed points into field-rational points so translation morphisms can be formed. `LocallyOfFiniteType` is used for Jacobson density at `:141` and `:169`.

## Existing escape routes

AJCR has no indexed arbitrary-field group theorem and no producer of `IrreducibleSpace P.glueData.glued`.

The existing assumption-free alternatives are conditional on stronger geometry:

- `QuasiProjectiveFiniteInAffine.lean:44`: `finiteInAffine_of_isImmersion`
- `:64`: `finiteInAffine_of_isProjective`
- `Pic0FiniteStageOrbitAffine.lean:87,100,114`: immersion/projectivity wrappers
- `Pic0FiniteStageStableAffineCover.lean:55,69,80,107`: corresponding consumers

No scoped source produces the required immersion or `P.gluedMap.IsProjective`.

Indexed search did find substantial infrastructure only in the sibling AJC project:

- `Picard/IdentityComponent.lean:318`: `IdentityComponent.isOpenSubgroupScheme`
- `:768`: `IdentityComponent.isSubgroupHomomorphism`
- `:1374`:
  ```lean
  IdentityComponent.isFiniteTypeGeometricallyIrreducible ... :
    LocallyOfFiniteType (IdentityComponent G).hom ∧
    QuasiCompact (IdentityComponent G).hom ∧
    GeometricallyIrreducible (IdentityComponent G).hom
  ```

This can remove irreducibility for an actual identity-component carrier, but AJCR has neither this infrastructure nor an identification of `P.gluedOver` with `IdentityComponent ...`. It does not itself prove `FiniteInAffine` over an arbitrary field. Also, `finiteInAffine_of_isAffineHom` has the wrong direction for descent from an algebraic closure.

## Minimal plan

The desired generic declaration is:

```lean
theorem GroupScheme.finiteInAffine
    (G : Over (Spec (.of K))) [GrpObj G]
    [LocallyOfFiniteType G.hom] :
    Scheme.FiniteInAffine G.left
```

Once available, rewiring is mechanical: use it in `Pic0FiniteStageOrbitAffine.lean`, remove both binders from the orbit wrapper, then remove them from the two stable-cover/descent consumers.

The theorem itself is not a viable one-file proof from current AJCR dependencies. Removing reducibility needs identity-component/component and finite-disjoint-union infrastructure; removing `IsAlgClosed` additionally needs descent of a suitably stable affine open from a finite field extension. The sibling identity-component development is useful substrate, but not a drop-in finish. End-to-end work is therefore multi-file, at minimum `GroupAffineOpen.lean`, `Pic0FiniteStageOrbitAffine.lean`, and `Pic0FiniteStageStableAffineCover.lean`, plus imported identity-component/descent infrastructure. The only potentially short route is a direct immersion/projectivity theorem for `P.gluedOver`, for which this scoped audit found no producer.

No files or Horizon ledger state were edited; no build was run.
